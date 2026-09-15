package com.accasw.ristoranteApp.controller.api;

import java.util.Map;
import java.util.Set;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;

import com.accasw.ristoranteApp.exception.UnauthorizedApiException;
import com.accasw.ristoranteApp.security.AuthenticatedUser;
import com.accasw.ristoranteApp.service.JdbcCrudService;

/**
 * Base per i controller CRUD multi-tenant.
 * Le sottoclassi definiscono tabella, campi consentiti ed etichetta;
 * i hook beforeCreate/Update/Delete permettono validazioni specifiche.
 */
public abstract class AbstractTenantCrudController {

    protected final JdbcCrudService crud;

    protected AbstractTenantCrudController(JdbcCrudService crud) {
        this.crud = crud;
    }

    protected abstract String table();
    protected abstract Set<String> fields();
    protected abstract String label();

    // ---------- helpers ----------

    protected AuthenticatedUser user(Authentication auth) {
        if (auth == null || !(auth.getPrincipal() instanceof AuthenticatedUser u)) {
            throw new UnauthorizedApiException("Utente non autenticato");
        }
        return u;
    }

    protected Map<String, Object> one(Authentication auth, Long id) {
        return crud.findOne(table(), id, user(auth).aziendaId())
                .orElseThrow(() -> new IllegalArgumentException(label() + " non trovato"));
    }

    protected Long asLong(Object o) {
        if (o == null) return null;
        if (o instanceof Number n) return n.longValue();
        try { return Long.parseLong(o.toString()); }
        catch (NumberFormatException e) { throw new IllegalArgumentException("Valore numerico non valido: " + o); }
    }

    // ---------- operazioni comuni ----------

    protected Map<String, Object> doIndex(Authentication auth) {
        return Map.of("data", crud.list(table(), user(auth).aziendaId()));
    }

    protected Map<String, Object> doShow(Authentication auth, Long id) {
        return one(auth, id);
    }

    protected ResponseEntity<Map<String, Long>> doCreate(Authentication auth, Map<String, Object> body) {
        AuthenticatedUser u = user(auth);
        body.put("azienda_id", u.aziendaId());
        beforeCreate(u, body);
        long id = crud.insert(table(), body, fields());
        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("id", id));
    }

    protected Map<String, Object> doUpdate(Authentication auth, Long id, Map<String, Object> body) {
        AuthenticatedUser u = user(auth);
        one(auth, id);
        body.remove("azienda_id");
        body.remove("id");
        beforeUpdate(u, id, body);
        crud.update(table(), id, u.aziendaId(), body, fields());
        return Map.of("ok", true, "message", label() + " aggiornato");
    }

    protected Map<String, String> doDelete(Authentication auth, Long id) {
        AuthenticatedUser u = user(auth);
        one(auth, id);
        beforeDelete(u, id);
        crud.softDelete(table(), id, u.aziendaId());
        return Map.of("message", label() + " eliminato");
    }

    // ---------- hook opzionali ----------
    protected void beforeCreate(AuthenticatedUser user, Map<String, Object> body) {}
    protected void beforeUpdate(AuthenticatedUser user, Long id, Map<String, Object> body) {}
    protected void beforeDelete(AuthenticatedUser user, Long id) {}
}