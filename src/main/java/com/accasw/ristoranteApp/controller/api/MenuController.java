package com.accasw.ristoranteApp.controller.api;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import com.accasw.ristoranteApp.model.Menu;
import com.accasw.ristoranteApp.security.AuthenticatedUser;
import com.accasw.ristoranteApp.service.MenuService;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@RestController
@RequestMapping("/api")
public class MenuController {

    private final MenuService menuService;

    public MenuController(MenuService menuService) {
        this.menuService = menuService;
    }

    // ============================================================
    // ADMIN
    // ============================================================

    @GetMapping("/admin/menu")
    public Map<String, Object> index(Authentication auth,
            @RequestParam(required = false) Boolean attivo,
            @RequestParam(required = false) Boolean predefinito,
            @RequestParam(defaultValue = "") String search) {
        Long aziendaId = user(auth).aziendaId();
        String needle = search.toLowerCase();

        List<Menu> menus = menuService.listByAzienda(aziendaId).stream()
                .filter(m -> attivo == null || m.isAttivo() == attivo)
                .filter(m -> predefinito == null || m.isPredefinito() == predefinito)
                .filter(m -> needle.isBlank()
                        || m.getNome().toLowerCase().contains(needle)
                        || (m.getDescrizione() != null
                                && m.getDescrizione().toLowerCase().contains(needle)))
                .toList();

        return Map.of("data", menus);
    }

    @GetMapping("/admin/menu/{id}")
    public Menu show(Authentication auth, @PathVariable Long id) {
        return ownedMenu(auth, id);
    }

    @PostMapping("/admin/menu")
    public ResponseEntity<Map<String, Long>> create(Authentication auth,
            @Valid @RequestBody MenuRequest req) {
        if (menuService.existsBySlug(req.slug())) {
            throw new IllegalArgumentException("Slug già in uso");
        }
        Menu menu = req.toEntity();
        menu.setAziendaId(user(auth).aziendaId());
        Menu saved = menuService.create(menu);
        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("id", saved.getId()));
    }

    @PutMapping("/admin/menu/{id}")
    public Map<String, Object> update(Authentication auth, @PathVariable Long id,
            @Valid @RequestBody MenuRequest req) {
        Menu menu = ownedMenu(auth, id);
        if (menuService.existsBySlugExcluding(req.slug(), id)) {
            throw new IllegalArgumentException("Slug già in uso");
        }
        req.update(menu);
        menuService.update(menu);
        return Map.of("ok", true, "message", "Menu aggiornato");
    }

    @DeleteMapping("/admin/menu/{id}")
    public Map<String, String> delete(Authentication auth, @PathVariable Long id) {
        Menu menu = ownedMenu(auth, id);
        menuService.delete(menu);
        return Map.of("message", "Menu eliminato");
    }

    // ============================================================
    // PUBBLICI
    // ============================================================

    @GetMapping("/menu/pubblici")
    public Map<String, Object> publicMenus() {
        List<Map<String, Object>> menus = menuService.publicList().stream()
                .map(m -> {
                    Map<String, Object> mm = new LinkedHashMap<>();
                    mm.put("nome", m.getNome());
                    mm.put("slug", m.getSlug());
                    mm.put("descrizione", m.getDescrizione() == null ? "" : m.getDescrizione());
                    mm.put("lingua_predefinita", m.getLinguaPredefinita());
                    mm.put("qr_scansioni", m.getQrScansioni());
                    return mm;
                })
                .toList();
        return Map.of("menus", menus);
    }

    @GetMapping("/menu/pubblici/{slug}")
    public Map<String, Object> publicMenu(
            @PathVariable String slug,
            @RequestParam(defaultValue = "it") String lang) {

        // 1) incremento atomico (fuori dalla cache)
        menuService.incrementQrScansioniBySlug(slug);

        // 2) dettaglio cachato
        Map<String, Object> menu = menuService.publicMenuDetail(slug, lang)
                .orElseThrow(() -> new IllegalArgumentException("Menu non disponibile"));

        return Map.of("menu", menu);
    }

    // ============================================================
    // HELPERS
    // ============================================================

    private Menu ownedMenu(Authentication auth, Long id) {
        return menuService.findOwned(id, user(auth).aziendaId())
                .orElseThrow(() -> new IllegalArgumentException("Menu non trovato"));
    }

    private AuthenticatedUser user(Authentication auth) {
        return (AuthenticatedUser) auth.getPrincipal();
    }

    // ============================================================
    // REQUEST
    // ============================================================

    public record MenuRequest(
            @NotBlank @Size(max = 100) String nome,
            @NotBlank @Size(max = 150) String slug,
            String descrizione,
            String linguaPredefinita,
            Boolean predefinito,
            Boolean attivo,
            Short ordine) {

        Menu toEntity() {
            Menu m = new Menu();
            update(m);
            return m;
        }

        void update(Menu m) {
            m.setNome(nome);
            m.setSlug(slug);
            m.setDescrizione(descrizione);
            m.setLinguaPredefinita(linguaPredefinita == null ? "it" : linguaPredefinita);
            m.setPredefinito(Boolean.TRUE.equals(predefinito));
            m.setAttivo(attivo == null || attivo);
            m.setOrdine(ordine == null ? (short) 0 : ordine);
        }
    }
}