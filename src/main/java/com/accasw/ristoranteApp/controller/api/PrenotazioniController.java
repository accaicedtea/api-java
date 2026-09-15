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
@RequestMapping("/api/prenotazioni")
public class PrenotazioniController extends AbstractTenantCrudController {

    public PrenotazioniController(JdbcCrudService crud) { super(crud); }

    @Override protected String table()  { return "prenotazioni"; }
    @Override protected Set<String> fields() { return DbFields.PRENOTAZIONI; }
    @Override protected String label()  { return "Prenotazione"; }

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

    @Override
    protected void beforeCreate(AuthenticatedUser u, Map<String, Object> body) {
        body.putIfAbsent("dominio", "default");
        body.remove("ora_fine"); // generated column
        if (body.get("stato") == null) body.put("stato", "in_attesa");
        validateTavolo(u, body);
    }

    @Override
    protected void beforeUpdate(AuthenticatedUser u, Long id, Map<String, Object> body) {
        body.remove("ora_fine");
        validateTavolo(u, body);
    }

    private void validateTavolo(AuthenticatedUser u, Map<String, Object> body) {
        Long tavoloId = asLong(body.get("tavolo_id"));
        if (tavoloId != null && !crud.exists("tavoli", tavoloId, u.aziendaId())) {
            throw new IllegalArgumentException("Tavolo non valido o non appartiene all'azienda");
        }
    }
}