package com.accasw.ristoranteApp.service;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.accasw.ristoranteApp.model.Menu;
import com.accasw.ristoranteApp.repository.MenuRepository;

@Service
public class MenuService {

    /** Lingue supportate per le traduzioni (whitelist anti SQL-injection). */
    private static final Set<String> LINGUE = Set.of("it", "fr", "de", "zh");

    private final MenuRepository repo;
    private final JdbcTemplate   jdbc;

    public MenuService(MenuRepository repo, JdbcTemplate jdbc) {
        this.repo = repo;
        this.jdbc = jdbc;
    }

    // ============================================================
    // READ ADMIN (non cachati)
    // ============================================================

    @Transactional(readOnly = true)
    public List<Menu> listByAzienda(Long aziendaId) {
        return repo.findByAziendaIdAndDeletedAtIsNullOrderByOrdineAscNomeAsc(aziendaId);
    }

    @Transactional(readOnly = true)
    public Optional<Menu> findOwned(Long id, Long aziendaId) {
        return repo.findByIdAndAziendaIdAndDeletedAtIsNull(id, aziendaId);
    }

    // ============================================================
    // READ PUBBLICI (cachati)
    // ============================================================

    @Cacheable(value = "menuPubblici", key = "'list'")
    @Transactional(readOnly = true)
    public List<Menu> publicList() {
        return repo.findByAttivoTrueAndDeletedAtIsNullOrderByOrdineAsc();
    }

    @Cacheable(value = "menuPubblici", key = "'slug:' + #slug")
    @Transactional(readOnly = true)
    public Optional<Menu> publicBySlug(String slug) {
        return repo.findBySlugAndAttivoTrueAndDeletedAtIsNull(slug);
    }

    /**
     * Incremento atomico del contatore QR. Fuori dalla cache: va chiamato
     * ad OGNI scansione, prima di servire il dettaglio.
     */
    @Transactional
    public int incrementQrScansioniBySlug(String slug) {
        return jdbc.update(
            "UPDATE menu SET qr_scansioni = qr_scansioni + 1 " +
            "WHERE slug = ? AND attivo = 1 AND deleted_at IS NULL",
            slug);
    }

