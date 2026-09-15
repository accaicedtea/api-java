package com.accasw.ristoranteApp.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.accasw.ristoranteApp.model.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // ---- login ----

    Optional<User> findByUsernameAndActiveTrue(String username);

    Optional<User> findByApiTokenAndActiveTrue(String apiToken);

    // ---- gestione utenti per azienda ----

    List<User> findByAziendaIdAndActiveTrue(Long aziendaId);

    Optional<User> findByIdAndAziendaId(Long id, Long aziendaId);

    boolean existsByUsername(String username);
}