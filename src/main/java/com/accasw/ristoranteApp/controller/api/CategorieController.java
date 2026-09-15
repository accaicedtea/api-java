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
@RequestMapping("/api/admin/categorie")
public class CategorieController extends AbstractTenantCrudController {

    public CategorieController(JdbcCrudService crud) { super(crud); }

    @Override protected String table()  { return "categorie"; }
    @Override protected Set<String> fields() { return DbFields.CATEGORIE; }
    @Override protected String label()  { return "Categoria"; }

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

    // ---- hooks ----

    @Override
    protected void beforeCreate(AuthenticatedUser u, Map<String, Object> body) {
        Long menuId = asLong(body.get("menu_id"));
        if (menuId == null || !crud.exists("menu", menuId, u.aziendaId())) {
            throw new IllegalArgumentException("Menu non valido o non appartiene all'azienda");
        }
        Long parentId = asLong(body.get("parent_id"));
        if (parentId != null && !crud.exists("categorie", parentId, u.aziendaId())) {
            throw new IllegalArgumentException("Categoria padre non valida");
        }
    }
}