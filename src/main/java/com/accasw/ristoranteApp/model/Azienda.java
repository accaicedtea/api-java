package com.accasw.ristoranteApp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "aziende")
public class Azienda {

    @Id
    private Long id;

    @Column(nullable = false)
    private String nome;

    @Column(name = "pin_hash", length = 255)
    private String pinHash;

    public Long getId() { return id; }
    public String getNome() { return nome; }
    public String getPinHash() { return pinHash; }
    public void setPinHash(String pinHash) { this.pinHash = pinHash; }
}