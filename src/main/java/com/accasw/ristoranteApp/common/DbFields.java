package com.accasw.ristoranteApp.common;

import java.util.Set;

public final class DbFields {

    private DbFields() {}

    public static final Set<String> CATEGORIE = Set.of(
            "menu_id", "azienda_id", "parent_id", "nome", "descrizione",
            "icona", "immagine_url", "colore", "ordine", "visibile");

    public static final Set<String> ALLERGENI = Set.of(
            "azienda_id", "codice", "nome_it", "nome_en", "nome_fr",
            "nome_de", "nome_zh", "icona");

    public static final Set<String> PRODOTTI = Set.of(
            "azienda_id", "sku", "nome", "descrizione", "note_chef",
            "prezzo", "iva", "foto_url", "foto_thumbnail_url",
            "vegan", "vegetariano", "senza_glutine", "biologico",
            "piccante_livello", "calorie", "peso_grammi",
            "attivo", "ordine", "in_evidenza");

    public static final Set<String> INGREDIENTI = Set.of(
            "azienda_id", "nome", "descrizione",
            "foto_url", "foto_thumbnail_url", "colore_badge",
            "prezzo_extra", "vegan", "vegetariano", "senza_glutine",
            "piccante_livello", "calorie", "peso_grammi",
            "disponibile", "disponibile_dal", "disponibile_al",
            "ordine", "in_evidenza", "note_interne");

    public static final Set<String> TAVOLI = Set.of(
            "azienda_id", "numero", "posti", "zona", "priorita", "attivo");

    public static final Set<String> PROMOZIONI = Set.of(
            "azienda_id", "prodotto_id", "prodotti_menu_id",
            "tipo", "valore", "prezzo_finale",
            "data_inizio", "data_fine", "attiva");

    public static final Set<String> PRENOTAZIONI = Set.of(
            "azienda_id", "nome_cliente", "dominio", "email", "telefono",
            "data", "ora", "numero_persone", "note", "stato",
            "tavolo_id", "durata_minuti");

    public static final Set<String> EVENTS = Set.of(
            "azienda_id", "event_date", "event_name", "image_url",
            "is_closed", "publish_at");

    public static final Set<String> VARIAZIONI = Set.of(
            "prodotto_id", "nome", "prezzo_extra",
            "peso_grammi", "calorie", "attivo", "ordine");

    /** Tabelle consentite (anti SQL-injection via table name). */
    public static final Set<String> ALLOWED_TABLES = Set.of(
            "menu", "categorie", "prodotti", "ingredienti", "allergeni",
            "tavoli", "promozioni", "prenotazioni", "events",
            "variazioni_prodotto", "prodotti_menu",
            "prodotti_ingredienti", "ingredienti_allergeni");
}