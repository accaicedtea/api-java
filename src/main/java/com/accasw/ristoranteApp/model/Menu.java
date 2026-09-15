package com.accasw.ristoranteApp.model;

import java.time.Instant;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "menu")
public class Menu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "azienda_id", nullable = false)
    private Long aziendaId;

    @Column(nullable = false, length = 100)
    private String nome;

    @Column(columnDefinition = "TEXT")
    private String descrizione;

    @Column(nullable = false, unique = true, length = 150)
    private String slug;

    @Column(name = "lingua_predefinita", nullable = false, length = 5)
    private String linguaPredefinita = "it";

    @Column(nullable = false)
    private boolean predefinito;

    @Column(nullable = false)
    private boolean attivo = true;

    @Column(nullable = false)
    private short ordine;

    @Column(name = "qr_scansioni", nullable = false)
    private long qrScansioni;

    @Column(name = "created_at", insertable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_at", insertable = false, updatable = false)
    private Instant updatedAt;

    @Column(name = "deleted_at")
    private Instant deletedAt;

    // ---- getters/setters completi ----

    public Long getId() { return id; }
    public Long getAziendaId() { return aziendaId; }
    public void setAziendaId(Long aziendaId) { this.aziendaId = aziendaId; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getDescrizione() { return descrizione; }
    public void setDescrizione(String descrizione) { this.descrizione = descrizione; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public String getLinguaPredefinita() { return linguaPredefinita; }
    public void setLinguaPredefinita(String linguaPredefinita) { this.linguaPredefinita = linguaPredefinita; }

    public boolean isPredefinito() { return predefinito; }
    public void setPredefinito(boolean predefinito) { this.predefinito = predefinito; }

    public boolean isAttivo() { return attivo; }
    public void setAttivo(boolean attivo) { this.attivo = attivo; }

    public short getOrdine() { return ordine; }
    public void setOrdine(short ordine) { this.ordine = ordine; }

    public long getQrScansioni() { return qrScansioni; }
    public void setQrScansioni(long qrScansioni) { this.qrScansioni = qrScansioni; }

    public Instant getCreatedAt() { return createdAt; }
    public Instant getUpdatedAt() { return updatedAt; }

    public Instant getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Instant deletedAt) { this.deletedAt = deletedAt; }
}