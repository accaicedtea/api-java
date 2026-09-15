package com.accasw.ristoranteApp.config;

import java.time.Duration;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.caffeine.CaffeineCache;
import org.springframework.cache.support.SimpleCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.github.benmanes.caffeine.cache.Caffeine;

@Configuration
@EnableCaching
public class CacheConfig {

    private static final Logger log = LoggerFactory.getLogger(CacheConfig.class);

    @Bean
    public CacheManager cacheManager() {
        log.warn(">>> CacheConfig CARICATO — Caffeine (L1)");

        var cacheManager = new SimpleCacheManager();
        cacheManager.setCaches(List.of(
            buildCache("allergeni",        500, Duration.ofMinutes(30)),
            buildCache("menuPubblici", 1000, Duration.ofMinutes(10))
        ));
        return cacheManager;
    }

    private CaffeineCache buildCache(String name, long maxSize, Duration ttl) {
        return new CaffeineCache(name,
            Caffeine.newBuilder()
                .maximumSize(maxSize)
                .expireAfterWrite(ttl)
                .recordStats()                  // abilita statistiche per /actuator/metrics
                .build());
    }
}