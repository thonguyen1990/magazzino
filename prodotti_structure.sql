-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Feb 09, 2023 alle 14:02
-- Versione del server: 10.1.37-MariaDB
-- Versione PHP: 7.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `prodotti`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `agenda`
--

CREATE TABLE `agenda` (
  `id` int(11) NOT NULL,
  `tipo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idRelativo` int(11) NOT NULL,
  `title` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `dayStart` date NOT NULL,
  `dayEnd` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `categorie`
--

CREATE TABLE `categorie` (
  `id` int(11) NOT NULL,
  `nome` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `livello` int(11) NOT NULL,
  `genitore` int(11) NOT NULL,
  `img` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `pos` int(11) NOT NULL,
  `descrizioneCat` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `clienti`
--

CREATE TABLE `clienti` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `cognome` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `indirizzo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `telefono` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `sconto` float(10,2) NOT NULL DEFAULT '0.00',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `note` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `dataNascita` date DEFAULT NULL,
  `fasciaEta` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hobbies` text COLLATE utf8mb4_unicode_ci,
  `fasciaPrezzo` text COLLATE utf8mb4_unicode_ci,
  `tipologiaRichiesta` text COLLATE utf8mb4_unicode_ci,
  `idCollegamento1` int(11) DEFAULT NULL,
  `relazione1` text COLLATE utf8mb4_unicode_ci,
  `idCollegamento2` int(11) DEFAULT NULL,
  `relazione2` text COLLATE utf8mb4_unicode_ci,
  `tagAttivo` tinyint(1) NOT NULL DEFAULT '0',
  `attivo` tinyint(1) NOT NULL DEFAULT '1',
  `misuraAnello` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `fonte` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fonte_dettaglio` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dataInserimento` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `clienti_collegati`
--

CREATE TABLE `clienti_collegati` (
  `idCliente` int(11) NOT NULL,
  `idCollegamento` int(11) NOT NULL,
  `relazione` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `config`
--

CREATE TABLE `config` (
  `campo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valore` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `favoriti`
--

CREATE TABLE `favoriti` (
  `idProdotto` int(11) NOT NULL,
  `datamodifica` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `files`
--

CREATE TABLE `files` (
  `id` int(11) NOT NULL,
  `idRif` int(11) NOT NULL,
  `nome` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `src` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tabella` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `items`
--

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `codice` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `titolo` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `descrizione` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `descrizione2` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `prezzo` decimal(11,2) DEFAULT NULL,
  `ct` decimal(10,2) DEFAULT NULL,
  `img` text COLLATE utf8mb4_unicode_ci,
  `colore` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `purezza` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `taglio` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `certificato` text COLLATE utf8mb4_unicode_ci,
  `dataInserimento` date NOT NULL DEFAULT '2020-01-01',
  `notePannello` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `items_categorie`
--

CREATE TABLE `items_categorie` (
  `idItem` int(11) NOT NULL,
  `idCategoria` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `laboratorio`
--

CREATE TABLE `laboratorio` (
  `id` int(11) NOT NULL,
  `progressivo` int(11) NOT NULL DEFAULT '0',
  `stato` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` date DEFAULT NULL,
  `qnt` int(11) DEFAULT NULL,
  `carati` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tipo` text COLLATE utf8_unicode_ci,
  `caratteristiche` text COLLATE utf8_unicode_ci,
  `grammi` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `modello` text COLLATE utf8_unicode_ci,
  `codice` text COLLATE utf8_unicode_ci,
  `riferimento` text COLLATE utf8_unicode_ci,
  `pietre` text COLLATE utf8_unicode_ci,
  `scarico` text COLLATE utf8_unicode_ci,
  `fornitore` text COLLATE utf8_unicode_ci,
  `nota` text COLLATE utf8_unicode_ci,
  `flag` tinyint(4) NOT NULL DEFAULT '0',
  `cIncassatura` decimal(11,2) DEFAULT NULL,
  `cFusione` decimal(11,2) DEFAULT NULL,
  `cOrafo` decimal(11,2) DEFAULT NULL,
  `cDisegno` decimal(11,2) DEFAULT NULL,
  `cVarie` decimal(11,2) DEFAULT NULL,
  `ultimaModifica` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `laboratorio_temp_stampa`
--

CREATE TABLE `laboratorio_temp_stampa` (
  `contatore` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `progressivo` int(11) NOT NULL DEFAULT '0',
  `stato` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` date DEFAULT NULL,
  `qnt` int(11) DEFAULT NULL,
  `carati` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tipo` text COLLATE utf8_unicode_ci,
  `caratteristiche` text COLLATE utf8_unicode_ci,
  `grammi` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `modello` text COLLATE utf8_unicode_ci,
  `codice` text COLLATE utf8_unicode_ci,
  `riferimento` text COLLATE utf8_unicode_ci,
  `pietre` text COLLATE utf8_unicode_ci,
  `scarico` text COLLATE utf8_unicode_ci,
  `fornitore` text COLLATE utf8_unicode_ci,
  `nota` text COLLATE utf8_unicode_ci,
  `flag` tinyint(4) NOT NULL DEFAULT '0',
  `cIncassatura` decimal(11,2) DEFAULT NULL,
  `cFusione` decimal(11,2) DEFAULT NULL,
  `cOrafo` decimal(11,2) DEFAULT NULL,
  `cDisegno` decimal(11,2) DEFAULT NULL,
  `cVarie` decimal(11,2) DEFAULT NULL,
  `ultimaModifica` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `lavorazioni`
--

CREATE TABLE `lavorazioni` (
  `id` int(11) NOT NULL,
  `idCliente` int(11) NOT NULL,
  `tipo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ORDINE, RIPARAZIONE',
  `oggetto` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `descrizione` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `stato` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `preventivo` float(10,2) NOT NULL DEFAULT '0.00',
  `acconto` float(10,2) NOT NULL DEFAULT '0.00',
  `costo` float(10,2) NOT NULL DEFAULT '0.00',
  `dataRicezione` date DEFAULT NULL,
  `dataConsegnaPrevista` date DEFAULT NULL,
  `dataConsegnaEffettiva` date DEFAULT NULL,
  `ultimaModifica` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `note`
--

CREATE TABLE `note` (
  `id` int(11) NOT NULL,
  `titolo` text NOT NULL,
  `testo` text NOT NULL,
  `data` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `categoria` int(11) NOT NULL,
  `letta` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `note_categorie`
--

CREATE TABLE `note_categorie` (
  `id` int(11) NOT NULL,
  `nome` varchar(500) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `notifiche`
--

CREATE TABLE `notifiche` (
  `id` int(11) NOT NULL,
  `tipo` varchar(255) NOT NULL,
  `idRif` int(11) NOT NULL,
  `notifica` int(11) NOT NULL DEFAULT '0',
  `dataNotifica` datetime NOT NULL,
  `inviata` tinyint(1) NOT NULL DEFAULT '0',
  `nascosta` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `utenti`
--

CREATE TABLE `utenti` (
  `id` int(11) NOT NULL,
  `nome` varchar(500) NOT NULL,
  `password` varchar(500) NOT NULL,
  `db` int(1) NOT NULL,
  `numeri_telefono` int(1) NOT NULL,
  `elenco_visite_vendite` int(1) NOT NULL,
  `ruolo` int(11) NOT NULL,
  `categorie_note_vietate` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `vendite`
--

CREATE TABLE `vendite` (
  `id` int(11) NOT NULL,
  `idVisita` int(11) NOT NULL,
  `idCliente` int(11) NOT NULL,
  `idItem` int(11) NOT NULL,
  `itemTitolo` text COLLATE utf8mb4_unicode_ci,
  `itemDesc` text COLLATE utf8mb4_unicode_ci,
  `itemPrezzo` float(10,2) DEFAULT NULL,
  `itemCt` float(10,2) DEFAULT NULL,
  `sconto` float(10,2) NOT NULL DEFAULT '0.00',
  `prezzoScontato` float(10,2) NOT NULL DEFAULT '0.00',
  `cat` text COLLATE utf8mb4_unicode_ci,
  `catBis` text COLLATE utf8mb4_unicode_ci,
  `sottocat` text COLLATE utf8mb4_unicode_ci,
  `dataVendita` date NOT NULL,
  `oraVendita` int(11) NOT NULL DEFAULT '0',
  `vetrina` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `dataRIF` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `vetrina`
--

CREATE TABLE `vetrina` (
  `id` int(11) NOT NULL,
  `nome` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `descrizione` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `img` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `larghezza` int(11) NOT NULL,
  `altezza` int(11) NOT NULL,
  `idCategoria` int(11) NOT NULL,
  `attivo` int(11) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `vetrina_prodotti`
--

CREATE TABLE `vetrina_prodotti` (
  `id` int(11) NOT NULL,
  `idVetrina` int(11) NOT NULL,
  `idProdotto` int(11) NOT NULL,
  `x` float(20,10) NOT NULL,
  `y` float(20,10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struttura della tabella `visite`
--

CREATE TABLE `visite` (
  `id` int(11) NOT NULL,
  `idCliente` int(11) NOT NULL,
  `dataVisita` date NOT NULL,
  `oraVisita` int(11) NOT NULL DEFAULT '0',
  `note` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `dataRIF` date DEFAULT NULL,
  `isVendita` int(11) NOT NULL DEFAULT '0',
  `fonte` text COLLATE utf8mb4_unicode_ci,
  `fonte_dettaglio` text COLLATE utf8mb4_unicode_ci,
  `gift` tinyint(4) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `agenda`
--
ALTER TABLE `agenda`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `categorie`
--
ALTER TABLE `categorie`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `clienti`
--
ALTER TABLE `clienti`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `config`
--
ALTER TABLE `config`
  ADD PRIMARY KEY (`campo`);

--
-- Indici per le tabelle `favoriti`
--
ALTER TABLE `favoriti`
  ADD PRIMARY KEY (`idProdotto`,`datamodifica`);

--
-- Indici per le tabelle `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `items_categorie`
--
ALTER TABLE `items_categorie`
  ADD PRIMARY KEY (`idItem`,`idCategoria`);

--
-- Indici per le tabelle `laboratorio`
--
ALTER TABLE `laboratorio`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `laboratorio_temp_stampa`
--
ALTER TABLE `laboratorio_temp_stampa`
  ADD PRIMARY KEY (`contatore`);

--
-- Indici per le tabelle `lavorazioni`
--
ALTER TABLE `lavorazioni`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `note`
--
ALTER TABLE `note`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `note_categorie`
--
ALTER TABLE `note_categorie`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `notifiche`
--
ALTER TABLE `notifiche`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `utenti`
--
ALTER TABLE `utenti`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `vendite`
--
ALTER TABLE `vendite`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `vetrina`
--
ALTER TABLE `vetrina`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `vetrina_prodotti`
--
ALTER TABLE `vetrina_prodotti`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `visite`
--
ALTER TABLE `visite`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `agenda`
--
ALTER TABLE `agenda`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `categorie`
--
ALTER TABLE `categorie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `clienti`
--
ALTER TABLE `clienti`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `files`
--
ALTER TABLE `files`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `laboratorio`
--
ALTER TABLE `laboratorio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `laboratorio_temp_stampa`
--
ALTER TABLE `laboratorio_temp_stampa`
  MODIFY `contatore` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `lavorazioni`
--
ALTER TABLE `lavorazioni`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `note`
--
ALTER TABLE `note`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `note_categorie`
--
ALTER TABLE `note_categorie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `notifiche`
--
ALTER TABLE `notifiche`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `utenti`
--
ALTER TABLE `utenti`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `vendite`
--
ALTER TABLE `vendite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `vetrina`
--
ALTER TABLE `vetrina`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `vetrina_prodotti`
--
ALTER TABLE `vetrina_prodotti`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `visite`
--
ALTER TABLE `visite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
