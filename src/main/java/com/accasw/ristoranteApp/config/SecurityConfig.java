package com.accasw.ristoranteApp.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.accasw.ristoranteApp.security.BearerTokenFilter;

@Configuration
public class SecurityConfig {

    private static final Logger log = LoggerFactory.getLogger(SecurityConfig.class);

    private final BearerTokenFilter bearerTokenFilter;

    public SecurityConfig(BearerTokenFilter bearerTokenFilter) {
        log.warn(">>> SecurityConfig CARICATO <<<");
        this.bearerTokenFilter = bearerTokenFilter;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        log.warn(">>> SecurityFilterChain BUILD — CSRF DISABLED, CORS ENABLED <<<");
        http
            .cors(Customizer.withDefaults())    // ← Spring Security usa il bean corsConfigurationSource
            .csrf(csrf -> csrf.disable())
            .httpBasic(b -> b.disable())
            .formLogin(b -> b.disable())
            .logout(b -> b.disable())
            .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                .requestMatchers(
                    "/test",
                    "/api/login",
                    "/api/manager/login",
                    "/api/menu/pubblici/**",
                    "/api/allergens"
                ).permitAll()
                .requestMatchers("/api/admin/**").hasAnyRole("ADMIN", "MANAGER", "USER")
                .anyRequest().authenticated()
            )
            .addFilterBefore(bearerTokenFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}