    /**
     * Dettaglio pubblico completo: menu + categorie + prodotti + ingredienti
     * (come descrizione) + allergeni. Traduzioni in base a `lang`.
     */
    @Cacheable(value = "menuPubblici", key = "'detail:' + #slug + ':' + #lang")
    @Transactional(readOnly = true)
    public Optional<Map<String, Object>> publicMenuDetail(String slug, String lang) {

        if (lang == null || !LINGUE.contains(lang)) lang = "it";

        // ---------- 1) Menu ----------
        List<Map<String, Object>> menuRows = jdbc.queryForList(
            "SELECT * FROM menu WHERE slug = ? AND attivo = 1 AND deleted_at IS NULL", slug);
        if (menuRows.isEmpty()) return Optional.empty();
        Map<String, Object> menuRow = menuRows.get(0);

        Long menuId    = toLong(menuRow.get("id"));
        Long aziendaId = toLong(menuRow.get("azienda_id"));

        // ---------- 2) Prodotti (JOIN categorie + traduzioni) ----------
        // NOTA: no filtro su c.visibile qui, lo aggiungo dopo aver scartato le cat non visibili
        List<Map<String, Object>> productRows = jdbc.queryForList("""
            SELECT
                pm.categoria_id,
                pm.ordine                                       AS pm_ordine,
                COALESCE(pm.prezzo_override, p.prezzo)          AS prezzo_finale,
                p.id, p.nome, p.descrizione,
                p.foto_url, p.foto_thumbnail_url,
                p.vegan, p.vegetariano, p.senza_glutine, p.biologico,
                p.piccante_livello, p.calorie, p.in_evidenza,
                c.nome       AS categoria_nome,
                c.icona      AS categoria_icona,
                c.colore     AS categoria_colore,
                c.ordine     AS categoria_ordine,
                c.visibile   AS categoria_visibile,
                ct.nome      AS categoria_nome_tradotto
            FROM prodotti_menu pm
            JOIN prodotti p
                ON  p.id = pm.prodotto_id
                AND p.attivo = 1
                AND p.deleted_at IS NULL
                AND p.azienda_id = ?
            LEFT JOIN categorie c
                ON  c.id = pm.categoria_id
                AND c.deleted_at IS NULL
            LEFT JOIN categorie_traduzioni ct
                ON  ct.categoria_id = c.id
                AND ct.lingua = ?
            WHERE pm.menu_id = ?
              AND pm.attivo = 1
            ORDER BY c.ordine, pm.ordine, p.nome
            """, aziendaId, lang, menuId);

        // ---------- 3) Ingredienti per prodotto ----------
        List<Long> productIds = productRows.stream()
                .map(r -> toLong(r.get("id")))
                .filter(Objects::nonNull)
                .distinct()
                .toList();

        Map<Long, List<Long>> prodottoIngredienti = new HashMap<>();
        Map<Long, String>     ingredientiNomi      = new HashMap<>();

        if (!productIds.isEmpty()) {
            List<Map<String, Object>> piRows = jdbc.queryForList(
                "SELECT prodotto_id, ingrediente_id FROM prodotti_ingredienti " +
                "WHERE prodotto_id IN (" + placeholders(productIds.size()) + ")",
                productIds.toArray());

            List<Long> ingredienteIds = new ArrayList<>();
            for (Map<String, Object> r : piRows) {
                Long pid = toLong(r.get("prodotto_id"));
                Long iid = toLong(r.get("ingrediente_id"));
                if (pid == null || iid == null) continue;
                prodottoIngredienti.computeIfAbsent(pid, k -> new ArrayList<>()).add(iid);
                ingredienteIds.add(iid);
            }

            List<Long> uniqueIngredienti = ingredienteIds.stream().distinct().toList();
            if (!uniqueIngredienti.isEmpty()) {
                Object[] args = new Object[uniqueIngredienti.size() + 1];
                args[0] = lang;
                for (int i = 0; i < uniqueIngredienti.size(); i++) args[i + 1] = uniqueIngredienti.get(i);

                List<Map<String, Object>> ingRows = jdbc.queryForList("""
                    SELECT i.id, i.nome AS nome_base, it.nome AS nome_tradotto
                    FROM ingredienti i
                    LEFT JOIN ingredienti_traduzioni it
                        ON  it.ingrediente_id = i.id
                        AND it.lingua = ?
                    WHERE i.id IN (""" + placeholders(uniqueIngredienti.size()) + ")",
                    args);

                for (Map<String, Object> r : ingRows) {
                    Long iid = toLong(r.get("id"));
                    Object trad = r.get("nome_tradotto");
                    Object base = r.get("nome_base");
                    String nome = (trad != null && !trad.toString().isBlank())
                            ? trad.toString()
                            : (base != null ? base.toString() : "?");
                    if (iid != null) ingredientiNomi.put(iid, nome);
                }
            }
        }

        // ---------- 4) Allergeni per ingrediente ----------
        Map<Long, List<Map<String, Object>>> ingredientiAllergeni = new HashMap<>();
        if (!ingredientiNomi.isEmpty()) {
            List<Long> ingIds = new ArrayList<>(ingredientiNomi.keySet());

            List<Map<String, Object>> allRows = jdbc.queryForList(
                "SELECT ia.ingrediente_id, a.id AS allergene_id, a.codice, " +
                "       a.nome_it, a.nome_fr, a.nome_de, a.nome_zh, a.icona " +
                "FROM ingredienti_allergeni ia " +
                "JOIN allergeni a ON a.id = ia.allergene_id " +
                "WHERE ia.ingrediente_id IN (" + placeholders(ingIds.size()) + ") " +
                "AND ia.presente = 1",
                ingIds.toArray());

            for (Map<String, Object> r : allRows) {
                Long iid = toLong(r.get("ingrediente_id"));
                if (iid == null) continue;
                Map<String, Object> alg = new LinkedHashMap<>();
                alg.put("id",     toLong(r.get("allergene_id")));
                alg.put("codice", r.get("codice"));
                alg.put("nome",   allergeneNome(r, lang));
                alg.put("icona",  r.get("icona"));
                ingredientiAllergeni.computeIfAbsent(iid, k -> new ArrayList<>()).add(alg);
            }
        }

        // ---------- 5) Assemblaggio categorie / prodotti ----------
        LinkedHashMap<Long, Map<String, Object>> categorieMap = new LinkedHashMap<>();

        for (Map<String, Object> r : productRows) {
            Long catId          = toLong(r.get("categoria_id"));
            Boolean catVisibile = toBool(r.get("categoria_visibile"));

            // Se la categoria esiste ed è nascosta → escludi il prodotto
            if (catId != null && Boolean.FALSE.equals(catVisibile)) continue;

            Long catKey = catId != null ? catId : -1L;

            Map<String, Object> categoria = categorieMap.computeIfAbsent(catKey, k -> {
                Map<String, Object> c = new LinkedHashMap<>();
                c.put("id",       catId);
                c.put("nome",     nomeCategoria(r));
                c.put("icona",    r.get("categoria_icona"));
                c.put("colore",   r.get("categoria_colore"));
                c.put("ordine",   toInt(r.get("categoria_ordine")));
                c.put("prodotti", new ArrayList<Map<String, Object>>());
                return c;
            });

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> prodotti =
                    (List<Map<String, Object>>) categoria.get("prodotti");
            prodotti.add(buildProdotto(r, prodottoIngredienti, ingredientiNomi, ingredientiAllergeni));
        }

        // ---------- 6) Risultato finale ----------
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("id",                 menuId);
        result.put("nome",               menuRow.get("nome"));
        result.put("slug",               menuRow.get("slug"));
        result.put("descrizione",        menuRow.get("descrizione") == null ? "" : menuRow.get("descrizione"));
        result.put("lingua_predefinita", menuRow.get("lingua_predefinita"));
        result.put("qr_scansioni",       toLong(menuRow.get("qr_scansioni")));
        result.put("categorie",          new ArrayList<>(categorieMap.values()));

        return Optional.of(result);
    }

