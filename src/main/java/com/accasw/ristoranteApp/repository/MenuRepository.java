package com.accasw.ristoranteApp.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.accasw.ristoranteApp.model.Menu;

@Repository
public interface MenuRepository extends JpaRepository<Menu, Long> {

    // admin
    List<Menu> findByAziendaIdAndDeletedAtIsNullOrderByOrdineAscNomeAsc(Long aziendaId);
    Optional<Menu> findByIdAndAziendaIdAndDeletedAtIsNull(Long id, Long aziendaId);

    // slug
    boolean existsBySlugAndDeletedAtIsNull(String slug);
    boolean existsBySlugAndDeletedAtIsNullAndIdNot(String slug, Long id);
    Optional<Menu> findBySlugAndDeletedAtIsNull(String slug);

    // pubblici
    List<Menu> findByAttivoTrueAndDeletedAtIsNullOrderByOrdineAsc();
    Optional<Menu> findBySlugAndAttivoTrueAndDeletedAtIsNull(String slug);

    // utility
    long countByAziendaIdAndDeletedAtIsNull(Long aziendaId);
}