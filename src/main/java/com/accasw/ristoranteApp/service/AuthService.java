package com.accasw.ristoranteApp.service;

import java.security.SecureRandom;
import java.util.HexFormat;
import java.util.Map;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.accasw.ristoranteApp.model.User;
import com.accasw.ristoranteApp.repository.AziendaRepository;
import com.accasw.ristoranteApp.repository.UserRepository;
import com.accasw.ristoranteApp.security.AuthenticatedUser;
import com.accasw.ristoranteApp.exception.UnauthorizedApiException;

@Service
public class AuthService {

	private final UserRepository userRepository;
	private final AziendaRepository aziendaRepository;
	private final PasswordEncoder passwordEncoder;
	private final SecureRandom secureRandom = new SecureRandom();

	public AuthService(UserRepository userRepository, AziendaRepository aziendaRepository,
			PasswordEncoder passwordEncoder) {
		this.userRepository = userRepository;
		this.aziendaRepository = aziendaRepository;
		this.passwordEncoder = passwordEncoder;
	}

	public Map<String, Object> login(String username, String password) {
		User user = userRepository.findByUsernameAndActiveTrue(username)
				.filter(candidate -> passwordEncoder.matches(password, candidate.getPassword()))
				.orElseThrow(() -> new UnauthorizedApiException("Credenziali non valide"));
		return tokenResponse(user, false);
	}

	public Map<String, Object> loginManager(String email, String pin) {
		User user = userRepository.findByUsernameAndActiveTrue(email)
				.filter(candidate -> "manager".equalsIgnoreCase(candidate.getRole()))
				.orElseThrow(() -> new UnauthorizedApiException("Credenziali manager non valide"));
		var azienda = aziendaRepository.findById(user.getAziendaId())
				.filter(candidate -> candidate.getPinHash() != null
						&& passwordEncoder.matches(pin, candidate.getPinHash()))
				.orElseThrow(() -> new UnauthorizedApiException("Credenziali manager non valide"));
		if (azienda == null) {
			throw new IllegalArgumentException("Credenziali manager non valide");
		}
		return tokenResponse(user, true);
	}

	public void logout(AuthenticatedUser user) {
		userRepository.findById(user.id()).ifPresent(account -> {
			account.setApiToken(null);
			userRepository.save(account);
		});
	}

	private Map<String, Object> tokenResponse(User user, boolean includeManagerData) {
		byte[] bytes = new byte[32];
		secureRandom.nextBytes(bytes);
		user.setApiToken(HexFormat.of().formatHex(bytes));
		userRepository.save(user);
		var response = new java.util.HashMap<String, Object>();
		response.put("status", 200);
		response.put("token", user.getApiToken());
		if (includeManagerData) {
			response.put("azienda_id", user.getAziendaId());
			response.put("role", user.getRole());
		}
		return response;
	}
}