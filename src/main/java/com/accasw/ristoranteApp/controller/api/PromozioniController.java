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
@RequestMapping("/api/admin/promozioni")
public class PromozioniController extends AbstractTenantCrudController {

    public PromozioniController(JdbcCrudService crud) { super(crud); }

    @Override protected String table()  { return "promozioni"; }
    @Override protected Set<String> fields() { return DbFields.PROMOZIONI; }
    @Override protected String label()  { return "Promozione"; }

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
        validate(body, u);
    }

    @Override
    protected void beforeUpdate(AuthenticatedUser u, Long id, Map<String, Object> body) {
        validate(body, u);
    }

    private void validate(Map<String, Object> body, AuthenticatedUser u) {
        Long prodottoId = asLong(body.get("prodotto_id"));
        if (prodottoId != null && !crud.exists("prodotti", prodottoId, u.aziendaId())) {
            throw new IllegalArgumentException("Prodotto non valido o non appartiene all'azienda");
        }
        Long pmId = asLong(body.get("prodotti_menu_id"));
        if (pmId != null) {
            // prodotti_menu non ha azienda_id → verifica attraverso prodotti
            var rows = crud.findByColumn("prodotti_menu", "id", pmId);
            if (rows.isEmpty()) throw new IllegalArgumentException("Riga prodotti_menu non valida");
            Long pid = asLong(rows.get(0).get("prodotto_id"));
            if (pid == null || !crud.exists("prodotti", pid, u.aziendaId())) {
                throw new IllegalArgumentException("prodotti_menu non appartiene all'azienda");
            }
        }
        Object tipo = body.get("tipo");
        if (tipo != null && !"percentuale".equals(tipo) && !"importo".equals(tipo)) {
            throw new IllegalArgumentException("Tipo promozione non valido");
        }
    }
}