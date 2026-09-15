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
@RequestMapping("/api/events")
public class EventsController extends AbstractTenantCrudController {

    public EventsController(JdbcCrudService crud) { super(crud); }

    @Override protected String table()  { return "events"; }   // nome reale DB
    @Override protected Set<String> fields() { return DbFields.EVENTS; }
    @Override protected String label()  { return "Evento"; }

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
        checkDateUniqueness(u, body.get("event_date"), null);
    }

    @Override
    protected void beforeUpdate(AuthenticatedUser u, Long id, Map<String, Object> body) {
        if (body.containsKey("event_date")) {
            checkDateUniqueness(u, body.get("event_date"), id);
        }
    }

    private void checkDateUniqueness(AuthenticatedUser u, Object date, Long excludeId) {
        if (date == null) throw new IllegalArgumentException("event_date obbligatoria");
        if (crud.existsByColumn("events", "event_date", date, u.aziendaId(), excludeId)) {
            throw new IllegalArgumentException("Esiste già un evento per questa data");
        }
    }
}