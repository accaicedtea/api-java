package com.accasw.ristoranteApp.controller.api;

import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;


import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import com.accasw.ristoranteApp.security.AuthenticatedUser;
import com.accasw.ristoranteApp.service.JdbcCrudService;

@RestController
@RequestMapping("/api/admin/dashboard")
public class DashboardController {

    private final JdbcCrudService crud;

    public DashboardController(JdbcCrudService crud) { this.crud = crud; }

    @GetMapping
    public Map<String, Object> stats(Authentication auth) {
        
        Long aziendaId = ((AuthenticatedUser) auth.getPrincipal()).aziendaId();
        LocalDate today = LocalDate.now();

        Map<String, Object> s = new LinkedHashMap<>();
        s.put("menu",         crud.count("menu", aziendaId));
        s.put("categorie",    crud.count("categorie", aziendaId));
        s.put("prodotti",     crud.count("prodotti", aziendaId));
        s.put("ingredienti",  crud.count("ingredienti", aziendaId));
        s.put("allergeni",    crud.count("allergeni", aziendaId));
        s.put("tavoli",       crud.count("tavoli", aziendaId));
        s.put("promozioni",   crud.count("promozioni", aziendaId));
        
        
        // Da oggi in poi
        s.put("prenotazioni", crud.countFromDate("prenotazioni", aziendaId, "data", today));
        s.put("events",       crud.countFromDate("events", aziendaId, "event_date", today));

        return Map.of("data", s);
    }
}