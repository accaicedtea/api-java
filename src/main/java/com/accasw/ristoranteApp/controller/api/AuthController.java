package com.accasw.ristoranteApp.controller.api;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.accasw.ristoranteApp.security.AuthenticatedUser;
import com.accasw.ristoranteApp.service.AuthService;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;

@RestController
@RequestMapping("/api")
@Validated
public class AuthController {

	private final AuthService authService;

	public AuthController(AuthService authService) {
		this.authService = authService;
	}

	@PostMapping("/login")
	public Map<String, Object> login(@Valid @RequestBody LoginRequest request) {
		return authService.login(request.username(), request.password());
	}

	@PostMapping("/manager/login")
	public Map<String, Object> loginManager(@Valid @RequestBody ManagerLoginRequest request) {
		return authService.loginManager(request.email(), request.pin());
	}

	@PostMapping("/logout")
	public ResponseEntity<Map<String, String>> logout(Authentication authentication) {
		AuthenticatedUser user = (AuthenticatedUser) authentication.getPrincipal();
		authService.logout(user);
		return ResponseEntity.ok(Map.of("message", "Logout effettuato"));
	}

	public record LoginRequest(@NotBlank String username, @NotBlank String password) { }
	public record ManagerLoginRequest(@NotBlank String email, @NotBlank String pin) { }
}