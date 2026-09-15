package com.accasw.ristoranteApp.security;

public record AuthenticatedUser(Long id, Long aziendaId, String username, String role) {
}