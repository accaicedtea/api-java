-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Creato il: Set 13, 2026 alle 21:31
-- Versione del server: 10.4.28-MariaDB
-- Versione PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `acca_kirby`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `allergeni`
--

CREATE TABLE `allergeni` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `azienda_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'NULL = allergene standard (i 14 UE ecc.), altrimenti personalizzato',
  `codice` varchar(30) NOT NULL,
  `nome_it` varchar(100) NOT NULL,
  `nome_en` varchar(100) DEFAULT NULL,
  `nome_fr` varchar(100) DEFAULT NULL,
  `nome_de` varchar(100) DEFAULT NULL,
  `nome_zh` varchar(100) DEFAULT NULL,
  `icona` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `allergeni`
--

INSERT INTO `allergeni` (`id`, `azienda_id`, `codice`, `nome_it`, `nome_en`, `nome_fr`, `nome_de`, `nome_zh`, `icona`) VALUES
(1, NULL, 'glutine', 'Glutine', 'Gluten', 'Gluten', 'Gluten', '含麸质的谷物', NULL),
(2, NULL, 'crostacei', 'Crostacei', 'Crustaceans', 'Crustacés', 'Krebstiere', '甲壳类动物及其制品', NULL),
(3, NULL, 'uova', 'Uova', 'Eggs', 'Œufs', 'Eier', '鸡蛋及其制品', NULL),
(4, NULL, 'pesce', 'Pesce', 'Fish', 'Poisson', 'Fisch', '鱼类及其制品', NULL),
(5, NULL, 'arachidi', 'Arachidi', 'Peanuts', 'Arachides', 'Erdnüsse', '花生及其制品', NULL),
(6, NULL, 'soia', 'Soia', 'Soybeans', 'Soja', 'Soja', '大豆及其制品', NULL),
(7, NULL, 'latte', 'Latte e derivati', 'Milk', 'Lait', 'Milch', '牛奶及其制品（包括乳糖）', NULL),
(8, NULL, 'frutta_guscio', 'Frutta a guscio', 'Tree nuts', 'Fruits à coque', 'Schalenfrüchte', '坚果及其制品', NULL),
(9, NULL, 'sedano', 'Sedano', 'Celery', 'Céleri', 'Sellerie', '芹菜及其制品', NULL),
(10, NULL, 'senape', 'Senape', 'Mustard', 'Moutarde', 'Senf', '芥末及其制品', NULL),
(11, NULL, 'sesamo', 'Semi di sesamo', 'Sesame seeds', 'Graines de sésame', 'Sesamsamen', '芝麻及其制品', NULL),
(12, NULL, 'solfiti', 'Anidride solforosa e solfiti', 'Sulphites', 'Sulfites', 'Sulfite', '二氧化硫及亚硫酸盐', NULL),
(13, NULL, 'lupini', 'Lupini', 'Lupin', 'Lupin', 'Lupinen', '羽扇豆及其制品', NULL),
(14, NULL, 'molluschi', 'Molluschi', 'Molluscs', 'Mollusques', 'Weichtiere', '软体动物及其制品', NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `aziende`
--

CREATE TABLE `aziende` (
  `id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) NOT NULL,
  `piano_id` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `nome` varchar(255) NOT NULL DEFAULT '',
  `ragione_sociale` varchar(255) DEFAULT NULL,
  `piva` varchar(20) DEFAULT NULL,
  `codice_fiscale` varchar(20) DEFAULT NULL,
  `sdi` varchar(10) DEFAULT NULL,
  `pec` varchar(255) DEFAULT NULL,
  `indirizzo` varchar(255) DEFAULT NULL,
  `civico` varchar(10) DEFAULT NULL,
  `cap` char(5) DEFAULT NULL,
  `citta` varchar(100) DEFAULT NULL,
  `provincia` char(2) DEFAULT NULL,
  `paese` char(2) NOT NULL DEFAULT 'IT',
  `email` varchar(255) NOT NULL DEFAULT '',
  `pin_hash` varchar(255) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `sito_web` varchar(255) DEFAULT NULL,
  `cassa_tipo` enum('cassa_in_cloud','lightspeed','local_agent','none') NOT NULL DEFAULT 'none',
  `cassa_config` text DEFAULT NULL,
  `cassa_verificata` tinyint(1) NOT NULL DEFAULT 0,
  `cassa_ultimo_test` timestamp NULL DEFAULT NULL,
  `cassa_test_esito` varchar(255) DEFAULT NULL,
  `lingua_default` char(2) NOT NULL DEFAULT 'it',
  `valuta` char(3) NOT NULL DEFAULT 'EUR',
  `fuso_orario` varchar(50) NOT NULL DEFAULT 'Europe/Rome',
  `logo_url` varchar(500) DEFAULT NULL,
  `colore_primario` char(7) DEFAULT '#1A4B9B',
  `timeout_idle_sec` smallint(6) NOT NULL DEFAULT 90,
  `messaggio_benvenuto` text DEFAULT NULL,
  `messaggio_grazie` text DEFAULT NULL,
  `stato` enum('attivo','sospeso','cancellato','trial') NOT NULL DEFAULT 'trial',
  `trial_scadenza` date DEFAULT NULL,
  `abbonamento_dal` date DEFAULT NULL,
  `abbonamento_al` date DEFAULT NULL,
  `prossimo_rinnovo` date DEFAULT NULL,
  `metodo_pagamento` varchar(100) DEFAULT NULL,
  `note_interne` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `aziende`
--

