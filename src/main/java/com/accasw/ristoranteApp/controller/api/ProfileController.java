package com.accasw.ristoranteApp.controller.api;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import com.accasw.ristoranteApp.exception.UnauthorizedApiException;
import com.accasw.ristoranteApp.repository.UserRepository;
import com.accasw.ristoranteApp.security.AuthenticatedUser;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@RestController
@RequestMapping("/api/admin/profile")
@Validated
public class ProfileController {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public ProfileController(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping
    public Map<String, Object> show(Authentication auth) {
        AuthenticatedUser current = (AuthenticatedUser) auth.getPrincipal();
        var user = userRepository.findById(current.id())
                .orElseThrow(() -> new IllegalArgumentException("Utente non trovato"));
        return Map.of("data", Map.of(
                "id", user.getId(),
                "username", user.getUsername(),
                "role", user.getRole(),
                "azienda_id", user.getAziendaId()
        ));
    }

    @PutMapping("/password")
    public ResponseEntity<Map<String, String>> changePassword(Authentication auth,
            @Valid @RequestBody ChangePasswordRequest request) {
        AuthenticatedUser current = (AuthenticatedUser) auth.getPrincipal();
        var user = userRepository.findById(current.id())
                .orElseThrow(() -> new IllegalArgumentException("Utente non trovato"));
        if (!passwordEncoder.matches(request.currentPassword(), user.getPassword())) {
            throw new UnauthorizedApiException("Password attuale non valida");
        }
        user.setPassword(passwordEncoder.encode(request.newPassword()));
        userRepository.save(user);
        return ResponseEntity.ok(Map.of("message", "Password aggiornata"));
    }

    public record ChangePasswordRequest(
            @NotBlank String currentPassword,
            @NotBlank @Size(min = 8, message = "La password deve avere almeno 8 caratteri") String newPassword) { }
}