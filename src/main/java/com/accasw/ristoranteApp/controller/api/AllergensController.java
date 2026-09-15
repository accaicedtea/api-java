package com.accasw.ristoranteApp.controller.api;

import java.util.Map;
import java.util.Set;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import com.accasw.ristoranteApp.common.DbFields;
import com.accasw.ristoranteApp.security.AuthenticatedUser;
import com.accasw.ristoranteApp.service.JdbcCrudService;

@RestController
@RequestMapping("/api")
public class AllergensController extends AbstractTenantCrudController {

    public AllergensController(JdbcCrudService crud) { super(crud); }

    @Override protected String table()  { return "allergeni"; }
    @Override protected Set<String> fields() { return DbFields.ALLERGENI; }
    @Override protected String label()  { return "Allergene"; }

    // ---- pubblico: allergeni di sistema + quelli dell'azienda se autenticata ----
    @GetMapping("/allergens")
    public Map<String, Object> publicIndex(Authentication authentication) {
        Long aziendaId = null;
        if (authentication != null && authentication.getPrincipal() instanceof AuthenticatedUser u) {
            aziendaId = u.aziendaId();
        }
        return Map.of("data", crud.listAllergens(aziendaId));
    }

    // ---- admin ----
    @GetMapping("/admin/allergeni")
    public Map<String, Object> index(Authentication a) {
        // includiamo anche quelli di sistema? No: qui solo quelli custom dell'azienda.
        return doIndex(a);
    }

    @GetMapping("/admin/allergeni/{id}")
    public Map<String, Object> show(Authentication a, @PathVariable Long id) { return doShow(a, id); }

    @PostMapping("/admin/allergeni")
    public ResponseEntity<Map<String, Long>> create(Authentication a, @RequestBody Map<String, Object> body) {
        return doCreate(a, body);
    }

    @PutMapping("/admin/allergeni/{id}")
    public Map<String, Object> update(Authentication a, @PathVariable Long id, @RequestBody Map<String, Object> body) {
        return doUpdate(a, id, body);
    }

    @DeleteMapping("/admin/allergeni/{id}")
    public Map<String, String> delete(Authentication a, @PathVariable Long id) { return doDelete(a, id); }

    @Override
    protected void beforeCreate(AuthenticatedUser u, Map<String, Object> body) {
        Object codice = body.get("codice");
        if (codice == null) throw new IllegalArgumentException("Codice obbligatorio");
        if (crud.existsByColumn("allergeni", "codice", codice, u.aziendaId(), null)) {
            throw new IllegalArgumentException("Codice allergene già esistente");
        }
        Object nomeIt = body.get("nome_it");
        if (nomeIt == null) throw new IllegalArgumentException("nome_it obbligatorio");
    }
}