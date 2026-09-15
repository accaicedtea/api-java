package com.accasw.ristoranteApp.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.accasw.ristoranteApp.model.Azienda;

public interface AziendaRepository extends JpaRepository<Azienda, Long> {
}