    // ============================================================
    // WRITE
    // ============================================================

    @CacheEvict(value = "menuPubblici", allEntries = true)
    @Transactional
    public Menu create(Menu menu) { return repo.save(menu); }

    @CacheEvict(value = "menuPubblici", allEntries = true)
    @Transactional
    public Menu update(Menu menu) { return repo.save(menu); }

    @CacheEvict(value = "menuPubblici", allEntries = true)
    @Transactional
    public void delete(Menu menu) {
        menu.setDeletedAt(Instant.now());
        repo.save(menu);
    }

    // ============================================================
    // CHECK UNICITÀ
    // ============================================================

    public boolean existsBySlug(String slug) {
        return repo.existsBySlugAndDeletedAtIsNull(slug);
    }

    public boolean existsBySlugExcluding(String slug, Long id) {
        return repo.existsBySlugAndDeletedAtIsNullAndIdNot(slug, id);
    }

    // ============================================================
    // HELPERS
    // ============================================================

    private static Map<String, Object> buildProdotto(
            Map<String, Object> r,
            Map<Long, List<Long>> prodottoIngredienti,
            Map<Long, String> ingredientiNomi,
            Map<Long, List<Map<String, Object>>> ingredientiAllergeni) {

        Long productId = toLong(r.get("id"));

        List<Long> ingIds = prodottoIngredienti.getOrDefault(productId, List.of());

        List<String> nomiIngredienti = new ArrayList<>();
        LinkedHashMap<Object, Map<String, Object>> allergeniUnici = new LinkedHashMap<>();

        for (Long ingId : ingIds) {
            String nome = ingredientiNomi.get(ingId);
            if (nome != null) nomiIngredienti.add(nome);

            for (Map<String, Object> a : ingredientiAllergeni.getOrDefault(ingId, List.of())) {
                allergeniUnici.putIfAbsent(a.get("id"), a);
            }
        }

        Map<String, Object> p = new LinkedHashMap<>();
        p.put("id",              productId);
        p.put("nome",            r.get("nome"));
        p.put("descrizione",     String.join(", ", nomiIngredienti));
        p.put("descrizione_piatti", r.get("descrizione"));   // descrizione originale del piatto
        p.put("prezzo",          r.get("prezzo_finale"));
        p.put("foto_url",        r.get("foto_url"));
        p.put("thumbnail_url",   r.get("foto_thumbnail_url"));
        p.put("allergeni",       new ArrayList<>(allergeniUnici.values()));
        p.put("vegan",           toBool(r.get("vegan")));
        p.put("vegetariano",     toBool(r.get("vegetariano")));
        p.put("senza_glutine",   toBool(r.get("senza_glutine")));
        p.put("biologico",       toBool(r.get("biologico")));
        p.put("piccante_livello", toInt(r.get("piccante_livello")));
        p.put("calorie",         toInt(r.get("calorie")));
        p.put("in_evidenza",     toBool(r.get("in_evidenza")));
        return p;
    }

    private static String nomeCategoria(Map<String, Object> r) {
        Object trad = r.get("categoria_nome_tradotto");
        if (trad != null && !trad.toString().isBlank()) return trad.toString();
        Object base = r.get("categoria_nome");
        return base != null ? base.toString() : "Senza categoria";
    }

    private static String allergeneNome(Map<String, Object> r, String lang) {
        Object v = r.get("nome_" + lang);
        if (v != null && !v.toString().isBlank()) return v.toString();
        Object it = r.get("nome_it");
        return it != null ? it.toString() : "";
    }

    private static String placeholders(int n) {
        return String.join(",", Collections.nCopies(n, "?"));
    }

    private static Long toLong(Object v) {
        if (v == null) return null;
        if (v instanceof Long l) return l;
        if (v instanceof Integer i) return i.longValue();
        if (v instanceof Number n) return n.longValue();
        try { return Long.parseLong(v.toString()); } catch (Exception e) { return null; }
    }

    private static int toInt(Object v) {
        if (v == null) return 0;
        if (v instanceof Number n) return n.intValue();
        try { return Integer.parseInt(v.toString()); } catch (Exception e) { return 0; }
    }

    private static Boolean toBool(Object v) {
        if (v == null) return null;
        if (v instanceof Boolean b) return b;
        if (v instanceof Number n) return n.intValue() != 0;
        return null;
    }
}