INSERT INTO `aziende` (`id`, `tenant_id`, `piano_id`, `nome`, `ragione_sociale`, `piva`, `codice_fiscale`, `sdi`, `pec`, `indirizzo`, `civico`, `cap`, `citta`, `provincia`, `paese`, `email`, `pin_hash`, `telefono`, `sito_web`, `cassa_tipo`, `cassa_config`, `cassa_verificata`, `cassa_ultimo_test`, `cassa_test_esito`, `lingua_default`, `valuta`, `fuso_orario`, `logo_url`, `colore_primario`, `timeout_idle_sec`, `messaggio_benvenuto`, `messaggio_grazie`, `stato`, `trial_scadenza`, `abbonamento_dal`, `abbonamento_al`, `prossimo_rinnovo`, `metodo_pagamento`, `note_interne`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 2, 'Kumpir Roma', 'Kumpir Roma S.R.L.', '12345678901', NULL, NULL, NULL, 'Via del Corso', '10', '00186', 'Roma', 'RM', 'IT', 'info@kumpirroma.it', '<hash generato con password_hash>', '+39 06 1234567', 'localhost', 'none', NULL, 0, NULL, NULL, 'it', 'EUR', 'Europe/Rome', NULL, '#E85D04', 90, 'Benvenuto da Kumpir Roma! 🥔', 'Grazie! Il tuo ordine è in preparazione 🎉', 'attivo', NULL, '2026-03-09', NULL, '2026-04-09', NULL, NULL, '2026-03-09 18:01:03', '2026-07-24 13:40:09', NULL),
(3, 1, 1, 'fijfirj', NULL, '49384938', 'fijfrif232', NULL, NULL, 'via dal ca', NULL, '00191', 'roma', 'RM', 'IT', 'jfijfir@gmgm.com', NULL, '989384938', 'localhost', 'none', NULL, 0, NULL, NULL, 'it', 'EUR', 'Europe/Rome', NULL, '#1A4B9B', 90, 'Benvenuto al ca', 'Ciao grazi', 'attivo', NULL, NULL, NULL, NULL, NULL, NULL, '2026-04-27 16:16:28', '2026-07-16 13:36:40', NULL),
(4, 1, 4, 'MenuOnliu.Risto', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'IT', 'hasansincreed@gmail.com', NULL, NULL, 'localhost', 'none', NULL, 0, NULL, NULL, 'it', 'EUR', 'Europe/Rome', NULL, '#1A4B9B', 90, NULL, NULL, 'trial', NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-06 08:30:34', '2026-07-16 13:36:41', NULL),
(9, 1, 3, 'ROMA ROMA ROMA', 'SEMPRE ROMA', '4093084038', 'BDLSHSN232', 'gioven', NULL, NULL, NULL, NULL, NULL, NULL, 'IT', 'gmail@gmail.com', NULL, NULL, 'localhost', 'lightspeed', NULL, 0, NULL, NULL, 'it', 'EUR', 'Europe/Rome', NULL, '#1A4B9B', 90, NULL, NULL, 'trial', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-20 18:51:55', '2026-07-16 13:39:40', NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `categorie`
--

CREATE TABLE `categorie` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `menu_id` smallint(5) UNSIGNED NOT NULL,
  `azienda_id` int(10) UNSIGNED NOT NULL,
  `parent_id` smallint(5) UNSIGNED DEFAULT NULL,
  `nome` varchar(100) NOT NULL,
  `descrizione` text DEFAULT NULL,
  `icona` varchar(50) DEFAULT NULL,
  `immagine_url` varchar(500) DEFAULT NULL,
  `colore` char(7) DEFAULT NULL,
  `ordine` smallint(6) NOT NULL DEFAULT 0,
  `visibile` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `categorie`
--

INSERT INTO `categorie` (`id`, `menu_id`, `azienda_id`, `parent_id`, `nome`, `descrizione`, `icona`, `immagine_url`, `colore`, `ordine`, `visibile`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 2, 1, NULL, 'Pizze', NULL, NULL, NULL, NULL, 3, 1, '2026-06-24 22:17:16', '2026-09-08 14:46:22', NULL),
(2, 18, 1, NULL, 'Paste', NULL, NULL, NULL, NULL, 2, 1, '2026-06-24 22:17:16', '2026-09-08 21:03:12', NULL),
(3, 18, 1, NULL, 'Antipasti', NULL, NULL, NULL, NULL, 1, 1, '2026-06-24 22:17:16', '2026-09-08 21:03:12', NULL),
(4, 2, 1, NULL, 'Insalate', NULL, NULL, NULL, NULL, 4, 1, '2026-06-24 22:17:16', '2026-09-08 14:46:22', NULL),
(5, 1, 1, NULL, 'Dessert', NULL, NULL, NULL, NULL, 5, 1, '2026-06-24 22:17:16', '2026-07-13 20:52:07', NULL),
(6, 18, 1, NULL, 'Insalate estive', NULL, NULL, NULL, NULL, 1, 1, '2026-06-24 22:17:16', '2026-09-08 21:03:12', NULL),
(7, 2, 1, NULL, 'Piatti freddi', NULL, NULL, NULL, NULL, 2, 1, '2026-06-24 22:17:16', '2026-07-13 20:52:05', NULL),
(8, 2, 1, NULL, 'Cocktail analcolici', NULL, NULL, NULL, NULL, 3, 1, '2026-06-24 22:17:16', '2026-07-13 20:52:04', NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `categorie_traduzioni`
--

CREATE TABLE `categorie_traduzioni` (
  `id` int(10) UNSIGNED NOT NULL,
  `categoria_id` smallint(5) UNSIGNED NOT NULL,
  `lingua` varchar(5) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descrizione` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `categorie_traduzioni`
--

INSERT INTO `categorie_traduzioni` (`id`, `categoria_id`, `lingua`, `nome`, `descrizione`) VALUES
(1, 1, 'fr', 'Pizzas', NULL),
(2, 1, 'de', 'Pizzen', NULL),
(3, 1, 'zh', '比萨', NULL),
(4, 2, 'fr', 'Pâtes', NULL),
(5, 2, 'de', 'Pasta', NULL),
(6, 2, 'zh', '意大利面', NULL),
(7, 3, 'fr', 'Entrées', NULL),
(8, 3, 'de', 'Vorspeisen', NULL),
(9, 3, 'zh', '前菜', NULL),
(10, 4, 'fr', 'Salades', NULL),
(11, 4, 'de', 'Salate', NULL),
(12, 4, 'zh', '沙拉', NULL),
(13, 5, 'fr', 'Desserts', NULL),
(14, 5, 'de', 'Desserts', NULL),
(15, 5, 'zh', '甜点', NULL),
(16, 6, 'fr', 'Salades d\'été', NULL),
(17, 6, 'de', 'Sommersalate', NULL),
(18, 6, 'zh', '夏季沙拉', NULL),
(19, 7, 'fr', 'Plats froids', NULL),
(20, 7, 'de', 'Kalte Gerichte', NULL),
(21, 7, 'zh', '冷盘', NULL),
(22, 8, 'fr', 'Cocktails sans alcool', NULL),
(23, 8, 'de', 'Alkoholfreie Cocktails', NULL),
(24, 8, 'zh', '无酒精鸡尾酒', NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `azienda_id` int(11) NOT NULL,
  `event_date` date NOT NULL,
  `event_name` varchar(255) DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `is_closed` tinyint(1) NOT NULL DEFAULT 0,
  `publish_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `events`
--

INSERT INTO `events` (`id`, `azienda_id`, `event_date`, `event_name`, `image_url`, `is_closed`, `publish_at`, `created_at`, `updated_at`) VALUES
(4, 1, '2026-06-29', 'Serata Jazz', NULL, 0, NULL, '2026-07-03 12:46:53', '2026-07-03 13:41:56'),
(5, 1, '2026-06-30', NULL, NULL, 1, NULL, '2026-07-03 12:46:53', '2026-07-03 13:41:56'),
(6, 0, '2026-07-01', NULL, NULL, 1, NULL, '2026-07-03 14:00:22', '2026-07-03 14:00:22'),
(9, 0, '2026-07-02', NULL, NULL, 1, NULL, '2026-07-03 14:00:27', '2026-07-03 14:00:27'),
(18, 0, '2026-07-03', NULL, NULL, 1, NULL, '2026-07-03 14:01:51', '2026-07-03 14:01:51'),
(19, 0, '2026-07-17', NULL, NULL, 1, NULL, '2026-07-03 14:01:53', '2026-07-03 14:01:53'),
(20, 0, '2026-07-18', NULL, NULL, 1, NULL, '2026-07-03 14:01:55', '2026-07-03 14:01:55'),
(21, 0, '2026-07-25', NULL, NULL, 1, NULL, '2026-07-03 14:01:56', '2026-07-03 14:01:56'),
(23, 0, '2026-07-15', 'ccckcck', '', 0, NULL, '2026-07-13 21:57:44', '2026-07-13 21:57:44'),
(30, 1, '2026-07-15', 'cjcjc', '', 0, '2026-07-14 00:01:00', '2026-07-14 00:01:18', '2026-07-14 00:01:18'),
(39, 1, '2026-07-16', 'ckokcowjcw', '', 0, '2026-07-14 00:14:00', '2026-07-14 00:14:48', '2026-07-14 00:14:48'),
(40, 1, '2026-07-17', 'Ciao', '', 0, '2026-07-14 00:14:00', '2026-07-14 00:14:53', '2026-07-14 00:14:53'),
(41, 1, '2026-07-13', 'jcwocwcjowc', '', 0, '2026-07-14 00:14:00', '2026-07-14 00:14:59', '2026-07-14 00:14:59'),
(42, 1, '2026-07-14', 'cwocwococwoc', '', 0, '2026-07-14 00:15:00', '2026-07-14 00:15:05', '2026-07-14 00:15:05'),
(43, 1, '2026-07-18', 'cwjocjwocjowcocjocjwoc', '', 0, '2026-07-14 00:15:00', '2026-07-14 00:15:10', '2026-07-14 00:15:10'),
(44, 1, '2026-07-19', 'mmm', '', 0, '2026-07-14 00:15:00', '2026-07-14 00:15:14', '2026-07-14 00:15:14'),
(45, 1, '2026-07-22', 'ciaoaoa', '', 0, NULL, '2026-07-14 19:38:30', '2026-07-14 19:38:30'),
(53, 1, '2026-08-31', '', '', 0, NULL, '2026-08-26 15:03:09', '2026-08-26 15:03:09'),
(54, 1, '2026-08-24', '', '', 0, NULL, '2026-08-26 15:03:11', '2026-08-26 15:03:11'),
(55, 1, '2026-08-17', '', '', 0, NULL, '2026-08-26 15:03:12', '2026-08-26 15:03:12'),
(56, 1, '2026-08-10', '', '', 0, NULL, '2026-08-26 15:03:13', '2026-08-26 15:03:13'),
(57, 1, '2026-08-03', '', '', 0, NULL, '2026-08-26 15:03:15', '2026-08-26 15:03:15'),
(59, 1, '2026-08-26', '', '', 0, NULL, '2026-08-26 15:05:39', '2026-08-26 15:05:39');

-- --------------------------------------------------------

--
-- Struttura della tabella `ingredienti`
--

CREATE TABLE `ingredienti` (
  `id` int(10) UNSIGNED NOT NULL,
  `azienda_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'NULL = ingrediente di sistema condiviso, altrimenti personalizzato dall''azienda',
  `nome` varchar(150) NOT NULL,
  `descrizione` text DEFAULT NULL,
  `foto_url` varchar(500) DEFAULT NULL,
  `foto_thumbnail_url` varchar(500) DEFAULT NULL,
  `colore_badge` char(7) DEFAULT NULL,
  `prezzo_extra` decimal(8,2) NOT NULL DEFAULT 0.00,
  `vegan` tinyint(1) NOT NULL DEFAULT 0,
  `vegetariano` tinyint(1) NOT NULL DEFAULT 0,
  `senza_glutine` tinyint(1) NOT NULL DEFAULT 0,
  `piccante_livello` tinyint(4) NOT NULL DEFAULT 0,
  `calorie` smallint(5) UNSIGNED DEFAULT NULL,
  `peso_grammi` smallint(5) UNSIGNED DEFAULT NULL,
  `disponibile` tinyint(1) NOT NULL DEFAULT 1,
  `disponibile_dal` time DEFAULT NULL,
  `disponibile_al` time DEFAULT NULL,
  `ordine` smallint(6) NOT NULL DEFAULT 0,
  `in_evidenza` tinyint(1) NOT NULL DEFAULT 0,
  `note_interne` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `ingredienti`
--

INSERT INTO `ingredienti` (`id`, `azienda_id`, `nome`, `descrizione`, `foto_url`, `foto_thumbnail_url`, `colore_badge`, `prezzo_extra`, `vegan`, `vegetariano`, `senza_glutine`, `piccante_livello`, `calorie`, `peso_grammi`, `disponibile`, `disponibile_dal`, `disponibile_al`, `ordine`, `in_evidenza`, `note_interne`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Pomodoroo', 'Salsa di pomodoro fresco', NULL, NULL, NULL, 0.00, 1, 1, 1, 0, 18, 100, 1, NULL, NULL, 1, 1, NULL, '2026-06-24 22:17:16', '2026-07-13 21:10:35', NULL),
(2, 1, 'Mozzarella', 'Fior di latte', NULL, NULL, NULL, 0.00, 0, 1, 0, 0, 280, 100, 1, NULL, NULL, 2, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 23:09:52', NULL),
(3, 1, 'Ricotta', 'Ricotta fresca di latte vaccino', NULL, NULL, NULL, 0.00, 0, 1, 1, 0, 174, 100, 1, NULL, NULL, 3, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(4, 1, 'Speck', 'Speck Alto Adige IGP', NULL, NULL, NULL, 1.50, 0, 0, 1, 0, 115, 60, 1, NULL, NULL, 4, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(5, 1, 'Prosciutto cotto', 'Prosciutto cotto di alta qualità', NULL, NULL, NULL, 1.50, 0, 0, 1, 0, 105, 70, 1, NULL, NULL, 5, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(6, 1, 'Salame piccante', 'Salame stagionato con peperoncino', NULL, NULL, '#E63946', 1.50, 0, 0, 1, 3, 345, 60, 1, NULL, NULL, 6, 1, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(7, 1, 'Funghi', 'Funghi champignon freschi', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 22, 80, 1, NULL, NULL, 7, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(8, 1, 'Carciofi', 'Cuori di carciofo', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 47, 80, 1, NULL, NULL, 8, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(9, 1, 'Olive', 'Olive nere denocciolate', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 115, 50, 1, NULL, NULL, 9, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(10, 1, 'Cipolla', 'Cipolla rossa di Tropea', NULL, NULL, NULL, 0.00, 1, 1, 1, 0, 40, 50, 1, NULL, NULL, 10, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(11, 1, 'Peperoni', 'Peperoni rossi e gialli', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 31, 80, 1, NULL, NULL, 11, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(12, 1, 'Melanzane', 'Melanzane grigliate', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 24, 80, 1, NULL, NULL, 12, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(13, 1, 'Parmigiano Reggiano', 'Parmigiano Reggiano DOP 24 mesi', NULL, NULL, NULL, 1.00, 0, 1, 1, 0, 387, 60, 1, NULL, NULL, 13, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(14, 1, 'Provola', 'Provola affumicata', NULL, NULL, NULL, 0.50, 0, 1, 0, 0, 326, 70, 1, NULL, NULL, 14, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(15, 1, 'Salsiccia', 'Salsiccia fresca di suino', NULL, NULL, NULL, 1.50, 0, 0, 1, 1, 340, 80, 1, NULL, NULL, 15, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(16, 1, 'Gamberetti', 'Gamberetti sgusciati', NULL, NULL, NULL, 2.00, 0, 0, 1, 0, 99, 70, 1, NULL, NULL, 16, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(17, 1, 'Tonno', 'Tonno sott\'olio', NULL, NULL, NULL, 1.50, 0, 0, 1, 0, 198, 80, 1, NULL, NULL, 17, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(18, 1, 'Scamorza', 'Scamorza affumicata', NULL, NULL, NULL, 0.50, 0, 1, 0, 0, 334, 70, 1, NULL, NULL, 18, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(19, 1, 'Uovo', 'Uovo sodo a fette', NULL, NULL, NULL, 0.80, 0, 1, 1, 0, 155, 100, 1, NULL, NULL, 19, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(20, 1, 'Acciughe', 'Acciughe sott\'olio', NULL, NULL, NULL, 1.00, 0, 0, 1, 0, 210, 40, 1, NULL, NULL, 20, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(21, 1, 'Salmone affumicato', 'Salmone norvegese affumicato', NULL, NULL, NULL, 2.50, 0, 0, 1, 0, 208, 60, 1, NULL, NULL, 21, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(22, 1, 'Pangrattato', 'Pangrattato tostato', NULL, NULL, NULL, 0.00, 1, 1, 0, 0, 360, 30, 1, NULL, NULL, 22, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(23, 1, 'Noci', 'Gherigli di noce', NULL, NULL, NULL, 1.00, 1, 1, 1, 0, 654, 30, 1, NULL, NULL, 23, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(24, 1, 'Mandorle', 'Mandorle pelate', NULL, NULL, NULL, 0.80, 1, 1, 1, 0, 579, 30, 1, NULL, NULL, 24, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(25, 1, 'Pistacchi', 'Pistacchi di Bronte', NULL, NULL, NULL, 1.50, 1, 1, 1, 0, 562, 30, 1, NULL, NULL, 25, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(26, 1, 'Crostini', 'Crostini di pane casereccio', NULL, NULL, NULL, 0.50, 1, 1, 0, 0, 379, 40, 1, NULL, NULL, 26, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(27, 1, 'Sedano', 'Sedano a cubetti', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 16, 50, 1, NULL, NULL, 27, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(28, 1, 'Senape', 'Senape in grani', NULL, NULL, NULL, 0.30, 1, 1, 1, 1, 66, 20, 1, NULL, NULL, 28, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(29, 1, 'Burrata', 'Burrata pugliese', NULL, NULL, NULL, 2.00, 0, 1, 0, 0, 330, 100, 1, NULL, NULL, 29, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(30, 1, 'Gorgonzola', 'Gorgonzola DOP dolce', NULL, NULL, NULL, 1.00, 0, 1, 1, 0, 314, 60, 1, NULL, NULL, 30, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(31, 1, 'Salsa di soia', 'Salsa di soia giapponese', NULL, NULL, NULL, 0.50, 1, 1, 0, 0, 53, 20, 1, NULL, NULL, 31, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(32, 1, 'Pasta fresca', 'Pasta all\'uovo', NULL, NULL, NULL, 0.00, 0, 1, 0, 0, 288, 150, 1, NULL, NULL, 32, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(33, 1, 'Calamari', 'Calamari a rondelle', NULL, NULL, NULL, 2.00, 0, 0, 1, 0, 92, 80, 1, NULL, NULL, 33, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(34, 1, 'Pane', 'Pane casereccio a fette', NULL, NULL, NULL, 0.00, 1, 1, 0, 0, 275, 100, 1, NULL, NULL, 34, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(35, 1, 'Uvetta', 'Uvetta sultanina', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 299, 30, 1, NULL, NULL, 35, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(36, 1, 'Peperoncino', 'Peperoncino fresco', NULL, NULL, '#D90429', 0.00, 1, 1, 1, 5, 40, 10, 1, NULL, NULL, 36, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(37, 1, 'Rucola', 'Rucola selvatica', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 25, 30, 1, NULL, NULL, 37, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(38, 1, 'Basilico', 'Basilico fresco', NULL, NULL, NULL, 0.00, 1, 1, 1, 0, 23, 10, 1, NULL, NULL, 38, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(39, 1, 'Origano', 'Origano secco', NULL, NULL, NULL, 0.00, 1, 1, 1, 0, 306, 5, 1, NULL, NULL, 39, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(40, 1, 'Aglio', 'Aglio fresco', NULL, NULL, NULL, 0.00, 1, 1, 1, 0, 149, 10, 1, NULL, NULL, 40, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(41, 1, 'Olio EVO', 'Olio extravergine d\'oliva', NULL, NULL, NULL, 0.00, 1, 1, 1, 0, 884, 20, 1, NULL, NULL, 41, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(42, 1, 'Aceto balsamico', 'Aceto balsamico di Modena IGP', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 88, 15, 1, NULL, NULL, 42, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(43, 1, 'Capperi', 'Capperi sotto sale', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 23, 20, 1, NULL, NULL, 43, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(44, 1, 'Porchetta', 'Porchetta di Ariccia', NULL, NULL, NULL, 2.00, 0, 0, 1, 0, 275, 80, 1, NULL, NULL, 44, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(45, 1, 'Pancetta', 'Pancetta tesa stagionata', NULL, NULL, NULL, 1.50, 0, 0, 1, 0, 458, 60, 1, NULL, NULL, 45, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(46, 1, 'Bresaola', 'Bresaola della Valtellina', NULL, NULL, NULL, 2.00, 0, 0, 1, 0, 151, 60, 1, NULL, NULL, 46, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(47, 1, 'Pinoli', 'Pinoli italiani', NULL, NULL, NULL, 1.00, 1, 1, 1, 0, 673, 20, 1, NULL, NULL, 47, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(48, 1, 'Semi di sesamo', 'Semi di sesamo tostati', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 573, 15, 1, NULL, NULL, 48, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(49, 1, 'Lupini', 'Farina di lupini', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 330, 30, 1, NULL, NULL, 49, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(50, 1, 'Mozzarella di bufala', 'Mozzarella di bufala campana DOP', NULL, NULL, NULL, 2.50, 0, 1, 0, 0, 270, 125, 1, NULL, NULL, 50, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(51, 1, 'Stracciatella', 'Stracciatella di bufala', NULL, NULL, NULL, 2.00, 0, 1, 0, 0, 300, 80, 1, NULL, NULL, 51, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(52, 1, 'Tartufo', 'Tartufo nero estivo', NULL, NULL, NULL, 4.00, 1, 1, 1, 0, 54, 15, 1, NULL, NULL, 52, 1, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(53, 1, 'Pesto', 'Pesto genovese (basilico, pinoli, formaggi)', NULL, NULL, '#2A9D8F', 1.50, 0, 1, 1, 0, 470, 50, 1, NULL, NULL, 53, 1, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(54, 1, 'Crema di zucca', 'Crema di zucca mantovana', NULL, NULL, NULL, 1.00, 1, 1, 1, 0, 76, 80, 1, NULL, NULL, 54, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(55, 1, 'Radicchio', 'Radicchio rosso di Treviso', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 23, 60, 1, NULL, NULL, 55, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(56, 1, 'Zola dolce', 'Gorgonzola cremoso', NULL, NULL, NULL, 1.00, 0, 1, 1, 0, 314, 60, 1, NULL, NULL, 56, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(57, 1, 'Feta', 'Formaggio greco DOP', NULL, NULL, NULL, 1.00, 0, 1, 1, 0, 264, 80, 1, NULL, NULL, 57, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(58, 1, 'Cetriolo', 'Cetriolo fresco a dadini', NULL, NULL, NULL, 0.50, 1, 1, 1, 0, 15, 80, 1, NULL, NULL, 58, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL),
(59, 1, 'Menta', 'Menta fresca', NULL, NULL, NULL, 0.00, 1, 1, 1, 0, 70, 5, 1, NULL, NULL, 59, 0, NULL, '2026-06-24 22:17:16', '2026-07-13 16:53:41', NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `ingredienti_allergeni`
--

CREATE TABLE `ingredienti_allergeni` (
  `ingrediente_id` int(10) UNSIGNED NOT NULL,
  `allergene_id` tinyint(3) UNSIGNED NOT NULL,
  `presente` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `ingredienti_allergeni`
--

INSERT INTO `ingredienti_allergeni` (`ingrediente_id`, `allergene_id`, `presente`) VALUES
(2, 7, 1),
(3, 7, 1),
(13, 7, 1),
(14, 7, 1),
(16, 2, 1),
(17, 4, 1),
(18, 7, 1),
(19, 3, 1),
(20, 4, 1),
(21, 4, 1),
(22, 1, 1),
(23, 8, 1),
(24, 8, 1),
(25, 8, 1),
(26, 1, 1),
(27, 9, 1),
(28, 10, 1),
(29, 7, 1),
(30, 7, 1),
(31, 1, 1),
(31, 6, 1),
(32, 1, 1),
(32, 3, 1),
(33, 14, 1),
(34, 1, 1),
(35, 12, 1),
(42, 12, 1),
(47, 8, 1),
(48, 11, 1),
(49, 13, 1),
(50, 7, 1),
(51, 7, 1),
(53, 7, 1),
(53, 8, 1),
(56, 7, 1),
(57, 7, 1);

-- --------------------------------------------------------

--
-- Struttura della tabella `ingredienti_traduzioni`
--

CREATE TABLE `ingredienti_traduzioni` (
  `id` int(10) UNSIGNED NOT NULL,
  `ingrediente_id` int(10) UNSIGNED NOT NULL,
  `lingua` varchar(5) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `descrizione` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `ingredienti_traduzioni`
--

INSERT INTO `ingredienti_traduzioni` (`id`, `ingrediente_id`, `lingua`, `nome`, `descrizione`) VALUES
(1, 1, 'it', 'Pomodoro', 'Salsa di pomodoro fresco'),
(2, 1, 'fr', 'Tomate', 'Sauce tomate fraîche'),
(3, 1, 'de', 'Tomatensauce', 'Frische Tomatensauce'),
(4, 1, 'zh', '番茄酱', '新鲜番茄酱'),
(5, 2, 'it', 'Mozzarella', 'Fior di latte'),
(6, 2, 'fr', 'Mozzarella', 'Fior di latte'),
(7, 2, 'de', 'Mozzarella', 'Fior di latte'),
(8, 2, 'zh', '马苏里拉奶酪', '牛奶酪'),
(9, 3, 'it', 'Ricotta', 'Ricotta fresca di latte vaccino'),
(10, 3, 'fr', 'Ricotta', 'Ricotta fraîche au lait de vache'),
(11, 3, 'de', 'Ricotta', 'Frischer Kuhmilch-Ricotta'),
(12, 3, 'zh', '里科塔奶酪', '新鲜牛乳清干酪'),
(13, 4, 'it', 'Speck', 'Speck Alto Adige IGP'),
(14, 4, 'fr', 'Speck', 'Speck du Tyrol du Sud IGP'),
(15, 4, 'de', 'Speck', 'Südtiroler Speck g.g.A.'),
(16, 4, 'zh', '南蒂罗尔烟熏火腿', 'IGP南蒂罗尔烟熏火腿'),
(17, 5, 'it', 'Prosciutto cotto', 'Prosciutto cotto di alta qualità'),
(18, 5, 'fr', 'Jambon cuit', 'Jambon cuit de haute qualité'),
(19, 5, 'de', 'Kochschinken', 'Hochwertiger Kochschinken'),
(20, 5, 'zh', '熟火腿', '优质熟火腿'),
(21, 6, 'it', 'Salame piccante', 'Salame stagionato con peperoncino'),
(22, 6, 'fr', 'Saucisson piquant', 'Saucisson sec au piment'),
(23, 6, 'de', 'Scharfe Salami', 'Scharfe, luftgetrocknete Salami mit Chili'),
(24, 6, 'zh', '辣味萨拉米', '加入辣椒的干腌萨拉米'),
(25, 7, 'it', 'Funghi', 'Funghi champignon freschi'),
(26, 7, 'fr', 'Champignons', 'Champignons de Paris frais'),
(27, 7, 'de', 'Champignons', 'Frische Champignons'),
(28, 7, 'zh', '蘑菇', '新鲜白蘑菇'),
(29, 8, 'it', 'Carciofi', 'Cuori di carciofo'),
(30, 8, 'fr', 'Artichauts', 'Cœurs d\'artichaut'),
(31, 8, 'de', 'Artischockenherzen', 'Artischockenherzen'),
(32, 8, 'zh', '朝鲜蓟', '朝鲜蓟心'),
(33, 9, 'it', 'Olive', 'Olive nere denocciolate'),
(34, 9, 'fr', 'Olives noires', 'Olives noires dénoyautées'),
(35, 9, 'de', 'Schwarze Oliven', 'Schwarze Oliven, entsteint'),
(36, 9, 'zh', '黑橄榄', '去核黑橄榄'),
(37, 10, 'it', 'Cipolla', 'Cipolla rossa di Tropea'),
(38, 10, 'fr', 'Oignon rouge', 'Oignon rouge de Tropea'),
(39, 10, 'de', 'Rote Zwiebel', 'Rote Zwiebel aus Tropea'),
(40, 10, 'zh', '特罗佩亚红洋葱', '特罗佩亚红洋葱'),
(41, 11, 'it', 'Peperoni', 'Peperoni rossi e gialli'),
(42, 11, 'fr', 'Poivrons', 'Poivrons rouges et jaunes'),
(43, 11, 'de', 'Paprika', 'Rote und gelbe Paprika'),
(44, 11, 'zh', '彩椒', '红黄甜椒'),
(45, 12, 'it', 'Melanzane', 'Melanzane grigliate'),
(46, 12, 'fr', 'Aubergines grillées', 'Aubergines grillées'),
(47, 12, 'de', 'Gegrillte Auberginen', 'Gegrillte Auberginen'),
(48, 12, 'zh', '烤茄子', '烤茄子片'),
(49, 13, 'it', 'Parmigiano Reggiano', 'Parmigiano Reggiano DOP 24 mesi'),
(50, 13, 'fr', 'Parmesan', 'Parmigiano Reggiano AOP 24 mois'),
(51, 13, 'de', 'Parmesan', 'Parmigiano Reggiano DOP 24 Monate gereift'),
(52, 13, 'zh', '帕尔马干酪', 'DOP帕尔马干酪，陈年24个月'),
(53, 14, 'it', 'Provola', 'Provola affumicata'),
(54, 14, 'fr', 'Provola fumée', 'Provola fumée'),
(55, 14, 'de', 'Geräucherter Provola', 'Geräucherter Provola-Käse'),
(56, 14, 'zh', '烟熏普拉沃拉奶酪', '烟熏普拉沃拉奶酪'),
(57, 15, 'it', 'Salsiccia', 'Salsiccia fresca di suino'),
(58, 15, 'fr', 'Saucisse fraîche', 'Saucisse fraîche de porc'),
(59, 15, 'de', 'Frische Bratwurst', 'Frische Schweinsbratwurst'),
(60, 15, 'zh', '鲜猪肉香肠', '新鲜猪肉香肠'),
(61, 16, 'it', 'Gamberetti', 'Gamberetti sgusciati'),
(62, 16, 'fr', 'Crevettes', 'Crevettes décortiquées'),
(63, 16, 'de', 'Garnelen', 'Garnelen, geschält'),
(64, 16, 'zh', '虾仁', '去壳虾仁'),
(65, 17, 'it', 'Tonno', 'Tonno sott\'olio'),
(66, 17, 'fr', 'Thon', 'Thon à l\'huile'),
(67, 17, 'de', 'Thunfisch', 'Thunfisch in Öl'),
(68, 17, 'zh', '金枪鱼', '油浸金枪鱼罐头'),
(69, 18, 'it', 'Scamorza', 'Scamorza affumicata'),
(70, 18, 'fr', 'Scamorza fumée', 'Scamorza fumée'),
(71, 18, 'de', 'Geräucherter Scamorza', 'Geräucherter Scamorza-Käse'),
(72, 18, 'zh', '烟熏斯卡莫扎奶酪', '烟熏斯卡莫扎奶酪'),
(73, 19, 'it', 'Uovo', 'Uovo sodo a fette'),
(74, 19, 'fr', 'Œuf dur', 'Œuf dur en tranches'),
(75, 19, 'de', 'Gekochtes Ei', 'Hartgekochtes Ei in Scheiben'),
(76, 19, 'zh', '鸡蛋', '切片水煮蛋'),
(77, 20, 'it', 'Acciughe', 'Acciughe sott\'olio'),
(78, 20, 'fr', 'Anchois', 'Anchois à l\'huile'),
(79, 20, 'de', 'Sardellen', 'Sardellen in Öl'),
(80, 20, 'zh', '油浸凤尾鱼', '油浸凤尾鱼'),
(81, 21, 'it', 'Salmone affumicato', 'Salmone norvegese affumicato'),
(82, 21, 'fr', 'Saumon fumé', 'Saumon fumé de Norvège'),
(83, 21, 'de', 'Räucherlachs', 'Norwegischer Räucherlachs'),
(84, 21, 'zh', '烟熏三文鱼', '挪威烟熏三文鱼'),
(85, 22, 'it', 'Pangrattato', 'Pangrattato tostato'),
(86, 22, 'fr', 'Chapelure toastée', 'Chapelure toastée'),
(87, 22, 'de', 'Geröstetes Paniermehl', 'Geröstetes Paniermehl'),
(88, 22, 'zh', '烤面包屑', '烤面包屑'),
(89, 23, 'it', 'Noci', 'Gherigli di noce'),
(90, 23, 'fr', 'Noix', 'Cerneaux de noix'),
(91, 23, 'de', 'Walnusskerne', 'Walnusskerne'),
(92, 23, 'zh', '核桃仁', '核桃仁'),
(93, 24, 'it', 'Mandorle', 'Mandorle pelate'),
(94, 24, 'fr', 'Amandes pelées', 'Amandes pelées'),
(95, 24, 'de', 'Geschälte Mandeln', 'Geschälte Mandeln'),
(96, 24, 'zh', '去皮杏仁', '去皮杏仁'),
(97, 25, 'it', 'Pistacchi', 'Pistacchi di Bronte'),
(98, 25, 'fr', 'Pistaches', 'Pistaches de Bronte'),
(99, 25, 'de', 'Pistazien', 'Pistazien aus Bronte'),
(100, 25, 'zh', '布朗泰开心果', '布朗泰开心果'),
(101, 26, 'it', 'Crostini', 'Crostini di pane casereccio'),
(102, 26, 'fr', 'Croûtons', 'Croûtons de pain maison'),
(103, 26, 'de', 'Croûtons', 'Hausgemachte Brotwürfel'),
(104, 26, 'zh', '面包丁', '自制面包丁'),
(105, 27, 'it', 'Sedano', 'Sedano a cubetti'),
(106, 27, 'fr', 'Céleri', 'Céleri en dés'),
(107, 27, 'de', 'Sellerie', 'Sellerie gewürfelt'),
(108, 27, 'zh', '芹菜', '芹菜丁'),
(109, 28, 'it', 'Senape', 'Senape in grani'),
(110, 28, 'fr', 'Moutarde en grains', 'Moutarde en grains'),
(111, 28, 'de', 'Senfkörner', 'Senfkörner'),
(112, 28, 'zh', '芥末籽', '芥末籽'),
(113, 29, 'it', 'Burrata', 'Burrata pugliese'),
(114, 29, 'fr', 'Burrata', 'Burrata des Pouilles'),
(115, 29, 'de', 'Burrata', 'Burrata aus Apulien'),
(116, 29, 'zh', '布拉塔奶酪', '普利亚布拉塔奶酪'),
(117, 30, 'it', 'Gorgonzola', 'Gorgonzola DOP dolce'),
(118, 30, 'fr', 'Gorgonzola AOP', 'Gorgonzola AOP doux'),
(119, 30, 'de', 'Gorgonzola DOP', 'Gorgonzola DOP mild'),
(120, 30, 'zh', '甜戈贡佐拉奶酪', 'DOP甜味戈贡佐拉奶酪'),
(121, 31, 'it', 'Salsa di soia', 'Salsa di soia giapponese'),
(122, 31, 'fr', 'Sauce soja', 'Sauce soja japonaise'),
(123, 31, 'de', 'Sojasauce', 'Japanische Sojasauce'),
(124, 31, 'zh', '酱油', '日式酱油'),
(125, 32, 'it', 'Pasta fresca', 'Pasta all\'uovo'),
(126, 32, 'fr', 'Pâtes fraîches', 'Pâtes fraîches aux œufs'),
(127, 32, 'de', 'Frische Eiernudeln', 'Frische Eiernudeln'),
(128, 32, 'zh', '新鲜鸡蛋面', '新鲜鸡蛋意大利面'),
(129, 33, 'it', 'Calamari', 'Calamari a rondelle'),
(130, 33, 'fr', 'Calamars', 'Calamars en rondelles'),
(131, 33, 'de', 'Tintenfischringe', 'Tintenfischringe'),
(132, 33, 'zh', '鱿鱼', '鱿鱼圈'),
(133, 34, 'it', 'Pane', 'Pane casereccio a fette'),
(134, 34, 'fr', 'Pain maison', 'Pain maison en tranches'),
(135, 34, 'de', 'Hausgemachtes Brot', 'Hausgemachtes Brot in Scheiben'),
(136, 34, 'zh', '自制面包片', '自制面包片'),
(137, 35, 'it', 'Uvetta', 'Uvetta sultanina'),
(138, 35, 'fr', 'Raisins secs', 'Raisins secs sultanine'),
(139, 35, 'de', 'Sultaninen', 'Sultaninen'),
(140, 35, 'zh', '苏丹娜葡萄干', '苏丹娜葡萄干'),
(141, 36, 'it', 'Peperoncino', 'Peperoncino fresco'),
(142, 36, 'fr', 'Piment frais', 'Piment frais'),
(143, 36, 'de', 'Frische Chilischote', 'Frische Chilischote'),
(144, 36, 'zh', '新鲜辣椒', '新鲜辣椒'),
(145, 37, 'it', 'Rucola', 'Rucola selvatica'),
(146, 37, 'fr', 'Roquette sauvage', 'Roquette sauvage'),
(147, 37, 'de', 'Wilder Rucola', 'Wilder Rucola'),
(148, 37, 'zh', '野生芝麻菜', '野生芝麻菜'),
(149, 38, 'it', 'Basilico', 'Basilico fresco'),
(150, 38, 'fr', 'Basilic frais', 'Basilic frais'),
(151, 38, 'de', 'Frisches Basilikum', 'Frisches Basilikum'),
(152, 38, 'zh', '新鲜罗勒', '新鲜罗勒叶'),
(153, 39, 'it', 'Origano', 'Origano secco'),
(154, 39, 'fr', 'Origan séché', 'Origan séché'),
(155, 39, 'de', 'Getrockneter Oregano', 'Getrockneter Oregano'),
(156, 39, 'zh', '干牛至', '干牛至'),
(157, 40, 'it', 'Aglio', 'Aglio fresco'),
(158, 40, 'fr', 'Ail frais', 'Ail frais'),
(159, 40, 'de', 'Frischer Knoblauch', 'Frischer Knoblauch'),
(160, 40, 'zh', '新鲜大蒜', '新鲜大蒜'),
(161, 41, 'it', 'Olio EVO', 'Olio extravergine d\'oliva'),
(162, 41, 'fr', 'Huile d\'olive extra vierge', 'Huile d\'olive extra vierge'),
(163, 41, 'de', 'Natives Olivenöl extra', 'Natives Olivenöl extra'),
(164, 41, 'zh', '特级初榨橄榄油', '特级初榨橄榄油'),
(165, 42, 'it', 'Aceto balsamico', 'Aceto balsamico di Modena IGP'),
(166, 42, 'fr', 'Vinaigre balsamique', 'Vinaigre balsamique de Modène IGP'),
(167, 42, 'de', 'Balsamico-Essig', 'Balsamico-Essig aus Modena g.g.A.'),
(168, 42, 'zh', '摩德纳香醋', 'IGP摩德纳香醋'),
(169, 43, 'it', 'Capperi', 'Capperi sotto sale'),
(170, 43, 'fr', 'Câpres', 'Câpres au sel'),
(171, 43, 'de', 'Kapern', 'Salzkapern'),
(172, 43, 'zh', '盐渍刺山柑', '盐渍刺山柑'),
(173, 44, 'it', 'Porchetta', 'Porchetta di Ariccia'),
(174, 44, 'fr', 'Porchetta', 'Porchetta d\'Ariccia'),
(175, 44, 'de', 'Porchetta', 'Porchetta aus Ariccia'),
(176, 44, 'zh', '阿里恰烤猪肉', '阿里恰烤猪肉卷'),
(177, 45, 'it', 'Pancetta', 'Pancetta tesa stagionata'),
(178, 45, 'fr', 'Pancetta', 'Pancetta affinée'),
(179, 45, 'de', 'Pancetta', 'Gereifter Bauchspeck'),
(180, 45, 'zh', '干腌五花肉', '干腌猪五花'),
(181, 46, 'it', 'Bresaola', 'Bresaola della Valtellina'),
(182, 46, 'fr', 'Bresaola', 'Bresaola de la Valteline'),
(183, 46, 'de', 'Bresaola', 'Bresaola aus dem Veltlin'),
(184, 46, 'zh', '瓦尔泰利纳风干牛肉', '瓦尔泰利纳风干牛肉'),
(185, 47, 'it', 'Pinoli', 'Pinoli italiani'),
(186, 47, 'fr', 'Pignons de pin', 'Pignons de pin italiens'),
(187, 47, 'de', 'Pinienkerne', 'Italienische Pinienkerne'),
(188, 47, 'zh', '意大利松子', '意大利松子'),
(189, 48, 'it', 'Semi di sesamo', 'Semi di sesamo tostati'),
(190, 48, 'fr', 'Graines de sésame', 'Graines de sésame torréfiées'),
(191, 48, 'de', 'Sesamsamen', 'Geröstete Sesamsamen'),
(192, 48, 'zh', '烤芝麻', '烤芝麻'),
(193, 49, 'it', 'Lupini', 'Farina di lupini'),
(194, 49, 'fr', 'Farine de lupin', 'Farine de lupin'),
(195, 49, 'de', 'Lupinenmehl', 'Lupinenmehl'),
(196, 49, 'zh', '羽扇豆粉', '羽扇豆粉'),
(197, 50, 'it', 'Mozzarella di bufala', 'Mozzarella di bufala campana DOP'),
(198, 50, 'fr', 'Mozzarella di bufala AOP', 'Mozzarella di bufala de Campanie AOP'),
(199, 50, 'de', 'Büffelmozzarella g.U.', 'Büffelmozzarella aus Kampanien g.U.'),
(200, 50, 'zh', '坎帕尼亚水牛马苏里拉奶酪', 'DOP坎帕尼亚水牛马苏里拉奶酪'),
(201, 51, 'it', 'Stracciatella', 'Stracciatella di bufala'),
(202, 51, 'fr', 'Stracciatella', 'Stracciatella di bufala'),
(203, 51, 'de', 'Stracciatella', 'Stracciatella di bufala'),
(204, 51, 'zh', '斯特拉奇泰拉奶酪', '水牛斯特拉奇泰拉奶酪'),
(205, 52, 'it', 'Tartufo', 'Tartufo nero estivo'),
(206, 52, 'fr', 'Truffe noire d\'été', 'Truffe noire d\'été'),
(207, 52, 'de', 'Schwarzer Sommertrüffel', 'Schwarzer Sommertrüffel'),
(208, 52, 'zh', '夏季黑松露', '夏季黑松露'),
(209, 53, 'it', 'Pesto', 'Pesto genovese (basilico, pinoli, formaggi)'),
(210, 53, 'fr', 'Pesto génois', 'Pesto génois (basilic, pignons, fromages)'),
(211, 53, 'de', 'Pesto Genovese', 'Pesto Genovese (Basilikum, Pinienkerne, Käse)'),
(212, 53, 'zh', '热那亚青酱', '热那亚青酱（罗勒、松子、奶酪）'),
(213, 54, 'it', 'Crema di zucca', 'Crema di zucca mantovana'),
(214, 54, 'fr', 'Crème de potiron', 'Crème de potiron de Mantoue'),
(215, 54, 'de', 'Kürbiscreme', 'Kürbiscreme aus Mantua'),
(216, 54, 'zh', '南瓜奶油', '曼托瓦南瓜奶油'),
(217, 55, 'it', 'Radicchio', 'Radicchio rosso di Treviso'),
(218, 55, 'fr', 'Radicchio rouge', 'Radicchio rouge de Trévise'),
(219, 55, 'de', 'Radicchio', 'Radicchio aus Treviso'),
(220, 55, 'zh', '特雷维索红菊苣', '特雷维索红菊苣'),
(221, 56, 'it', 'Zola dolce', 'Gorgonzola cremoso'),
(222, 56, 'fr', 'Gorgonzola crémeux', 'Gorgonzola crémeux'),
(223, 56, 'de', 'Cremiger Gorgonzola', 'Cremiger Gorgonzola'),
(224, 56, 'zh', '奶油戈贡佐拉奶酪', '奶油状戈贡佐拉奶酪'),
(225, 57, 'it', 'Feta', 'Formaggio greco DOP'),
(226, 57, 'fr', 'Feta', 'Fromage grec AOP'),
(227, 57, 'de', 'Feta', 'Griechischer Feta-Käse g.U.'),
(228, 57, 'zh', '菲达奶酪', '希腊DOP菲达奶酪'),
(229, 58, 'it', 'Cetriolo', 'Cetriolo fresco a dadini'),
(230, 58, 'fr', 'Concombre', 'Concombre frais en dés'),
(231, 58, 'de', 'Gurke', 'Frische Gurke, gewürfelt'),
(232, 58, 'zh', '黄瓜', '新鲜黄瓜丁'),
(233, 59, 'it', 'Menta', 'Menta fresca'),
(234, 59, 'fr', 'Menthe', 'Menthe fraîche'),
(235, 59, 'de', 'Minze', 'Frische Minze'),
(236, 59, 'zh', '薄荷', '新鲜薄荷');

-- --------------------------------------------------------

--
-- Struttura della tabella `lingue`
--

CREATE TABLE `lingue` (
  `codice` varchar(5) NOT NULL,
  `nome` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `lingue`
--

INSERT INTO `lingue` (`codice`, `nome`) VALUES
('de', 'Deutsch'),
('fr', 'Français'),
('it', 'Italiano'),
('zh', '中文');

-- --------------------------------------------------------

--
-- Struttura della tabella `menu`
--

CREATE TABLE `menu` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `nome` varchar(100) NOT NULL,
  `azienda_id` bigint(20) NOT NULL,
  `descrizione` text DEFAULT NULL,
  `slug` varchar(150) NOT NULL,
  `lingua_predefinita` varchar(5) NOT NULL DEFAULT 'it',
  `predefinito` tinyint(1) NOT NULL DEFAULT 0,
  `attivo` tinyint(1) NOT NULL DEFAULT 1,
  `ordine` smallint(6) NOT NULL DEFAULT 0,
  `qr_scansioni` bigint(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `menu`
--

INSERT INTO `menu` (`id`, `nome`, `azienda_id`, `descrizione`, `slug`, `lingua_predefinita`, `predefinito`, `attivo`, `ordine`, `qr_scansioni`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Menu Principale', 1, 'Il nostro menu sempre disponibile', 'menu-principale', 'it', 1, 1, 1, 1, '2026-06-24 22:17:16', '2026-09-08 16:43:43', NULL),
(2, 'Estate 2026', 1, 'Menu estivo con ingredienti freschi', 'menu-estate', 'it', 0, 1, 2, 12, '2026-06-24 22:17:16', '2026-09-08 18:07:27', NULL),
(18, 'menu', 1, '', 'menu-test', 'it', 0, 0, 0, 0, '2026-09-08 14:31:15', '2026-09-08 19:16:32', NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `migrations`
--

CREATE TABLE `migrations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `version` varchar(255) NOT NULL,
  `class` varchar(255) NOT NULL,
  `group` varchar(255) NOT NULL,
  `namespace` varchar(255) NOT NULL,
  `time` int(11) NOT NULL,
  `batch` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `migrations`
--

INSERT INTO `migrations` (`id`, `version`, `class`, `group`, `namespace`, `time`, `batch`) VALUES
(1, '20260724120000', 'App\\Database\\Migrations\\AddRoleToUsers', 'default', 'App', 1784897001, 1);

-- --------------------------------------------------------

--
-- Struttura della tabella `prenotazioni`
--

CREATE TABLE `prenotazioni` (
  `id` int(10) UNSIGNED NOT NULL,
  `azienda_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `nome_cliente` varchar(100) NOT NULL,
  `dominio` varchar(50) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `data` date NOT NULL,
  `ora` time NOT NULL,
  `numero_persone` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `note` text DEFAULT NULL,
  `stato` enum('in_attesa','confermata','annullata','completata') NOT NULL DEFAULT 'in_attesa',
  `tavolo_id` smallint(5) UNSIGNED DEFAULT NULL COMMENT 'Tavolo assegnato',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  `durata_minuti` smallint(5) UNSIGNED NOT NULL DEFAULT 120 COMMENT 'Durata prevista in minuti',
  `ora_fine` time GENERATED ALWAYS AS (sec_to_time(time_to_sec(`ora`) + `durata_minuti` * 60)) STORED COMMENT 'Calcolato automaticamente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `prodotti`
--

CREATE TABLE `prodotti` (
  `id` int(10) UNSIGNED NOT NULL,
  `azienda_id` int(10) NOT NULL,
  `sku` varchar(50) DEFAULT NULL,
  `nome` varchar(150) NOT NULL,
  `descrizione` text DEFAULT NULL,
  `note_chef` text DEFAULT NULL,
  `prezzo` decimal(8,2) NOT NULL,
  `iva` int(2) NOT NULL DEFAULT 22,
  `foto_url` varchar(500) DEFAULT NULL,
  `foto_thumbnail_url` varchar(500) DEFAULT NULL,
  `vegan` tinyint(1) NOT NULL DEFAULT 0,
  `vegetariano` tinyint(1) NOT NULL DEFAULT 0,
  `senza_glutine` tinyint(1) NOT NULL DEFAULT 0,
  `biologico` tinyint(1) NOT NULL DEFAULT 0,
  `piccante_livello` tinyint(4) NOT NULL DEFAULT 0,
  `calorie` smallint(5) UNSIGNED DEFAULT NULL,
  `peso_grammi` smallint(5) UNSIGNED DEFAULT NULL,
  `attivo` tinyint(1) NOT NULL DEFAULT 1,
  `ordine` smallint(6) NOT NULL DEFAULT 0,
  `in_evidenza` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `prodotti`
--

INSERT INTO `prodotti` (`id`, `azienda_id`, `sku`, `nome`, `descrizione`, `note_chef`, `prezzo`, `iva`, `foto_url`, `foto_thumbnail_url`, `vegan`, `vegetariano`, `senza_glutine`, `biologico`, `piccante_livello`, `calorie`, `peso_grammi`, `attivo`, `ordine`, `in_evidenza`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'PIZ001', 'Margherita', 'Pomodoro, mozzarella, basilico', 'La classica napoletana', 6.50, 22, NULL, NULL, 0, 1, 0, 0, 0, 793, 350, 1, 1, 1, '2026-06-24 22:17:16', '2026-09-08 16:06:35', NULL),
(2, 1, 'PIZ002', 'Marinara', 'Pomodoro, aglio, origano, olio EVO', 'Senza mozzarella, sapore deciso', 5.00, 22, NULL, NULL, 1, 1, 1, 0, 0, 550, 330, 1, 2, 0, '2026-06-24 22:17:16', '2026-09-08 16:06:37', NULL),
(3, 1, 'PIZ003', 'Diavola', 'Pomodoro, mozzarella, salame piccante', 'Per chi ama il piccante', 8.00, 22, NULL, NULL, 0, 0, 0, 0, 3, 950, 380, 1, 3, 1, '2026-06-24 22:17:16', '2026-09-08 16:06:40', NULL),
(4, 1, 'PIZ004', 'Quattro Stagioni', 'Pomodoro, mozzarella, funghi, prosciutto cotto, carciofi, olive', 'I quattro gusti classici', 9.00, 22, NULL, NULL, 0, 0, 0, 0, 0, 1050, 420, 1, 4, 0, '2026-06-24 22:17:16', '2026-09-08 16:06:40', NULL),
(5, 1, 'PIZ005', 'Capricciosa', 'Pomodoro, mozzarella, prosciutto cotto, carciofi, funghi, olive', 'Ricca e saporita', 9.50, 22, NULL, NULL, 0, 0, 0, 0, 0, 1100, 450, 1, 5, 0, '2026-06-24 22:17:16', '2026-09-08 21:03:51', NULL),
(6, 1, 'PIZ006', 'Bufalina', 'Pomodoro, mozzarella di bufala, basilico, olio EVO', 'Con mozzarella di bufala campana DOP', 10.00, 22, NULL, NULL, 0, 1, 0, 0, 0, 850, 380, 1, 6, 1, '2026-06-24 22:17:16', '2026-09-08 21:03:51', NULL),
(7, 1, 'PIZ007', 'Boscaiola', 'Pomodoro, mozzarella, funghi, salsiccia', 'Sapore di bosco', 9.00, 22, NULL, NULL, 0, 0, 0, 0, 0, 1020, 400, 1, 7, 0, '2026-06-24 22:17:16', '2026-09-08 21:03:51', NULL),
(8, 1, 'PIZ008', 'Parmigiana', 'Pomodoro, mozzarella, melanzane grigliate, parmigiano, basilico', 'Ispirata alla parmigiana', 9.50, 22, NULL, NULL, 0, 1, 0, 0, 0, 930, 410, 1, 8, 0, '2026-06-24 22:17:16', '2026-07-03 15:07:14', NULL),
(9, 1, 'PIZ009', 'Vegetariana', 'Pomodoro, mozzarella, peperoni, melanzane, zucchine, cipolla', 'Arcobaleno di verdure', 8.50, 22, NULL, NULL, 0, 1, 0, 1, 0, 780, 400, 1, 9, 0, '2026-06-24 22:17:16', '2026-07-03 15:07:14', NULL),
(10, 1, 'PAS001', 'Spaghetti al pomodoro', 'Spaghetti con salsa di pomodoro fresco e basilico', 'Semplicità e gusto', 7.00, 22, NULL, NULL, 1, 1, 0, 0, 0, 450, 350, 1, 10, 0, '2026-06-24 22:17:16', '2026-07-03 15:07:14', NULL),
(11, 1, 'PAS002', 'Penne all\'arrabbiata', 'Penne con salsa di pomodoro, aglio, peperoncino, prezzemolo', 'Piccantezza regolabile', 7.50, 22, NULL, NULL, 1, 1, 0, 0, 4, 480, 360, 1, 11, 0, '2026-06-24 22:17:16', '2026-07-03 15:07:14', NULL),
(12, 1, 'PAS003', 'Carbonara', 'Spaghetti con uovo, pancetta, parmigiano, pepe nero', 'Ricetta tradizionale', 9.00, 22, NULL, NULL, 0, 0, 0, 0, 0, 680, 380, 1, 12, 1, '2026-06-24 22:17:16', '2026-09-08 21:03:51', NULL),
(13, 1, 'PAS004', 'Pasta al pesto', 'Trofie con pesto genovese, patate, fagiolini', 'Profumo di basilico', 10.00, 22, NULL, NULL, 0, 1, 0, 0, 0, 720, 400, 1, 13, 0, '2026-06-24 22:17:16', '2026-07-03 15:07:14', NULL),
(14, 1, 'PAS005', 'Lasagne alla bolognese', 'Lasagne con ragù, besciamella, parmigiano', 'Piatto ricco e gratinato', 11.00, 22, NULL, NULL, 0, 0, 0, 0, 0, 850, 450, 1, 14, 0, '2026-06-24 22:17:16', '2026-07-03 15:07:14', NULL),
(15, 1, 'ANT001', 'Bruschetta al pomodoro', 'Pane casereccio tostato con pomodoro, aglio, basilico, olio EVO', 'Semplice e fragrante', 5.00, 22, NULL, NULL, 1, 1, 0, 1, 0, 250, 120, 1, 15, 1, '2026-06-24 22:17:16', '2026-09-08 21:03:51', NULL),
(16, 1, 'ANT002', 'Tagliere misto', 'Selezione di salumi e formaggi: speck, salame, pancetta, provola, parmigiano', 'Perfetto da condividere', 14.00, 22, NULL, NULL, 0, 0, 0, 0, 2, 1100, 350, 1, 16, 0, '2026-06-24 22:17:16', '2026-07-03 15:07:14', NULL),
(17, 1, 'ANT003', 'Carpaccio di bresaola', 'Bresaola della Valtellina, rucola, scaglie di parmigiano, olio EVO', 'Leggero e raffinato', 12.00, 22, NULL, NULL, 0, 0, 1, 0, 0, 380, 180, 1, 17, 0, '2026-06-24 22:17:16', '2026-09-08 16:06:38', NULL),
(18, 1, 'INS001', 'Insalata mista', 'Lattuga, rucola, pomodorini, carote, cetrioli', 'Freschezza in tavola', 6.00, 22, NULL, NULL, 1, 1, 1, 1, 0, 180, 250, 1, 18, 0, '2026-06-24 22:17:16', '2026-09-08 16:06:36', NULL),
(19, 1, 'INS002', 'Insalata di mare', 'Calamari, gamberetti, sedano, olive, olio EVO', 'Solo pescato fresco', 13.00, 22, NULL, NULL, 0, 0, 1, 0, 0, 320, 280, 1, 19, 0, '2026-06-24 22:17:16', '2026-07-03 15:07:14', NULL),
(20, 1, 'DES001', 'Tiramisù', 'Savoiardi, caffè, mascarpone, cacao amaro', 'Il dolce italiano per eccellenza', 7.00, 22, NULL, NULL, 0, 1, 0, 0, 0, 480, 180, 1, 20, 1, '2026-06-24 22:17:16', '2026-07-03 15:07:14', NULL),
(21, 1, 'DES002', 'Panna cotta', 'Panna cotta ai frutti di bosco', 'Vellutata e delicata', 6.50, 22, NULL, NULL, 0, 1, 1, 0, 0, 360, 150, 1, 21, 0, '2026-06-24 22:17:16', '2026-07-03 15:07:14', NULL),
(22, 1, NULL, 'Insalata di anguria e feta', 'Anguria, feta, cetriolo, menta, olive, olio EVO', 'Dolce e salato, perfetto per l\'estate', 11.00, 22, NULL, NULL, 0, 1, 1, 0, 0, 320, 280, 1, 22, 1, '2026-06-24 22:17:16', '2026-09-08 16:06:39', NULL),
(36, 1, '', 'MMMM', '', NULL, 9999.00, 22, NULL, NULL, 0, 0, 0, 0, 0, NULL, NULL, 1, 0, 0, '2026-09-08 14:01:57', '2026-09-08 14:01:57', NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `prodotti_ingredienti`
--

CREATE TABLE `prodotti_ingredienti` (
  `prodotto_id` int(10) UNSIGNED NOT NULL,
  `ingrediente_id` int(10) UNSIGNED NOT NULL,
  `ordinamento` tinyint(3) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `prodotti_ingredienti`
--

INSERT INTO `prodotti_ingredienti` (`prodotto_id`, `ingrediente_id`, `ordinamento`) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 38, 3),
(2, 1, 1),
(2, 39, 3),
(2, 40, 2),
(2, 41, 4),
(3, 1, 1),
(3, 2, 2),
(3, 6, 3),
(4, 1, 1),
(4, 2, 2),
(4, 5, 4),
(4, 7, 3),
(4, 8, 5),
(4, 9, 6),
(5, 1, 1),
(5, 2, 2),
(5, 5, 3),
(5, 7, 5),
(5, 8, 4),
(5, 9, 6),
(6, 1, 1),
(6, 38, 3),
(6, 41, 4),
(6, 50, 2),
(7, 1, 1),
(7, 2, 2),
(7, 7, 3),
(7, 15, 4),
(8, 1, 1),
(8, 2, 2),
(8, 12, 3),
(8, 13, 4),
(8, 38, 5),
(9, 1, 1),
(9, 2, 2),
(9, 10, 6),
(9, 11, 3),
(9, 12, 4),
(9, 54, 5),
(10, 1, 1),
(10, 38, 2),
(11, 1, 1),
(11, 36, 3),
(11, 40, 2),
(12, 13, 3),
(12, 19, 1),
(12, 45, 2),
(13, 53, 1),
(14, 1, 1),
(14, 2, 3),
(14, 13, 4),
(14, 15, 2),
(15, 1, 2),
(15, 34, 1),
(15, 38, 4),
(15, 40, 3),
(15, 41, 5),
(16, 4, 1),
(16, 6, 2),
(16, 13, 5),
(16, 14, 4),
(16, 45, 3),
(17, 13, 3),
(17, 37, 2),
(17, 41, 4),
(17, 46, 1),
(18, 1, 2),
(18, 10, 3),
(18, 37, 1),
(19, 9, 4),
(19, 16, 2),
(19, 27, 3),
(19, 33, 1),
(19, 41, 5),
(22, 9, 4),
(22, 41, 5),
(22, 57, 1),
(22, 58, 2),
(22, 59, 3);

-- --------------------------------------------------------

--
-- Struttura della tabella `prodotti_menu`
--

CREATE TABLE `prodotti_menu` (
  `id` int(10) UNSIGNED NOT NULL,
  `prodotto_id` int(10) UNSIGNED NOT NULL,
  `menu_id` smallint(5) UNSIGNED NOT NULL,
  `categoria_id` smallint(5) UNSIGNED DEFAULT NULL,
  `prezzo_override` decimal(8,2) DEFAULT NULL,
  `attivo` tinyint(1) NOT NULL DEFAULT 1,
  `ordine` smallint(6) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `prodotti_menu`
--

INSERT INTO `prodotti_menu` (`id`, `prodotto_id`, `menu_id`, `categoria_id`, `prezzo_override`, `attivo`, `ordine`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, NULL, 1, 1, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(2, 2, 1, 1, NULL, 1, 2, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(3, 3, 1, 1, NULL, 1, 3, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(4, 4, 1, 1, NULL, 1, 4, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(5, 5, 1, 1, NULL, 1, 5, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(6, 6, 1, 1, NULL, 1, 6, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(7, 7, 1, 1, NULL, 1, 7, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(8, 8, 1, 1, NULL, 1, 8, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(9, 9, 1, 1, NULL, 1, 9, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(10, 10, 1, 2, NULL, 1, 10, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(11, 11, 1, 2, NULL, 1, 11, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(12, 12, 1, 2, NULL, 1, 12, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(13, 13, 1, 2, NULL, 1, 13, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(14, 14, 1, 2, NULL, 1, 14, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(15, 15, 1, 3, NULL, 1, 15, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(16, 16, 1, 3, NULL, 1, 16, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(17, 17, 1, 3, NULL, 1, 17, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(18, 18, 1, 4, NULL, 1, 18, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(19, 19, 1, 4, NULL, 1, 19, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(20, 20, 1, 5, NULL, 1, 20, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(21, 21, 1, 5, NULL, 1, 21, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(32, 18, 2, 6, NULL, 1, 1, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(33, 17, 2, 7, 11.50, 1, 2, '2026-06-24 22:17:16', '2026-06-24 22:17:16'),
(34, 22, 2, 6, NULL, 1, 3, '2026-06-24 22:17:16', '2026-06-24 22:17:16');

-- --------------------------------------------------------

--
-- Struttura della tabella `promozioni`
--

CREATE TABLE `promozioni` (
  `id` int(10) UNSIGNED NOT NULL,
  `azienda_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `prodotto_id` int(10) UNSIGNED DEFAULT NULL,
  `prodotti_menu_id` int(10) UNSIGNED DEFAULT NULL,
  `tipo` enum('percentuale','importo') NOT NULL,
  `valore` decimal(5,2) NOT NULL,
  `prezzo_finale` decimal(8,2) DEFAULT NULL,
  `data_inizio` date DEFAULT NULL,
  `data_fine` date DEFAULT NULL,
  `attiva` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Struttura della tabella `tavoli`
--

CREATE TABLE `tavoli` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `azienda_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `numero` varchar(10) NOT NULL COMMENT 'Etichetta (A1, 12, Giardino)',
  `posti` tinyint(3) UNSIGNED NOT NULL DEFAULT 2,
  `zona` varchar(50) DEFAULT NULL COMMENT 'Sala, veranda, giardino…',
  `priorita` tinyint(1) UNSIGNED NOT NULL DEFAULT 3 COMMENT '1 = miglior tavolo, 5 = peggiore',
  `attivo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `tavoli`
--

INSERT INTO `tavoli` (`id`, `azienda_id`, `numero`, `posti`, `zona`, `priorita`, `attivo`, `created_at`, `updated_at`, `deleted_at`) VALUES
(9, 1, 'A1', 2, 'Sala', 1, 1, '2026-07-16 13:48:26', '2026-07-16 13:48:26', NULL),
(10, 1, 'A2', 2, 'Sala', 3, 1, '2026-07-16 13:48:26', '2026-07-16 13:48:26', NULL),
(11, 1, 'A3', 4, 'Sala', 1, 1, '2026-07-16 13:48:26', '2026-07-16 13:48:26', NULL),
(12, 1, 'A4', 4, 'Veranda', 2, 1, '2026-07-16 13:48:26', '2026-07-16 13:48:26', NULL),
(13, 1, 'B1', 6, 'Sala', 2, 1, '2026-07-16 13:48:26', '2026-07-16 13:48:26', NULL),
(14, 1, 'B2', 6, 'Giardino', 1, 1, '2026-07-16 13:48:26', '2026-07-16 13:48:26', NULL),
(15, 1, 'C1', 12, 'Giardino', 1, 1, '2026-07-16 13:48:26', '2026-07-16 13:48:26', NULL),
(16, 1, 'D1', 2, 'Giardino', 5, 1, '2026-07-16 13:48:26', '2026-07-16 13:48:26', NULL),
(20, 1, 'S1', 2, 'Sala', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(21, 1, 'S2', 2, 'Sala', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(22, 1, 'S3', 2, 'Sala', 2, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(23, 1, 'S4', 2, 'Sala', 2, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(24, 1, 'S5', 4, 'Sala', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(25, 1, 'S6', 4, 'Sala', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(26, 1, 'S7', 4, 'Sala', 2, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(27, 1, 'S8', 4, 'Sala', 2, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(28, 1, 'S9', 4, 'Sala', 3, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(29, 1, 'S10', 6, 'Sala', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(30, 1, 'S11', 6, 'Sala', 2, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(31, 1, 'S12', 8, 'Sala', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(32, 1, 'S13', 8, 'Sala', 2, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(33, 1, 'S14', 12, 'Sala', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(34, 1, 'V1', 2, 'Veranda', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(35, 1, 'V2', 2, 'Veranda', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(36, 1, 'V3', 4, 'Veranda', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(37, 1, 'V4', 4, 'Veranda', 2, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(38, 1, 'V5', 4, 'Veranda', 3, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(39, 1, 'V6', 6, 'Veranda', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(40, 1, 'V7', 6, 'Veranda', 2, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(41, 1, 'V8', 8, 'Veranda', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(42, 1, 'G1', 2, 'Giardino', 2, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(43, 1, 'G2', 2, 'Giardino', 3, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(44, 1, 'G3', 4, 'Giardino', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(45, 1, 'G4', 4, 'Giardino', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(46, 1, 'G5', 6, 'Giardino', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(47, 1, 'G6', 6, 'Giardino', 2, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(48, 1, 'G7', 8, 'Giardino', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL),
(49, 1, 'G8', 12, 'Giardino', 1, 1, '2026-07-16 13:49:14', '2026-07-16 13:49:14', NULL);

-- --------------------------------------------------------

--
-- Struttura della tabella `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `azienda_id` int(10) UNSIGNED NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `api_token` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `role` varchar(50) DEFAULT 'user',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dump dei dati per la tabella `users`
--

INSERT INTO `users` (`id`, `azienda_id`, `username`, `password`, `api_token`, `active`, `role`, `created_at`, `updated_at`) VALUES
(1, 1, 'admin@gmail.com', '$2y$10$9JVArbtvC3hhSMskziEaY.bwZRSO4B6xynD/FeMGr8ZgIgr/tovii', 'ff846dde8a9343ceaff280b19b33c5efde7aba2992404925905f9d02f312a68c', 1, 'admin', '2026-06-24 22:49:56', '2026-07-29 10:21:22'),
(2, 1, 'ManagerBistrot69', '$2y$10$db.bi8X8k1BDkIgNHB0VeOopuT6Xdk0jI/vBf5sb73jafEu/s6ZB2', '7b050a6e150bbc3cd499c90ce20a22ff10c984df460262d528d70f0b6daf7647', 1, 'manager', '2026-07-24 13:14:57', '2026-07-24 13:14:57');

-- --------------------------------------------------------

--
-- Struttura della tabella `variazioni_prodotto`
--

CREATE TABLE `variazioni_prodotto` (
  `id` int(10) UNSIGNED NOT NULL,
  `prodotto_id` int(10) UNSIGNED NOT NULL,
  `nome` varchar(100) NOT NULL,
  `prezzo_extra` decimal(8,2) NOT NULL DEFAULT 0.00,
  `peso_grammi` smallint(5) UNSIGNED DEFAULT NULL,
  `calorie` smallint(5) UNSIGNED DEFAULT NULL,
  `attivo` tinyint(1) NOT NULL DEFAULT 1,
  `ordine` smallint(6) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `vw_menu_prodotti`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `vw_menu_prodotti` (
`menu_id` smallint(5) unsigned
,`menu_nome` varchar(100)
,`menu_slug` varchar(150)
,`lingua_predefinita` varchar(5)
,`categoria_id` smallint(5) unsigned
,`categoria_nome` varchar(100)
,`prodotto_id` int(10) unsigned
,`prodotto_nome` varchar(150)
,`prezzo_base` decimal(8,2)
,`prezzo_finale` decimal(8,2)
,`allergeni_it` mediumtext
,`allergeni_fr` mediumtext
,`allergeni_de` mediumtext
,`allergeni_zh` mediumtext
,`vegan` tinyint(1)
,`vegetariano` tinyint(1)
,`senza_glutine` tinyint(1)
,`biologico` tinyint(1)
,`piccante_livello` tinyint(4)
,`calorie` smallint(5) unsigned
,`peso_grammi` smallint(5) unsigned
,`in_evidenza` tinyint(1)
,`ordine_prodotto` smallint(6)
,`ordine_categoria` smallint(6)
,`ordine_menu` smallint(6)
);

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `vw_prezzo_finale`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `vw_prezzo_finale` (
`prodotto_id` int(10) unsigned
,`menu_id` smallint(5) unsigned
,`prezzo_finale` decimal(8,2)
);

-- --------------------------------------------------------

--
-- Struttura per vista `vw_menu_prodotti`
--
DROP TABLE IF EXISTS `vw_menu_prodotti`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_menu_prodotti`  AS SELECT `m`.`id` AS `menu_id`, `m`.`nome` AS `menu_nome`, `m`.`slug` AS `menu_slug`, `m`.`lingua_predefinita` AS `lingua_predefinita`, `c`.`id` AS `categoria_id`, `c`.`nome` AS `categoria_nome`, `p`.`id` AS `prodotto_id`, `p`.`nome` AS `prodotto_nome`, coalesce(`pm`.`prezzo_override`,`p`.`prezzo`) AS `prezzo_base`, `pf`.`prezzo_finale` AS `prezzo_finale`, group_concat(distinct `a`.`nome_it` order by `a`.`nome_it` ASC separator ', ') AS `allergeni_it`, group_concat(distinct `a`.`nome_fr` order by `a`.`nome_fr` ASC separator ', ') AS `allergeni_fr`, group_concat(distinct `a`.`nome_de` order by `a`.`nome_de` ASC separator ', ') AS `allergeni_de`, group_concat(distinct `a`.`nome_zh` order by `a`.`nome_zh` ASC separator ', ') AS `allergeni_zh`, `p`.`vegan` AS `vegan`, `p`.`vegetariano` AS `vegetariano`, `p`.`senza_glutine` AS `senza_glutine`, `p`.`biologico` AS `biologico`, `p`.`piccante_livello` AS `piccante_livello`, `p`.`calorie` AS `calorie`, `p`.`peso_grammi` AS `peso_grammi`, `p`.`in_evidenza` AS `in_evidenza`, `pm`.`ordine` AS `ordine_prodotto`, `c`.`ordine` AS `ordine_categoria`, `m`.`ordine` AS `ordine_menu` FROM (((((((`prodotti_menu` `pm` join `menu` `m` on(`pm`.`menu_id` = `m`.`id` and `m`.`attivo` = 1)) join `categorie` `c` on(`pm`.`categoria_id` = `c`.`id` and `c`.`visibile` = 1)) join `prodotti` `p` on(`pm`.`prodotto_id` = `p`.`id` and `p`.`attivo` = 1)) left join (select `pm2`.`prodotto_id` AS `prodotto_id`,`pm2`.`menu_id` AS `menu_id`,coalesce(min(`prom`.`prezzo_finale`),coalesce(`pm2`.`prezzo_override`,`p2`.`prezzo`)) AS `prezzo_finale` from ((`prodotti_menu` `pm2` join `prodotti` `p2` on(`pm2`.`prodotto_id` = `p2`.`id`)) left join `promozioni` `prom` on(`prom`.`attiva` = 1 and curdate() between `prom`.`data_inizio` and `prom`.`data_fine` and (`prom`.`prodotti_menu_id` = `pm2`.`id` or `prom`.`prodotto_id` = `pm2`.`prodotto_id`))) where `pm2`.`attivo` = 1 and `p2`.`attivo` = 1 group by `pm2`.`prodotto_id`,`pm2`.`menu_id`,`pm2`.`prezzo_override`,`p2`.`prezzo`) `pf` on(`pf`.`prodotto_id` = `p`.`id` and `pf`.`menu_id` = `m`.`id`)) left join `prodotti_ingredienti` `pi` on(`p`.`id` = `pi`.`prodotto_id`)) left join `ingredienti_allergeni` `ia` on(`pi`.`ingrediente_id` = `ia`.`ingrediente_id` and `ia`.`presente` = 1)) left join `allergeni` `a` on(`ia`.`allergene_id` = `a`.`id`)) WHERE `pm`.`attivo` = 1 GROUP BY `pm`.`id`, `m`.`id`, `c`.`id`, `p`.`id`, `pf`.`prezzo_finale` ORDER BY `m`.`ordine` ASC, `c`.`ordine` ASC, `pm`.`ordine` ASC ;

-- --------------------------------------------------------

--
-- Struttura per vista `vw_prezzo_finale`
--
DROP TABLE IF EXISTS `vw_prezzo_finale`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_prezzo_finale`  AS SELECT `pm`.`prodotto_id` AS `prodotto_id`, `pm`.`menu_id` AS `menu_id`, coalesce(min(`prom`.`prezzo_finale`),coalesce(`pm`.`prezzo_override`,`p`.`prezzo`)) AS `prezzo_finale` FROM ((`prodotti_menu` `pm` join `prodotti` `p` on(`pm`.`prodotto_id` = `p`.`id`)) left join `promozioni` `prom` on(`prom`.`attiva` = 1 and curdate() between `prom`.`data_inizio` and `prom`.`data_fine` and (`prom`.`prodotti_menu_id` = `pm`.`id` or `prom`.`prodotto_id` = `pm`.`prodotto_id`))) WHERE `pm`.`attivo` = 1 AND `p`.`attivo` = 1 GROUP BY `pm`.`prodotto_id`, `pm`.`menu_id`, `pm`.`prezzo_override`, `p`.`prezzo` ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `allergeni`
--
ALTER TABLE `allergeni`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_allergene_azienda_codice` (`azienda_id`,`codice`),
  ADD UNIQUE KEY `uq_allergene_azienda_nome` (`azienda_id`,`nome_it`),
  ADD KEY `idx_allergene_azienda` (`azienda_id`);

--
-- Indici per le tabelle `aziende`
--
ALTER TABLE `aziende`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_piano` (`piano_id`),
  ADD KEY `idx_stato` (`stato`),
  ADD KEY `idx_piva` (`piva`);

--
-- Indici per le tabelle `categorie`
--
ALTER TABLE `categorie`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cat_menu` (`menu_id`),
  ADD KEY `fk_cat_parent` (`parent_id`);

--
-- Indici per le tabelle `categorie_traduzioni`
--
ALTER TABLE `categorie_traduzioni`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cat_lingua` (`categoria_id`,`lingua`),
  ADD KEY `fk_ct_lingua` (`lingua`);

--
-- Indici per le tabelle `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_tenant_date` (`azienda_id`,`event_date`),
  ADD KEY `idx_tenant_publish` (`azienda_id`,`publish_at`);

--
-- Indici per le tabelle `ingredienti`
--
ALTER TABLE `ingredienti`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_ingrediente_azienda_nome` (`azienda_id`,`nome`),
  ADD KEY `idx_disponibile` (`disponibile`),
  ADD KEY `idx_ordine` (`ordine`),
  ADD KEY `idx_ingrediente_azienda` (`azienda_id`);

--
-- Indici per le tabelle `ingredienti_allergeni`
--
ALTER TABLE `ingredienti_allergeni`
  ADD PRIMARY KEY (`ingrediente_id`,`allergene_id`),
  ADD KEY `fk_ia_allergene` (`allergene_id`);

--
-- Indici per le tabelle `ingredienti_traduzioni`
--
ALTER TABLE `ingredienti_traduzioni`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_ingrediente_lingua` (`ingrediente_id`,`lingua`),
  ADD KEY `idx_lingua` (`lingua`);

--
-- Indici per le tabelle `lingue`
--
ALTER TABLE `lingue`
  ADD PRIMARY KEY (`codice`);

--
-- Indici per le tabelle `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_slug` (`slug`),
  ADD KEY `fk_menu_lingua` (`lingua_predefinita`);

--
-- Indici per le tabelle `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `prenotazioni`
--
ALTER TABLE `prenotazioni`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_data_ora` (`data`,`ora`),
  ADD KEY `idx_stato` (`stato`),
  ADD KEY `fk_prenotazioni_tavolo` (`tavolo_id`),
  ADD KEY `fk_prenotazioni_azienda` (`azienda_id`);

--
-- Indici per le tabelle `prodotti`
--
ALTER TABLE `prodotti`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `prodotti_ingredienti`
--
ALTER TABLE `prodotti_ingredienti`
  ADD PRIMARY KEY (`prodotto_id`,`ingrediente_id`),
  ADD KEY `fk_pi_ingrediente` (`ingrediente_id`);

--
-- Indici per le tabelle `prodotti_menu`
--
ALTER TABLE `prodotti_menu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_prodotto_menu` (`prodotto_id`,`menu_id`),
  ADD KEY `fk_pm_menu` (`menu_id`),
  ADD KEY `fk_pm_categoria` (`categoria_id`);

--
-- Indici per le tabelle `promozioni`
--
ALTER TABLE `promozioni`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_promo_prodotto` (`prodotto_id`),
  ADD KEY `fk_promo_pm` (`prodotti_menu_id`),
  ADD KEY `fk_promozioni_azienda` (`azienda_id`);

--
-- Indici per le tabelle `tavoli`
--
ALTER TABLE `tavoli`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_numero` (`numero`);

--
-- Indici per le tabelle `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `fk_users_azienda` (`azienda_id`);

--
-- Indici per le tabelle `variazioni_prodotto`
--
ALTER TABLE `variazioni_prodotto`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_var_prodotto` (`prodotto_id`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `allergeni`
--
ALTER TABLE `allergeni`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT per la tabella `aziende`
--
ALTER TABLE `aziende`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT per la tabella `categorie`
--
ALTER TABLE `categorie`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT per la tabella `categorie_traduzioni`
--
ALTER TABLE `categorie_traduzioni`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT per la tabella `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT per la tabella `ingredienti`
--
ALTER TABLE `ingredienti`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=110;

--
-- AUTO_INCREMENT per la tabella `ingredienti_traduzioni`
--
ALTER TABLE `ingredienti_traduzioni`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=237;

--
-- AUTO_INCREMENT per la tabella `menu`
--
ALTER TABLE `menu`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT per la tabella `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT per la tabella `prenotazioni`
--
ALTER TABLE `prenotazioni`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT per la tabella `prodotti`
--
ALTER TABLE `prodotti`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT per la tabella `prodotti_menu`
--
ALTER TABLE `prodotti_menu`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT per la tabella `promozioni`
--
ALTER TABLE `promozioni`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `tavoli`
--
ALTER TABLE `tavoli`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT per la tabella `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT per la tabella `variazioni_prodotto`
--
ALTER TABLE `variazioni_prodotto`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `allergeni`
--
ALTER TABLE `allergeni`
  ADD CONSTRAINT `fk_allergene_azienda` FOREIGN KEY (`azienda_id`) REFERENCES `aziende` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `categorie`
--
ALTER TABLE `categorie`
  ADD CONSTRAINT `fk_cat_menu` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cat_parent` FOREIGN KEY (`parent_id`) REFERENCES `categorie` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limiti per la tabella `categorie_traduzioni`
--
ALTER TABLE `categorie_traduzioni`
  ADD CONSTRAINT `fk_ct_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ct_lingua` FOREIGN KEY (`lingua`) REFERENCES `lingue` (`codice`) ON UPDATE CASCADE;

--
-- Limiti per la tabella `ingredienti`
--
ALTER TABLE `ingredienti`
  ADD CONSTRAINT `fk_ingrediente_azienda` FOREIGN KEY (`azienda_id`) REFERENCES `aziende` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `ingredienti_allergeni`
--
ALTER TABLE `ingredienti_allergeni`
  ADD CONSTRAINT `fk_ia_allergene` FOREIGN KEY (`allergene_id`) REFERENCES `allergeni` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ia_ingrediente` FOREIGN KEY (`ingrediente_id`) REFERENCES `ingredienti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `ingredienti_traduzioni`
--
ALTER TABLE `ingredienti_traduzioni`
  ADD CONSTRAINT `fk_it_ingrediente` FOREIGN KEY (`ingrediente_id`) REFERENCES `ingredienti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_it_lingua` FOREIGN KEY (`lingua`) REFERENCES `lingue` (`codice`) ON UPDATE CASCADE;

--
-- Limiti per la tabella `menu`
--
ALTER TABLE `menu`
  ADD CONSTRAINT `fk_menu_lingua` FOREIGN KEY (`lingua_predefinita`) REFERENCES `lingue` (`codice`) ON UPDATE CASCADE;

--
-- Limiti per la tabella `prenotazioni`
--
ALTER TABLE `prenotazioni`
  ADD CONSTRAINT `fk_prenotazioni_azienda` FOREIGN KEY (`azienda_id`) REFERENCES `aziende` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prenotazioni_tavolo` FOREIGN KEY (`tavolo_id`) REFERENCES `tavoli` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limiti per la tabella `prodotti_ingredienti`
--
ALTER TABLE `prodotti_ingredienti`
  ADD CONSTRAINT `fk_pi_ingrediente` FOREIGN KEY (`ingrediente_id`) REFERENCES `ingredienti` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pi_prodotto` FOREIGN KEY (`prodotto_id`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `prodotti_menu`
--
ALTER TABLE `prodotti_menu`
  ADD CONSTRAINT `fk_pm_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorie` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pm_menu` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pm_prodotto` FOREIGN KEY (`prodotto_id`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `promozioni`
--
ALTER TABLE `promozioni`
  ADD CONSTRAINT `fk_promo_pm` FOREIGN KEY (`prodotti_menu_id`) REFERENCES `prodotti_menu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_promo_prodotto` FOREIGN KEY (`prodotto_id`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_promozioni_azienda` FOREIGN KEY (`azienda_id`) REFERENCES `aziende` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_azienda` FOREIGN KEY (`azienda_id`) REFERENCES `aziende` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `variazioni_prodotto`
--
ALTER TABLE `variazioni_prodotto`
  ADD CONSTRAINT `fk_var_prodotto` FOREIGN KEY (`prodotto_id`) REFERENCES `prodotti` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
