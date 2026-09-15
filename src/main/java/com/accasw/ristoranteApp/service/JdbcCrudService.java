package com.accasw.ristoranteApp.service;

import java.sql.Statement;
import java.util.*;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;

import com.accasw.ristoranteApp.common.DbFields;

@Service
public class JdbcCrudService {

    private final JdbcTemplate jdbc;

    public JdbcCrudService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    // ============================================================
    // READ
    // ============================================================

    public List<Map<String, Object>> list(String table, Long aziendaId) {
        validateTable(table);
        return jdbc.queryForList(
                "SELECT * FROM " + table +
                " WHERE azienda_id = ? AND deleted_at IS NULL ORDER BY id DESC",
                aziendaId);
    }

    public List<Map<String, Object>> listPaginated(String table, Long aziendaId, int limit, int offset) {
        validateTable(table);
        if (limit <= 0 || limit > 500) limit = 50;
        if (offset < 0) offset = 0;
        return jdbc.queryForList(
                "SELECT * FROM " + table +
                " WHERE azienda_id = ? AND deleted_at IS NULL ORDER BY id DESC LIMIT ? OFFSET ?",
                aziendaId, limit, offset);
    }

    /**
     * Cachato per aziendaId (chiave) — la cache "allergeni" viene invalidata
     * quando insert/update/softDelete toccano la tabella 'allergeni'.
     *
     * Key SpEL: se aziendaId è null → 'system', altrimenti il valore numerico.
     * Così la cache per gli allergeni di sistema è separata da quella delle aziende.
     */
    @Cacheable(value = "allergeni", key = "#aziendaId == null ? 'system' : #aziendaId")
    public List<Map<String, Object>> listAllergens(Long aziendaId) {
        if (aziendaId == null) {
            return jdbc.queryForList(
                    "SELECT * FROM allergeni WHERE azienda_id IS NULL AND deleted_at IS NULL ORDER BY id");
        }
        return jdbc.queryForList(
                "SELECT * FROM allergeni WHERE (azienda_id = ? OR azienda_id IS NULL) " +
                "AND deleted_at IS NULL ORDER BY id", aziendaId);
    }

    public List<Map<String, Object>> findRows(String table, Long id, Long aziendaId) {
        validateTable(table);
        return jdbc.queryForList(
                "SELECT * FROM " + table +
                " WHERE id = ? AND azienda_id = ? AND deleted_at IS NULL",
                id, aziendaId);
    }

    public Optional<Map<String, Object>> findOne(String table, Long id, Long aziendaId) {
        return findRows(table, id, aziendaId).stream().findFirst();
    }

    public boolean exists(String table, Long id, Long aziendaId) {
        return !findRows(table, id, aziendaId).isEmpty();
    }

    public long count(String table, Long aziendaId) {
        validateTable(table);
        Long n = jdbc.queryForObject(
                "SELECT COUNT(*) FROM " + table +
                " WHERE azienda_id = ? AND deleted_at IS NULL",
                Long.class, aziendaId);
        return n == null ? 0L : n;
    }

    public boolean existsByColumn(String table, String column, Object value, Long aziendaId, Long excludeId) {
        validateTable(table);
        validateColumn(column);
        String sql = "SELECT COUNT(*) FROM " + table +
                " WHERE " + column + " = ? AND azienda_id = ? AND deleted_at IS NULL" +
                (excludeId != null ? " AND id <> ?" : "");
        Long n = excludeId == null
                ? jdbc.queryForObject(sql, Long.class, value, aziendaId)
                : jdbc.queryForObject(sql, Long.class, value, aziendaId, excludeId);
        return n != null && n > 0;
    }

    public List<Map<String, Object>> findByColumn(String table, String column, Object value) {
        validateTable(table);
        validateColumn(column);
        return jdbc.queryForList(
                "SELECT * FROM " + table +
                " WHERE " + column + " = ? AND deleted_at IS NULL ORDER BY id DESC", value);
    }

    // ============================================================
    // WRITE — invalidazione cache 'allergeni' solo se la tabella è allergeni
    // ============================================================

    @CacheEvict(value = "allergeni", allEntries = true, condition = "#table == 'allergeni'")
    public long insert(String table, Map<String, Object> input, Set<String> allowed) {
        validateTable(table);
        List<String> columns = new ArrayList<>();
        List<Object> values = new ArrayList<>();
        input.forEach((k, v) -> {
            if (allowed.contains(k) && v != null) {
                columns.add(k);
                values.add(v);
            }
        });
        if (columns.isEmpty()) throw new IllegalArgumentException("Nessun dato valido fornito");
        String placeholders = String.join(", ", Collections.nCopies(columns.size(), "?"));
        String sql = "INSERT INTO " + table + " (" + String.join(", ", columns) + ") VALUES (" + placeholders + ")";
        KeyHolder kh = new GeneratedKeyHolder();
        jdbc.update(con -> {
            var ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            for (int i = 0; i < values.size(); i++) ps.setObject(i + 1, values.get(i));
            return ps;
        }, kh);
        Number key = kh.getKey();
        if (key == null) throw new IllegalStateException("Impossibile recuperare la chiave generata");
        return key.longValue();
    }

    @CacheEvict(value = "allergeni", allEntries = true, condition = "#table == 'allergeni'")
    public int update(String table, Long id, Long aziendaId, Map<String, Object> input, Set<String> allowed) {
        validateTable(table);
        List<String> assignments = new ArrayList<>();
        List<Object> values = new ArrayList<>();
        input.forEach((k, v) -> {
            if (allowed.contains(k) && !"azienda_id".equals(k)) {
                assignments.add(k + " = ?");
                values.add(v);
            }
        });
        if (assignments.isEmpty()) throw new IllegalArgumentException("Nessun dato valido fornito");
        values.add(id);
        values.add(aziendaId);
        return jdbc.update(
                "UPDATE " + table + " SET " + String.join(", ", assignments) +
                " WHERE id = ? AND azienda_id = ? AND deleted_at IS NULL",
                values.toArray());
    }

    @CacheEvict(value = "allergeni", allEntries = true, condition = "#table == 'allergeni'")
    public int softDelete(String table, Long id, Long aziendaId) {
        validateTable(table);
        return jdbc.update(
                "UPDATE " + table + " SET deleted_at = CURRENT_TIMESTAMP " +
                "WHERE id = ? AND azienda_id = ? AND deleted_at IS NULL",
                id, aziendaId);
    }

    // ============================================================
    // GUARDS
    // ============================================================

    private void validateTable(String table) {
        if (!DbFields.ALLOWED_TABLES.contains(table))
            throw new IllegalArgumentException("Tabella non consentita: " + table);
    }

    private void validateColumn(String column) {
        if (column == null || !column.matches("[a-zA-Z_][a-zA-Z0-9_]*"))
            throw new IllegalArgumentException("Colonna non valida: " + column);
    }
}