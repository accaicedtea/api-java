package com.accasw.ristoranteApp.controller.api;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import com.accasw.ristoranteApp.common.DbFields;
import com.accasw.ristoranteApp.security.AuthenticatedUser;
import com.accasw.ristoranteApp.service.JdbcCrudService;

/**
 * variazioni_prodotto non ha azienda_id → ownership via prodotto_id.
 */
@RestController
@RequestMapping("/api/admin/variazioni")
public class VariazioniController {

    private final JdbcCrudService crud;
    private final JdbcTemplate jdbc;

    public VariazioniController(JdbcCrudService crud, JdbcTemplate jdbc) {
        this.crud = crud;
        this.jdbc = jdbc;
    }

    @GetMapping("/prodotto/{prodottoId}")
    public Map<String, Object> byProdotto(Authentication auth, @PathVariable Long prodottoId) {
        assertOwnedProdotto(prodottoId, user(auth).aziendaId());
        return Map.of("data", jdbc.queryForList(
                "SELECT * FROM variazioni_prodotto " +
                "WHERE prodotto_id = ? AND deleted_at IS NULL ORDER BY ordine, id",
                prodottoId));
    }

    @GetMapping("/{id}")
    public Map<String, Object> show(Authentication auth, @PathVariable Long id) {
        return findOwned(id, user(auth).aziendaId());
    }

    @PostMapping
    public ResponseEntity<Map<String, Long>> create(Authentication auth, @RequestBody Map<String, Object> body) {
        Long aziendaId = user(auth).aziendaId();
        Long prodottoId = requireLong(body, "prodotto_id");
        assertOwnedProdotto(prodottoId, aziendaId);
        long id = crud.insert("variazioni_prodotto", body, DbFields.VARIAZIONI);
        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("id", id));
    }

    @PutMapping("/{id}")
    public Map<String, Object> update(Authentication auth, @PathVariable Long id,
                                      @RequestBody Map<String, Object> body) {
        Long aziendaId = user(auth).aziendaId();
        findOwned(id, aziendaId);

        body.remove("id");
        body.remove("prodotto_id"); // ownership immutabile

        var assignments = new java.util.ArrayList<String>();
        var values = new java.util.ArrayList<Object>();
        body.forEach((k, v) -> {
            if (DbFields.VARIAZIONI.contains(k)) { assignments.add(k + " = ?"); values.add(v); }
        });
        if (assignments.isEmpty()) throw new IllegalArgumentException("Nessun dato valido fornito");
        values.add(id);
        jdbc.update("UPDATE variazioni_prodotto SET " + String.join(", ", assignments) +
                    " WHERE id = ? AND deleted_at IS NULL", values.toArray());
        return Map.of("ok", true, "message", "Variazione aggiornata");
    }

    @DeleteMapping("/{id}")
    public Map<String, String> delete(Authentication auth, @PathVariable Long id) {
        Long aziendaId = user(auth).aziendaId();
        findOwned(id, aziendaId);
        jdbc.update("UPDATE variazioni_prodotto SET deleted_at = CURRENT_TIMESTAMP " +
                    "WHERE id = ? AND deleted_at IS NULL", id);
        return Map.of("message", "Variazione eliminata");
    }

    // ---------- helpers ----------

    private Map<String, Object> findOwned(Long id, Long aziendaId) {
        List<Map<String, Object>> rows = jdbc.queryForList(
                "SELECT v.* FROM variazioni_prodotto v " +
                "JOIN prodotti p ON p.id = v.prodotto_id " +
                "WHERE v.id = ? AND v.deleted_at IS NULL " +
                "  AND p.azienda_id = ? AND p.deleted_at IS NULL",
                id, aziendaId);
        if (rows.isEmpty()) throw new IllegalArgumentException("Variazione non trovata");
        return rows.get(0);
    }

    private void assertOwnedProdotto(Long prodottoId, Long aziendaId) {
        if (!crud.exists("prodotti", prodottoId, aziendaId)) {
            throw new IllegalArgumentException("Prodotto non valido o non appartiene all'azienda");
        }
    }

    private Long requireLong(Map<String, Object> body, String key) {
        Object v = body.get(key);
        if (v == null) throw new IllegalArgumentException(key + " obbligatorio");
        if (v instanceof Number n) return n.longValue();
        try { return Long.parseLong(v.toString()); }
        catch (NumberFormatException e) { throw new IllegalArgumentException(key + " non valido"); }
    }

    private AuthenticatedUser user(Authentication auth) {
        return (AuthenticatedUser) auth.getPrincipal();
    }
}