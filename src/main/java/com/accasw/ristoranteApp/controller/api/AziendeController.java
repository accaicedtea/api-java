package com.accasw.ristoranteApp.controller.api;

import java.util.Map;
import java.util.Set;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import com.accasw.ristoranteApp.security.AuthenticatedUser;
import com.accasw.ristoranteApp.service.JdbcCrudService;

@RestController
@RequestMapping("/api/admin/azienda")
public class AziendeController {

    private static final Set<String> FIELDS = Set.of(
            "nome", "partita_iva", "indirizzo", "citta", "cap",
            "telefono", "email", "sito_web", "logo_url");
    private final JdbcCrudService crud;
    private final JdbcTemplate jdbc;

    public AziendeController(JdbcCrudService crud, JdbcTemplate jdbc) {
        this.crud = crud;
        this.jdbc = jdbc;
    }

    @GetMapping
    public Map<String, Object> show(Authentication auth) {
        Long aziendaId = user(auth).aziendaId();
        var rows = jdbc.queryForList("SELECT * FROM aziende WHERE id = ?", aziendaId);
        if (rows.isEmpty()) throw new IllegalArgumentException("Azienda non trovata");
        return Map.of("data", rows.get(0));
    }

    @PutMapping
    public Map<String, Object> update(Authentication auth, @RequestBody Map<String, Object> body) {
        Long aziendaId = user(auth).aziendaId();
        var assignments = new java.util.ArrayList<String>();
        var values = new java.util.ArrayList<Object>();
        body.forEach((k, v) -> {
            if (FIELDS.contains(k)) { assignments.add(k + " = ?"); values.add(v); }
        });
        if (assignments.isEmpty()) throw new IllegalArgumentException("Nessun dato valido fornito");
        values.add(aziendaId);
        jdbc.update("UPDATE aziende SET " + String.join(", ", assignments) + " WHERE id = ?", values.toArray());
        return Map.of("ok", true, "message", "Azienda aggiornata");
    }

    private AuthenticatedUser user(Authentication auth) { return (AuthenticatedUser) auth.getPrincipal(); }
}