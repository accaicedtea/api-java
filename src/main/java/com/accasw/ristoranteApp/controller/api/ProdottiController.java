package com.accasw.ristoranteApp.controller.api;

import java.util.Map;
import java.util.Set;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import com.accasw.ristoranteApp.common.DbFields;
import com.accasw.ristoranteApp.service.JdbcCrudService;

@RestController
@RequestMapping("/api/admin/prodotti")
public class ProdottiController extends AbstractTenantCrudController {

    public ProdottiController(JdbcCrudService crud) { super(crud); }

    @Override protected String table()  { return "prodotti"; }
    @Override protected Set<String> fields() { return DbFields.PRODOTTI; }
    @Override protected String label()  { return "Prodotto"; }

    @GetMapping
    public Map<String, Object> index(Authentication a) { return doIndex(a); }

    @GetMapping("/{id}")
    public Map<String, Object> show(Authentication a, @PathVariable Long id) { return doShow(a, id); }

    @PostMapping
    public ResponseEntity<Map<String, Long>> create(Authentication a, @RequestBody Map<String, Object> body) {
        return doCreate(a, body);
    }

    @PutMapping("/{id}")
    public Map<String, Object> update(Authentication a, @PathVariable Long id, @RequestBody Map<String, Object> body) {
        return doUpdate(a, id, body);
    }

    @DeleteMapping("/{id}")
    public Map<String, String> delete(Authentication a, @PathVariable Long id) { return doDelete(a, id); }

    // NB: prodotti non ha categoria_id → l'associazione si fa su prodotti_menu.
    // Se il client manda categoria_id, viene ignorato (non è in FIELDS).
}