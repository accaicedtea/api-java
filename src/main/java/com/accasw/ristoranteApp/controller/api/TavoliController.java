package com.accasw.ristoranteApp.controller.api;

import java.util.Map;
import java.util.Set;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import com.accasw.ristoranteApp.common.DbFields;
import com.accasw.ristoranteApp.security.AuthenticatedUser;
import com.accasw.ristoranteApp.service.JdbcCrudService;

@RestController
@RequestMapping("/api/admin/tavoli")
public class TavoliController extends AbstractTenantCrudController {

    public TavoliController(JdbcCrudService crud) { super(crud); }

    @Override protected String table()  { return "tavoli"; }
    @Override protected Set<String> fields() { return DbFields.TAVOLI; }
    @Override protected String label()  { return "Tavolo"; }

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

    // NOTA: tavoli.numero è UNIQUE globale nel DB — vedi sezione "migliorie".
    @Override
    protected void beforeCreate(AuthenticatedUser u, Map<String, Object> body) {
        Object numero = body.get("numero");
        if (numero == null) throw new IllegalArgumentException("Numero tavolo obbligatorio");
        if (crud.existsByColumn("tavoli", "numero", numero, u.aziendaId(), null)) {
            throw new IllegalArgumentException("Numero tavolo già esistente");
        }
    }
}