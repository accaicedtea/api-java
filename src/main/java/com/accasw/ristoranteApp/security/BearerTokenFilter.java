package com.accasw.ristoranteApp.security;

import java.io.IOException;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.accasw.ristoranteApp.model.User;
import com.accasw.ristoranteApp.repository.UserRepository;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class BearerTokenFilter extends OncePerRequestFilter {

    private final UserRepository userRepository;

    public BearerTokenFilter(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {
        String authorization = request.getHeader("Authorization");
        if (authorization != null && authorization.startsWith("Bearer ")
                && SecurityContextHolder.getContext().getAuthentication() == null) {
            String token = authorization.substring(7).trim();
            userRepository.findByApiTokenAndActiveTrue(token).ifPresent(user -> authenticate(user));
        }
        filterChain.doFilter(request, response);
    }

    private void authenticate(User user) {
        String role = user.getRole() == null ? "user" : user.getRole().toUpperCase();
        var authorities = java.util.List.of(new SimpleGrantedAuthority("ROLE_" + role));
        var principal = new AuthenticatedUser(user.getId(), user.getAziendaId(), user.getUsername(), role);
        var authentication = new UsernamePasswordAuthenticationToken(principal, null, authorities);
        SecurityContextHolder.getContext().setAuthentication(authentication);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        return path.startsWith("/api/login")
                || path.startsWith("/api/manager/login")
                || path.startsWith("/api/menu/pubblici")
                || path.startsWith("/api/allergens")
                || path.startsWith("/test");
    }
}