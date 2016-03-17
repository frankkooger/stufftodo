-- vim: syntax=sql
--
-- Host: localhost
-- Generatie Tijd: 16 Nov 2009 om 09:29
-- PHP Versie: 5.2.9


--
-- Database: "administratie"
--

-- --------------------------------------------------------
BEGIN TRANSACTION;

--
-- Tabel structuur voor tabel "boekregels"
--

DROP TABLE IF EXISTS "boekregels";
CREATE TABLE IF NOT EXISTS "boekregels" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" int(11)  default '0',
  "boekjaar" int(11)  default '0',
  "datum" date  default '0000-00-00',
  "grootboekrekening" int(11)  default '0',
  "btwrelatie" int(11)  default '0' ,
  "factuurrelatie" int(11)  default '0' ,
  "relatie" varchar(32)  default '' ,
  "nummer" varchar(16)  default '' ,
  "oorsprong" varchar(16)  default '' ,
  "bomschrijving" varchar(128)  default '',
  "bedrag" decimal(12,2)  default '0.00'
);

  CREATE UNIQUE INDEX IF NOT EXISTS "idboekjaar" ON "boekregels" ("id","boekjaar");
  CREATE INDEX IF NOT EXISTS "journaalid" ON "boekregels" ("journaalid");
  CREATE INDEX IF NOT EXISTS "grootboekrekening" ON "boekregels" ("grootboekrekening");

--
-- Gegevens worden uitgevoerd voor tabel "boekregels"
--

INSERT INTO "boekregels" VALUES(1, 2, 2008, '2008-01-05', 4240, 2, 0, '', '0301', '', 'KPN 21okt-20dec 2007', 101.12);
INSERT INTO "boekregels" VALUES(2, 2, 2008, '2008-01-05', 2200, 0, 0, '', '0301', '', 'KPN 21okt-20dec 2007', 19.21);
INSERT INTO "boekregels" VALUES(3, 2, 2008, '2008-02-21', 4240, 4, 0, '', '0303', '', 'KPN 21dec-20feb', 87.51);
INSERT INTO "boekregels" VALUES(4, 2, 2008, '2008-02-21', 2200, 0, 0, '', '0303', '', 'KPN 21dec-20feb', 16.63);
INSERT INTO "boekregels" VALUES(5, 1, 2008, '2008-01-01', 1050, 0, 0, '', '', '', 'Beginbalans', 5099.95);
INSERT INTO "boekregels" VALUES(37, 4, 2008, '2008-02-28', 1060, 0, 0, '', '', 'rabo 2', 'Prive uitgaven', 581.24);
INSERT INTO "boekregels" VALUES(36, 4, 2008, '2008-02-13', 2200, 0, 0, '', '1312', 'rabo 2', 'xs4all internet', 3.70);
INSERT INTO "boekregels" VALUES(38, 5, 2008, '2008-03-28', 1050, 0, 0, '', '', '', 'Bankafschrift: 0121', -1166.30);
INSERT INTO "boekregels" VALUES(35, 4, 2008, '2008-02-13', 4245, 36, 0, '', '1312', 'rabo 2', 'xs4all internet', 19.50);
INSERT INTO "boekregels" VALUES(39, 5, 2008, '2008-02-19', 4240, 40, 0, '', '0069', 'rabo 3', 'Telefoonkosten mobiel', 26.58);
INSERT INTO "boekregels" VALUES(32, 4, 2008, '2008-01-24', 2300, 0, 0, '', '', 'rabo 2', 'Betaalde OB 4e kw. 2007', 1969.00);
INSERT INTO "boekregels" VALUES(33, 4, 2008, '2008-02-04', 4490, 0, 0, '', '2000', 'rabo 2', 'kamer van Koophandel contributie', 46.05);
INSERT INTO "boekregels" VALUES(30, 3, 2008, '2008-01-15', 2200, 0, 0, '', '4051', 'rabo 1', 'XS4all internet', 3.71);
INSERT INTO "boekregels" VALUES(31, 4, 2008, '2008-02-15', 1050, 0, 0, '', '', '', 'Bankafschrift: 0120', -2619.49);
INSERT INTO "boekregels" VALUES(28, 3, 2008, '2008-01-15', 2200, 0, 0, '', '0108', 'rabo 1', 'telefoonkosten mobiel', 3.19);
INSERT INTO "boekregels" VALUES(29, 3, 2008, '2008-01-15', 4245, 30, 0, '', '4051', 'rabo 1', 'XS4all internet', 19.52);
INSERT INTO "boekregels" VALUES(26, 3, 2008, '2008-01-31', 1060, 0, 0, '', '', 'rabo 1', 'prive uitgaven', 1237.37);
INSERT INTO "boekregels" VALUES(27, 3, 2008, '2008-01-15', 4240, 28, 0, '', '0108', 'rabo 1', 'telefoonkosten mobiel', 16.81);
INSERT INTO "boekregels" VALUES(25, 3, 2008, '2008-01-01', 4350, 0, 0, '', '', 'rabo 1', 'Bankkosten', 36.28);
INSERT INTO "boekregels" VALUES(24, 3, 2008, '2008-01-08', 1050, 0, 0, '', '', '', 'Bankafschrift 119', -1316.88);
INSERT INTO "boekregels" VALUES(21, 2, 2008, '2008-03-03', 4240, 22, 0, '', '', '', 'mobiele telefoonkosten', 41.31);
INSERT INTO "boekregels" VALUES(22, 2, 2008, '2008-03-03', 2200, 0, 0, '', '', '', 'mobiele telefoonkosten', 7.85);
INSERT INTO "boekregels" VALUES(40, 5, 2008, '2008-02-19', 2200, 0, 0, '', '0069', 'rabo 3', 'Telefoonkosten mobiel', 5.05);
INSERT INTO "boekregels" VALUES(41, 5, 2008, '2008-03-19', 4240, 42, 0, '', '0070', 'rabo 3', 'telefoonkosten mobiel', 23.24);
INSERT INTO "boekregels" VALUES(42, 5, 2008, '2008-03-19', 2200, 0, 0, '', '0070', 'rabo 3', 'telefoonkosten mobiel', 4.42);
INSERT INTO "boekregels" VALUES(43, 5, 2008, '2008-03-31', 1060, 0, 0, '', '', 'rabo 3', 'Prive uitgaven', 1107.01);
INSERT INTO "boekregels" VALUES(44, 6, 2008, '2008-06-30', 4230, 45, 0, '', '', '', 'vakblad CT magazine', 5.65);
INSERT INTO "boekregels" VALUES(45, 6, 2008, '2008-06-30', 2200, 0, 0, '', '', '', 'vakblad CT magazine', 0.34);
INSERT INTO "boekregels" VALUES(46, 6, 2008, '2008-06-30', 4500, 47, 0, '', '08-615', '', 'Huur Stand', 189.08);
INSERT INTO "boekregels" VALUES(47, 6, 2008, '2008-06-30', 2200, 0, 0, '', '08-615', '', 'Huur Stand', 35.92);
INSERT INTO "boekregels" VALUES(48, 6, 2008, '2008-05-30', 4220, 49, 0, '', '', '', 'schildersdoeken', 37.79);
INSERT INTO "boekregels" VALUES(49, 6, 2008, '2008-05-30', 2200, 0, 0, '', '', '', 'schildersdoeken', 7.18);
INSERT INTO "boekregels" VALUES(50, 6, 2008, '2008-05-30', 4230, 51, 0, '', '', '', 'vakblad CT magazine', 5.65);
INSERT INTO "boekregels" VALUES(51, 6, 2008, '2008-05-30', 2200, 0, 0, '', '', '', 'vakblad CT magazine', 0.34);
INSERT INTO "boekregels" VALUES(52, 6, 2008, '2008-04-01', 4490, 53, 0, '', '', '', 'inlijsten schilderijen', 179.83);
INSERT INTO "boekregels" VALUES(53, 6, 2008, '2008-04-01', 2200, 0, 0, '', '', '', 'inlijsten schilderijen', 34.17);
INSERT INTO "boekregels" VALUES(54, 6, 2008, '2008-05-07', 4490, 55, 0, '', '', '', 'relatiegeschenk klant', 74.08);
INSERT INTO "boekregels" VALUES(55, 6, 2008, '2008-05-07', 2200, 0, 0, '', '', '', 'relatiegeschenk klant', 14.07);
INSERT INTO "boekregels" VALUES(56, 6, 2008, '2008-04-07', 4245, 57, 0, '', '9740', '', 'XS4all internet', 19.50);
INSERT INTO "boekregels" VALUES(57, 6, 2008, '2008-04-07', 2200, 0, 0, '', '9740', '', 'XS4all internet', 3.70);
INSERT INTO "boekregels" VALUES(58, 6, 2008, '2008-04-21', 4490, 0, 0, '', '', '', 'Diner relatie', 39.80);
INSERT INTO "boekregels" VALUES(59, 6, 2008, '2008-04-21', 2300, 0, 0, '', '', '', 'Naheffing betaalde OB 2e kw. 2007', 86.00);
INSERT INTO "boekregels" VALUES(60, 6, 2008, '2008-04-18', 4490, 0, 0, '', '7320', '', 'Uitreksel KvK', 11.00);
INSERT INTO "boekregels" VALUES(61, 6, 2008, '2008-06-19', 4100, 62, 0, '', '2678', '', 'Deelbetaling Eneco electra', 310.08);
INSERT INTO "boekregels" VALUES(62, 6, 2008, '2008-06-19', 2200, 0, 0, '', '2678', '', 'Deelbetaling Eneco electra', 58.92);
INSERT INTO "boekregels" VALUES(63, 6, 2008, '2008-06-19', 1000, 0, 0, '', '', '', 'Kasbetalingen 2e kwartaal', -1113.10);
INSERT INTO "boekregels" VALUES(159, 30, 2008, '2008-10-23', 8020, 160, 0, '', '8290', '', 'Correctie bankst.124 Sigma Laservision', -60.00);
INSERT INTO "boekregels" VALUES(66, 7, 2008, '2008-06-16', 1060, 0, 0, '', '', '', 'Aankoop Mac-air', -1646.92);
INSERT INTO "boekregels" VALUES(67, 8, 2008, '2008-04-25', 1050, 0, 0, '', '', '', 'Bankafschrift: 0122', 46.34);
INSERT INTO "boekregels" VALUES(68, 8, 2008, '2008-04-01', 4350, 0, 0, '', '', 'rabo 4', 'Bankkosten', 34.76);
INSERT INTO "boekregels" VALUES(69, 8, 2008, '2008-04-22', 4240, 70, 0, '', '0071', 'rabo 4', 'telefoonkosten mobiel', 23.52);
INSERT INTO "boekregels" VALUES(70, 8, 2008, '2008-04-22', 2200, 0, 0, '', '0071', 'rabo 4', 'telefoonkosten mobiel', 4.47);
INSERT INTO "boekregels" VALUES(71, 8, 2008, '2008-04-25', 1060, 0, 0, '', '', 'rabo 4', 'prive uitgaven', -109.09);
INSERT INTO "boekregels" VALUES(72, 9, 2008, '2008-05-23', 1050, 0, 0, '', '', '', 'bankafschrift: 0123', 599.38);
INSERT INTO "boekregels" VALUES(73, 9, 2008, '2008-05-05', 8010, 74, 0, '', '28010', 'rabo 5', 'Factuur KCW onderhoud 1ekw.', -2550.00);
INSERT INTO "boekregels" VALUES(74, 9, 2008, '2008-05-05', 2110, 0, 0, '', '28010', 'rabo 5', 'Factuur KCW onderhoud 1ekw.', -484.50);
INSERT INTO "boekregels" VALUES(75, 9, 2008, '2008-05-06', 4245, 76, 0, '', '61012', 'rabo 5', 'registratie domeinnaam', 7.50);
INSERT INTO "boekregels" VALUES(76, 9, 2008, '2008-05-06', 2200, 0, 0, '', '61012', 'rabo 5', 'registratie domeinnaam', 1.43);
INSERT INTO "boekregels" VALUES(77, 9, 2008, '2008-05-07', 4240, 78, 0, '', '0305', 'rabo 5', 'telefoonkosten zakelijk', 97.97);
INSERT INTO "boekregels" VALUES(78, 9, 2008, '2008-05-07', 2200, 0, 0, '', '0305', 'rabo 5', 'telefoonkosten zakelijk', 18.61);
INSERT INTO "boekregels" VALUES(79, 9, 2008, '2008-05-09', 4245, 80, 0, '', '4889', 'rabo 5', 'xS4all internet', 19.50);
INSERT INTO "boekregels" VALUES(80, 9, 2008, '2008-05-09', 2200, 0, 0, '', '4889', 'rabo 5', 'xS4all internet', 3.70);
INSERT INTO "boekregels" VALUES(81, 9, 2008, '2008-05-23', 4240, 82, 0, '', '0072', 'rabo 5', 'mobiele telefoonkosten', 19.95);
INSERT INTO "boekregels" VALUES(82, 9, 2008, '2008-05-23', 2200, 0, 0, '', '0072', 'rabo 5', 'mobiele telefoonkosten', 3.79);
INSERT INTO "boekregels" VALUES(83, 9, 2008, '2008-05-23', 1060, 0, 0, '', '', 'rabo 5', 'prive uitgaven', 2262.67);
INSERT INTO "boekregels" VALUES(84, 10, 2008, '2008-06-30', 1050, 0, 0, '', '', '', 'Bankafschrift: 0124', 2121.20);
INSERT INTO "boekregels" VALUES(85, 10, 2008, '2008-05-27', 8020, 86, 0, '', '8253', 'rabo 6', 'Sigma Laservision', -90.00);
INSERT INTO "boekregels" VALUES(86, 10, 2008, '2008-05-27', 2110, 0, 0, '', '8253', 'rabo 6', 'Sigma Laservision', -17.10);
INSERT INTO "boekregels" VALUES(87, 10, 2008, '2008-06-03', 4220, 88, 0, '', '3001', 'rabo 6', 'Schildersmateriaal', 97.48);
INSERT INTO "boekregels" VALUES(88, 10, 2008, '2008-06-03', 2200, 0, 0, '', '3001', 'rabo 6', 'Schildersmateriaal', 18.52);
INSERT INTO "boekregels" VALUES(89, 10, 2008, '2008-06-09', 4245, 90, 0, '', '1833', 'rabo 6', 'xS4all internet', 19.50);
INSERT INTO "boekregels" VALUES(90, 10, 2008, '2008-06-09', 2200, 0, 0, '', '1833', 'rabo 6', 'xS4all internet', 3.70);
INSERT INTO "boekregels" VALUES(91, 10, 2008, '2008-06-09', 8020, 92, 0, '', '8290', 'rabo 6', 'Sigma laservision', 60.00);
INSERT INTO "boekregels" VALUES(92, 10, 2008, '2008-06-09', 2110, 0, 0, '', '8290', 'rabo 6', 'Sigma laservision', 11.40);
INSERT INTO "boekregels" VALUES(93, 10, 2008, '2008-06-10', 8010, 94, 0, '', '28020', 'rabo 6', 'Kcw onderhoud 2e kw. 08', -2040.00);
INSERT INTO "boekregels" VALUES(94, 10, 2008, '2008-06-10', 2110, 0, 0, '', '28020', 'rabo 6', 'Kcw onderhoud 2e kw. 08', -387.60);
INSERT INTO "boekregels" VALUES(95, 10, 2008, '2008-06-11', 8010, 96, 0, '', '8252', 'rabo 6', 'Tips op Windows EZ', -880.00);
INSERT INTO "boekregels" VALUES(96, 10, 2008, '2008-06-11', 2110, 0, 0, '', '8252', 'rabo 6', 'Tips op Windows EZ', -167.20);
INSERT INTO "boekregels" VALUES(97, 10, 2008, '2008-06-30', 1060, 0, 0, '', '', 'rabo 6', 'prive uitgaven', 1230.10);
INSERT INTO "boekregels" VALUES(98, 2, 2008, '2008-03-31', 1000, 0, 0, '', '', '', 'Kasbetalingen 1e kwartaal', -273.63);
INSERT INTO "boekregels" VALUES(100, 11, 2008, '2008-06-10', 1600, 0, 0, 'hi', '5951011.73', '', '0623477347 - juni 2008', -20.00);
INSERT INTO "boekregels" VALUES(101, 11, 2008, '2008-06-10', 4240, 102, 0, 'hi', '5951011.73', '', '0623477347 - juni 2008', 16.81);
INSERT INTO "boekregels" VALUES(102, 11, 2008, '2008-06-10', 2200, 0, 0, 'hi', '5951011.73', '', '0623477347 - juni 2008', 3.19);
INSERT INTO "boekregels" VALUES(103, 12, 2008, '2008-06-25', 1600, 0, 0, 'tmobile', '901070203247', '', '0643795777 - 16-6/22-7', -13.57);
INSERT INTO "boekregels" VALUES(104, 12, 2008, '2008-06-25', 4240, 105, 0, 'tmobile', '901070203247', '', '0643795777 - 16-6/22-7', 11.40);
INSERT INTO "boekregels" VALUES(105, 12, 2008, '2008-06-25', 2200, 0, 0, 'tmobile', '901070203247', '', '0643795777 - 16-6/22-7', 2.17);
INSERT INTO "boekregels" VALUES(106, 13, 2008, '2008-06-26', 1600, 0, 0, 'kpn', '0182611557-0307', '', 'BelBasis + ADSL 1-7/31-8', -100.44);
INSERT INTO "boekregels" VALUES(107, 13, 2008, '2008-06-26', 4245, 109, 0, 'kpn', '0182611557-0307', '', 'BelBasis + ADSL 1-7/31-8', 84.40);
INSERT INTO "boekregels" VALUES(109, 13, 2008, '2008-06-26', 2200, 0, 0, 'kpn', '0182611557-0307', '', 'BelBasis + ADSL 1-7/31-8', 16.04);
INSERT INTO "boekregels" VALUES(110, 14, 2008, '2008-07-07', 1600, 0, 0, 'xs4all', '24102215', '', 'ADSL Basic 6-7/6-8', -23.20);
INSERT INTO "boekregels" VALUES(111, 14, 2008, '2008-07-07', 4245, 112, 0, 'xs4all', '24102215', '', 'ADSL Basic 6-7/6-8', 19.50);
INSERT INTO "boekregels" VALUES(112, 14, 2008, '2008-07-07', 2200, 0, 0, 'xs4all', '24102215', '', 'ADSL Basic 6-7/6-8', 3.70);
INSERT INTO "boekregels" VALUES(113, 15, 2008, '2008-07-03', 1600, 0, 0, 'orange', '00001505010708', '', '0651425883 - 3-7/2-8', -20.00);
INSERT INTO "boekregels" VALUES(114, 15, 2008, '2008-07-03', 4240, 115, 0, 'orange', '00001505010708', '', '0651425883 - 3-7/2-8', 16.81);
INSERT INTO "boekregels" VALUES(115, 15, 2008, '2008-07-03', 2200, 0, 0, 'orange', '00001505010708', '', '0651425883 - 3-7/2-8', 3.19);
INSERT INTO "boekregels" VALUES(116, 16, 2008, '2008-07-10', 1600, 0, 0, 'hi', '5951011.74', '', '0623477347 - juli 08', -20.00);
INSERT INTO "boekregels" VALUES(117, 16, 2008, '2008-07-10', 4240, 118, 0, 'hi', '5951011.74', '', '0623477347 - juli 08', 16.81);
INSERT INTO "boekregels" VALUES(118, 16, 2008, '2008-07-10', 2200, 0, 0, 'hi', '5951011.74', '', '0623477347 - juli 08', 3.19);
INSERT INTO "boekregels" VALUES(119, 17, 2008, '2008-07-28', 1600, 0, 0, 'tmobile', '901071514459', '', '0623477347 - 23-7/23-8', -57.23);
INSERT INTO "boekregels" VALUES(120, 17, 2008, '2008-07-28', 4240, 121, 0, 'tmobile', '901071514459', '', '0623477347 - 23-7/23-8', 48.09);
INSERT INTO "boekregels" VALUES(121, 17, 2008, '2008-07-28', 2200, 0, 0, 'tmobile', '901071514459', '', '0623477347 - 23-7/23-8', 9.14);
INSERT INTO "boekregels" VALUES(122, 18, 2008, '2008-06-04', 1600, 0, 0, 'apple', '9044011895', '', 'IMac SN.VM823WHT0KM', -2047.99);
INSERT INTO "boekregels" VALUES(123, 18, 2008, '2008-06-04', 100, 124, 0, 'apple', '9044011895', '', 'IMac SN.VM823WHT0KM', 1721.00);
INSERT INTO "boekregels" VALUES(124, 18, 2008, '2008-06-04', 2200, 0, 0, 'apple', '9044011895', '', 'IMac SN.VM823WHT0KM', 326.99);
INSERT INTO "boekregels" VALUES(125, 19, 2008, '2008-08-11', 1600, 0, 0, 'hi', '5951011.75', '', 'Retour wgs. afronding Hi abonnement', 6.45);
INSERT INTO "boekregels" VALUES(126, 19, 2008, '2008-08-11', 4240, 127, 0, 'hi', '5951011.75', '', 'Retour wgs. afronding Hi abonnement', -5.42);
INSERT INTO "boekregels" VALUES(127, 19, 2008, '2008-08-11', 2200, 0, 0, 'hi', '5951011.75', '', 'Retour wgs. afronding Hi abonnement', -1.03);
INSERT INTO "boekregels" VALUES(128, 20, 2008, '2008-08-03', 1600, 0, 0, 'orange', '00005256140808', '', '0651425883 - 3-8/2-9', -20.00);
INSERT INTO "boekregels" VALUES(129, 20, 2008, '2008-08-03', 4240, 130, 0, 'orange', '00005256140808', '', '0651425883 - 3-8/2-9', 16.81);
INSERT INTO "boekregels" VALUES(130, 20, 2008, '2008-08-03', 2200, 0, 0, 'orange', '00005256140808', '', '0651425883 - 3-8/2-9', 3.19);
INSERT INTO "boekregels" VALUES(131, 21, 2008, '2008-08-07', 1600, 0, 0, 'xs4all', '24421784', '', 'ADSL Basic 6-8/6-9', -23.20);
INSERT INTO "boekregels" VALUES(132, 21, 2008, '2008-08-07', 4245, 133, 0, 'xs4all', '24421784', '', 'ADSL Basic 6-8/6-9', 19.50);
INSERT INTO "boekregels" VALUES(133, 21, 2008, '2008-08-07', 2200, 0, 0, 'xs4all', '24421784', '', 'ADSL Basic 6-8/6-9', 3.70);
INSERT INTO "boekregels" VALUES(134, 22, 2008, '2008-08-26', 1600, 0, 0, 'tmobile', '901072876695', '', '0623477347 - 23-8/23-9', -62.74);
INSERT INTO "boekregels" VALUES(135, 22, 2008, '2008-08-26', 4240, 136, 0, 'tmobile', '901072876695', '', '0623477347 - 23-8/23-9', 52.72);
INSERT INTO "boekregels" VALUES(136, 22, 2008, '2008-08-26', 2200, 0, 0, 'tmobile', '901072876695', '', '0623477347 - 23-8/23-9', 10.02);
INSERT INTO "boekregels" VALUES(137, 23, 2008, '2008-08-27', 1600, 0, 0, 'kpn', '0182611557-0309', '', 'BelBasis + ADSL 1-9/31-10', -95.34);
INSERT INTO "boekregels" VALUES(138, 23, 2008, '2008-08-27', 4245, 139, 0, 'kpn', '0182611557-0309', '', 'BelBasis + ADSL 1-9/31-10', 80.12);
INSERT INTO "boekregels" VALUES(139, 23, 2008, '2008-08-27', 2200, 0, 0, 'kpn', '0182611557-0309', '', 'BelBasis + ADSL 1-9/31-10', 15.22);
INSERT INTO "boekregels" VALUES(140, 24, 2008, '2008-09-07', 1600, 0, 0, 'xs4all', '24747064', '', 'ADSL Basic 6-9/6-10', -23.20);
INSERT INTO "boekregels" VALUES(141, 24, 2008, '2008-09-07', 4245, 142, 0, 'xs4all', '24747064', '', 'ADSL Basic 6-9/6-10', 19.50);
INSERT INTO "boekregels" VALUES(142, 24, 2008, '2008-09-07', 2200, 0, 0, 'xs4all', '24747064', '', 'ADSL Basic 6-9/6-10', 3.70);
INSERT INTO "boekregels" VALUES(143, 25, 2008, '2008-09-03', 1600, 0, 0, 'orange', '00001913360908', '', '0651425883 - 3-9/2-10', -20.00);
INSERT INTO "boekregels" VALUES(144, 25, 2008, '2008-09-03', 4240, 145, 0, 'orange', '00001913360908', '', '0651425883 - 3-9/2-10', 16.81);
INSERT INTO "boekregels" VALUES(145, 25, 2008, '2008-09-03', 2200, 0, 0, 'orange', '00001913360908', '', '0651425883 - 3-9/2-10', 3.19);
INSERT INTO "boekregels" VALUES(146, 26, 2008, '2008-09-25', 1600, 0, 0, 'tmobile', '901074320344', '', '0623477347 - 23-9/22-10', -52.26);
INSERT INTO "boekregels" VALUES(147, 26, 2008, '2008-09-25', 4240, 148, 0, 'tmobile', '901074320344', '', '0623477347 - 23-9/22-10', 43.92);
INSERT INTO "boekregels" VALUES(148, 26, 2008, '2008-09-25', 2200, 0, 0, 'tmobile', '901074320344', '', '0623477347 - 23-9/22-10', 8.34);
INSERT INTO "boekregels" VALUES(149, 27, 2008, '2008-10-07', 1600, 0, 0, 'xs4all', '25062372', '', 'ADSL Basic 6-10/6-11', -23.20);
INSERT INTO "boekregels" VALUES(150, 27, 2008, '2008-10-07', 4245, 151, 0, 'xs4all', '25062372', '', 'ADSL Basic 6-10/6-11', 19.50);
INSERT INTO "boekregels" VALUES(151, 27, 2008, '2008-10-07', 2200, 0, 0, 'xs4all', '25062372', '', 'ADSL Basic 6-10/6-11', 3.70);
INSERT INTO "boekregels" VALUES(152, 28, 2008, '2008-10-03', 1600, 0, 0, 'orange', '00002073751008', '', '0651425883 - 3-10/2-11', -20.00);
INSERT INTO "boekregels" VALUES(153, 28, 2008, '2008-10-03', 4240, 154, 0, 'orange', '00002073751008', '', '0651425883 - 3-10/2-11', 16.81);
INSERT INTO "boekregels" VALUES(154, 28, 2008, '2008-10-03', 2200, 0, 0, 'orange', '00002073751008', '', '0651425883 - 3-10/2-11', 3.19);
INSERT INTO "boekregels" VALUES(155, 29, 2008, '2008-06-17', 1600, 0, 0, 'apple', '9044127937', '', 'MacAir sn: W8820004Y51', -1646.92);
INSERT INTO "boekregels" VALUES(156, 29, 2008, '2008-06-17', 100, 157, 0, 'apple', '9044127937', '', 'MacAir sn: W8820004Y51', 1383.97);
INSERT INTO "boekregels" VALUES(157, 29, 2008, '2008-06-17', 2200, 0, 0, 'apple', '9044127937', '', 'MacAir sn: W8820004Y51', 262.95);
INSERT INTO "boekregels" VALUES(158, 7, 2008, '2008-06-16', 1600, 0, 19, 'apple', '9044127937', '', 'Factuurbetaling', 1646.92);
INSERT INTO "boekregels" VALUES(160, 30, 2008, '2008-10-23', 2110, 0, 0, '', '8290', '', 'Correctie bankst.124 Sigma Laservision', -11.40);
INSERT INTO "boekregels" VALUES(161, 30, 2008, '2008-10-23', 8020, 162, 0, '', '8290', '', 'Sigma Laservision', -60.00);
INSERT INTO "boekregels" VALUES(162, 30, 2008, '2008-10-23', 2110, 0, 0, '', '8290', '', 'Sigma Laservision', -11.40);
INSERT INTO "boekregels" VALUES(163, 30, 2008, '2008-10-23', 1060, 0, 0, '', '', '', 'Correctie bankst.124 Sigma Laservision', 142.80);
INSERT INTO "boekregels" VALUES(164, 31, 2008, '2008-06-11', 4230, 165, 0, '', '', '', 'Visitekaartjes Avery Burger', 30.81);
INSERT INTO "boekregels" VALUES(165, 31, 2008, '2008-06-11', 2200, 0, 0, '', '', '', 'Visitekaartjes Avery Burger', 5.85);
INSERT INTO "boekregels" VALUES(166, 31, 2008, '2008-06-12', 4490, 167, 0, '', '', '', 'Lunch', 12.45);
INSERT INTO "boekregels" VALUES(167, 31, 2008, '2008-06-12', 2200, 0, 0, '', '', '', 'Lunch', 0.74);
INSERT INTO "boekregels" VALUES(168, 31, 2008, '2008-06-23', 4220, 169, 0, '', '', '', 'Acrylvernis Fixet', 11.18);
INSERT INTO "boekregels" VALUES(169, 31, 2008, '2008-06-23', 2200, 0, 0, '', '', '', 'Acrylvernis Fixet', 2.12);
INSERT INTO "boekregels" VALUES(170, 31, 2008, '2008-07-14', 4490, 171, 0, '', '', '', 'Bespreking diner', 45.16);
INSERT INTO "boekregels" VALUES(171, 31, 2008, '2008-07-14', 2200, 0, 0, '', '', '', 'Bespreking diner', 3.09);
INSERT INTO "boekregels" VALUES(172, 31, 2008, '2008-07-25', 4220, 173, 0, '', '', '', 'Verfdoeken Xenos', 71.36);
INSERT INTO "boekregels" VALUES(173, 31, 2008, '2008-07-25', 2200, 0, 0, '', '', '', 'Verfdoeken Xenos', 13.56);
INSERT INTO "boekregels" VALUES(174, 31, 2008, '2008-08-06', 4220, 175, 0, '', '', '', 'Airbrushmateriaal Harolds', 36.91);
INSERT INTO "boekregels" VALUES(175, 31, 2008, '2008-08-06', 2200, 0, 0, '', '', '', 'Airbrushmateriaal Harolds', 7.01);
INSERT INTO "boekregels" VALUES(176, 31, 2008, '2008-08-16', 4220, 177, 0, '', '', '', 'Materiaal Gamma', 12.69);
INSERT INTO "boekregels" VALUES(177, 31, 2008, '2008-08-16', 2200, 0, 0, '', '', '', 'Materiaal Gamma', 2.41);
INSERT INTO "boekregels" VALUES(178, 31, 2008, '2008-08-20', 4220, 179, 0, '', '', '', 'Colorspray vernis Fixet', 7.82);
INSERT INTO "boekregels" VALUES(179, 31, 2008, '2008-08-20', 2200, 0, 0, '', '', '', 'Colorspray vernis Fixet', 1.48);
INSERT INTO "boekregels" VALUES(180, 31, 2008, '2008-08-23', 4220, 181, 0, '', '', '', 'Combimachine Aldi', 26.02);
INSERT INTO "boekregels" VALUES(181, 31, 2008, '2008-08-23', 2200, 0, 0, '', '', '', 'Combimachine Aldi', 4.94);
INSERT INTO "boekregels" VALUES(182, 31, 2008, '2008-09-05', 4220, 183, 0, '', '', '', 'Plaatmateriaal Gamma', 12.82);
INSERT INTO "boekregels" VALUES(183, 31, 2008, '2008-09-05', 2200, 0, 0, '', '', '', 'Plaatmateriaal Gamma', 2.43);
INSERT INTO "boekregels" VALUES(184, 31, 2008, '2008-09-11', 4230, 185, 0, '', '', '', 'Vakliteratuur AH', 5.66);
INSERT INTO "boekregels" VALUES(185, 31, 2008, '2008-09-11', 2200, 0, 0, '', '', '', 'Vakliteratuur AH', 0.33);
INSERT INTO "boekregels" VALUES(186, 31, 2008, '2008-09-18', 4490, 187, 0, '', '', '', 'Lunch', 16.79);
INSERT INTO "boekregels" VALUES(187, 31, 2008, '2008-09-18', 2200, 0, 0, '', '', '', 'Lunch', 1.01);
INSERT INTO "boekregels" VALUES(188, 31, 2008, '2008-09-25', 4220, 189, 0, '', '', '', 'Schildersdoek Xenos', 75.58);
INSERT INTO "boekregels" VALUES(189, 31, 2008, '2008-09-25', 2200, 0, 0, '', '', '', 'Schildersdoek Xenos', 14.36);
INSERT INTO "boekregels" VALUES(190, 31, 2008, '2008-09-25', 4490, 191, 0, '', '', '', 'Diner onderweg', 72.51);
INSERT INTO "boekregels" VALUES(191, 31, 2008, '2008-09-25', 2200, 0, 0, '', '', '', 'Diner onderweg', 5.44);
INSERT INTO "boekregels" VALUES(192, 31, 2008, '2008-09-27', 4220, 193, 0, '', '', '', 'Schildersdoek VenD', 54.62);
INSERT INTO "boekregels" VALUES(193, 31, 2008, '2008-09-27', 2200, 0, 0, '', '', '', 'Schildersdoek VenD', 10.38);
INSERT INTO "boekregels" VALUES(194, 31, 2008, '2008-09-27', 4220, 195, 0, '', '', '', 'Schildersdoek VenD', 67.23);
INSERT INTO "boekregels" VALUES(195, 31, 2008, '2008-09-27', 2200, 0, 0, '', '', '', 'Schildersdoek VenD', 12.77);
INSERT INTO "boekregels" VALUES(196, 31, 2008, '2008-09-27', 4490, 197, 0, '', '', '', 'Lunch', 4.15);
INSERT INTO "boekregels" VALUES(197, 31, 2008, '2008-09-27', 2200, 0, 0, '', '', '', 'Lunch', 0.25);
INSERT INTO "boekregels" VALUES(198, 31, 2008, '2008-02-28', 4220, 199, 0, '', '1660776250', '', 'Synth verf Sigma', 75.00);
INSERT INTO "boekregels" VALUES(199, 31, 2008, '2008-02-28', 2200, 0, 0, '', '1660776250', '', 'Synth verf Sigma', 14.25);
INSERT INTO "boekregels" VALUES(200, 31, 2008, '2008-06-17', 4220, 201, 0, '', '', '', 'Spuitmateriaal Henxs', 127.06);
INSERT INTO "boekregels" VALUES(201, 31, 2008, '2008-06-17', 2200, 0, 0, '', '', '', 'Spuitmateriaal Henxs', 24.14);
INSERT INTO "boekregels" VALUES(202, 31, 2008, '2008-08-20', 4220, 203, 0, '', '', '', 'Acryl vanBeek', 62.22);
INSERT INTO "boekregels" VALUES(203, 31, 2008, '2008-08-20', 2200, 0, 0, '', '', '', 'Acryl vanBeek', 11.82);
INSERT INTO "boekregels" VALUES(204, 31, 2008, '2008-09-05', 4220, 205, 0, '', '', '', 'Steigermateriaal Bouwmaat', 360.53);
INSERT INTO "boekregels" VALUES(205, 31, 2008, '2008-09-05', 2200, 0, 0, '', '', '', 'Steigermateriaal Bouwmaat', 68.50);
INSERT INTO "boekregels" VALUES(206, 31, 2008, '2008-09-25', 4220, 207, 0, '', '', '', 'Spuitmateriaal Henxs', 273.24);
INSERT INTO "boekregels" VALUES(207, 31, 2008, '2008-09-25', 2200, 0, 0, '', '', '', 'Spuitmateriaal Henxs', 51.91);
INSERT INTO "boekregels" VALUES(208, 32, 2008, '2008-07-11', 1200, 0, 0, 'vonk', '8291', '', 'Workshop graffiti', 214.20);
INSERT INTO "boekregels" VALUES(209, 32, 2008, '2008-07-11', 8020, 210, 0, 'vonk', '8291', '', 'Workshop graffiti', -180.00);
INSERT INTO "boekregels" VALUES(210, 32, 2008, '2008-07-11', 2110, 0, 0, 'vonk', '8291', '', 'Workshop graffiti', -34.20);
INSERT INTO "boekregels" VALUES(211, 33, 2008, '2008-04-14', 1200, 0, 0, 'kcw', '8032', '', 'Div werkzaamheden KCW site', 8663.20);
INSERT INTO "boekregels" VALUES(212, 33, 2008, '2008-04-14', 8010, 213, 0, 'kcw', '8032', '', 'Div werkzaamheden KCW site', -7280.00);
INSERT INTO "boekregels" VALUES(213, 33, 2008, '2008-04-14', 2110, 0, 0, 'kcw', '8032', '', 'Div werkzaamheden KCW site', -1383.20);
INSERT INTO "boekregels" VALUES(214, 34, 2008, '2008-08-25', 1200, 0, 0, 'jjmidholl', '8292', '', 'Spuitwerkzaamheden', 160.65);
INSERT INTO "boekregels" VALUES(215, 34, 2008, '2008-08-25', 8020, 216, 0, 'jjmidholl', '8292', '', 'Spuitwerkzaamheden', -135.00);
INSERT INTO "boekregels" VALUES(216, 34, 2008, '2008-08-25', 2110, 0, 0, 'jjmidholl', '8292', '', 'Spuitwerkzaamheden', -25.65);
INSERT INTO "boekregels" VALUES(217, 35, 2008, '2008-07-18', 1050, 0, 0, '', '', '', 'Bankafschrift: 0125', -15.67);
INSERT INTO "boekregels" VALUES(218, 35, 2008, '2008-06-23', 1200, 0, 2, 'kcw', '8032', 'rabo 7', 'Factuurontvangst: kcw', -8663.20);
INSERT INTO "boekregels" VALUES(219, 35, 2008, '2008-06-04', 1600, 0, 8, 'apple', '9044011895', 'rabo 7', 'Factuurbetaling', 2047.99);
INSERT INTO "boekregels" VALUES(220, 35, 2008, '2008-07-01', 4350, 0, 0, '', '', 'rabo 7', 'Debetrente', 0.16);
INSERT INTO "boekregels" VALUES(221, 35, 2008, '2008-07-01', 4350, 0, 0, '', '', 'rabo 7', 'Bankkosten', 36.72);
INSERT INTO "boekregels" VALUES(223, 35, 2008, '2008-07-07', 1600, 0, 3, 'kpn', '0182611557-0307', 'rabo 7', 'Factuurbetaling', 100.41);
INSERT INTO "boekregels" VALUES(225, 35, 2008, '2008-07-08', 2300, 0, 0, '', '', 'rabo 7', 'OB 2e kwartaal', 573.00);
INSERT INTO "boekregels" VALUES(226, 35, 2008, '2008-07-16', 1600, 0, 4, 'xs4all', '24102215', 'rabo 7', 'Factuurbetaling', 23.20);
INSERT INTO "boekregels" VALUES(227, 35, 2008, '2008-07-16', 1600, 0, 5, 'orange', '00001505010708', 'rabo 7', 'Factuurbetaling', 20.00);
INSERT INTO "boekregels" VALUES(228, 35, 2008, '2008-07-16', 1200, 0, 1, 'vonk', '8291', 'rabo 7', 'Factuurontvangst: vonk', -214.20);
INSERT INTO "boekregels" VALUES(229, 35, 2008, '2008-07-18', 1600, 0, 6, 'hi', '5951011.74', 'rabo 7', 'Factuurbetaling', 20.00);
INSERT INTO "boekregels" VALUES(230, 35, 2008, '2008-07-18', 1060, 0, 0, '', '', 'rabo 7', 'Bankafschrift: 0125', 6071.59);
INSERT INTO "boekregels" VALUES(231, 36, 2008, '2008-08-15', 1050, 0, 0, '', '', '', 'Bankafschrift: 0126', -1292.69);
INSERT INTO "boekregels" VALUES(232, 36, 2008, '2008-07-25', 1600, 0, 2, 'tmobile', '901070203247', 'rabo 8', 'Factuurbetaling', 13.57);
INSERT INTO "boekregels" VALUES(233, 36, 2008, '2008-08-11', 1600, 0, 11, 'xs4all', '24421784', 'rabo 8', 'Factuurbetaling', 23.20);
INSERT INTO "boekregels" VALUES(234, 37, 2008, '2008-08-11', 1600, 0, 0, 'transip', 'F2008102940', '', 'Domeinregistraties', -26.13);
INSERT INTO "boekregels" VALUES(235, 37, 2008, '2008-08-11', 4245, 236, 0, 'transip', 'F2008102940', '', 'Domeinregistraties', 21.96);
INSERT INTO "boekregels" VALUES(236, 37, 2008, '2008-08-11', 2200, 0, 0, 'transip', 'F2008102940', '', 'Domeinregistraties', 4.17);
INSERT INTO "boekregels" VALUES(237, 38, 2008, '2008-09-01', 1600, 0, 0, 'transip', 'F2008111105', '', 'Domeinregistraties', -17.85);
INSERT INTO "boekregels" VALUES(238, 38, 2008, '2008-09-01', 4245, 239, 0, 'transip', 'F2008111105', '', 'Domeinregistraties', 15.00);
INSERT INTO "boekregels" VALUES(239, 38, 2008, '2008-09-01', 2200, 0, 0, 'transip', 'F2008111105', '', 'Domeinregistraties', 2.85);
INSERT INTO "boekregels" VALUES(240, 39, 2008, '2008-09-16', 1600, 0, 0, 'transip', 'F2008118657', '', 'Domeinregistraties', -5.94);
INSERT INTO "boekregels" VALUES(241, 39, 2008, '2008-09-16', 4245, 242, 0, 'transip', 'F2008118657', '', 'Domeinregistraties', 4.99);
INSERT INTO "boekregels" VALUES(242, 39, 2008, '2008-09-16', 2200, 0, 0, 'transip', 'F2008118657', '', 'Domeinregistraties', 0.95);
INSERT INTO "boekregels" VALUES(243, 40, 2008, '2008-09-09', 1600, 0, 0, 'transip', 'F2008124681', '', 'Domeinregistraties', -8.93);
INSERT INTO "boekregels" VALUES(244, 40, 2008, '2008-09-09', 4245, 245, 0, 'transip', 'F2008124681', '', 'Domeinregistraties', 7.50);
INSERT INTO "boekregels" VALUES(245, 40, 2008, '2008-09-09', 2200, 0, 0, 'transip', 'F2008124681', '', 'Domeinregistraties', 1.43);
INSERT INTO "boekregels" VALUES(246, 36, 2008, '2008-08-15', 1600, 0, 20, 'transip', 'F2008102940', 'rabo 8', 'Factuurbetaling', 26.13);
INSERT INTO "boekregels" VALUES(248, 36, 2008, '2008-08-15', 1060, 0, 0, '', '', 'rabo 8', 'Bankafschrift: 0126', 1229.79);
INSERT INTO "boekregels" VALUES(249, 41, 2008, '2008-09-26', 1050, 0, 0, '', '', '', 'Bankafschrift: 0127', -1533.77);
INSERT INTO "boekregels" VALUES(251, 41, 2008, '2008-08-19', 1600, 0, 10, 'orange', '00005256140808', 'rabo 9', 'Factuurbetaling', 20.00);
INSERT INTO "boekregels" VALUES(253, 41, 2008, '2008-09-26', 1600, 0, 9, 'hi', '5951011.75', 'rabo 9', 'Factuurbetaling ontvangst wgs afhandeling', -6.45);
INSERT INTO "boekregels" VALUES(254, 41, 2008, '2008-09-26', 4230, 0, 0, '', '', 'rabo 9', 'Software L.Wing', 20.08);
INSERT INTO "boekregels" VALUES(255, 41, 2008, '2008-09-26', 4230, 0, 0, '', '', 'rabo 9', 'Software Pangea', 26.22);
INSERT INTO "boekregels" VALUES(256, 41, 2008, '2008-08-27', 1600, 0, 7, 'tmobile', '901071514459', 'rabo 9', 'Factuurbetaling', 57.23);
INSERT INTO "boekregels" VALUES(257, 41, 2008, '2008-09-01', 1600, 0, 21, 'transip', 'F2008111105', 'rabo 9', 'Factuurbetaling', 17.85);
INSERT INTO "boekregels" VALUES(258, 41, 2008, '2008-09-12', 1200, 0, 3, 'jjmidholl', '8292', 'rabo 9', 'Factuurontvangst: jjmidholl', -160.65);
INSERT INTO "boekregels" VALUES(259, 41, 2008, '2008-09-12', 1600, 0, 15, 'orange', '00001913360908', 'rabo 9', 'Factuurbetaling', 20.00);
INSERT INTO "boekregels" VALUES(260, 41, 2008, '2008-09-12', 1600, 0, 14, 'xs4all', '24747064', 'rabo 9', 'Factuurbetaling', 23.20);
INSERT INTO "boekregels" VALUES(261, 41, 2008, '2008-09-12', 1600, 0, 13, 'kpn', '0182611557-0309', 'rabo 9', 'Factuurbetaling', 95.34);
INSERT INTO "boekregels" VALUES(262, 41, 2008, '2008-09-25', 1600, 0, 12, 'tmobile', '901072876695', 'rabo 9', 'Factuurbetaling', 62.74);
INSERT INTO "boekregels" VALUES(263, 41, 2008, '2008-09-26', 1060, 0, 0, '', '', 'rabo 9', 'Bankafschrift: 0127', 1358.21);
INSERT INTO "boekregels" VALUES(264, 10, 2008, '2008-06-18', 1600, 0, 1, 'hi', '5951011.73', 'rabo 6', 'Factuurbetaling', 20.00);
INSERT INTO "boekregels" VALUES(265, 42, 2008, '2008-09-30', 1000, 0, 0, '', '', '', 'Prive naar Kassaldo', 4000.00);
INSERT INTO "boekregels" VALUES(266, 42, 2008, '2008-09-30', 1060, 0, 0, '', '', '', 'Prive naar Kassaldo', -4000.00);
INSERT INTO "boekregels" VALUES(267, 31, 2008, '2008-09-30', 1000, 0, 0, '', '', '', 'Kasbetalingen 3e kwartaal 2008', -1720.60);
INSERT INTO "boekregels" VALUES(270, 44, 2008, '2008-10-27', 1600, 0, 0, 'tmobile', '01075800403', '', '0623477347 - 23-10/22-11', -52.26);
INSERT INTO "boekregels" VALUES(269, 43, 2008, '2008-10-28', 2300, 0, 0, '', '', '', 'BTW 3e kwartaal prive betaald', 778.00);
INSERT INTO "boekregels" VALUES(271, 44, 2008, '2008-10-27', 4240, 272, 0, 'tmobile', '01075800403', '', '0623477347 - 23-10/22-11', 43.92);
INSERT INTO "boekregels" VALUES(272, 44, 2008, '2008-10-27', 2200, 0, 0, 'tmobile', '01075800403', '', '0623477347 - 23-10/22-11', 8.34);
INSERT INTO "boekregels" VALUES(277, 43, 2008, '2008-10-28', 1600, 0, 17, 'xs4all', '25062372', '', 'Factuurbetaling', 23.20);
INSERT INTO "boekregels" VALUES(274, 45, 2008, '2008-10-27', 1600, 0, 0, 'kpn', '0182611557-0311', '', 'BelBasis + ADSL 1-11/31-12', -97.56);
INSERT INTO "boekregels" VALUES(275, 45, 2008, '2008-10-27', 4245, 276, 0, 'kpn', '0182611557-0311', '', 'BelBasis + ADSL 1-11/31-12', 81.98);
INSERT INTO "boekregels" VALUES(276, 45, 2008, '2008-10-27', 2200, 0, 0, 'kpn', '0182611557-0311', '', 'BelBasis + ADSL 1-11/31-12', 15.58);
INSERT INTO "boekregels" VALUES(278, 43, 2008, '2008-10-03', 4240, 279, 0, '', '', '', 'Telefoon Motorola', 91.60);
INSERT INTO "boekregels" VALUES(279, 43, 2008, '2008-10-03', 2200, 0, 0, '', '', '', 'Telefoon Motorola', 17.40);
INSERT INTO "boekregels" VALUES(280, 43, 2008, '2008-10-06', 4250, 0, 0, '', '', '', 'Postzegels', 88.00);
INSERT INTO "boekregels" VALUES(281, 43, 2008, '2008-10-07', 4230, 282, 0, '', '', '', 'CT Magazine AH', 5.66);
INSERT INTO "boekregels" VALUES(282, 43, 2008, '2008-10-07', 2200, 0, 0, '', '', '', 'CT Magazine AH', 0.33);
INSERT INTO "boekregels" VALUES(283, 43, 2008, '2008-10-07', 4220, 284, 0, '', '', '', 'Acrylvernis Fixet', 17.87);
INSERT INTO "boekregels" VALUES(284, 43, 2008, '2008-10-07', 2200, 0, 0, '', '', '', 'Acrylvernis Fixet', 3.40);
INSERT INTO "boekregels" VALUES(285, 43, 2008, '2008-10-10', 4220, 286, 0, '', '', '', 'Schildersmateriaal Gamma', 24.07);
INSERT INTO "boekregels" VALUES(286, 43, 2008, '2008-10-10', 2200, 0, 0, '', '', '', 'Schildersmateriaal Gamma', 4.57);
INSERT INTO "boekregels" VALUES(287, 43, 2008, '2008-10-15', 4230, 288, 0, '', '', '', 'CT Magazine AH', 5.66);
INSERT INTO "boekregels" VALUES(288, 43, 2008, '2008-10-15', 2200, 0, 0, '', '', '', 'CT Magazine AH', 0.33);
INSERT INTO "boekregels" VALUES(289, 43, 2008, '2008-10-13', 4220, 290, 0, '', '', '', 'Spuitmateriaal Henxs', 127.23);
INSERT INTO "boekregels" VALUES(290, 43, 2008, '2008-10-13', 2200, 0, 0, '', '', '', 'Spuitmateriaal Henxs', 24.17);
INSERT INTO "boekregels" VALUES(291, 43, 2008, '2008-10-20', 4230, 292, 0, '', '', '', 'Tijdschrift Bruna', 6.56);
INSERT INTO "boekregels" VALUES(292, 43, 2008, '2008-10-20', 2200, 0, 0, '', '', '', 'Tijdschrift Bruna', 0.39);
INSERT INTO "boekregels" VALUES(293, 46, 2008, '2008-08-12', 1200, 0, 0, 'kcw', '28045', '', 'Onderhoud 3e kwartaal', 2427.60);
INSERT INTO "boekregels" VALUES(294, 46, 2008, '2008-08-12', 8010, 295, 0, 'kcw', '28045', '', 'Onderhoud 3e kwartaal', -2040.00);
INSERT INTO "boekregels" VALUES(295, 46, 2008, '2008-08-12', 2110, 0, 0, 'kcw', '28045', '', 'Onderhoud 3e kwartaal', -387.60);
INSERT INTO "boekregels" VALUES(296, 47, 2008, '2008-10-28', 1200, 0, 0, 'kcw', '28095', '', 'Onderhoud 4e kwartaal', 2427.60);
INSERT INTO "boekregels" VALUES(300, 48, 2008, '2008-11-01', 1600, 0, 0, 'vanbeek', '246230', '', 'Spuitmateriaal', -27.09);
INSERT INTO "boekregels" VALUES(298, 47, 2008, '2008-10-28', 8010, 299, 0, 'kcw', '28095', '', 'Onderhoud 4e kwartaal', -2040.00);
INSERT INTO "boekregels" VALUES(299, 47, 2008, '2008-10-28', 2110, 0, 0, 'kcw', '28095', '', 'Onderhoud 4e kwartaal', -387.60);
INSERT INTO "boekregels" VALUES(301, 48, 2008, '2008-11-01', 4220, 302, 0, 'vanbeek', '246230', '', 'Spuitmateriaal', 22.76);
INSERT INTO "boekregels" VALUES(302, 48, 2008, '2008-11-01', 2200, 0, 0, 'vanbeek', '246230', '', 'Spuitmateriaal', 4.33);
INSERT INTO "boekregels" VALUES(303, 43, 2008, '2008-11-01', 1600, 0, 26, 'vanbeek', '246230', '', 'Factuurbetaling', 27.09);
INSERT INTO "boekregels" VALUES(304, 43, 2008, '2008-10-25', 4220, 305, 0, '', '', '', 'Ladder Gamma', 91.60);
INSERT INTO "boekregels" VALUES(305, 43, 2008, '2008-10-25', 2200, 0, 0, '', '', '', 'Ladder Gamma', 17.40);
INSERT INTO "boekregels" VALUES(306, 43, 2008, '2008-11-03', 4220, 307, 0, '', '', '', 'Spuitmateriaal Henxs', 63.03);
INSERT INTO "boekregels" VALUES(307, 43, 2008, '2008-11-03', 2200, 0, 0, '', '', '', 'Spuitmateriaal Henxs', 11.97);
INSERT INTO "boekregels" VALUES(308, 49, 2008, '2008-11-07', 1600, 0, 0, 'xs4all', '25378236', '', 'ADSL Basic 6-11/6-12', -23.20);
INSERT INTO "boekregels" VALUES(309, 49, 2008, '2008-11-07', 4245, 310, 0, 'xs4all', '25378236', '', 'ADSL Basic 6-11/6-12', 19.50);
INSERT INTO "boekregels" VALUES(310, 49, 2008, '2008-11-07', 2200, 0, 0, 'xs4all', '25378236', '', 'ADSL Basic 6-11/6-12', 3.70);
INSERT INTO "boekregels" VALUES(311, 50, 2008, '2008-11-06', 1600, 0, 0, 'conrad', '9541946926', '', 'Mediatablet', -73.79);
INSERT INTO "boekregels" VALUES(312, 50, 2008, '2008-11-06', 4210, 313, 0, 'conrad', '9541946926', '', 'Mediatablet', 62.01);
INSERT INTO "boekregels" VALUES(313, 50, 2008, '2008-11-06', 2200, 0, 0, 'conrad', '9541946926', '', 'Mediatablet', 11.78);
INSERT INTO "boekregels" VALUES(314, 51, 2008, '2008-11-03', 1600, 0, 0, 'orange', '2418311108', '', '0651425886 - 3-11/2-12', -20.00);
INSERT INTO "boekregels" VALUES(315, 51, 2008, '2008-11-03', 4240, 316, 0, 'orange', '2418311108', '', '0651425886 - 3-11/2-12', 16.81);
INSERT INTO "boekregels" VALUES(316, 51, 2008, '2008-11-03', 2200, 0, 0, 'orange', '2418311108', '', '0651425886 - 3-11/2-12', 3.19);
INSERT INTO "boekregels" VALUES(317, 52, 2008, '2008-11-20', 1600, 0, 0, 'diverse', 'U30298470', '', 'Security software Snitch for MacOSX', -31.94);
INSERT INTO "boekregels" VALUES(318, 52, 2008, '2008-11-20', 4230, 319, 0, 'diverse', 'U30298470', '', 'Security software Snitch for MacOSX', 27.30);
INSERT INTO "boekregels" VALUES(319, 52, 2008, '2008-11-20', 2200, 0, 0, 'diverse', 'U30298470', '', 'Security software Snitch for MacOSX', 4.64);
INSERT INTO "boekregels" VALUES(320, 43, 2008, '2008-11-21', 4250, 0, 0, '', '', '', 'Verzendkosten LaCie schijf', 8.75);
INSERT INTO "boekregels" VALUES(321, 43, 2008, '2008-11-22', 4230, 322, 0, '', '', '', 'Tijdschrift AH', 5.66);
INSERT INTO "boekregels" VALUES(322, 43, 2008, '2008-11-22', 2200, 0, 0, '', '', '', 'Tijdschrift AH', 0.33);
INSERT INTO "boekregels" VALUES(323, 43, 2008, '2008-11-12', 4210, 324, 0, '', '', '', 'LaCie schijf mediamarkt', 84.03);
INSERT INTO "boekregels" VALUES(324, 43, 2008, '2008-11-12', 2200, 0, 0, '', '', '', 'LaCie schijf mediamarkt', 15.96);
INSERT INTO "boekregels" VALUES(325, 53, 2008, '2008-11-26', 1600, 0, 0, 'tmobile', '901077335109', '', '0623477347 - 23-11/22-12', -52.26);
INSERT INTO "boekregels" VALUES(326, 53, 2008, '2008-11-26', 4240, 327, 0, 'tmobile', '901077335109', '', '0623477347 - 23-11/22-12', 43.92);
INSERT INTO "boekregels" VALUES(327, 53, 2008, '2008-11-26', 2200, 0, 0, 'tmobile', '901077335109', '', '0623477347 - 23-11/22-12', 8.34);
INSERT INTO "boekregels" VALUES(328, 43, 2008, '2008-11-29', 4500, 329, 0, '', '', '', 'Bloemen expositie', 18.91);
INSERT INTO "boekregels" VALUES(329, 43, 2008, '2008-11-29', 2200, 0, 0, '', '', '', 'Bloemen expositie', 3.59);
INSERT INTO "boekregels" VALUES(330, 43, 2008, '2008-11-29', 4500, 331, 0, '', '', '', 'Dranken etc. expositie', 30.29);
INSERT INTO "boekregels" VALUES(331, 43, 2008, '2008-11-29', 2200, 0, 0, '', '', '', 'Dranken etc. expositie', 2.86);
INSERT INTO "boekregels" VALUES(332, 43, 2008, '2008-11-27', 4500, 0, 0, '', '', '', 'Expositie versnaperingen', 22.98);
INSERT INTO "boekregels" VALUES(333, 43, 2008, '2008-12-03', 4220, 0, 0, '', '', '', 'EHBO', 9.96);
INSERT INTO "boekregels" VALUES(334, 54, 2008, '2008-12-07', 1600, 0, 0, 'xs4all', '25693810', '', 'ADSL Basic 6-12/6-01', -56.78);
INSERT INTO "boekregels" VALUES(335, 54, 2008, '2008-12-07', 4245, 336, 0, 'xs4all', '25693810', '', 'ADSL Basic 6-12/6-01', 47.72);
INSERT INTO "boekregels" VALUES(336, 54, 2008, '2008-12-07', 2200, 0, 0, 'xs4all', '25693810', '', 'ADSL Basic 6-12/6-01', 9.06);
INSERT INTO "boekregels" VALUES(337, 55, 2008, '2008-12-03', 1600, 0, 0, 'orange', '00002171381208', '', '0651425883 - 3-12/2-01', -20.00);
INSERT INTO "boekregels" VALUES(338, 55, 2008, '2008-12-03', 4240, 339, 0, 'orange', '00002171381208', '', '0651425883 - 3-12/2-01', 16.81);
INSERT INTO "boekregels" VALUES(339, 55, 2008, '2008-12-03', 2200, 0, 0, 'orange', '00002171381208', '', '0651425883 - 3-12/2-01', 3.19);
INSERT INTO "boekregels" VALUES(340, 56, 2008, '2008-12-16', 1600, 0, 0, 'diverse', '16dec', '', 'EveryDNS bijdrage DNS gebruik', -18.58);
INSERT INTO "boekregels" VALUES(341, 56, 2008, '2008-12-16', 4245, 0, 0, 'diverse', '16dec', '', 'EveryDNS bijdrage DNS gebruik', 18.58);
INSERT INTO "boekregels" VALUES(342, 43, 2008, '2008-12-17', 4210, 343, 0, '', '', '', 'Memorystick (mediamarkt)', 7.55);
INSERT INTO "boekregels" VALUES(343, 43, 2008, '2008-12-17', 2200, 0, 0, '', '', '', 'Memorystick (mediamarkt)', 1.44);
INSERT INTO "boekregels" VALUES(344, 43, 2008, '2008-12-19', 4230, 345, 0, '', '', '', 'Kaarten en ringbanden', 17.31);
INSERT INTO "boekregels" VALUES(345, 43, 2008, '2008-12-19', 2200, 0, 0, '', '', '', 'Kaarten en ringbanden', 3.29);
INSERT INTO "boekregels" VALUES(346, 57, 2008, '2008-12-19', 1600, 0, 0, '123inkt', '766013', '', 'Cartridges', -24.45);
INSERT INTO "boekregels" VALUES(347, 57, 2008, '2008-12-19', 4230, 348, 0, '123inkt', '766013', '', 'Cartridges', 20.55);
INSERT INTO "boekregels" VALUES(348, 57, 2008, '2008-12-19', 2200, 0, 0, '123inkt', '766013', '', 'Cartridges', 3.90);
INSERT INTO "boekregels" VALUES(349, 58, 2008, '2008-12-29', 1600, 0, 0, 'tmobile', '901078936459', '', 'Flex zakelijk 23-11/22-12', -52.26);
INSERT INTO "boekregels" VALUES(350, 58, 2008, '2008-12-29', 4240, 351, 0, 'tmobile', '901078936459', '', 'Flex zakelijk 23-11/22-12', 43.92);
INSERT INTO "boekregels" VALUES(351, 58, 2008, '2008-12-29', 2200, 0, 0, 'tmobile', '901078936459', '', 'Flex zakelijk 23-11/22-12', 8.34);
INSERT INTO "boekregels" VALUES(352, 59, 2008, '2008-12-29', 1600, 0, 0, 'kpn', '0182611557-0301', '', '8-12/20-12', -19.15);
INSERT INTO "boekregels" VALUES(353, 59, 2008, '2008-12-29', 4240, 354, 0, 'kpn', '0182611557-0301', '', '8-12/20-12', 16.09);
INSERT INTO "boekregels" VALUES(354, 59, 2008, '2008-12-29', 2200, 0, 0, 'kpn', '0182611557-0301', '', '8-12/20-12', 3.06);
INSERT INTO "boekregels" VALUES(355, 60, 2008, '2008-12-09', 1600, 0, 0, 'vonk', '420050', '', 'Zaalhuur presentatie', -350.00);
INSERT INTO "boekregels" VALUES(356, 60, 2008, '2008-12-09', 4500, 0, 0, 'vonk', '420050', '', 'Zaalhuur presentatie', 350.00);
INSERT INTO "boekregels" VALUES(357, 43, 2008, '2008-12-24', 4210, 358, 0, '', '', '', 'Muis (mediamarkt)', 37.81);
INSERT INTO "boekregels" VALUES(358, 43, 2008, '2008-12-24', 2200, 0, 0, '', '', '', 'Muis (mediamarkt)', 7.18);
INSERT INTO "boekregels" VALUES(359, 43, 2008, '2008-12-10', 4230, 360, 0, '', '', '', 'Brandstof kachel kantoor (welkoop)', 36.93);
INSERT INTO "boekregels" VALUES(360, 43, 2008, '2008-12-10', 2200, 0, 0, '', '', '', 'Brandstof kachel kantoor (welkoop)', 7.02);
INSERT INTO "boekregels" VALUES(361, 43, 2008, '2008-12-10', 4230, 0, 0, '', '', '', 'Statiegeld welkoop', 6.81);
INSERT INTO "boekregels" VALUES(362, 62, 2008, '2008-03-31', 2200, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -63.76);
INSERT INTO "boekregels" VALUES(363, 62, 2008, '2008-03-31', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2200', 63.76);
INSERT INTO "boekregels" VALUES(364, 62, 2008, '2008-03-31', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 8900', 0.24);
INSERT INTO "boekregels" VALUES(365, 62, 2008, '2008-03-31', 8900, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2300', -0.24);
INSERT INTO "boekregels" VALUES(366, 63, 2008, '2008-06-30', 2110, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', 1045.00);
INSERT INTO "boekregels" VALUES(367, 63, 2008, '2008-06-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2110', -1045.00);
INSERT INTO "boekregels" VALUES(368, 63, 2008, '2008-06-30', 2200, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', -471.81);
INSERT INTO "boekregels" VALUES(369, 63, 2008, '2008-06-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2200', 471.81);
INSERT INTO "boekregels" VALUES(370, 63, 2008, '2008-06-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 8900', 0.19);
INSERT INTO "boekregels" VALUES(371, 63, 2008, '2008-06-30', 8900, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2300', -0.19);
INSERT INTO "boekregels" VALUES(372, 64, 2008, '2008-09-30', 2110, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', 1465.85);
INSERT INTO "boekregels" VALUES(373, 64, 2008, '2008-09-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2110', -1465.85);
INSERT INTO "boekregels" VALUES(374, 64, 2008, '2008-09-30', 2200, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -687.59);
INSERT INTO "boekregels" VALUES(375, 64, 2008, '2008-09-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2200', 687.59);
INSERT INTO "boekregels" VALUES(376, 64, 2008, '2008-09-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 8900', -0.15);
INSERT INTO "boekregels" VALUES(377, 64, 2008, '2008-09-30', 8900, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2300', 0.15);
INSERT INTO "boekregels" VALUES(378, 64, 2008, '2008-09-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 8900', 0.41);
INSERT INTO "boekregels" VALUES(379, 64, 2008, '2008-09-30', 8900, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2300', -0.41);
INSERT INTO "boekregels" VALUES(380, 65, 2008, '2008-06-30', 1060, 0, 0, '', '', '', 'BTW teruggave 1e per. prive ontvangen', 67.00);
INSERT INTO "boekregels" VALUES(381, 65, 2008, '2008-06-30', 2300, 0, 0, '', '', '', 'BTW teruggave 1e per. prive ontvangen', -67.00);
INSERT INTO "boekregels" VALUES(382, 66, 2008, '2008-06-30', 2300, 0, 0, '', '', '', 'Verschil periode1-aangifte', 3.00);
INSERT INTO "boekregels" VALUES(383, 66, 2008, '2008-06-30', 8900, 0, 0, '', '', '', 'Verschil periode1-aangifte', -3.00);
INSERT INTO "boekregels" VALUES(384, 1, 2008, '2008-01-01', 2300, 0, 0, '', '', '', 'Beginbalans', -2055.00);
INSERT INTO "boekregels" VALUES(385, 68, 2009, '2009-01-01', 1600, 0, 0, 'transip', 'F2009000711', '', 'Domeinregistraties', -26.78);
INSERT INTO "boekregels" VALUES(386, 68, 2009, '2009-01-01', 4245, 387, 0, 'transip', 'F2009000711', '', 'Domeinregistraties', 22.50);
INSERT INTO "boekregels" VALUES(387, 68, 2009, '2009-01-01', 2200, 0, 0, 'transip', 'F2009000711', '', 'Domeinregistraties', 4.28);
INSERT INTO "boekregels" VALUES(388, 69, 2008, '2008-10-24', 1050, 0, 0, '', '', '', 'Bankafschrift: 128', 11.12);
INSERT INTO "boekregels" VALUES(389, 69, 2008, '2008-10-01', 1600, 0, 23, 'transip', 'F2008124681', 'rabo 10', 'Factuurbetaling', 8.93);
INSERT INTO "boekregels" VALUES(390, 69, 2008, '2008-10-01', 1600, 0, 22, 'transip', 'F2008118657', 'rabo 10', 'Factuurbetaling', 5.94);
INSERT INTO "boekregels" VALUES(391, 69, 2008, '2008-10-01', 4350, 0, 0, '', '', 'rabo 10', 'Debetrente', 0.21);
INSERT INTO "boekregels" VALUES(392, 69, 2008, '2008-10-01', 4350, 0, 0, '', '', 'rabo 10', 'Bankkosten 2e kw', 37.04);
INSERT INTO "boekregels" VALUES(393, 69, 2008, '2008-10-01', 1600, 0, 16, 'tmobile', '901074320344', 'rabo 10', 'Factuurbetaling', 52.26);
INSERT INTO "boekregels" VALUES(394, 69, 2008, '2008-10-01', 1060, 0, 0, '', '', 'rabo 10', 'Bankafschrift: 0128', -115.50);
INSERT INTO "boekregels" VALUES(395, 70, 2008, '2008-11-21', 1050, 0, 0, '', '', '', 'Bankafschrift: 129', 2090.42);
INSERT INTO "boekregels" VALUES(396, 70, 2008, '2008-10-31', 1200, 0, 4, 'kcw', '28045', 'rabo 10', 'Factuurontvangst', -2427.60);
INSERT INTO "boekregels" VALUES(397, 71, 2008, '2008-11-01', 1600, 0, 0, 'transip', 'F2008141168', '', 'Domeinregistratie multishots.nl', -8.93);
INSERT INTO "boekregels" VALUES(398, 71, 2008, '2008-11-01', 4245, 399, 0, 'transip', 'F2008141168', '', 'Domeinregistratie multishots.nl', 7.50);
INSERT INTO "boekregels" VALUES(399, 71, 2008, '2008-11-01', 2200, 0, 0, 'transip', 'F2008141168', '', 'Domeinregistratie multishots.nl', 1.43);
INSERT INTO "boekregels" VALUES(400, 72, 2008, '2008-11-20', 1600, 0, 0, 'transip', 'F2008151040', '', 'Domeinregistratie ruudkooger.nl', -5.94);
INSERT INTO "boekregels" VALUES(401, 72, 2008, '2008-11-20', 4245, 402, 0, 'transip', 'F2008151040', '', 'Domeinregistratie ruudkooger.nl', 4.99);
INSERT INTO "boekregels" VALUES(402, 72, 2008, '2008-11-20', 2200, 0, 0, 'transip', 'F2008151040', '', 'Domeinregistratie ruudkooger.nl', 0.95);
INSERT INTO "boekregels" VALUES(403, 73, 2008, '2008-11-30', 1600, 0, 0, 'transip', 'F2008154146', '', 'Domeinregistratie liekestraver.nl', -5.94);
INSERT INTO "boekregels" VALUES(404, 73, 2008, '2008-11-30', 4600, 405, 0, 'transip', 'F2008154146', '', 'Domeinregistratie liekestraver.nl', 4.99);
INSERT INTO "boekregels" VALUES(405, 73, 2008, '2008-11-30', 2200, 0, 0, 'transip', 'F2008154146', '', 'Domeinregistratie liekestraver.nl', 0.95);
INSERT INTO "boekregels" VALUES(406, 74, 2008, '2008-12-01', 1600, 0, 0, 'transip', 'F2008155218', '', 'Domeinregistraties hid', -17.85);
INSERT INTO "boekregels" VALUES(407, 74, 2008, '2008-12-01', 4245, 408, 0, 'transip', 'F2008155218', '', 'Domeinregistraties hid', 15.00);
INSERT INTO "boekregels" VALUES(408, 74, 2008, '2008-12-01', 2200, 0, 0, 'transip', 'F2008155218', '', 'Domeinregistraties hid', 2.85);
INSERT INTO "boekregels" VALUES(409, 70, 2008, '2008-11-03', 1600, 0, 40, 'transip', 'F2008141168', 'rabo 10', 'Factuurbetaling', 8.93);
INSERT INTO "boekregels" VALUES(410, 70, 2008, '2008-11-03', 8020, 0, 0, '', '', 'rabo 10', 'Syncera materialen workshop', -303.45);
INSERT INTO "boekregels" VALUES(411, 70, 2008, '2008-11-05', 1600, 0, 25, 'kpn', '0182611557-0311', 'rabo 10', 'Factuurbetaling', 97.56);
INSERT INTO "boekregels" VALUES(412, 70, 2008, '2008-11-06', 1600, 0, 28, 'conrad', '9541946926', 'rabo 10', 'Factuurbetaling', 73.79);
INSERT INTO "boekregels" VALUES(413, 70, 2008, '2008-11-12', 1600, 0, 27, 'xs4all', '25378236', 'rabo 10', 'Factuurbetaling', 23.20);
INSERT INTO "boekregels" VALUES(414, 70, 2008, '2008-11-17', 1200, 0, 5, 'kcw', '28095', 'rabo 10', 'Factuurontvangst', -2427.60);
INSERT INTO "boekregels" VALUES(419, 70, 2008, '2008-11-21', 1060, 0, 0, '', '', 'rabo 10', 'Bankafschrift: 129', 2864.75);
INSERT INTO "boekregels" VALUES(416, 75, 2008, '2008-12-19', 1600, 0, 0, 'henx', '3248', '', 'Spuitmateriaal', -163.10);
INSERT INTO "boekregels" VALUES(417, 75, 2008, '2008-12-19', 4220, 418, 0, 'henx', '3248', '', 'Spuitmateriaal', 137.06);
INSERT INTO "boekregels" VALUES(418, 75, 2008, '2008-12-19', 2200, 0, 0, 'henx', '3248', '', 'Spuitmateriaal', 26.04);
INSERT INTO "boekregels" VALUES(420, 76, 2008, '2008-12-19', 1050, 0, 0, '', '', '', 'Bankafschrift: 130', -900.32);
INSERT INTO "boekregels" VALUES(421, 76, 2008, '2008-11-24', 1600, 0, 29, 'orange', '2418311108', 'rabo 130', 'Factuurbetaling', 20.00);
INSERT INTO "boekregels" VALUES(422, 76, 2008, '2008-11-26', 1600, 0, 24, 'tmobile', '01075800403', 'rabo 130', 'Factuurbetaling', 52.26);
INSERT INTO "boekregels" VALUES(423, 76, 2008, '2008-12-01', 1600, 0, 43, 'transip', 'F2008155218', 'rabo 130', 'Factuurbetaling', 17.85);
INSERT INTO "boekregels" VALUES(424, 76, 2008, '2008-12-01', 1600, 0, 42, 'transip', 'F2008154146', 'rabo 130', 'Factuurbetaling', 5.94);
INSERT INTO "boekregels" VALUES(425, 76, 2008, '2008-12-01', 1600, 0, 41, 'transip', 'F2008151040', 'rabo 130', 'Factuurbetaling', 5.94);
INSERT INTO "boekregels" VALUES(426, 76, 2008, '2008-12-09', 1600, 0, 32, 'xs4all', '25693810', 'rabo 130', 'Factuurbetaling', 56.78);
INSERT INTO "boekregels" VALUES(427, 76, 2008, '2008-12-17', 1600, 0, 33, 'orange', '00002171381208', 'rabo 130', 'Factuurbetaling', 20.00);
INSERT INTO "boekregels" VALUES(428, 76, 2008, '2008-12-19', 1600, 0, 44, 'henx', '3248', 'rabo 130', 'Factuurbetaling', 163.10);
INSERT INTO "boekregels" VALUES(430, 76, 2008, '2008-12-19', 1060, 0, 0, '', '', 'rabo 130', 'Bankafschrift: 130', 558.45);
INSERT INTO "boekregels" VALUES(431, 77, 2009, '2009-01-03', 1600, 0, 0, 'orange', '2004820109', '', '0651425883 - 3-1/2-2', -20.00);
INSERT INTO "boekregels" VALUES(432, 77, 2009, '2009-01-03', 4240, 433, 0, 'orange', '2004820109', '', '0651425883 - 3-1/2-2', 16.81);
INSERT INTO "boekregels" VALUES(433, 77, 2009, '2009-01-03', 2200, 0, 0, 'orange', '2004820109', '', '0651425883 - 3-1/2-2', 3.19);
INSERT INTO "boekregels" VALUES(434, 78, 2009, '2009-01-13', 4230, 435, 0, '', '', '', 'Kantoormateriaal (kwantum)', 3.01);
INSERT INTO "boekregels" VALUES(435, 78, 2009, '2009-01-13', 2200, 0, 0, '', '', '', 'Kantoormateriaal (kwantum)', 0.57);
INSERT INTO "boekregels" VALUES(436, 78, 2009, '2009-01-13', 4230, 437, 0, '', '', '', 'Kantoormateriaal (burger)', 1.13);
INSERT INTO "boekregels" VALUES(437, 78, 2009, '2009-01-13', 2200, 0, 0, '', '', '', 'Kantoormateriaal (burger)', 0.22);
INSERT INTO "boekregels" VALUES(438, 78, 2009, '2009-01-13', 4230, 439, 0, '', '', '', 'Kantoormateriaal (hema)', 14.39);
INSERT INTO "boekregels" VALUES(439, 78, 2009, '2009-01-13', 2200, 0, 0, '', '', '', 'Kantoormateriaal (hema)', 2.61);
INSERT INTO "boekregels" VALUES(440, 79, 2009, '2009-01-24', 2020, 0, 0, 'Fixet de Bas', '570', '', 'Brandstof kachel kantoor', -43.95);
INSERT INTO "boekregels" VALUES(441, 79, 2009, '2009-01-24', 4230, 442, 0, 'Fixet de Bas', '570', '', 'Brandstof kachel kantoor', 36.93);
INSERT INTO "boekregels" VALUES(442, 79, 2009, '2009-01-24', 2200, 0, 0, 'Fixet de Bas', '570', '', 'Brandstof kachel kantoor', 7.02);
INSERT INTO "boekregels" VALUES(443, 80, 2009, '2009-01-24', 2020, 0, 0, 'AH', '90617', '', 'Vaktijdschrift', -5.99);
INSERT INTO "boekregels" VALUES(444, 80, 2009, '2009-01-24', 4230, 445, 0, 'AH', '90617', '', 'Vaktijdschrift', 5.66);
INSERT INTO "boekregels" VALUES(445, 80, 2009, '2009-01-24', 2200, 0, 0, 'AH', '90617', '', 'Vaktijdschrift', 0.33);
INSERT INTO "boekregels" VALUES(446, 81, 2008, '2008-12-31', 2110, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', 775.20);
INSERT INTO "boekregels" VALUES(447, 81, 2008, '2008-12-31', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2110', -775.20);
INSERT INTO "boekregels" VALUES(448, 81, 2008, '2008-12-31', 2200, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 2300', -242.73);
INSERT INTO "boekregels" VALUES(449, 81, 2008, '2008-12-31', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2200', 242.73);
INSERT INTO "boekregels" VALUES(450, 81, 2008, '2008-12-31', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 8900', 0.20);
INSERT INTO "boekregels" VALUES(451, 81, 2008, '2008-12-31', 8900, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2300', -0.20);
INSERT INTO "boekregels" VALUES(452, 81, 2008, '2008-12-31', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 naar 8900', 0.27);
INSERT INTO "boekregels" VALUES(453, 81, 2008, '2008-12-31', 8900, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 4 van 2300', -0.27);
INSERT INTO "boekregels" VALUES(454, 82, 2009, '2009-01-07', 1600, 0, 0, 'xs4all', '26008394', '', 'ADSL Basic 6-01/6-02', -64.18);
INSERT INTO "boekregels" VALUES(455, 82, 2009, '2009-01-07', 4245, 456, 0, 'xs4all', '26008394', '', 'ADSL Basic 6-01/6-02', 53.81);
INSERT INTO "boekregels" VALUES(456, 82, 2009, '2009-01-07', 2200, 0, 0, 'xs4all', '26008394', '', 'ADSL Basic 6-01/6-02', 10.37);
INSERT INTO "boekregels" VALUES(457, 1, 2008, '2008-01-01', 1000, 0, 0, '', '', '', 'Beginbalans', 583.99);
INSERT INTO "boekregels" VALUES(458, 1, 2008, '2008-01-01', 100, 0, 0, '', '', '', 'Beginbalans', 955.80);
INSERT INTO "boekregels" VALUES(459, 1, 2008, '2008-01-01', 900, 0, 0, '', '', '', 'Beginbalans', -4584.74);
INSERT INTO "boekregels" VALUES(460, 83, 2008, '2008-12-31', 100, 0, 0, '', '', '', 'Afschrijving Dimensions PC deel 2007', -150.82);
INSERT INTO "boekregels" VALUES(461, 83, 2008, '2008-12-31', 100, 0, 0, '', '', '', 'Afschrijving Dimensions PC deel 2008', -286.71);
INSERT INTO "boekregels" VALUES(462, 83, 2008, '2008-12-31', 100, 0, 0, '', '', '', 'Afschrijving IMac', -296.21);
INSERT INTO "boekregels" VALUES(463, 83, 2008, '2008-12-31', 100, 0, 0, '', '', '', 'Afschrijving MacAir', -223.45);
INSERT INTO "boekregels" VALUES(464, 83, 2008, '2008-12-31', 4300, 0, 0, '', '', '', 'Afschrijvingen 2008', 957.19);
INSERT INTO "boekregels" VALUES(465, 43, 2008, '2008-12-31', 1000, 0, 0, '', '', '', 'Kasbetalingen 4e kwartaal 2008', -1758.19);
INSERT INTO "boekregels" VALUES(466, 84, 2008, '2008-12-31', 1000, 0, 0, '', '', '', 'Prive naar kas', 500.00);
INSERT INTO "boekregels" VALUES(467, 84, 2008, '2008-12-31', 1060, 0, 0, '', '', '', 'Prive naar kas', -500.00);
INSERT INTO "boekregels" VALUES(468, 85, 2008, '2008-12-31', 1060, 0, 0, '', '', '', 'Huisvesting huur deel kantoor en machineruimte', -3060.00);
INSERT INTO "boekregels" VALUES(469, 85, 2008, '2008-12-31', 4100, 0, 0, '', '', '', 'Huisvesting huur deel kantoor en machineruimte', 3060.00);
INSERT INTO "boekregels" VALUES(470, 86, 2009, '2009-01-01', 100, 0, 0, '', '', 'begin', 'Beginbalans', 3103.58);
INSERT INTO "boekregels" VALUES(471, 86, 2009, '2009-01-01', 900, 0, 0, '', '', 'begin', 'Beginbalans', -3344.67);
INSERT INTO "boekregels" VALUES(472, 86, 2009, '2009-01-01', 1000, 0, 0, '', '', 'begin', 'Beginbalans', 218.47);
INSERT INTO "boekregels" VALUES(473, 86, 2009, '2009-01-01', 1050, 0, 0, '', '', 'begin', 'Beginbalans', 1123.29);
INSERT INTO "boekregels" VALUES(474, 86, 2009, '2009-01-01', 1600, 0, 0, '', '', 'begin', 'Beginbalans', -568.67);
INSERT INTO "boekregels" VALUES(475, 86, 2009, '2009-01-01', 2300, 0, 0, '', '', 'begin', 'Beginbalans', -532.00);
INSERT INTO "boekregels" VALUES(476, 87, 2009, '2009-01-27', 1600, 0, 0, 'tmobile', '901080575403', '', '23-12/22-01', -52.26);
INSERT INTO "boekregels" VALUES(477, 87, 2009, '2009-01-27', 4240, 478, 0, 'tmobile', '901080575403', '', '23-12/22-01', 43.92);
INSERT INTO "boekregels" VALUES(478, 87, 2009, '2009-01-27', 2200, 0, 0, 'tmobile', '901080575403', '', '23-12/22-01', 8.34);
INSERT INTO "boekregels" VALUES(479, 88, 2009, '2009-02-04', 1600, 0, 0, 'transip', '200900014426', '', 'Domeinregistratie rampenoverleven.nl', -8.93);
INSERT INTO "boekregels" VALUES(480, 88, 2009, '2009-02-04', 4245, 481, 0, 'transip', '200900014426', '', 'Domeinregistratie rampenoverleven.nl', 7.50);
INSERT INTO "boekregels" VALUES(481, 88, 2009, '2009-02-04', 2200, 0, 0, 'transip', '200900014426', '', 'Domeinregistratie rampenoverleven.nl', 1.43);
INSERT INTO "boekregels" VALUES(482, 89, 2009, '2009-02-04', 1200, 0, 0, 'kcw', '29010', '', 'Onderhoud 1e kwartaal', 3034.50);
INSERT INTO "boekregels" VALUES(483, 89, 2009, '2009-02-04', 8010, 484, 0, 'kcw', '29010', '', 'Onderhoud 1e kwartaal', -2550.00);
INSERT INTO "boekregels" VALUES(484, 89, 2009, '2009-02-04', 2110, 0, 0, 'kcw', '29010', '', 'Onderhoud 1e kwartaal', -484.50);
INSERT INTO "boekregels" VALUES(485, 90, 2009, '2009-01-01', 1600, 0, 18, 'orange', '00002073751008', '', 'Factuurbetaling prive', 20.00);
INSERT INTO "boekregels" VALUES(486, 90, 2009, '2009-01-01', 1060, 0, 0, '', '2073751008', '', 'Factuurbetaling prive orange 3-10-08', -19.90);
INSERT INTO "boekregels" VALUES(487, 90, 2009, '2009-01-01', 8900, 0, 0, '', '2073751008', '', 'Betalingsverschil orange 3-10-08', -0.10);
INSERT INTO "boekregels" VALUES(488, 91, 2009, '2009-01-01', 1600, 0, 3, 'kpn', '0182611557-0307', '', 'Betalingsverschil', 0.03);
INSERT INTO "boekregels" VALUES(489, 91, 2009, '2009-01-01', 8900, 0, 0, '', '0307', '', 'Betalingsverschil KPN', -0.03);
INSERT INTO "boekregels" VALUES(490, 92, 2009, '2009-02-04', 1600, 0, 0, 'kvk', '929044932', '', 'Jaarlijkse bijdrage - 2009', -46.30);
INSERT INTO "boekregels" VALUES(491, 92, 2009, '2009-02-04', 4490, 0, 0, 'kvk', '929044932', '', 'Jaarlijkse bijdrage - 2009', 46.30);
INSERT INTO "boekregels" VALUES(492, 78, 2009, '2009-01-01', 4230, 493, 0, '', '', '', 'Vakliteratuur AH', 5.66);
INSERT INTO "boekregels" VALUES(493, 78, 2009, '2009-01-01', 2200, 0, 0, '', '', '', 'Vakliteratuur AH', 0.33);
INSERT INTO "boekregels" VALUES(494, 93, 2009, '2009-02-03', 1600, 0, 0, 'orange', '1867240209', '', '0651425883 - 3-2/2-3', -20.00);
INSERT INTO "boekregels" VALUES(495, 93, 2009, '2009-02-03', 4240, 496, 0, 'orange', '1867240209', '', '0651425883 - 3-2/2-3', 16.81);
INSERT INTO "boekregels" VALUES(496, 93, 2009, '2009-02-03', 2200, 0, 0, 'orange', '1867240209', '', '0651425883 - 3-2/2-3', 3.19);
INSERT INTO "boekregels" VALUES(497, 94, 2009, '2009-02-07', 1600, 0, 0, 'xs4all', '26326804', '', 'ADSL Basic 6-02/6-03', -58.51);
INSERT INTO "boekregels" VALUES(498, 94, 2009, '2009-02-07', 4245, 499, 0, 'xs4all', '26326804', '', 'ADSL Basic 6-02/6-03', 49.17);
INSERT INTO "boekregels" VALUES(499, 94, 2009, '2009-02-07', 2200, 0, 0, 'xs4all', '26326804', '', 'ADSL Basic 6-02/6-03', 9.34);
INSERT INTO "boekregels" VALUES(500, 78, 2009, '2009-02-23', 1600, 0, 50, 'orange', '1867240209', '', 'Factuurbetaling', 20.00);
INSERT INTO "boekregels" VALUES(501, 78, 2009, '2009-02-23', 1600, 0, 51, 'xs4all', '26326804', '', 'Factuurbetaling', 58.51);
INSERT INTO "boekregels" VALUES(502, 95, 2009, '2009-02-26', 1600, 0, 0, 'tmobile', '901082279965', '', '0623477347 - 23-02/22-03', -52.26);
INSERT INTO "boekregels" VALUES(503, 95, 2009, '2009-02-26', 4240, 504, 0, 'tmobile', '901082279965', '', '0623477347 - 23-02/22-03', 43.92);
INSERT INTO "boekregels" VALUES(504, 95, 2009, '2009-02-26', 2200, 0, 0, 'tmobile', '901082279965', '', '0623477347 - 23-02/22-03', 8.34);
INSERT INTO "boekregels" VALUES(505, 96, 2009, '2009-03-03', 1600, 0, 0, 'orange', '2128460309', '', '0623477347 - 03-03/02-04', -20.00);
INSERT INTO "boekregels" VALUES(506, 96, 2009, '2009-03-03', 4240, 507, 0, 'orange', '2128460309', '', '0623477347 - 03-03/02-04', 16.81);
INSERT INTO "boekregels" VALUES(507, 96, 2009, '2009-03-03', 2200, 0, 0, 'orange', '2128460309', '', '0623477347 - 03-03/02-04', 3.19);
INSERT INTO "boekregels" VALUES(508, 97, 2009, '2009-03-07', 1600, 0, 0, 'xs4all', '26643291', '', 'ADSL Basic 6-03/6-04', -63.00);
INSERT INTO "boekregels" VALUES(509, 97, 2009, '2009-03-07', 4245, 510, 0, 'xs4all', '26643291', '', 'ADSL Basic 6-03/6-04', 52.94);
INSERT INTO "boekregels" VALUES(510, 97, 2009, '2009-03-07', 2200, 0, 0, 'xs4all', '26643291', '', 'ADSL Basic 6-03/6-04', 10.06);
INSERT INTO "boekregels" VALUES(511, 78, 2009, '2009-03-16', 4230, 0, 0, '', '', '', 'Oplaad accus', 3.99);
INSERT INTO "boekregels" VALUES(512, 98, 2009, '2009-02-26', 1600, 0, 0, 'kpn', '0182611557-303', '', 'Credit wgs eindafrekening', 31.32);
INSERT INTO "boekregels" VALUES(513, 98, 2009, '2009-02-26', 4240, 514, 0, 'kpn', '0182611557-303', '', 'Credit wgs eindafrekening', -26.32);
INSERT INTO "boekregels" VALUES(514, 98, 2009, '2009-02-26', 2200, 0, 0, 'kpn', '0182611557-303', '', 'Credit wgs eindafrekening', -5.00);
INSERT INTO "boekregels" VALUES(515, 78, 2009, '2009-03-23', 4230, 516, 0, '', '', '', 'Tijdschrift AH', 5.66);
INSERT INTO "boekregels" VALUES(516, 78, 2009, '2009-03-23', 2200, 0, 0, '', '', '', 'Tijdschrift AH', 0.33);
INSERT INTO "boekregels" VALUES(517, 78, 2009, '2009-01-01', 4220, 518, 0, '', '', '', 'Tape', 6.71);
INSERT INTO "boekregels" VALUES(518, 78, 2009, '2009-01-01', 2200, 0, 0, '', '', '', 'Tape', 1.27);
INSERT INTO "boekregels" VALUES(519, 99, 2009, '2009-03-26', 1600, 0, 0, 'tmobile', '901084029752', '', '0623477347 - 23-2/22-3', -52.26);
INSERT INTO "boekregels" VALUES(520, 99, 2009, '2009-03-26', 4240, 521, 0, 'tmobile', '901084029752', '', '0623477347 - 23-2/22-3', 43.92);
INSERT INTO "boekregels" VALUES(521, 99, 2009, '2009-03-26', 2200, 0, 0, 'tmobile', '901084029752', '', '0623477347 - 23-2/22-3', 8.34);
INSERT INTO "boekregels" VALUES(522, 78, 2009, '2009-03-21', 4230, 523, 0, '', '', '', 'Boek Flash3', 34.34);
INSERT INTO "boekregels" VALUES(523, 78, 2009, '2009-03-21', 2200, 0, 0, '', '', '', 'Boek Flash3', 2.06);
INSERT INTO "boekregels" VALUES(524, 100, 2009, '2009-04-01', 1600, 0, 0, 'transip', 'F0000.2009.0003.', '', 'Domeinen literature.nu, literatuurmetvrienden.nl', -65.44);
INSERT INTO "boekregels" VALUES(525, 100, 2009, '2009-04-01', 4245, 526, 0, 'transip', 'F0000.2009.0003.', '', 'Domeinen literature.nu, literatuurmetvrienden.nl', 54.99);
INSERT INTO "boekregels" VALUES(526, 100, 2009, '2009-04-01', 2200, 0, 0, 'transip', 'F0000.2009.0003.', '', 'Domeinen literature.nu, literatuurmetvrienden.nl', 10.45);
INSERT INTO "boekregels" VALUES(527, 101, 2009, '2009-04-03', 1600, 0, 0, 'orange', '2104090409', '', '0651425883 3-4/2-5', -20.00);
INSERT INTO "boekregels" VALUES(528, 101, 2009, '2009-04-03', 4240, 529, 0, 'orange', '2104090409', '', '0651425883 3-4/2-5', 16.81);
INSERT INTO "boekregels" VALUES(529, 101, 2009, '2009-04-03', 2200, 0, 0, 'orange', '2104090409', '', '0651425883 3-4/2-5', 3.19);
INSERT INTO "boekregels" VALUES(530, 102, 2009, '2009-04-07', 1600, 0, 0, 'xs4all', '26957120', '', 'ADSL Basic 6-4/6-5', -60.15);
INSERT INTO "boekregels" VALUES(531, 102, 2009, '2009-04-07', 4245, 532, 0, 'xs4all', '26957120', '', 'ADSL Basic 6-4/6-5', 50.55);
INSERT INTO "boekregels" VALUES(532, 102, 2009, '2009-04-07', 2200, 0, 0, 'xs4all', '26957120', '', 'ADSL Basic 6-4/6-5', 9.60);
INSERT INTO "boekregels" VALUES(533, 78, 2009, '2009-03-31', 1000, 0, 0, '', '', '', 'Kasbetalingen 1e kwartaal 2009', -160.79);
INSERT INTO "boekregels" VALUES(534, 103, 2009, '2009-04-07', 4220, 535, 0, '', '', '', 'Vernis', 12.58);
INSERT INTO "boekregels" VALUES(535, 103, 2009, '2009-04-07', 2200, 0, 0, '', '', '', 'Vernis', 2.39);
INSERT INTO "boekregels" VALUES(537, 105, 2009, '2009-04-15', 1600, 0, 0, 'transip', '20900036492', '', 'raov.nl', -8.93);
INSERT INTO "boekregels" VALUES(538, 105, 2009, '2009-04-15', 4245, 539, 0, 'transip', '20900036492', '', 'raov.nl', 7.50);
INSERT INTO "boekregels" VALUES(539, 105, 2009, '2009-04-15', 2200, 0, 0, 'transip', '20900036492', '', 'raov.nl', 1.43);
INSERT INTO "boekregels" VALUES(540, 103, 2009, '2009-04-01', 4500, 541, 0, '', '', '', 'Planten en bloemen aankleding expositie', 93.02);
INSERT INTO "boekregels" VALUES(541, 103, 2009, '2009-04-01', 2200, 0, 0, '', '', '', 'Planten en bloemen aankleding expositie', 6.78);
INSERT INTO "boekregels" VALUES(542, 106, 2009, '2009-04-13', 1600, 0, 0, 'foka', '4986609', '', 'Flitsset', -185.95);
INSERT INTO "boekregels" VALUES(543, 106, 2009, '2009-04-13', 4210, 544, 0, 'foka', '4986609', '', 'Flitsset', 156.26);
INSERT INTO "boekregels" VALUES(544, 106, 2009, '2009-04-13', 2200, 0, 0, 'foka', '4986609', '', 'Flitsset', 29.69);
INSERT INTO "boekregels" VALUES(545, 107, 2009, '2009-04-20', 1600, 0, 0, 'officec', '47062', '', 'Kantoormateriaal', -52.21);
INSERT INTO "boekregels" VALUES(546, 107, 2009, '2009-04-20', 4230, 547, 0, 'officec', '47062', '', 'Kantoormateriaal', 43.87);
INSERT INTO "boekregels" VALUES(547, 107, 2009, '2009-04-20', 2200, 0, 0, 'officec', '47062', '', 'Kantoormateriaal', 8.34);
INSERT INTO "boekregels" VALUES(548, 108, 2009, '2009-04-28', 1600, 0, 0, 'tmobile', '901085828341', '', '0623477347 23-4/22-5', -52.26);
INSERT INTO "boekregels" VALUES(549, 108, 2009, '2009-04-28', 4240, 550, 0, 'tmobile', '901085828341', '', '0623477347 23-4/22-5', 43.92);
INSERT INTO "boekregels" VALUES(550, 108, 2009, '2009-04-28', 2200, 0, 0, 'tmobile', '901085828341', '', '0623477347 23-4/22-5', 8.34);
INSERT INTO "boekregels" VALUES(551, 103, 2009, '2009-04-23', 4220, 552, 0, '', '', '', 'Roller', 1.68);
INSERT INTO "boekregels" VALUES(552, 103, 2009, '2009-04-23', 2200, 0, 0, '', '', '', 'Roller', 0.32);
INSERT INTO "boekregels" VALUES(553, 109, 2009, '2009-03-31', 2110, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', 484.50);
INSERT INTO "boekregels" VALUES(554, 109, 2009, '2009-03-31', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2110', -484.50);
INSERT INTO "boekregels" VALUES(555, 109, 2009, '2009-03-31', 2200, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 2300', -79.81);
INSERT INTO "boekregels" VALUES(556, 109, 2009, '2009-03-31', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2200', 79.81);
INSERT INTO "boekregels" VALUES(557, 109, 2009, '2009-03-31', 2300, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 1 naar 8900', -0.50);
INSERT INTO "boekregels" VALUES(558, 109, 2009, '2009-03-31', 8900, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 1 van 2300', 0.50);
INSERT INTO "boekregels" VALUES(559, 109, 2009, '2009-03-31', 2300, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 1 naar 8900', 0.19);
INSERT INTO "boekregels" VALUES(560, 109, 2009, '2009-03-31', 8900, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 1 van 2300', -0.19);
INSERT INTO "boekregels" VALUES(561, 103, 2009, '2009-04-17', 4220, 562, 0, '', '', '', 'Achtergrondmateriaal', 8.82);
INSERT INTO "boekregels" VALUES(562, 103, 2009, '2009-04-17', 2200, 0, 0, '', '', '', 'Achtergrondmateriaal', 1.67);
INSERT INTO "boekregels" VALUES(563, 103, 2009, '2009-04-21', 4220, 564, 0, '', '', '', 'Handgereedschap', 1.34);
INSERT INTO "boekregels" VALUES(564, 103, 2009, '2009-04-21', 2200, 0, 0, '', '', '', 'Handgereedschap', 0.26);
INSERT INTO "boekregels" VALUES(565, 103, 2009, '2009-04-23', 4220, 566, 0, '', '', '', 'Doeken', 46.21);
INSERT INTO "boekregels" VALUES(566, 103, 2009, '2009-04-23', 2200, 0, 0, '', '', '', 'Doeken', 8.78);
INSERT INTO "boekregels" VALUES(567, 103, 2009, '2009-04-27', 4230, 568, 0, '', '', '', 'Afstandbediening computer', 10.92);
INSERT INTO "boekregels" VALUES(568, 103, 2009, '2009-04-27', 2200, 0, 0, '', '', '', 'Afstandbediening computer', 2.07);
INSERT INTO "boekregels" VALUES(569, 103, 2009, '2009-05-05', 4230, 570, 0, '', '', '', 'Vaktijdschrift', 5.65);
INSERT INTO "boekregels" VALUES(570, 103, 2009, '2009-05-05', 2200, 0, 0, '', '', '', 'Vaktijdschrift', 0.34);
INSERT INTO "boekregels" VALUES(571, 103, 2009, '2009-05-06', 4220, 572, 0, '', '', '', 'Klein materiaal', 7.52);
INSERT INTO "boekregels" VALUES(572, 103, 2009, '2009-05-06', 2200, 0, 0, '', '', '', 'Klein materiaal', 1.43);
INSERT INTO "boekregels" VALUES(573, 103, 2009, '2009-05-06', 4490, 574, 0, '', '', '', 'Lunch', 11.37);
INSERT INTO "boekregels" VALUES(574, 103, 2009, '2009-05-06', 2200, 0, 0, '', '', '', 'Lunch', 0.68);
INSERT INTO "boekregels" VALUES(575, 103, 2009, '2009-05-16', 4210, 576, 0, '', '', '', 'USB schijf', 16.80);
INSERT INTO "boekregels" VALUES(576, 103, 2009, '2009-05-16', 2200, 0, 0, '', '', '', 'USB schijf', 3.19);
INSERT INTO "boekregels" VALUES(577, 103, 2009, '2009-05-16', 4220, 578, 0, '', '', '', 'Doeken', 40.73);
INSERT INTO "boekregels" VALUES(578, 103, 2009, '2009-05-16', 2200, 0, 0, '', '', '', 'Doeken', 7.74);
INSERT INTO "boekregels" VALUES(579, 103, 2009, '2009-05-18', 4490, 580, 0, '', '', '', 'Dekzijl', 6.71);
INSERT INTO "boekregels" VALUES(580, 103, 2009, '2009-05-18', 2200, 0, 0, '', '', '', 'Dekzijl', 1.28);
INSERT INTO "boekregels" VALUES(581, 103, 2009, '2009-05-22', 4230, 582, 0, '', '', '', 'Vaktijdschrift', 5.65);
INSERT INTO "boekregels" VALUES(582, 103, 2009, '2009-05-22', 2200, 0, 0, '', '', '', 'Vaktijdschrift', 0.34);
INSERT INTO "boekregels" VALUES(583, 103, 2009, '2009-05-25', 4490, 0, 0, '', '', '', 'Lunch', 12.55);
INSERT INTO "boekregels" VALUES(585, 0, 2009, '2009-06-04', 2200, 0, 0, '', '', '', 'Doeken', 4.77);
INSERT INTO "boekregels" VALUES(586, 103, 2009, '2009-04-06', 4220, 587, 0, '', '', '', 'Doeken', 25.13);
INSERT INTO "boekregels" VALUES(587, 103, 2009, '2009-04-06', 2200, 0, 0, '', '', '', 'Doeken', 4.77);
INSERT INTO "boekregels" VALUES(588, 103, 2009, '2009-06-05', 4220, 589, 0, '', '', '', 'Materiaal', 25.33);
INSERT INTO "boekregels" VALUES(589, 103, 2009, '2009-06-05', 2200, 0, 0, '', '', '', 'Materiaal', 4.81);
INSERT INTO "boekregels" VALUES(590, 103, 2009, '2009-06-10', 4230, 591, 0, '', '', '', 'Materiaal', 12.94);
INSERT INTO "boekregels" VALUES(591, 103, 2009, '2009-06-10', 2200, 0, 0, '', '', '', 'Materiaal', 2.46);
INSERT INTO "boekregels" VALUES(592, 103, 2009, '2009-06-17', 4490, 593, 0, '', '', '', 'Ophangmateriaal kantoor', 8.93);
INSERT INTO "boekregels" VALUES(593, 103, 2009, '2009-06-17', 2200, 0, 0, '', '', '', 'Ophangmateriaal kantoor', 1.70);
INSERT INTO "boekregels" VALUES(594, 103, 2009, '2009-06-24', 4490, 595, 0, '', '', '', 'Diner', 24.91);
INSERT INTO "boekregels" VALUES(595, 103, 2009, '2009-06-24', 2200, 0, 0, '', '', '', 'Diner', 1.49);
INSERT INTO "boekregels" VALUES(596, 103, 2009, '2009-06-27', 4230, 597, 0, '', '', '', 'Vaktijdschrift', 5.65);
INSERT INTO "boekregels" VALUES(597, 103, 2009, '2009-06-27', 2200, 0, 0, '', '', '', 'Vaktijdschrift', 0.34);
INSERT INTO "boekregels" VALUES(598, 110, 2009, '2009-07-01', 4230, 599, 0, '', '', '', 'Stekkerdoos', 2.60);
INSERT INTO "boekregels" VALUES(599, 110, 2009, '2009-07-01', 2200, 0, 0, '', '', '', 'Stekkerdoos', 0.49);
INSERT INTO "boekregels" VALUES(600, 111, 2009, '2009-05-03', 1600, 0, 0, 'orange', '1368100509', '', '0651425883 3-5/2-6', -20.00);
INSERT INTO "boekregels" VALUES(601, 111, 2009, '2009-05-03', 4240, 602, 0, 'orange', '1368100509', '', '0651425883 3-5/2-6', 16.81);
INSERT INTO "boekregels" VALUES(602, 111, 2009, '2009-05-03', 2200, 0, 0, 'orange', '1368100509', '', '0651425883 3-5/2-6', 3.19);
INSERT INTO "boekregels" VALUES(603, 112, 2009, '2009-05-07', 1600, 0, 0, 'xs4all', '27271652', '', 'ADSL Basic 6-5/6-6', -60.22);
INSERT INTO "boekregels" VALUES(604, 112, 2009, '2009-05-07', 4245, 605, 0, 'xs4all', '27271652', '', 'ADSL Basic 6-5/6-6', 50.61);
INSERT INTO "boekregels" VALUES(605, 112, 2009, '2009-05-07', 2200, 0, 0, 'xs4all', '27271652', '', 'ADSL Basic 6-5/6-6', 9.61);
INSERT INTO "boekregels" VALUES(606, 113, 2009, '2009-05-07', 1600, 0, 0, 'henx', '3528', '', 'Spuitmateriaal', -112.00);
INSERT INTO "boekregels" VALUES(607, 113, 2009, '2009-05-07', 4220, 608, 0, 'henx', '3528', '', 'Spuitmateriaal', 94.12);
INSERT INTO "boekregels" VALUES(608, 113, 2009, '2009-05-07', 2200, 0, 0, 'henx', '3528', '', 'Spuitmateriaal', 17.88);
INSERT INTO "boekregels" VALUES(609, 114, 2009, '2009-05-19', 1600, 0, 0, 'dwdeal', 'F2009014731', '', 'Drukwerk folders', -112.10);
INSERT INTO "boekregels" VALUES(610, 114, 2009, '2009-05-19', 4500, 611, 0, 'dwdeal', 'F2009014731', '', 'Drukwerk folders', 94.20);
INSERT INTO "boekregels" VALUES(611, 114, 2009, '2009-05-19', 2200, 0, 0, 'dwdeal', 'F2009014731', '', 'Drukwerk folders', 17.90);
INSERT INTO "boekregels" VALUES(612, 115, 2009, '2009-05-28', 1600, 0, 0, 'tmobile', '901087680801', '', '0623477347 23-5/22-6', -55.39);
INSERT INTO "boekregels" VALUES(613, 115, 2009, '2009-05-28', 4240, 614, 0, 'tmobile', '901087680801', '', '0623477347 23-5/22-6', 46.55);
INSERT INTO "boekregels" VALUES(614, 115, 2009, '2009-05-28', 2200, 0, 0, 'tmobile', '901087680801', '', '0623477347 23-5/22-6', 8.84);
INSERT INTO "boekregels" VALUES(615, 116, 2009, '2009-06-07', 1600, 0, 0, 'xs4all', '27584261', '', 'ADSL Basic 6-6/6-7', -63.15);
INSERT INTO "boekregels" VALUES(616, 116, 2009, '2009-06-07', 4245, 617, 0, 'xs4all', '27584261', '', 'ADSL Basic 6-6/6-7', 53.07);
INSERT INTO "boekregels" VALUES(617, 116, 2009, '2009-06-07', 2200, 0, 0, 'xs4all', '27584261', '', 'ADSL Basic 6-6/6-7', 10.08);
INSERT INTO "boekregels" VALUES(618, 117, 2009, '2009-06-03', 1600, 0, 0, 'orange', '959800609', '', '0651425883 3-6/2-7', -20.00);
INSERT INTO "boekregels" VALUES(619, 117, 2009, '2009-06-03', 4240, 620, 0, 'orange', '959800609', '', '0651425883 3-6/2-7', 16.81);
INSERT INTO "boekregels" VALUES(620, 117, 2009, '2009-06-03', 2200, 0, 0, 'orange', '959800609', '', '0651425883 3-6/2-7', 3.19);
INSERT INTO "boekregels" VALUES(621, 118, 2009, '2009-06-08', 1600, 0, 0, '123inkt', '925101', '', 'Inkt printer', -38.45);
INSERT INTO "boekregels" VALUES(622, 118, 2009, '2009-06-08', 4230, 623, 0, '123inkt', '925101', '', 'Inkt printer', 32.31);
INSERT INTO "boekregels" VALUES(623, 118, 2009, '2009-06-08', 2200, 0, 0, '123inkt', '925101', '', 'Inkt printer', 6.14);
INSERT INTO "boekregels" VALUES(624, 119, 2009, '2009-06-29', 1600, 0, 0, 'tmobile', '901089575053', '', '0623477347 23-6/22-7', -58.51);
INSERT INTO "boekregels" VALUES(625, 119, 2009, '2009-06-29', 4240, 626, 0, 'tmobile', '901089575053', '', '0623477347 23-6/22-7', 49.17);
INSERT INTO "boekregels" VALUES(626, 119, 2009, '2009-06-29', 2200, 0, 0, 'tmobile', '901089575053', '', '0623477347 23-6/22-7', 9.34);
INSERT INTO "boekregels" VALUES(627, 120, 2009, '2009-06-29', 1600, 0, 0, 'conrad', '9542255322', '', 'Computermateriaal', -29.99);
INSERT INTO "boekregels" VALUES(628, 120, 2009, '2009-06-29', 4210, 629, 0, 'conrad', '9542255322', '', 'Computermateriaal', 25.20);
INSERT INTO "boekregels" VALUES(629, 120, 2009, '2009-06-29', 2200, 0, 0, 'conrad', '9542255322', '', 'Computermateriaal', 4.79);
INSERT INTO "boekregels" VALUES(630, 121, 2009, '2009-04-17', 1200, 0, 0, 'woonpmh', '29014', '', 'Muurschilderingen', 481.95);
INSERT INTO "boekregels" VALUES(631, 121, 2009, '2009-04-17', 8020, 632, 0, 'woonpmh', '29014', '', 'Muurschilderingen', -405.00);
INSERT INTO "boekregels" VALUES(632, 121, 2009, '2009-04-17', 2110, 0, 0, 'woonpmh', '29014', '', 'Muurschilderingen', -76.95);
INSERT INTO "boekregels" VALUES(633, 122, 2009, '2009-04-26', 1200, 0, 0, 'woonpmh', '29016', '', 'Workshop', 311.78);
INSERT INTO "boekregels" VALUES(634, 122, 2009, '2009-04-26', 8020, 635, 0, 'woonpmh', '29016', '', 'Workshop', -262.00);
INSERT INTO "boekregels" VALUES(635, 122, 2009, '2009-04-26', 2110, 0, 0, 'woonpmh', '29016', '', 'Workshop', -49.78);
INSERT INTO "boekregels" VALUES(636, 123, 2009, '2009-05-07', 1200, 0, 0, 'sppernis', '29018', '', 'Workshop', 285.60);
INSERT INTO "boekregels" VALUES(637, 123, 2009, '2009-05-07', 8020, 638, 0, 'sppernis', '29018', '', 'Workshop', -240.00);
INSERT INTO "boekregels" VALUES(638, 123, 2009, '2009-05-07', 2110, 0, 0, 'sppernis', '29018', '', 'Workshop', -45.60);
INSERT INTO "boekregels" VALUES(639, 124, 2009, '2009-05-11', 1200, 0, 0, 'kcw', '29019', '', 'Onderhoud 2e kwartaal', 2427.60);
INSERT INTO "boekregels" VALUES(640, 124, 2009, '2009-05-11', 8010, 641, 0, 'kcw', '29019', '', 'Onderhoud 2e kwartaal', -2040.00);
INSERT INTO "boekregels" VALUES(641, 124, 2009, '2009-05-11', 2110, 0, 0, 'kcw', '29019', '', 'Onderhoud 2e kwartaal', -387.60);
INSERT INTO "boekregels" VALUES(642, 125, 2009, '2009-06-15', 1200, 0, 0, 'kunstig', '29025', '', 'Schilderij Beatrix theater', 210.04);
INSERT INTO "boekregels" VALUES(643, 125, 2009, '2009-06-15', 8020, 644, 0, 'kunstig', '29025', '', 'Schilderij Beatrix theater', -176.50);
INSERT INTO "boekregels" VALUES(644, 125, 2009, '2009-06-15', 2110, 0, 0, 'kunstig', '29025', '', 'Schilderij Beatrix theater', -33.54);
INSERT INTO "boekregels" VALUES(645, 126, 2009, '2009-06-20', 1200, 0, 0, 'sppernis', '29026', '', 'Workshop', 348.67);
INSERT INTO "boekregels" VALUES(646, 126, 2009, '2009-06-20', 8020, 647, 0, 'sppernis', '29026', '', 'Workshop', -293.00);
INSERT INTO "boekregels" VALUES(647, 126, 2009, '2009-06-20', 2110, 0, 0, 'sppernis', '29026', '', 'Workshop', -55.67);
INSERT INTO "boekregels" VALUES(648, 127, 2009, '2009-06-30', 2110, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', 649.14);
INSERT INTO "boekregels" VALUES(649, 127, 2009, '2009-06-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2110', -649.14);
INSERT INTO "boekregels" VALUES(650, 127, 2009, '2009-06-30', 2200, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 naar 2300', -214.84);
INSERT INTO "boekregels" VALUES(651, 127, 2009, '2009-06-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 2 van 2200', 214.84);
INSERT INTO "boekregels" VALUES(652, 127, 2009, '2009-06-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 2 naar 8900', 0.14);
INSERT INTO "boekregels" VALUES(653, 127, 2009, '2009-06-30', 8900, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 2 van 2300', -0.14);
INSERT INTO "boekregels" VALUES(654, 127, 2009, '2009-06-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 2 naar 8900', 0.16);
INSERT INTO "boekregels" VALUES(655, 127, 2009, '2009-06-30', 8900, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 2 van 2300', -0.16);
INSERT INTO "boekregels" VALUES(656, 128, 2009, '2009-08-07', 1600, 0, 0, 'xs4all', '28223309', '', 'ADSL Basic 6-8/6-9', -60.50);
INSERT INTO "boekregels" VALUES(657, 128, 2009, '2009-08-07', 4245, 658, 0, 'xs4all', '28223309', '', 'ADSL Basic 6-8/6-9', 50.84);
INSERT INTO "boekregels" VALUES(658, 128, 2009, '2009-08-07', 2200, 0, 0, 'xs4all', '28223309', '', 'ADSL Basic 6-8/6-9', 9.66);
INSERT INTO "boekregels" VALUES(659, 129, 2009, '2009-08-27', 1600, 0, 0, 'tmobile', '901093352660', '', '0623477347 23-8/22-9', -70.41);
INSERT INTO "boekregels" VALUES(660, 129, 2009, '2009-08-27', 4240, 661, 0, 'tmobile', '901093352660', '', '0623477347 23-8/22-9', 59.17);
INSERT INTO "boekregels" VALUES(661, 129, 2009, '2009-08-27', 2200, 0, 0, 'tmobile', '901093352660', '', '0623477347 23-8/22-9', 11.24);
INSERT INTO "boekregels" VALUES(662, 130, 2009, '2009-08-18', 1600, 0, 0, 'marktp', '200958603', '', 'Plusvermelding', -59.00);
INSERT INTO "boekregels" VALUES(663, 130, 2009, '2009-08-18', 4500, 664, 0, 'marktp', '200958603', '', 'Plusvermelding', 49.58);
INSERT INTO "boekregels" VALUES(664, 130, 2009, '2009-08-18', 2200, 0, 0, 'marktp', '200958603', '', 'Plusvermelding', 9.42);
INSERT INTO "boekregels" VALUES(665, 131, 2009, '2009-08-14', 1600, 0, 0, 'tmobile', '901091433021', '', '0623477347 23-7/22-8', -82.31);
INSERT INTO "boekregels" VALUES(666, 131, 2009, '2009-08-14', 4240, 667, 0, 'tmobile', '901091433021', '', '0623477347 23-7/22-8', 69.17);
INSERT INTO "boekregels" VALUES(667, 131, 2009, '2009-08-14', 2200, 0, 0, 'tmobile', '901091433021', '', '0623477347 23-7/22-8', 13.14);
INSERT INTO "boekregels" VALUES(668, 132, 2009, '2009-07-07', 1600, 0, 0, 'xs4all', '27898308', '', 'ADSL Basic 6-7/6-8', -60.25);
INSERT INTO "boekregels" VALUES(669, 132, 2009, '2009-07-07', 4245, 670, 0, 'xs4all', '27898308', '', 'ADSL Basic 6-7/6-8', 50.63);
INSERT INTO "boekregels" VALUES(670, 132, 2009, '2009-07-07', 2200, 0, 0, 'xs4all', '27898308', '', 'ADSL Basic 6-7/6-8', 9.62);
INSERT INTO "boekregels" VALUES(671, 110, 2009, '2009-08-05', 4490, 672, 0, '', '', '', 'Werklunch', 10.85);
INSERT INTO "boekregels" VALUES(672, 110, 2009, '2009-08-05', 2200, 0, 0, '', '', '', 'Werklunch', 0.65);
INSERT INTO "boekregels" VALUES(673, 110, 2009, '2009-08-05', 4490, 674, 0, '', '', '', 'Parkeerkosten bespreking Den Haag', 6.30);
INSERT INTO "boekregels" VALUES(674, 110, 2009, '2009-08-05', 2200, 0, 0, '', '', '', 'Parkeerkosten bespreking Den Haag', 1.20);
INSERT INTO "boekregels" VALUES(675, 110, 2009, '2009-08-08', 4230, 676, 0, '', '', '', 'Div materiaal', 37.35);
INSERT INTO "boekregels" VALUES(676, 110, 2009, '2009-08-08', 2200, 0, 0, '', '', '', 'Div materiaal', 7.10);
INSERT INTO "boekregels" VALUES(677, 110, 2009, '2009-08-14', 4230, 678, 0, '', '', '', 'Vaktijdschrift', 5.65);
INSERT INTO "boekregels" VALUES(678, 110, 2009, '2009-08-14', 2200, 0, 0, '', '', '', 'Vaktijdschrift', 0.34);
INSERT INTO "boekregels" VALUES(679, 110, 2009, '2009-08-20', 4230, 680, 0, '', '', '', 'Vaktijdschrift', 6.56);
INSERT INTO "boekregels" VALUES(680, 110, 2009, '2009-08-20', 2200, 0, 0, '', '', '', 'Vaktijdschrift', 0.39);
INSERT INTO "boekregels" VALUES(681, 110, 2009, '2009-08-26', 4230, 682, 0, '', '', '', 'Div materiaal', 3.34);
INSERT INTO "boekregels" VALUES(682, 110, 2009, '2009-08-26', 2200, 0, 0, '', '', '', 'Div materiaal', 0.64);
INSERT INTO "boekregels" VALUES(683, 110, 2009, '2009-09-02', 4220, 684, 0, '', '', '', 'Spuitmateriaal', 12.58);
INSERT INTO "boekregels" VALUES(684, 110, 2009, '2009-09-02', 2200, 0, 0, '', '', '', 'Spuitmateriaal', 2.39);
INSERT INTO "boekregels" VALUES(685, 110, 2009, '2009-09-08', 4230, 686, 0, '', '', '', 'Nietmachine', 4.19);
INSERT INTO "boekregels" VALUES(686, 110, 2009, '2009-09-08', 2200, 0, 0, '', '', '', 'Nietmachine', 0.80);
INSERT INTO "boekregels" VALUES(687, 133, 2009, '2009-09-07', 1600, 0, 0, 'rgblaser', '1197', '', 'Green Laser projector', -107.98);
INSERT INTO "boekregels" VALUES(688, 133, 2009, '2009-09-07', 4220, 689, 0, 'rgblaser', '1197', '', 'Green Laser projector', 90.74);
INSERT INTO "boekregels" VALUES(689, 133, 2009, '2009-09-07', 2200, 0, 0, 'rgblaser', '1197', '', 'Green Laser projector', 17.24);
INSERT INTO "boekregels" VALUES(690, 134, 2009, '2009-09-07', 1600, 0, 0, 'xs4all', '28545703', '', 'ADSL Basic 6-9/6-10', -60.28);
INSERT INTO "boekregels" VALUES(691, 134, 2009, '2009-09-07', 4245, 692, 0, 'xs4all', '28545703', '', 'ADSL Basic 6-9/6-10', 50.66);
INSERT INTO "boekregels" VALUES(692, 134, 2009, '2009-09-07', 2200, 0, 0, 'xs4all', '28545703', '', 'ADSL Basic 6-9/6-10', 9.62);
INSERT INTO "boekregels" VALUES(693, 135, 2009, '2009-09-28', 1600, 0, 0, 'tmobile', '901095390990', '', '0623477347 23-9/22-10', -70.41);
INSERT INTO "boekregels" VALUES(694, 135, 2009, '2009-09-28', 4240, 695, 0, 'tmobile', '901095390990', '', '0623477347 23-9/22-10', 59.17);
INSERT INTO "boekregels" VALUES(695, 135, 2009, '2009-09-28', 2200, 0, 0, 'tmobile', '901095390990', '', '0623477347 23-9/22-10', 11.24);
INSERT INTO "boekregels" VALUES(696, 136, 2009, '2009-10-05', 1600, 0, 0, 'j&h', '47140', '', 'DMX kabels en sturing', -212.41);
INSERT INTO "boekregels" VALUES(697, 136, 2009, '2009-10-05', 4220, 698, 0, 'j&h', '47140', '', 'DMX kabels en sturing', 178.50);
INSERT INTO "boekregels" VALUES(698, 136, 2009, '2009-10-05', 2200, 0, 0, 'j&h', '47140', '', 'DMX kabels en sturing', 33.91);
INSERT INTO "boekregels" VALUES(699, 137, 2009, '2009-10-06', 1600, 0, 0, 'kramerart', '4039', '', 'Spuitmateriaal', -236.10);
INSERT INTO "boekregels" VALUES(700, 137, 2009, '2009-10-06', 4220, 701, 0, 'kramerart', '4039', '', 'Spuitmateriaal', 198.40);
INSERT INTO "boekregels" VALUES(701, 137, 2009, '2009-10-06', 2200, 0, 0, 'kramerart', '4039', '', 'Spuitmateriaal', 37.70);
INSERT INTO "boekregels" VALUES(702, 138, 2009, '2009-10-07', 1600, 0, 0, 'xs4all', '28852349', '', 'ADSL Basic 6-10/6-11', -59.99);
INSERT INTO "boekregels" VALUES(703, 138, 2009, '2009-10-07', 4245, 704, 0, 'xs4all', '28852349', '', 'ADSL Basic 6-10/6-11', 50.41);
INSERT INTO "boekregels" VALUES(704, 138, 2009, '2009-10-07', 2200, 0, 0, 'xs4all', '28852349', '', 'ADSL Basic 6-10/6-11', 9.58);
INSERT INTO "boekregels" VALUES(705, 139, 2009, '2009-10-27', 1600, 0, 0, 'tmobile', '901097465083', '', '0623477347 23-10/22-11', -35.90);
INSERT INTO "boekregels" VALUES(706, 139, 2009, '2009-10-27', 4240, 707, 0, 'tmobile', '901097465083', '', '0623477347 23-10/22-11', 30.17);
INSERT INTO "boekregels" VALUES(707, 139, 2009, '2009-10-27', 2200, 0, 0, 'tmobile', '901097465083', '', '0623477347 23-10/22-11', 5.73);
INSERT INTO "boekregels" VALUES(708, 140, 2009, '2009-08-06', 1200, 0, 0, 'kcw', '29042', '', 'Onderhoud 3e kwartaal', 2427.60);
INSERT INTO "boekregels" VALUES(709, 140, 2009, '2009-08-06', 8010, 710, 0, 'kcw', '29042', '', 'Onderhoud 3e kwartaal', -2040.00);
INSERT INTO "boekregels" VALUES(710, 140, 2009, '2009-08-06', 2110, 0, 0, 'kcw', '29042', '', 'Onderhoud 3e kwartaal', -387.60);
INSERT INTO "boekregels" VALUES(711, 141, 2009, '2009-09-05', 1200, 0, 0, 'jjmidholl', '29028', '', 'Workshop', 476.00);
INSERT INTO "boekregels" VALUES(712, 141, 2009, '2009-09-05', 8020, 713, 0, 'jjmidholl', '29028', '', 'Workshop', -400.00);
INSERT INTO "boekregels" VALUES(713, 141, 2009, '2009-09-05', 2110, 0, 0, 'jjmidholl', '29028', '', 'Workshop', -76.00);
INSERT INTO "boekregels" VALUES(714, 142, 2009, '2009-09-30', 2110, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', 463.60);
INSERT INTO "boekregels" VALUES(715, 142, 2009, '2009-09-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2110', -463.60);
INSERT INTO "boekregels" VALUES(716, 142, 2009, '2009-09-30', 2200, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 naar 2300', -105.18);
INSERT INTO "boekregels" VALUES(717, 142, 2009, '2009-09-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 3 van 2200', 105.18);
INSERT INTO "boekregels" VALUES(718, 142, 2009, '2009-09-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 3 naar 8900', -0.40);
INSERT INTO "boekregels" VALUES(719, 142, 2009, '2009-09-30', 8900, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 3 van 2300', 0.40);
INSERT INTO "boekregels" VALUES(720, 142, 2009, '2009-09-30', 2300, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 3 naar 8900', -0.18);
INSERT INTO "boekregels" VALUES(721, 142, 2009, '2009-09-30', 8900, 0, 0, '', '', 'egalisatie', 'BTW Afronding periode 3 van 2300', 0.18);
INSERT INTO "boekregels" VALUES(722, 143, 2009, '2009-10-15', 4230, 723, 0, '', '', '', 'Tijdschrift', 5.65);
INSERT INTO "boekregels" VALUES(723, 143, 2009, '2009-10-15', 2200, 0, 0, '', '', '', 'Tijdschrift', 0.34);
INSERT INTO "boekregels" VALUES(724, 143, 2009, '2009-10-15', 4220, 725, 0, '', '390632', '', 'Acrylic', 19.33);
INSERT INTO "boekregels" VALUES(725, 143, 2009, '2009-10-15', 2200, 0, 0, '', '390632', '', 'Acrylic', 3.67);
INSERT INTO "boekregels" VALUES(726, 143, 2009, '2009-10-01', 4230, 727, 0, '', '', '', 'Accus + lader', 11.74);
INSERT INTO "boekregels" VALUES(727, 143, 2009, '2009-10-01', 2200, 0, 0, '', '', '', 'Accus + lader', 2.23);
INSERT INTO "boekregels" VALUES(728, 143, 2009, '2009-10-02', 4230, 729, 0, '', '', '', 'Batterijen en materiaal', 13.83);
INSERT INTO "boekregels" VALUES(729, 143, 2009, '2009-10-02', 2200, 0, 0, '', '', '', 'Batterijen en materiaal', 2.63);
INSERT INTO "boekregels" VALUES(730, 143, 2009, '2009-10-03', 4230, 731, 0, '', '', '', 'Tijdschrift', 5.65);
INSERT INTO "boekregels" VALUES(731, 143, 2009, '2009-10-03', 2200, 0, 0, '', '', '', 'Tijdschrift', 0.34);
INSERT INTO "boekregels" VALUES(732, 143, 2009, '2009-10-03', 4220, 733, 0, '', '', '', 'Materiaal', 21.78);
INSERT INTO "boekregels" VALUES(733, 143, 2009, '2009-10-03', 2200, 0, 0, '', '', '', 'Materiaal', 4.14);
INSERT INTO "boekregels" VALUES(734, 110, 2009, '2009-07-01', 1000, 0, 0, '', '', '', 'Kasbetalingen 3e kwartaal 2009', -103.42);
INSERT INTO "boekregels" VALUES(735, 103, 2009, '2009-04-01', 1000, 0, 0, '', '', '', 'Kasbetalingen 2e kwartaal 2009', -437.28);

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "boekregelsTrash"
--

DROP TABLE IF EXISTS "boekregelsTrash";
CREATE TABLE IF NOT EXISTS "boekregelsTrash" (
  "id" int(11)  default '0',
  "journaalid" int(11)  default '0',
  "boekjaar" int(11)  default '0',
  "datum" date  default '0000-00-00',
  "grootboekrekening" int(11)  default '0',
  "btwrelatie" int(11)  default '0' ,
  "factuurrelatie" int(11)  default '0',
  "relatie" varchar(32)  default '' ,
  "nummer" varchar(16)  default '' ,
  "oorsprong" varchar(16)  default '' ,
  "bomschrijving" varchar(128)  default '',
  "bedrag" decimal(12,2)  default '0.00'
);

  CREATE INDEX IF NOT EXISTS "journaalid" ON "boekregelsTrash" ("journaalid");
  CREATE INDEX IF NOT EXISTS "grootboekrekening" ON "boekregelsTrash" ("grootboekrekening");
  CREATE INDEX IF NOT EXISTS "id" ON "boekregelsTrash" ("id");
--
-- Gegevens worden uitgevoerd voor tabel "boekregelsTrash"
--

INSERT INTO "boekregelsTrash" VALUES(6, 3, 0, '2008-01-18', 1050, 0, 0, '', '', '', 'Rabobank 1e kwartaal 1', -1316.88);
INSERT INTO "boekregelsTrash" VALUES(8, 3, 0, '2008-01-15', 2200, 0, 0, '', '4051', 'rabo 1', 'XS4all internet', 3.71);
INSERT INTO "boekregelsTrash" VALUES(7, 3, 0, '2008-01-15', 4245, 0, 0, '', '4051', 'rabo 1', 'XS4all internet', 19.52);
INSERT INTO "boekregelsTrash" VALUES(10, 3, 0, '2008-01-23', 2200, 0, 0, '', '0068', 'rabo 1', 'telefoonkosten mobiel', 3.19);
INSERT INTO "boekregelsTrash" VALUES(9, 3, 0, '2008-01-23', 4240, 0, 0, '', '0068', 'rabo 1', 'telefoonkosten mobiel', 16.81);
INSERT INTO "boekregelsTrash" VALUES(12, 3, 0, '2008-02-04', 2200, 0, 0, '', '', 'rabo 1', 'Kamer van Koophandel contributie', 2.70);
INSERT INTO "boekregelsTrash" VALUES(11, 3, 0, '2008-02-04', 4490, 0, 0, '', '', 'rabo 1', 'Kamer van Koophandel contributie', 43.44);
INSERT INTO "boekregelsTrash" VALUES(14, 3, 0, '2008-02-13', 2200, 0, 0, '', '1312', '', 'xs4all internet', 3.70);
INSERT INTO "boekregelsTrash" VALUES(13, 3, 0, '2008-02-13', 4245, 0, 0, '', '1312', '', 'xs4all internet', 19.50);
INSERT INTO "boekregelsTrash" VALUES(16, 3, 0, '2008-02-19', 2200, 0, 0, '', '0069', '', 'Hi abbonement F. Kooger', 5.05);
INSERT INTO "boekregelsTrash" VALUES(15, 3, 0, '2008-02-19', 4240, 0, 0, '', '0069', '', 'Hi abbonement F. Kooger', 26.58);
INSERT INTO "boekregelsTrash" VALUES(18, 3, 0, '2008-03-19', 2200, 0, 0, '', '0070', '', 'Hi abbonement F. Kooger', 4.42);
INSERT INTO "boekregelsTrash" VALUES(17, 3, 0, '2008-03-19', 4240, 0, 0, '', '0070', '', 'Hi abbonement F. Kooger', 23.24);
INSERT INTO "boekregelsTrash" VALUES(19, 3, 0, '2008-03-31', 1060, 0, 0, '', '', '', 'prive betalingen', 2205.62);
INSERT INTO "boekregelsTrash" VALUES(20, 3, 0, '2008-03-31', 2110, 0, 0, '', '', '', 'Betaalde OB 4e kw. 2007', 1969.00);
INSERT INTO "boekregelsTrash" VALUES(23, 3, 0, '2008-01-18', 1050, 0, 0, '', '', '', 'Bankafschrift 119', 0.00);
INSERT INTO "boekregelsTrash" VALUES(34, 4, 0, '2008-02-04', 2200, 0, 0, '', '2000', 'rabo 2', 'kamer van Koophandel contributie', 2.71);
INSERT INTO "boekregelsTrash" VALUES(99, 2, 0, '2008-01-05', 1000, 0, 0, '', '', '', 'Kasbetalingen 1e kwartaal', 0.00);
INSERT INTO "boekregelsTrash" VALUES(108, 13, 0, '2008-06-26', 4245, 0, 0, 'kpn', '0182611557-0307', '', 'BelBasis + ADSL 1-7/31-8', 46.98);
INSERT INTO "boekregelsTrash" VALUES(65, 7, 0, '2008-06-16', 2200, 0, 0, '', '', '', 'Aankoop Mac-air', 262.95);
INSERT INTO "boekregelsTrash" VALUES(64, 7, 0, '2008-06-16', 100, 0, 0, '', '9044127937', '', 'Aankoop Mac-air', 1383.97);
INSERT INTO "boekregelsTrash" VALUES(222, 35, 0, '2008-07-07', 1600, 0, 3, 'kpn', '0182611557-0307', 'rabo 7', 'Factuurbetaling', 100.44);
INSERT INTO "boekregelsTrash" VALUES(224, 35, 0, '2008-07-07', 2300, 0, 3, 'kpn', '', 'rabo 7', 'OB 2e kwartaal', 573.00);
INSERT INTO "boekregelsTrash" VALUES(247, 36, 0, '2008-08-15', 1600, 0, 20, 'transip', 'F2008102940', 'rabo 8', 'Factuurbetaling', 26.13);
INSERT INTO "boekregelsTrash" VALUES(250, 41, 0, '2008-09-26', 1600, 0, 10, 'orange', '00005256140808', 'rabo 9', 'Factuurbetaling', 20.00);
INSERT INTO "boekregelsTrash" VALUES(252, 41, 0, '2008-08-20', 1600, 0, 9, 'hi', '5951011.75', 'rabo 9', 'Factuurbetaling', 6.45);
INSERT INTO "boekregelsTrash" VALUES(268, 43, 0, '2008-10-28', 1600, 0, 17, 'xs4all', '25062372', '', 'Factuurbetaling', -23.20);
INSERT INTO "boekregelsTrash" VALUES(273, 43, 0, '2008-12-31', 1600, 0, 17, 'xs4all', '25062372', '', 'Factuurbetaling', 23.20);
INSERT INTO "boekregelsTrash" VALUES(297, 47, 0, '2008-10-28', 1200, 0, 0, 'kcw', '28095', '', 'Onderhoud 4e kwartaal', -2427.60);
INSERT INTO "boekregelsTrash" VALUES(362, 61, 2008, '2008-03-31', 2200, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar', -63.76);
INSERT INTO "boekregelsTrash" VALUES(363, 61, 2008, '2008-03-31', 0, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van 2200', 63.76);
INSERT INTO "boekregelsTrash" VALUES(364, 61, 2008, '2008-03-31', 0, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 naar 8900', 0.24);
INSERT INTO "boekregelsTrash" VALUES(365, 61, 2008, '2008-03-31', 8900, 0, 0, '', '', 'egalisatie', 'BTW EGALISATIE periode 1 van', -0.24);
INSERT INTO "boekregelsTrash" VALUES(415, 70, 2008, '2008-11-21', 1060, 0, 0, '', '', 'rabo 10', 'Factuurontvangst', 2864.75);
INSERT INTO "boekregelsTrash" VALUES(429, 76, 2008, '2008-12-19', 1060, 0, 0, '', '', 'rabo 130', 'Bankafschrift: 130', 558.45);
INSERT INTO "boekregelsTrash" VALUES(536, 104, 2009, '2009-04-15', 1600, 0, 0, 'transip', '20900036492', '', 'raov.nl', -7.50);
INSERT INTO "boekregelsTrash" VALUES(584, 103, 2009, '2009-06-04', 4220, 585, 0, '', '', '', 'Doeken', 25.13);

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "btwaangiftelabels"
--

DROP TABLE IF EXISTS "btwaangiftelabels";
CREATE TABLE IF NOT EXISTS "btwaangiftelabels" (
  "key" varchar(24)  default '',
  "label" varchar(64)  default ''
);

--
-- Gegevens worden uitgevoerd voor tabel "btwaangiftelabels"
--

INSERT INTO "btwaangiftelabels" VALUES('rkg_btwinkopen', '5b. Voorbelasting');
INSERT INTO "btwaangiftelabels" VALUES('rkg_btwverkoophoog', '1a. Leveringen/diensten belast met hoog tarief');
INSERT INTO "btwaangiftelabels" VALUES('rkg_btwverkooplaag', '1b. Leveringen/diensten belast met laag tarief');
INSERT INTO "btwaangiftelabels" VALUES('verkopen_verlegd', '1e. Leveringen/diensten verlegde BTW');
INSERT INTO "btwaangiftelabels" VALUES('subtotaal5a', '5a. Verschuldigde omzetbelasting');
INSERT INTO "btwaangiftelabels" VALUES('totaal5e', '5e. Totaal');
INSERT INTO "btwaangiftelabels" VALUES('subtotaal5c', '5c. Subtotaal: 5a min 5b');
INSERT INTO "btwaangiftelabels" VALUES('vermindering5d', '5d. Vermindering volgens kleinondernemersregeling');

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "btwaangiftes"
--

DROP TABLE IF EXISTS "btwaangiftes";
CREATE TABLE IF NOT EXISTS "btwaangiftes" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" int(11)  default '0',
  "datum" date  default '0000-00-00',
  "boekjaar" int(11)  default '0',
  "periode" int(11)  default '0',
  "labelkey" varchar(32)  default '',
  "omzet" decimal(12,2)  default '0.00',
  "btw" decimal(12,2)  default '0.00'
);

--
-- Gegevens worden uitgevoerd voor tabel "btwaangiftes"
--

INSERT INTO "btwaangiftes" VALUES(13, 62, '2008-03-31', 2008, 1, 'rkg_btwinkopen', 0.00, 67.00);
insert into "btwaangiftes" values(12, 62, '2008-03-31', 2008, 1, 'subtotaal5a', 0.00, 0.00);
insert into "btwaangiftes" values(11, 62, '2008-03-31', 2008, 1, 'verkopen_verlegd', 0.00, 0.00);
insert into "btwaangiftes" values(10, 62, '2008-03-31', 2008, 1, 'rkg_btwverkooplaag', 0.00, 0.00);
insert into "btwaangiftes" values(9, 62, '2008-03-31', 2008, 1, 'rkg_btwverkoophoog', 0.00, 0.00);
insert into "btwaangiftes" values(14, 62, '2008-03-31', 2008, 1, 'subtotaal5c', 0.00, -67.00);
insert into "btwaangiftes" values(15, 62, '2008-03-31', 2008, 1, 'vermindering5d', 0.00, 0.00);
insert into "btwaangiftes" values(16, 62, '2008-03-31', 2008, 1, 'totaal5e', 0.00, -67.00);
insert into "btwaangiftes" values(17, 63, '2008-06-30', 2008, 2, 'rkg_btwverkoophoog', 5500.00, 1045.00);
insert into "btwaangiftes" values(18, 63, '2008-06-30', 2008, 2, 'rkg_btwverkooplaag', 0.00, 0.00);
insert into "btwaangiftes" values(19, 63, '2008-06-30', 2008, 2, 'verkopen_verlegd', 0.00, 0.00);
insert into "btwaangiftes" values(20, 63, '2008-06-30', 2008, 2, 'subtotaal5a', 0.00, 1045.00);
insert into "btwaangiftes" values(21, 63, '2008-06-30', 2008, 2, 'rkg_btwinkopen', 0.00, 472.00);
insert into "btwaangiftes" values(22, 63, '2008-06-30', 2008, 2, 'subtotaal5c', 0.00, 573.00);
insert into "btwaangiftes" values(23, 63, '2008-06-30', 2008, 2, 'vermindering5d', 0.00, 0.00);
insert into "btwaangiftes" values(24, 63, '2008-06-30', 2008, 2, 'totaal5e', 0.00, 573.00);
insert into "btwaangiftes" values(25, 64, '2008-09-30', 2008, 3, 'rkg_btwverkoophoog', 7716.00, 1466.00);
insert into "btwaangiftes" values(26, 64, '2008-09-30', 2008, 3, 'rkg_btwverkooplaag', 0.00, 0.00);
insert into "btwaangiftes" values(27, 64, '2008-09-30', 2008, 3, 'verkopen_verlegd', 0.00, 0.00);
insert into "btwaangiftes" values(28, 64, '2008-09-30', 2008, 3, 'subtotaal5a', 0.00, 1466.00);
insert into "btwaangiftes" values(29, 64, '2008-09-30', 2008, 3, 'rkg_btwinkopen', 0.00, 688.00);
insert into "btwaangiftes" values(30, 64, '2008-09-30', 2008, 3, 'subtotaal5c', 0.00, 778.00);
insert into "btwaangiftes" values(31, 64, '2008-09-30', 2008, 3, 'vermindering5d', 0.00, 0.00);
insert into "btwaangiftes" values(32, 64, '2008-09-30', 2008, 3, 'totaal5e', 0.00, 778.00);
insert into "btwaangiftes" values(33, 81, '2008-12-31', 2008, 4, 'rkg_btwverkoophoog', 4079.00, 775.00);
insert into "btwaangiftes" values(34, 81, '2008-12-31', 2008, 4, 'rkg_btwverkooplaag', 0.00, 0.00);
insert into "btwaangiftes" values(35, 81, '2008-12-31', 2008, 4, 'verkopen_verlegd', 0.00, 0.00);
insert into "btwaangiftes" values(36, 81, '2008-12-31', 2008, 4, 'subtotaal5a', 0.00, 775.00);
insert into "btwaangiftes" values(37, 81, '2008-12-31', 2008, 4, 'rkg_btwinkopen', 0.00, 243.00);
insert into "btwaangiftes" values(38, 81, '2008-12-31', 2008, 4, 'subtotaal5c', 0.00, 532.00);
insert into "btwaangiftes" values(39, 81, '2008-12-31', 2008, 4, 'vermindering5d', 0.00, 0.00);
insert into "btwaangiftes" values(40, 81, '2008-12-31', 2008, 4, 'totaal5e', 0.00, 532.00);
insert into "btwaangiftes" values(41, 109, '2009-03-31', 2009, 1, 'rkg_btwverkoophoog', 2553.00, 485.00);
insert into "btwaangiftes" values(42, 109, '2009-03-31', 2009, 1, 'rkg_btwverkooplaag', 0.00, 0.00);
insert into "btwaangiftes" values(43, 109, '2009-03-31', 2009, 1, 'verkopen_verlegd', 0.00, 0.00);
insert into "btwaangiftes" values(44, 109, '2009-03-31', 2009, 1, 'subtotaal5a', 0.00, 485.00);
insert into "btwaangiftes" values(45, 109, '2009-03-31', 2009, 1, 'rkg_btwinkopen', 0.00, 80.00);
insert into "btwaangiftes" values(46, 109, '2009-03-31', 2009, 1, 'subtotaal5c', 0.00, 405.00);
insert into "btwaangiftes" values(47, 109, '2009-03-31', 2009, 1, 'vermindering5d', 0.00, 0.00);
insert into "btwaangiftes" values(48, 109, '2009-03-31', 2009, 1, 'totaal5e', 0.00, 405.00);
insert into "btwaangiftes" values(49, 127, '2009-06-30', 2009, 2, 'rkg_btwverkoophoog', 3416.00, 649.00);
insert into "btwaangiftes" values(50, 127, '2009-06-30', 2009, 2, 'rkg_btwverkooplaag', 0.00, 0.00);
insert into "btwaangiftes" values(51, 127, '2009-06-30', 2009, 2, 'verkopen_verlegd', 0.00, 0.00);
insert into "btwaangiftes" values(52, 127, '2009-06-30', 2009, 2, 'subtotaal5a', 0.00, 649.00);
insert into "btwaangiftes" values(53, 127, '2009-06-30', 2009, 2, 'rkg_btwinkopen', 0.00, 215.00);
insert into "btwaangiftes" values(54, 127, '2009-06-30', 2009, 2, 'subtotaal5c', 0.00, 434.00);
insert into "btwaangiftes" values(55, 127, '2009-06-30', 2009, 2, 'vermindering5d', 0.00, 0.00);
insert into "btwaangiftes" values(56, 127, '2009-06-30', 2009, 2, 'totaal5e', 0.00, 434.00);
insert into "btwaangiftes" values(57, 142, '2009-09-30', 2009, 3, 'rkg_btwverkoophoog', 2442.00, 464.00);
insert into "btwaangiftes" values(58, 142, '2009-09-30', 2009, 3, 'rkg_btwverkooplaag', 0.00, 0.00);
insert into "btwaangiftes" values(59, 142, '2009-09-30', 2009, 3, 'verkopen_verlegd', 0.00, 0.00);
insert into "btwaangiftes" values(60, 142, '2009-09-30', 2009, 3, 'subtotaal5a', 0.00, 464.00);
insert into "btwaangiftes" values(61, 142, '2009-09-30', 2009, 3, 'rkg_btwinkopen', 0.00, 105.00);
insert into "btwaangiftes" values(62, 142, '2009-09-30', 2009, 3, 'subtotaal5c', 0.00, 359.00);
insert into "btwaangiftes" values(63, 142, '2009-09-30', 2009, 3, 'vermindering5d', 0.00, 0.00);
insert into "btwaangiftes" values(64, 142, '2009-09-30', 2009, 3, 'totaal5e', 0.00, 359.00);

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "crediteurenstam"
--

DROP TABLE IF EXISTS "crediteurenstam";
CREATE TABLE IF NOT EXISTS "crediteurenstam" (
  "id" INTEGER PRIMARY KEY,
  "datum" date  default '0000-00-00',
  "code" varchar(16)  default '',
  "naam" varchar(128)  default '',
  "contact" varchar(128)  default '',
  "telefoon" varchar(15)  default '',
  "fax" varchar(15)  default '',
  "email" varchar(64)  default '',
  "adres" varchar(255)  default '',
  "crediteurnummer" varchar(32)  default '',
  "omzet" decimal(12,2)  default '0.00'
);

--
-- Gegevens worden uitgevoerd voor tabel "crediteurenstam"
--

INSERT INTO "crediteurenstam" VALUES(1, '0000-00-00', 'hi', 'Hi', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(2, '0000-00-00', 'orange', 'Orange', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(3, '0000-00-00', 'xs4all', 'XS4All', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(4, '0000-00-00', 'kvk', 'Kamer van Koophandel', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(5, '0000-00-00', 'kpn', 'KPN', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(6, '0000-00-00', 'tmobile', 'T-Mobile', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(7, '0000-00-00', 'apple', 'Apple Sales International', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(8, '0000-00-00', 'transip', 'Transip BV', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(9, '0000-00-00', 'vanbeek', 'van Beek', '', '', '', '', 'Hoogstraat 58-64\r\n3011 PT Rotterdam', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(10, '0000-00-00', 'conrad', 'Conrad Electronics', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(11, '0000-00-00', 'diverse', 'Diverse', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(12, '0000-00-00', '123inkt', '123inkt.nl', '', '0294 255590', '', 'info@digitalrevolution.nl', 'Nieuw Walden 70\r\n1394 PC  Nederhorst den Berg', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(13, '0000-00-00', 'vonk', 'Stichting Vonk', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(14, '0000-00-00', 'henx', 'Henx', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(15, '2009-04-20', 'officec', 'Office Centre', '', '0182 538292', '0182 535017', '', 'Kampenringweg 30\r\n2803 PE  Gouda', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(16, '2009-04-20', 'foka', 'Foka', '', '010 4035300', '010 4148781', 'info@foka.nl', 'Admiraliteitsstraat 8\r\n3063 EK  Rotterdam', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(17, '2009-07-27', 'dwdeal', 'Drukwerkdeal', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(18, '2009-08-31', 'marktp', 'Marktplaats', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(19, '2009-10-15', 'rgblaser', 'RGB Lasersystems', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(20, '2009-10-15', 'kramerart', 'Kramer ArtSupply', '', '', '', '', '', '',  0.00);
INSERT INTO "crediteurenstam" VALUES(21, '2009-10-15', 'j&h', 'J&H Licht en Geluid', '', '', '', '', '', '',  0.00);

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "dagboeken"
--

DROP TABLE IF EXISTS "dagboeken";
CREATE TABLE IF NOT EXISTS "dagboeken" (
  "id" INTEGER PRIMARY KEY,
  "type" varchar(8)  default '',
  "code" varchar(16)  default '',
  "naam" varchar(64)  default '',
  "grootboekrekening" int(11)  default '0',
  "boeknummer" int(11)  default '0' ,
  "saldo" decimal(12,2)  default '0.00' ,
  "slot" int(11)  default '0' 
);

--
-- Gegevens worden uitgevoerd voor tabel "dagboeken"
--

INSERT INTO "dagboeken" VALUES(1, 'begin', 'begin', 'Beginbalans', 0, 0, 0.00, 0);
INSERT INTO "dagboeken" VALUES(2, 'memo', 'memo', 'Memoriaal', 0, 0, 0.00, 0);
INSERT INTO "dagboeken" VALUES(3, 'kas', 'kas', 'Kasboek', 1000, 0, 0.00, 0);
INSERT INTO "dagboeken" VALUES(4, 'bank', 'rabo', 'Rabobank', 1050, 130, 1112.17, 0);
INSERT INTO "dagboeken" VALUES(5, 'inkoop', 'inkoop', 'Inkoopboek', 1600, 0, 0.00, 0);
INSERT INTO "dagboeken" VALUES(6, 'verkoop', 'verkoop', 'Verkoopboek', 1200, 0, 0.00, 0);
INSERT INTO "dagboeken" VALUES(7, 'pin', 'pin', 'Pinbetalingen', 2020, 0, 0.00, 0);

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "dagboeken2008"
--

DROP TABLE IF EXISTS "dagboeken2008";
CREATE TABLE IF NOT EXISTS "dagboeken2008" (
  "id" INTEGER PRIMARY KEY,
  "type" varchar(8)  default '',
  "code" varchar(16)  default '',
  "naam" varchar(64)  default '',
  "grootboekrekening" int(11)  default '0',
  "boeknummer" int(11)  default '0' ,
  "saldo" decimal(12,2)  default '0.00' ,
  "slot" int(11)  default '0' 
);

--
-- Gegevens worden uitgevoerd voor tabel "dagboeken2008"
--

INSERT INTO "dagboeken2008" VALUES(1, 'begin', 'begin', 'Beginbalans', 0, 0, 0.00, 0);
INSERT INTO "dagboeken2008" VALUES(2, 'memo', 'memo', 'Memoriaal', 0, 0, 0.00, 0);
INSERT INTO "dagboeken2008" VALUES(3, 'kas', 'kas', 'Kasboek', 1000, 0, 0.00, 0);
INSERT INTO "dagboeken2008" VALUES(4, 'bank', 'rabo', 'Rabobank', 1050, 130, 1112.17, 0);
INSERT INTO "dagboeken2008" VALUES(5, 'inkoop', 'inkoop', 'Inkoopboek', 1600, 0, 0.00, 0);
INSERT INTO "dagboeken2008" VALUES(6, 'verkoop', 'verkoop', 'Verkoopboek', 1200, 0, 0.00, 0);
INSERT INTO "dagboeken2008" VALUES(7, 'pin', 'pin', 'Pinbetalingen', 2020, 0, 0.00, 0);

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "dagboekhistorie"
--

DROP TABLE IF EXISTS "dagboekhistorie";
CREATE TABLE IF NOT EXISTS "dagboekhistorie" (
  "code" varchar(12)  default '',
  "journaalid" int(11)  default '0',
  "boekjaar" int(11)  default '0',
  "vorigeboeknummer" int(11)  default '0',
  "saldo" decimal(12,2)  default '0.00',
  "huidigeboeknummer" int(11)  default '0',
  "nieuwsaldo" decimal(12,2)  default '0.00'
);

--
-- Gegevens worden uitgevoerd voor tabel "dagboekhistorie"
--

INSERT INTO "dagboekhistorie" VALUES('rabo', 3, 0, 118, 5099.95, 119, 3783.07);
INSERT INTO "dagboekhistorie" VALUES('rabo', 4, 0, 119, 3783.07, 120, 1163.58);
INSERT INTO "dagboekhistorie" VALUES('rabo', 5, 0, 120, 1163.58, 121, -2.72);
INSERT INTO "dagboekhistorie" VALUES('rabo', 8, 0, 121, -2.72, 122, 43.62);
INSERT INTO "dagboekhistorie" VALUES('rabo', 9, 0, 122, 43.62, 123, 643.00);
INSERT INTO "dagboekhistorie" VALUES('rabo', 10, 0, 123, 643.00, 124, 2764.20);
INSERT INTO "dagboekhistorie" VALUES('rabo', 35, 0, 124, 2764.20, 125, 2748.53);
INSERT INTO "dagboekhistorie" VALUES('rabo', 36, 0, 125, 2748.53, 126, 1455.84);
INSERT INTO "dagboekhistorie" VALUES('rabo', 41, 0, 126, 1455.84, 127, -77.93);
INSERT INTO "dagboekhistorie" VALUES('rabo', 69, 0, 127, -77.93, 128, -66.81);
INSERT INTO "dagboekhistorie" VALUES('rabo', 70, 0, 128, -66.81, 129, 2012.49);
INSERT INTO "dagboekhistorie" VALUES('rabo', 76, 0, 129, 2012.49, 130, 1112.17);

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "debiteurenstam"
--

DROP TABLE IF EXISTS "debiteurenstam";
CREATE TABLE IF NOT EXISTS "debiteurenstam" (
  "id" INTEGER PRIMARY KEY,
  "datum" date  default '0000-00-00',
  "code" varchar(16)  default '',
  "naam" varchar(128)  default '',
  "contact" varchar(128)  default '',
  "telefoon" varchar(15)  default '',
  "fax" varchar(15)  default '',
  "email" varchar(64)  default '',
  "adres" varchar(255) ,
  "type" int(11)  default '0',
  "omzet" decimal(12,2)  default '0.00'
);

--
-- Gegevens worden uitgevoerd voor tabel "debiteurenstam"
--

INSERT INTO "debiteurenstam" VALUES(1, '0000-00-00', 'kcw', 'Ministerie Justitie-KCW', '', '', '', '', '',  0, 0.00);
INSERT INTO "debiteurenstam" VALUES(2, '0000-00-00', 'ez', 'Ministerie EZ', '', '', '', '', '',  0, 0.00);
INSERT INTO "debiteurenstam" VALUES(3, '0000-00-00', 'vonk', 'Stichting Vonk', '', '', '', '', '',  0, 0.00);
INSERT INTO "debiteurenstam" VALUES(4, '0000-00-00', 'syncera', 'MWH-Syncera', '', '', '', '', '',  0, 0.00);
INSERT INTO "debiteurenstam" VALUES(5, '0000-00-00', 'sigma', 'Sigma', '', '', '', '', '',  0, 0.00);
INSERT INTO "debiteurenstam" VALUES(6, '0000-00-00', 'jjmidholl', 'Jeugd en Jongeren Midden-Holland', '', '', '', '', '',  0, 0.00);
INSERT INTO "debiteurenstam" VALUES(7, '2009-07-27', 'sppernis', 'Sportstimulering Pernis', '', '', '', '', 'Rotterdam',  0, 0.00);
INSERT INTO "debiteurenstam" VALUES(8, '2009-07-27', 'kunstig', 'Kunstig', '', '', '', '', '',  0, 0.00);
INSERT INTO "debiteurenstam" VALUES(9, '2009-07-27', 'woonpmh', 'Woonpartners Midden Holland', '', '', '', '', '',  0, 0.00);

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "eindbalansen"
--

DROP TABLE IF EXISTS "eindbalansen";
CREATE TABLE IF NOT EXISTS "eindbalansen" (
  "id" INTEGER PRIMARY KEY,
  "boekdatum" date  default '0000-00-00',
  "boekjaar" int(11)  default '0',
  "saldowinst" decimal(12,2)  default '0.00',
  "saldoverlies" decimal(12,2)  default '0.00',
  "saldobalans" decimal(12,2)  default '0.00'
);

--
-- Gegevens worden uitgevoerd voor tabel "eindbalansen"
--

INSERT INTO "eindbalansen" VALUES(1, '2009-01-28', 2008, 8039.40, 0.00, -8039.40);

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "eindbalansregels"
--

DROP TABLE IF EXISTS "eindbalansregels";
CREATE TABLE IF NOT EXISTS "eindbalansregels" (
  "id" INTEGER PRIMARY KEY,
  "ideindbalans" int(11)  default '0',
  "grootboekrekening" int(11)  default '0',
  "grootboeknaam" varchar(64)  default '',
  "debet" decimal(12,2)  default '0.00',
  "credit" decimal(12,2)  default '0.00',
  "saldo" decimal(12,2)  default '0.00'
);

  CREATE INDEX IF NOT EXISTS "ideindbalans" ON "eindbalansregels" ("ideindbalans");
--
-- Gegevens worden uitgevoerd voor tabel "eindbalansregels"
--

INSERT INTO "eindbalansregels" VALUES(1, 1, 100, 'Inventaris', 4060.77, -957.19, 3103.58);
INSERT INTO "eindbalansregels" VALUES(2, 1, 900, 'Kapitaal/prive', 0.00, -4584.74, -4584.74);
INSERT INTO "eindbalansregels" VALUES(3, 1, 1000, 'Kas', 5083.99, -4865.52, 218.47);
INSERT INTO "eindbalansregels" VALUES(4, 1, 1050, 'Rabobank', 9968.41, -8845.12, 1123.29);
INSERT INTO "eindbalansregels" VALUES(5, 1, 1060, 'Rekening courant prive', 18710.98, -9431.51, 9279.47);
INSERT INTO "eindbalansregels" VALUES(6, 1, 1200, 'Debiteuren', 13893.25, -13893.25, 0.00);
INSERT INTO "eindbalansregels" VALUES(7, 1, 1600, 'Crediteuren', 4907.00, -5475.67, -568.67);
INSERT INTO "eindbalansregels" VALUES(8, 1, 2110, 'Af te dragen BTW hoog tarief', 3297.45, -3297.45, 0.00);
INSERT INTO "eindbalansregels" VALUES(9, 1, 2200, 'Te ontvangen BTW', 1466.92, -1466.92, 0.00);
INSERT INTO "eindbalansregels" VALUES(10, 1, 2300, 'Betaalde BTW', 4876.20, -5408.20, -532.00);
INSERT INTO "eindbalansregels" VALUES(11, 1, 4100, 'Huisvestingskosten', 3370.08, 0.00, 3370.08);
INSERT INTO "eindbalansregels" VALUES(12, 1, 4210, 'Klein apparatuur', 191.40, 0.00, 191.40);
INSERT INTO "eindbalansregels" VALUES(13, 1, 4220, 'Atelierkosten', 1903.13, 0.00, 1903.13);
INSERT INTO "eindbalansregels" VALUES(14, 1, 4230, 'Kantoorkosten', 226.51, 0.00, 226.51);
INSERT INTO "eindbalansregels" VALUES(15, 1, 4240, 'Telefoonkosten', 968.07, -5.42, 962.65);
INSERT INTO "eindbalansregels" VALUES(16, 1, 4245, 'Internetkosten', 592.26, 0.00, 592.26);
INSERT INTO "eindbalansregels" VALUES(17, 1, 4250, 'Portikosten', 96.75, 0.00, 96.75);
INSERT INTO "eindbalansregels" VALUES(18, 1, 4300, 'Afschrijvingen', 957.19, 0.00, 957.19);
INSERT INTO "eindbalansregels" VALUES(19, 1, 4350, 'Bankkosten', 145.17, 0.00, 145.17);
INSERT INTO "eindbalansregels" VALUES(20, 1, 4490, 'Diverse kosten', 501.82, 0.00, 501.82);
INSERT INTO "eindbalansregels" VALUES(21, 1, 4500, 'Promotiekosten', 611.26, 0.00, 611.26);
INSERT INTO "eindbalansregels" VALUES(22, 1, 4600, 'Inkopen', 4.99, 0.00, 4.99);
INSERT INTO "eindbalansregels" VALUES(23, 1, 8010, 'Verkopen', 0.00, -16830.00, -16830.00);
INSERT INTO "eindbalansregels" VALUES(24, 1, 8020, 'Verkopen Atelier', 60.00, -828.45, -768.45);
INSERT INTO "eindbalansregels" VALUES(25, 1, 8900, 'Diverse opbrengsten', 0.15, -4.31, -4.16);

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "eindcheck"
--

DROP TABLE IF EXISTS "eindcheck";
CREATE TABLE IF NOT EXISTS "eindcheck" (
  "id" INTEGER PRIMARY KEY,
  "date" date  default '0000-00-00',
  "boekjaar" int(11)  default '0',
  "sortering" smallint(6)  default '0',
  "label" varchar(64)  default '',
  "naam" varchar(32)  default '',
  "type" tinyint(1)  default '0' ,
  "value" tinyint(1)  default '0' ,
  "tekst" text default ''
);

--
-- Gegevens worden uitgevoerd voor tabel "eindcheck"
--

INSERT INTO "eindcheck" VALUES(9, '0000-00-00', 2009, 5, 'Eindejaars memoriaalposten', 'memoriaal', 0, 2, 'De laatste memoriaalposten van het boekjaar');
INSERT INTO "eindcheck" VALUES(10, '0000-00-00', 2009, 10, 'Zijn alle periodes geconsolideerd?', 'consolidatie', 0, 2, '');
INSERT INTO "eindcheck" VALUES(11, '0000-00-00', 2009, 15, 'Backup maken', 'backup', 1, 0, 'Maak een backup van de huidige administratie voordat hij wordt gelockt/afgesloten. Als dit is gebeurd kan er niet meer geboekt worden in het boekjaar.');
INSERT INTO "eindcheck" VALUES(12, '0000-00-00', 2009, 20, 'Herstellen grootboeksaldi', 'herstel', 1, 0, 'Voor zekerheid, herstel de grootboeksaldi');
INSERT INTO "eindcheck" VALUES(13, '0000-00-00', 2009, 25, 'Zijn Proef- en Saldibalans uitgedraaid?', 'balansen', 0, 2, '');
INSERT INTO "eindcheck" VALUES(14, '0000-00-00', 2009, 30, 'Zijn de Grootboekkaarten uitgedraaid?', 'grootboekkaarten', 0, 2, 'Draai alle grootboekkaarten van het boekjaar uit. Print naar pdf voor archiefdoeleinden.');
INSERT INTO "eindcheck" VALUES(15, '0000-00-00', 2009, 35, 'Eindbalans consolideren', 'eindbalans', 1, 0, 'Leg debet, credit totalen en saldo per grootboekkaart vast in eindbalansen en eindbalansregels.');
INSERT INTO "eindcheck" VALUES(16, '0000-00-00', 2009, 40, 'Beginbalans nieuwe jaar', 'beginbalans', 1, 0, 'Beginbalans journaalpost aanmaken voor het nieuwe jaar. De journaalid is altijd nr. 1, moet er ook voor gereserveerd blijven, ook als er al boekingen in het nieuwe jaar zijn gedaan en nog geen beginbalans. Als de beginbalans boeking er al is, update vanuit de afsluiting, anders insert een nieuw.');
INSERT INTO "eindcheck" VALUES(17, '0000-00-00', 2008, 5, 'Eindejaars memoriaalposten', 'memoriaal', 0, 3, 'De laatste memoriaalposten van het boekjaar');
INSERT INTO "eindcheck" VALUES(18, '0000-00-00', 2008, 10, 'Zijn alle periodes geconsolideerd?', 'consolidatie', 0, 3, '');
INSERT INTO "eindcheck" VALUES(19, '0000-00-00', 2008, 15, 'Backup maken', 'backup', 1, 1, 'Maak een backup van de huidige administratie voordat hij wordt gelockt/afgesloten. Als dit is gebeurd kan er niet meer geboekt worden in het boekjaar.');
INSERT INTO "eindcheck" VALUES(20, '0000-00-00', 2008, 20, 'Herstellen grootboeksaldi', 'herstel', 1, 1, 'Voor zekerheid, herstel de grootboeksaldi');
INSERT INTO "eindcheck" VALUES(21, '0000-00-00', 2008, 25, 'Zijn Proef- en Saldibalans uitgedraaid?', 'balansen', 0, 3, '');
INSERT INTO "eindcheck" VALUES(22, '0000-00-00', 2008, 30, 'Zijn de Grootboekkaarten uitgedraaid?', 'grootboekkaarten', 0, 3, 'Draai alle grootboekkaarten van het boekjaar uit. Print naar pdf voor archiefdoeleinden.');
INSERT INTO "eindcheck" VALUES(23, '0000-00-00', 2008, 35, 'Eindbalans consolideren', 'eindbalans', 1, 1, 'Leg debet, credit totalen en saldo per grootboekkaart vast in eindbalansen en eindbalansregels.');
INSERT INTO "eindcheck" VALUES(24, '0000-00-00', 2008, 40, 'Beginbalans nieuwe jaar', 'beginbalans', 1, 1, 'Beginbalans journaalpost aanmaken voor het nieuwe jaar. De journaalid is altijd nr. 1, moet er ook voor gereserveerd blijven, ook als er al boekingen in het nieuwe jaar zijn gedaan en nog geen beginbalans. Als de beginbalans boeking er al is, update vanuit de afsluiting, anders insert een nieuw.');

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "grootboeksaldi"
--

DROP TABLE IF EXISTS "grootboeksaldi";
CREATE TABLE IF NOT EXISTS "grootboeksaldi" (
  "id" INTEGER PRIMARY KEY,
  "nummer" int(11)  default '0',
  "boekjaar" int(11)  default '0',
  "saldo" decimal(12,2)  default '0.00'
);

  CREATE INDEX IF NOT EXISTS "boekjaar" ON "grootboeksaldi" ("boekjaar");
  CREATE INDEX IF NOT EXISTS "nummer" ON "grootboeksaldi" ("nummer");
--
-- Gegevens worden uitgevoerd voor tabel "grootboeksaldi"
--

INSERT INTO "grootboeksaldi" VALUES(1, 4230, 2009, 324.32);
INSERT INTO "grootboeksaldi" VALUES(2, 4240, 2009, 563.62);
INSERT INTO "grootboeksaldi" VALUES(3, 1600, 2009, -3053.58);
INSERT INTO "grootboeksaldi" VALUES(4, 4245, 2009, 605.18);
INSERT INTO "grootboeksaldi" VALUES(5, 2200, 2009, 105.04);
INSERT INTO "grootboeksaldi" VALUES(6, 2300, 2008, -532.00);
INSERT INTO "grootboeksaldi" VALUES(7, 4350, 2008, 145.17);
INSERT INTO "grootboeksaldi" VALUES(8, 4230, 2008, 226.51);
INSERT INTO "grootboeksaldi" VALUES(9, 4250, 2008, 96.75);
INSERT INTO "grootboeksaldi" VALUES(10, 4220, 2008, 1903.13);
INSERT INTO "grootboeksaldi" VALUES(11, 8900, 2008, -4.16);
INSERT INTO "grootboeksaldi" VALUES(12, 1000, 2008, 218.47);
INSERT INTO "grootboeksaldi" VALUES(13, 1050, 2008, 1123.29);
INSERT INTO "grootboeksaldi" VALUES(14, 1060, 2008, 9279.47);
INSERT INTO "grootboeksaldi" VALUES(15, 4240, 2008, 962.65);
INSERT INTO "grootboeksaldi" VALUES(16, 2200, 2008, 0.00);
INSERT INTO "grootboeksaldi" VALUES(17, 4500, 2008, 611.26);
INSERT INTO "grootboeksaldi" VALUES(18, 4245, 2008, 592.26);
INSERT INTO "grootboeksaldi" VALUES(19, 4490, 2008, 501.82);
INSERT INTO "grootboeksaldi" VALUES(20, 4100, 2008, 3370.08);
INSERT INTO "grootboeksaldi" VALUES(21, 8010, 2008, -16830.00);
INSERT INTO "grootboeksaldi" VALUES(22, 2110, 2008, 0.00);
INSERT INTO "grootboeksaldi" VALUES(23, 1600, 2008, -568.67);
INSERT INTO "grootboeksaldi" VALUES(24, 8020, 2008, -768.45);
INSERT INTO "grootboeksaldi" VALUES(25, 1200, 2008, 0.00);
INSERT INTO "grootboeksaldi" VALUES(26, 100, 2008, 3103.58);
INSERT INTO "grootboeksaldi" VALUES(27, 4210, 2008, 191.40);
INSERT INTO "grootboeksaldi" VALUES(28, 4600, 2008, 4.99);
INSERT INTO "grootboeksaldi" VALUES(29, 2020, 2009, -49.94);
INSERT INTO "grootboeksaldi" VALUES(30, 900, 2008, -4584.74);
INSERT INTO "grootboeksaldi" VALUES(31, 4300, 2008, 957.19);
INSERT INTO "grootboeksaldi" VALUES(32, 0, 2008, 286.71);
INSERT INTO "grootboeksaldi" VALUES(33, 100, 2009, 3103.58);
INSERT INTO "grootboeksaldi" VALUES(34, 900, 2009, -3344.67);
INSERT INTO "grootboeksaldi" VALUES(35, 1000, 2009, -483.02);
INSERT INTO "grootboeksaldi" VALUES(36, 1050, 2009, 1123.29);
INSERT INTO "grootboeksaldi" VALUES(37, 2300, 2009, -1730.00);
INSERT INTO "grootboeksaldi" VALUES(38, 1200, 2009, 10003.74);
INSERT INTO "grootboeksaldi" VALUES(39, 8010, 2009, -6630.00);
INSERT INTO "grootboeksaldi" VALUES(40, 2110, 2009, 0.00);
INSERT INTO "grootboeksaldi" VALUES(41, 1060, 2009, -19.90);
INSERT INTO "grootboeksaldi" VALUES(42, 8900, 2009, 0.46);
INSERT INTO "grootboeksaldi" VALUES(43, 4490, 2009, 127.92);
INSERT INTO "grootboeksaldi" VALUES(44, 4220, 2009, 791.50);
INSERT INTO "grootboeksaldi" VALUES(45, 4500, 2009, 236.80);
INSERT INTO "grootboeksaldi" VALUES(46, 4210, 2009, 198.26);
INSERT INTO "grootboeksaldi" VALUES(47, 8020, 2009, -1776.50);

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "grootboekstam"
--

DROP TABLE IF EXISTS "grootboekstam";
CREATE TABLE IF NOT EXISTS "grootboekstam" (
  "id" INTEGER PRIMARY KEY,
  "nummer" int(11)  default '0',
  "populariteit" int(11) default '0',
  "type" int(11)  default '0' ,
  "nivo" int(11)  default '0',
  "verdichting" int(11)  default '0',
  "btwtype" int(11)  default '0' ,
  "naam" varchar(64)  default ''
);

  CREATE UNIQUE INDEX IF NOT EXISTS "nummer" ON "grootboekstam" ("nummer");
--
-- Gegevens worden uitgevoerd voor tabel "grootboekstam"
--

INSERT INTO "grootboekstam" VALUES(1, 100, 2, 1, 0, 0, 1, 'Inventaris');
INSERT INTO "grootboekstam" VALUES(2, 150, 0, 1, 0, 0, 5, 'Afschrijving inventaris');
INSERT INTO "grootboekstam" VALUES(3, 200, 0, 1, 0, 0, 1, 'Transportmiddelen');
INSERT INTO "grootboekstam" VALUES(4, 250, 0, 1, 0, 0, 5, 'Afschrijving transportmiddelen');
INSERT INTO "grootboekstam" VALUES(5, 300, 0, 1, 0, 0, 1, 'Software');
INSERT INTO "grootboekstam" VALUES(6, 350, 0, 1, 0, 0, 5, 'Afschrijving software');
INSERT INTO "grootboekstam" VALUES(7, 500, 0, 1, 0, 0, 5, 'Leningen');
INSERT INTO "grootboekstam" VALUES(8, 900, 1, 1, 0, 0, 5, 'Kapitaal/prive');
INSERT INTO "grootboekstam" VALUES(9, 1000, 3, 1, 0, 0, 5, 'Kas');
INSERT INTO "grootboekstam" VALUES(10, 1050, 1, 1, 0, 0, 5, 'Rabobank');
INSERT INTO "grootboekstam" VALUES(11, 1060, 9, 1, 0, 0, 5, 'Rekening courant prive');
INSERT INTO "grootboekstam" VALUES(12, 1100, 0, 1, 0, 0, 5, 'Nog te ontvangen');
INSERT INTO "grootboekstam" VALUES(13, 1200, 0, 1, 0, 0, 5, 'Debiteuren');
INSERT INTO "grootboekstam" VALUES(14, 1500, 0, 1, 0, 0, 5, 'Nog te betalen');
INSERT INTO "grootboekstam" VALUES(15, 1600, 0, 1, 0, 0, 5, 'Crediteuren');
INSERT INTO "grootboekstam" VALUES(16, 1999, 0, 3, 3, 0, 5, 'Totaal activa/passiva');
INSERT INTO "grootboekstam" VALUES(17, 2010, 1, 1, 0, 0, 5, 'Kruisposten');
INSERT INTO "grootboekstam" VALUES(18, 2020, 1, 1, 0, 0, 5, 'Betalingen onderweg');
INSERT INTO "grootboekstam" VALUES(19, 2099, 0, 3, 1, 0, 5, 'Totaal hulprekeningen');
INSERT INTO "grootboekstam" VALUES(20, 2110, 1, 1, 0, 0, 5, 'Af te dragen BTW hoog tarief');
INSERT INTO "grootboekstam" VALUES(21, 2120, 0, 1, 0, 0, 5, 'Af te dragen BTW laag tarief');
INSERT INTO "grootboekstam" VALUES(22, 2200, 1, 1, 0, 0, 5, 'Te ontvangen BTW');
INSERT INTO "grootboekstam" VALUES(23, 2300, 1, 1, 0, 0, 5, 'Betaalde BTW');
INSERT INTO "grootboekstam" VALUES(24, 2399, 0, 3, 1, 0, 5, 'Totaal periodieke BTW');
INSERT INTO "grootboekstam" VALUES(25, 2500, 0, 1, 0, 0, 5, 'Verschillenrekening');
INSERT INTO "grootboekstam" VALUES(26, 2899, 0, 3, 3, 0, 5, 'Totaal tussenrekeningen');
INSERT INTO "grootboekstam" VALUES(27, 3010, 0, 1, 0, 0, 5, 'Voorraad');
INSERT INTO "grootboekstam" VALUES(28, 3999, 0, 3, 7, 0, 5, 'Totaal balans');
INSERT INTO "grootboekstam" VALUES(29, 4010, 0, 2, 0, 0, 5, 'Personeelskosten');
INSERT INTO "grootboekstam" VALUES(30, 4020, 0, 2, 0, 0, 1, 'Uitbesteed werk');
INSERT INTO "grootboekstam" VALUES(31, 4100, 1, 2, 0, 0, 1, 'Huisvestingskosten');
INSERT INTO "grootboekstam" VALUES(32, 4200, 0, 2, 0, 0, 1, 'Documentatiekosten');
INSERT INTO "grootboekstam" VALUES(33, 4210, 5, 2, 0, 0, 1, 'Klein apparatuur');
INSERT INTO "grootboekstam" VALUES(34, 4220, 22, 2, 0, 0, 1, 'Atelierkosten');
INSERT INTO "grootboekstam" VALUES(35, 4230, 30, 2, 0, 0, 1, 'Kantoorkosten');
INSERT INTO "grootboekstam" VALUES(36, 4235, 0, 2, 0, 0, 1, 'Kantinekosten');
INSERT INTO "grootboekstam" VALUES(37, 4240, 20, 2, 0, 0, 1, 'Telefoonkosten');
INSERT INTO "grootboekstam" VALUES(38, 4245, 20, 2, 0, 0, 1, 'Internetkosten');
INSERT INTO "grootboekstam" VALUES(39, 4250, 0, 2, 0, 0, 1, 'Portikosten');
INSERT INTO "grootboekstam" VALUES(40, 4300, 0, 2, 0, 0, 1, 'Afschrijvingen');
INSERT INTO "grootboekstam" VALUES(41, 4350, 2, 2, 0, 0, 1, 'Bankkosten');
INSERT INTO "grootboekstam" VALUES(42, 4400, 0, 2, 0, 0, 1, 'Reiskosten');
INSERT INTO "grootboekstam" VALUES(43, 4490, 8, 2, 0, 0, 1, 'Diverse kosten');
INSERT INTO "grootboekstam" VALUES(44, 4499, 0, 3, 3, 0, 5, 'Totaal algemene kosten');
INSERT INTO "grootboekstam" VALUES(45, 4500, 5, 2, 0, 0, 1, 'Promotiekosten');
INSERT INTO "grootboekstam" VALUES(46, 4510, 0, 2, 0, 0, 1, 'Acquisitiekosten');
INSERT INTO "grootboekstam" VALUES(47, 4520, 0, 2, 0, 0, 1, 'Productiekosten');
INSERT INTO "grootboekstam" VALUES(48, 4600, 1, 2, 0, 0, 1, 'Inkopen');
INSERT INTO "grootboekstam" VALUES(49, 4699, 0, 3, 3, 0, 5, 'Totaal specifieke kosten');
INSERT INTO "grootboekstam" VALUES(50, 4900, 0, 2, 0, 0, 1, 'Voordelig/nadelig saldo');
INSERT INTO "grootboekstam" VALUES(51, 4999, 0, 3, 5, 0, 5, 'Totaal kosten');
INSERT INTO "grootboekstam" VALUES(52, 8010, 3, 2, 0, 0, 3, 'Verkopen');
INSERT INTO "grootboekstam" VALUES(53, 8099, 0, 3, 3, 0, 5, 'Totaal verkopen');
INSERT INTO "grootboekstam" VALUES(54, 8410, 0, 2, 0, 0, 5, 'Rente opbrengsten');
INSERT INTO "grootboekstam" VALUES(55, 8900, 0, 2, 0, 0, 5, 'Diverse opbrengsten');
INSERT INTO "grootboekstam" VALUES(56, 8980, 0, 3, 3, 0, 5, 'Totaal diverse opbrengsten');
INSERT INTO "grootboekstam" VALUES(57, 8985, 0, 3, 5, 0, 5, 'Totaal opbrengsten');
INSERT INTO "grootboekstam" VALUES(58, 8990, 0, 3, 7, 0, 5, 'Totaal verlies en winst');
INSERT INTO "grootboekstam" VALUES(59, 8999, 0, 3, 8, 0, 5, 'Totaal administratie');
INSERT INTO "grootboekstam" VALUES(60, 8020, 4, 2, 0, 0, 3, 'Verkopen Atelier');
INSERT INTO "grootboekstam" VALUES(61, 4099, 0, 3, 3, 0, 5, 'Totaal personeelskosten');
INSERT INTO "grootboekstam" VALUES(62, 8100, 0, 2, 0, 0, 4, 'Verkopen kunst laag tarief');

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "grootboekstam2008"
--

DROP TABLE IF EXISTS "grootboekstam2008";
CREATE TABLE IF NOT EXISTS "grootboekstam2008" (
  "id" INTEGER PRIMARY KEY,
  "nummer" int(11)  default '0',
  "populariteit" int(11) default '0',
  "type" int(11)  default '0' ,
  "nivo" int(11)  default '0',
  "verdichting" int(11)  default '0',
  "btwtype" int(11)  default '0' ,
  "naam" varchar(64)  default ''
);

  CREATE UNIQUE INDEX IF NOT EXISTS "nummer" ON "grootboekstam2008" ("nummer");
--
-- Gegevens worden uitgevoerd voor tabel "grootboekstam2008"
--

INSERT INTO "grootboekstam2008" VALUES(1, 100, 2, 1, 0, 0, 1, 'Inventaris');
INSERT INTO "grootboekstam2008" VALUES(2, 150, 0, 1, 0, 0, 5, 'Afschrijving inventaris');
INSERT INTO "grootboekstam2008" VALUES(3, 200, 0, 1, 0, 0, 1, 'Transportmiddelen');
INSERT INTO "grootboekstam2008" VALUES(4, 250, 0, 1, 0, 0, 5, 'Afschrijving transportmiddelen');
INSERT INTO "grootboekstam2008" VALUES(5, 300, 0, 1, 0, 0, 1, 'Software');
INSERT INTO "grootboekstam2008" VALUES(6, 350, 0, 1, 0, 0, 5, 'Afschrijving software');
INSERT INTO "grootboekstam2008" VALUES(7, 500, 0, 1, 0, 0, 5, 'Leningen');
INSERT INTO "grootboekstam2008" VALUES(8, 900, 1, 1, 0, 0, 5, 'Kapitaal/prive');
INSERT INTO "grootboekstam2008" VALUES(9, 1000, 3, 1, 0, 0, 5, 'Kas');
INSERT INTO "grootboekstam2008" VALUES(10, 1050, 1, 1, 0, 0, 5, 'Rabobank');
INSERT INTO "grootboekstam2008" VALUES(11, 1060, 9, 1, 0, 0, 5, 'Rekening courant prive');
INSERT INTO "grootboekstam2008" VALUES(12, 1100, 0, 1, 0, 0, 5, 'Nog te ontvangen');
INSERT INTO "grootboekstam2008" VALUES(13, 1200, 0, 1, 0, 0, 5, 'Debiteuren');
INSERT INTO "grootboekstam2008" VALUES(14, 1500, 0, 1, 0, 0, 5, 'Nog te betalen');
INSERT INTO "grootboekstam2008" VALUES(15, 1600, 0, 1, 0, 0, 5, 'Crediteuren');
INSERT INTO "grootboekstam2008" VALUES(16, 1999, 0, 3, 3, 0, 5, 'Totaal activa/passiva');
INSERT INTO "grootboekstam2008" VALUES(17, 2010, 1, 1, 0, 0, 5, 'Kruisposten');
INSERT INTO "grootboekstam2008" VALUES(18, 2020, 1, 1, 0, 0, 5, 'Betalingen onderweg');
INSERT INTO "grootboekstam2008" VALUES(19, 2099, 0, 3, 1, 0, 5, 'Totaal hulprekeningen');
INSERT INTO "grootboekstam2008" VALUES(20, 2110, 1, 1, 0, 0, 5, 'Af te dragen BTW hoog tarief');
INSERT INTO "grootboekstam2008" VALUES(21, 2120, 0, 1, 0, 0, 5, 'Af te dragen BTW laag tarief');
INSERT INTO "grootboekstam2008" VALUES(22, 2200, 1, 1, 0, 0, 5, 'Te ontvangen BTW');
INSERT INTO "grootboekstam2008" VALUES(23, 2300, 1, 1, 0, 0, 5, 'Betaalde BTW');
INSERT INTO "grootboekstam2008" VALUES(24, 2399, 0, 3, 1, 0, 5, 'Totaal periodieke BTW');
INSERT INTO "grootboekstam2008" VALUES(25, 2500, 0, 1, 0, 0, 5, 'Verschillenrekening');
INSERT INTO "grootboekstam2008" VALUES(26, 2899, 0, 3, 3, 0, 5, 'Totaal tussenrekeningen');
INSERT INTO "grootboekstam2008" VALUES(27, 3010, 0, 1, 0, 0, 5, 'Voorraad');
INSERT INTO "grootboekstam2008" VALUES(28, 3999, 0, 3, 7, 0, 5, 'Totaal balans');
INSERT INTO "grootboekstam2008" VALUES(29, 4010, 0, 2, 0, 0, 5, 'Personeelskosten');
INSERT INTO "grootboekstam2008" VALUES(30, 4020, 0, 2, 0, 0, 1, 'Uitbesteed werk');
INSERT INTO "grootboekstam2008" VALUES(31, 4100, 1, 2, 0, 0, 1, 'Huisvestingskosten');
INSERT INTO "grootboekstam2008" VALUES(32, 4200, 0, 2, 0, 0, 1, 'Documentatiekosten');
INSERT INTO "grootboekstam2008" VALUES(33, 4210, 2, 2, 0, 0, 1, 'Klein apparatuur');
INSERT INTO "grootboekstam2008" VALUES(34, 4220, 3, 2, 0, 0, 1, 'Atelierkosten');
INSERT INTO "grootboekstam2008" VALUES(35, 4230, 13, 2, 0, 0, 1, 'Kantoorkosten');
INSERT INTO "grootboekstam2008" VALUES(36, 4235, 0, 2, 0, 0, 1, 'Kantinekosten');
INSERT INTO "grootboekstam2008" VALUES(37, 4240, 10, 2, 0, 0, 1, 'Telefoonkosten');
INSERT INTO "grootboekstam2008" VALUES(38, 4245, 11, 2, 0, 0, 1, 'Internetkosten');
INSERT INTO "grootboekstam2008" VALUES(39, 4250, 0, 2, 0, 0, 1, 'Portikosten');
INSERT INTO "grootboekstam2008" VALUES(40, 4300, 0, 2, 0, 0, 1, 'Afschrijvingen');
INSERT INTO "grootboekstam2008" VALUES(41, 4350, 2, 2, 0, 0, 1, 'Bankkosten');
INSERT INTO "grootboekstam2008" VALUES(42, 4400, 0, 2, 0, 0, 1, 'Reiskosten');
INSERT INTO "grootboekstam2008" VALUES(43, 4490, 1, 2, 0, 0, 1, 'Diverse kosten');
INSERT INTO "grootboekstam2008" VALUES(44, 4499, 0, 3, 3, 0, 5, 'Totaal algemene kosten');
INSERT INTO "grootboekstam2008" VALUES(45, 4500, 2, 2, 0, 0, 1, 'Promotiekosten');
INSERT INTO "grootboekstam2008" VALUES(46, 4510, 0, 2, 0, 0, 1, 'Acquisitiekosten');
INSERT INTO "grootboekstam2008" VALUES(47, 4520, 0, 2, 0, 0, 1, 'Productiekosten');
INSERT INTO "grootboekstam2008" VALUES(48, 4600, 1, 2, 0, 0, 1, 'Inkopen');
INSERT INTO "grootboekstam2008" VALUES(49, 4699, 0, 3, 3, 0, 5, 'Totaal specifieke kosten');
INSERT INTO "grootboekstam2008" VALUES(50, 4900, 0, 2, 0, 0, 1, 'Voordelig/nadelig saldo');
INSERT INTO "grootboekstam2008" VALUES(51, 4999, 0, 3, 5, 0, 5, 'Totaal kosten');
INSERT INTO "grootboekstam2008" VALUES(52, 8010, 1, 2, 0, 0, 3, 'Verkopen');
INSERT INTO "grootboekstam2008" VALUES(53, 8099, 0, 3, 3, 0, 5, 'Totaal verkopen');
INSERT INTO "grootboekstam2008" VALUES(54, 8410, 0, 2, 0, 0, 5, 'Rente opbrengsten');
INSERT INTO "grootboekstam2008" VALUES(55, 8900, 0, 2, 0, 0, 5, 'Diverse opbrengsten');
INSERT INTO "grootboekstam2008" VALUES(56, 8980, 0, 3, 3, 0, 5, 'Totaal diverse opbrengsten');
INSERT INTO "grootboekstam2008" VALUES(57, 8985, 0, 3, 5, 0, 5, 'Totaal opbrengsten');
INSERT INTO "grootboekstam2008" VALUES(58, 8990, 0, 3, 7, 0, 5, 'Totaal verlies en winst');
INSERT INTO "grootboekstam2008" VALUES(59, 8999, 0, 3, 8, 0, 5, 'Totaal administratie');
INSERT INTO "grootboekstam2008" VALUES(60, 8020, 1, 2, 0, 0, 3, 'Verkopen Atelier');
INSERT INTO "grootboekstam2008" VALUES(61, 4099, 0, 3, 3, 0, 5, 'Totaal personeelskosten');

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "inkoopfacturen"
--

DROP TABLE IF EXISTS "inkoopfacturen";
CREATE TABLE IF NOT EXISTS "inkoopfacturen" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" int(11)  default '0',
  "boekjaar" int(11)  default '0',
  "datum" date  default '0000-00-00',
  "omschrijving" varchar(128)  default '',
  "factuurbedrag" decimal(12,2)  default '0.00',
  "relatiecode" varchar(32)  default '',
  "relatieid" int(11)  default '0',
  "factuurnummer" varchar(16)  default '' ,
  "voldaan" decimal(12,2)  default '0.00',
  "betaaldatum" date  default '0000-00-00'
);

  CREATE UNIQUE INDEX IF NOT EXISTS "idboekjaar" ON "inkoopfacturen" ("id","boekjaar");
--
-- Gegevens worden uitgevoerd voor tabel "inkoopfacturen"
--

INSERT INTO "inkoopfacturen" VALUES(1, 11, 2008, '2008-06-10', '0623477347 - juni 2008', 20.00, 'hi', 1, '5951011.73', 20.00, '2008-06-18');
INSERT INTO "inkoopfacturen" VALUES(2, 12, 2008, '2008-06-25', '0643795777 - 16-6/22-7', 13.57, 'tmobile', 6, '901070203247', 13.57, '2008-07-25');
INSERT INTO "inkoopfacturen" VALUES(3, 13, 2008, '2008-06-26', 'BelBasis + ADSL 1-7/31-8', 100.44, 'kpn', 5, '0182611557-0307', 100.44, '2009-01-01');
INSERT INTO "inkoopfacturen" VALUES(4, 14, 2008, '2008-07-07', 'ADSL Basic 6-7/6-8', 23.20, 'xs4all', 3, '24102215', 23.20, '2008-07-16');
INSERT INTO "inkoopfacturen" VALUES(5, 15, 2008, '2008-07-03', '0651425883 - 3-7/2-8', 20.00, 'orange', 2, '00001505010708', 20.00, '2008-07-16');
INSERT INTO "inkoopfacturen" VALUES(6, 16, 2008, '2008-07-10', '0623477347 - juli 08', 20.00, 'hi', 1, '5951011.74', 20.00, '2008-07-18');
INSERT INTO "inkoopfacturen" VALUES(7, 17, 2008, '2008-07-28', '0623477347 - 23-7/23-8', 57.23, 'tmobile', 6, '901071514459', 57.23, '2008-08-27');
INSERT INTO "inkoopfacturen" VALUES(8, 18, 2008, '2008-06-04', 'IMac SN.VM823WHT0KM', 2047.99, 'apple', 7, '9044011895', 2047.99, '2008-06-04');
INSERT INTO "inkoopfacturen" VALUES(9, 19, 2008, '2008-08-11', 'Retour wgs. afronding Hi abonnement', -6.45, 'hi', 1, '5951011.75', -6.45, '2008-09-26');
INSERT INTO "inkoopfacturen" VALUES(10, 20, 2008, '2008-08-03', '0651425883 - 3-8/2-9', 20.00, 'orange', 2, '00005256140808', 20.00, '2008-08-19');
INSERT INTO "inkoopfacturen" VALUES(11, 21, 2008, '2008-08-07', 'ADSL Basic 6-8/6-9', 23.20, 'xs4all', 3, '24421784', 23.20, '2008-08-11');
INSERT INTO "inkoopfacturen" VALUES(12, 22, 2008, '2008-08-26', '0623477347 - 23-8/23-9', 62.74, 'tmobile', 6, '901072876695', 62.74, '2008-09-25');
INSERT INTO "inkoopfacturen" VALUES(13, 23, 2008, '2008-08-27', 'BelBasis + ADSL 1-9/31-10', 95.34, 'kpn', 5, '0182611557-0309', 95.34, '2008-09-12');
INSERT INTO "inkoopfacturen" VALUES(14, 24, 2008, '2008-09-07', 'ADSL Basic 6-9/6-10', 23.20, 'xs4all', 3, '24747064', 23.20, '2008-09-12');
INSERT INTO "inkoopfacturen" VALUES(15, 25, 2008, '2008-09-03', '0651425883 - 3-9/2-10', 20.00, 'orange', 2, '00001913360908', 20.00, '2008-09-12');
INSERT INTO "inkoopfacturen" VALUES(16, 26, 2008, '2008-09-25', '0623477347 - 23-9/22-10', 52.26, 'tmobile', 6, '901074320344', 52.26, '2008-10-01');
INSERT INTO "inkoopfacturen" VALUES(17, 27, 2008, '2008-10-07', 'ADSL Basic 6-10/6-11', 23.20, 'xs4all', 3, '25062372', 23.20, '2008-10-28');
INSERT INTO "inkoopfacturen" VALUES(18, 28, 2008, '2008-10-03', '0651425883 - 3-10/2-11', 20.00, 'orange', 2, '00002073751008', 20.00, '2009-01-01');
INSERT INTO "inkoopfacturen" VALUES(19, 29, 2008, '2008-06-17', 'MacAir sn: W8820004Y51', 1646.92, 'apple', 7, '9044127937', 1646.92, '2008-06-16');
INSERT INTO "inkoopfacturen" VALUES(20, 37, 2008, '2008-08-11', 'Domeinregistraties', 26.13, 'transip', 8, 'F2008102940', 26.13, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(21, 38, 2008, '2008-09-01', 'Domeinregistraties', 17.85, 'transip', 8, 'F2008111105', 17.85, '2008-09-01');
INSERT INTO "inkoopfacturen" VALUES(22, 39, 2008, '2008-09-16', 'Domeinregistraties', 5.94, 'transip', 8, 'F2008118657', 5.94, '2008-10-01');
INSERT INTO "inkoopfacturen" VALUES(23, 40, 2008, '2008-09-09', 'Domeinregistraties', 8.93, 'transip', 8, 'F2008124681', 8.93, '2008-10-01');
INSERT INTO "inkoopfacturen" VALUES(24, 44, 2008, '2008-10-27', '0623477347 - 23-10/22-11', 52.26, 'tmobile', 6, '01075800403', 52.26, '2008-11-26');
INSERT INTO "inkoopfacturen" VALUES(25, 45, 2008, '2008-10-27', 'BelBasis + ADSL 1-11/31-12', 97.56, 'kpn', 5, '0182611557-0311', 97.56, '2008-11-05');
INSERT INTO "inkoopfacturen" VALUES(26, 48, 2008, '2008-11-01', 'Spuitmateriaal', 27.09, 'vanbeek', 9, '246230', 27.09, '2008-11-01');
INSERT INTO "inkoopfacturen" VALUES(27, 49, 2008, '2008-11-07', 'ADSL Basic 6-11/6-12', 23.20, 'xs4all', 3, '25378236', 23.20, '2008-11-12');
INSERT INTO "inkoopfacturen" VALUES(28, 50, 2008, '2008-11-06', 'Mediatablet', 73.79, 'conrad', 10, '9541946926', 73.79, '2008-11-06');
INSERT INTO "inkoopfacturen" VALUES(29, 51, 2008, '2008-11-03', '0651425886 - 3-11/2-12', 20.00, 'orange', 2, '2418311108', 20.00, '2008-11-24');
INSERT INTO "inkoopfacturen" VALUES(30, 52, 2008, '2008-11-20', 'Security software Snitch for MacOSX', 31.94, 'diverse', 11, 'U30298470', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(31, 53, 2008, '2008-11-26', '0623477347 - 23-11/22-12', 52.26, 'tmobile', 6, '901077335109', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(32, 54, 2008, '2008-12-07', 'ADSL Basic 6-12/6-01', 56.78, 'xs4all', 3, '25693810', 56.78, '2008-12-09');
INSERT INTO "inkoopfacturen" VALUES(33, 55, 2008, '2008-12-03', '0651425883 - 3-12/2-01', 20.00, 'orange', 2, '00002171381208', 20.00, '2008-12-17');
INSERT INTO "inkoopfacturen" VALUES(34, 56, 2008, '2008-12-16', 'EveryDNS bijdrage DNS gebruik', 18.58, 'diverse', 11, '16dec', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(35, 57, 2008, '2008-12-19', 'Cartridges', 24.45, '123inkt', 12, '766013', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(36, 58, 2008, '2008-12-29', 'Flex zakelijk 23-11/22-12', 52.26, 'tmobile', 6, '901078936459', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(37, 59, 2008, '2008-12-29', '8-12/20-12', 19.15, 'kpn', 5, '0182611557-0301', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(38, 60, 2008, '2008-12-09', 'Zaalhuur expositie', 350.00, 'vonk', 13, '420050', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(39, 68, 2009, '2009-01-01', 'Domeinregistraties', 26.78, 'transip', 8, 'F2009000711', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(40, 71, 2008, '2008-11-01', 'Domeinregistratie multishots.nl', 8.93, 'transip', 8, 'F2008141168', 8.93, '2008-11-03');
INSERT INTO "inkoopfacturen" VALUES(41, 72, 2008, '2008-11-20', 'Domeinregistratie ruudkooger.nl', 5.94, 'transip', 8, 'F2008151040', 5.94, '2008-12-01');
INSERT INTO "inkoopfacturen" VALUES(42, 73, 2008, '2008-11-30', 'Domeinregistratie liekestraver.nl', 5.94, 'transip', 8, 'F2008154146', 5.94, '2008-12-01');
INSERT INTO "inkoopfacturen" VALUES(43, 74, 2008, '2008-12-01', 'Domeinregistraties hid', 17.85, 'transip', 8, 'F2008155218', 17.85, '2008-12-01');
INSERT INTO "inkoopfacturen" VALUES(44, 75, 2008, '2008-12-19', 'Spuitmateriaal', 163.10, 'henx', 14, '3248', 163.10, '2008-12-19');
INSERT INTO "inkoopfacturen" VALUES(45, 77, 2009, '2009-01-03', '0651425883 - 3-1/2-2', 20.00, 'orange', 2, '2004820109', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(46, 82, 2009, '2009-01-07', 'ADSL Basic 6-01/6-02', 64.18, 'xs4all', 3, '26008394', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(47, 87, 2009, '2009-01-27', '23-12/22-01', 52.26, 'tmobile', 6, '901080575403', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(48, 88, 2009, '2009-02-04', 'Domeinregistratie rampenoverleven.nl', 8.93, 'transip', 8, '200900014426', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(49, 92, 2009, '2009-02-04', 'Jaarlijkse bijdrage - 2009', 46.30, 'kvk', 4, '929044932', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(50, 93, 2009, '2009-02-03', '0651425883 - 3-2/2-3', 20.00, 'orange', 2, '1867240209', 20.00, '2009-02-23');
INSERT INTO "inkoopfacturen" VALUES(51, 94, 2009, '2009-02-07', 'ADSL Basic 6-02/6-03', 58.51, 'xs4all', 3, '26326804', 58.51, '2009-02-23');
INSERT INTO "inkoopfacturen" VALUES(52, 95, 2009, '2009-02-26', '0623477347 - 23-02/22-03', 52.26, 'tmobile', 6, '901082279965', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(53, 96, 2009, '2009-03-03', '0623477347 - 03-03/02-04', 20.00, 'orange', 2, '2128460309', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(54, 97, 2009, '2009-03-07', 'ADSL Basic 6-03/6-04', 63.00, 'xs4all', 3, '26643291', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(55, 98, 2009, '2009-02-26', 'Credit wgs eindafrekening', -31.32, 'kpn', 5, '0182611557-303', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(56, 99, 2009, '2009-03-26', '0623477347 - 23-2/22-3', 52.26, 'tmobile', 6, '901084029752', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(57, 100, 2009, '2009-04-01', 'Domeinen literature.nu, literatuurmetvrienden.nl', 65.44, 'transip', 8, 'F0000.2009.0003.', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(58, 101, 2009, '2009-04-03', '0651425883 3-4/2-5', 20.00, 'orange', 2, '2104090409', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(59, 102, 2009, '2009-04-07', 'ADSL Basic 6-4/6-5', 60.15, 'xs4all', 3, '26957120', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(61, 105, 2009, '2009-04-15', 'raov.nl', 8.93, 'transip', 8, '20900036492', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(62, 106, 2009, '2009-04-13', 'Flitsset', 185.95, 'foka', 16, '4986609', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(63, 107, 2009, '2009-04-20', 'Kantoormateriaal', 52.21, 'officec', 15, '47062', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(64, 108, 2009, '2009-04-28', '0623477347 23-4/22-5', 52.26, 'tmobile', 6, '901085828341', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(65, 111, 2009, '2009-05-03', '0651425883 3-5/2-6', 20.00, 'orange', 2, '1368100509', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(66, 112, 2009, '2009-05-07', 'ADSL Basic 6-5/6-6', 60.22, 'xs4all', 3, '27271652', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(67, 113, 2009, '2009-05-07', 'Spuitmateriaal', 112.00, 'henx', 14, '3528', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(68, 114, 2009, '2009-05-19', 'Drukwerk folders', 112.10, 'dwdeal', 17, 'F2009014731', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(69, 115, 2009, '2009-05-28', '0623477347 23-5/22-6', 55.39, 'tmobile', 6, '901087680801', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(70, 116, 2009, '2009-06-07', 'ADSL Basic 6-6/6-7', 63.15, 'xs4all', 3, '27584261', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(71, 117, 2009, '2009-06-03', '0651425883 3-6/2-7', 20.00, 'orange', 2, '959800609', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(72, 118, 2009, '2009-06-08', 'Inkt printer', 38.45, '123inkt', 12, '925101', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(73, 119, 2009, '2009-06-29', '0623477347 23-6/22-7', 58.51, 'tmobile', 6, '901089575053', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(74, 120, 2009, '2009-06-29', 'Computermateriaal', 29.99, 'conrad', 10, '9542255322', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(75, 128, 2009, '2009-08-07', 'ADSL Basic 6-8/6-9', 60.50, 'xs4all', 3, '28223309', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(76, 129, 2009, '2009-08-27', '0623477347 23-8/22-9', 70.41, 'tmobile', 6, '901093352660', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(77, 130, 2009, '2009-08-18', 'Plusvermelding', 59.00, 'marktp', 18, '200958603', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(78, 131, 2009, '2009-08-14', '0623477347 23-7/22-8', 82.31, 'tmobile', 6, '901091433021', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(79, 132, 2009, '2009-07-07', 'ADSL Basic 6-7/6-8', 60.25, 'xs4all', 3, '27898308', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(80, 133, 2009, '2009-09-07', 'Green Laser projector', 107.98, 'rgblaser', 19, '1197', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(81, 134, 2009, '2009-09-07', 'ADSL Basic 6-9/6-10', 60.28, 'xs4all', 3, '28545703', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(82, 135, 2009, '2009-09-28', '0623477347 23-9/22-10', 70.41, 'tmobile', 6, '901095390990', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(83, 136, 2009, '2009-10-05', 'DMX kabels en sturing', 212.41, 'j&h', 21, '47140', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(84, 137, 2009, '2009-10-06', 'Spuitmateriaal', 236.10, 'kramerart', 20, '4039', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(85, 138, 2009, '2009-10-07', 'ADSL Basic 6-10/6-11', 59.99, 'xs4all', 3, '28852349', 0.00, '0000-00-00');
INSERT INTO "inkoopfacturen" VALUES(86, 139, 2009, '2009-10-27', '0623477347 23-10/22-11', 35.90, 'tmobile', 6, '901097465083', 0.00, '0000-00-00');

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "journaal"
--

DROP TABLE IF EXISTS "journaal";
CREATE TABLE IF NOT EXISTS "journaal" (
  "id" INTEGER PRIMARY KEY,
  "journaalpost" int(11)  default '0',
  "boekjaar" int(11)  default '0',
  "datum" date  default '0000-00-00',
  "periode" int(11)  default '0',
  "dagboekcode" varchar(16)  default '',
  "jomschrijving" varchar(128)  default '',
  "saldo" decimal(12,2)  default '0.00',
  "jrelatie" varchar(32)  default '',
  "jnummer" varchar(16)  default '' ,
  "joorsprong" varchar(16)  default '' ,
  "tekst" text default ''
);

  CREATE UNIQUE INDEX IF NOT EXISTS "idboekjaar" ON "journaal" ("journaalpost","boekjaar");
  CREATE INDEX IF NOT EXISTS "periode" ON "journaal" ("periode");
  CREATE INDEX IF NOT EXISTS "dagboekcode" ON "journaal" ("dagboekcode");
--
-- Gegevens worden uitgevoerd voor tabel "journaal"
--

INSERT INTO "journaal" VALUES(1, 1, 2008, '2008-01-01', 0, 'begin', 'Beginbalans', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(2, 2, 2008, '2008-03-31', 1, 'kas', 'Kasbetalingen 1e kwartaal 2008', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(3, 3, 2008, '2008-01-08', 1, 'rabo', 'Bankafschrift 119', 0, '', '', 'rabo 1', '');
INSERT INTO "journaal" VALUES(4, 4, 2008, '2008-02-15', 1, 'rabo', 'Bankafschrift: 120', 0, '', '', 'rabo 2', '');
INSERT INTO "journaal" VALUES(5, 5, 2008, '2008-03-28', 1, 'rabo', 'Bankafschrift: 121', 0, '', '', 'rabo 3', '');
INSERT INTO "journaal" VALUES(6, 6, 2008, '2008-06-30', 2, 'kas', 'Kasbetalingen 2e kwartaal 2008', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(7, 7, 2008, '2008-06-16', 2, 'memo', 'Aankoop Mac-air', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(8, 8, 2008, '2008-04-25', 2, 'rabo', 'Bankafschrift: 122', 0, '', '', 'rabo 4', '');
INSERT INTO "journaal" VALUES(9, 9, 2008, '2008-05-23', 2, 'rabo', 'bankafschrift: 123', 0, '', '', 'rabo 5', '');
INSERT INTO "journaal" VALUES(10, 10, 2008, '2008-06-30', 2, 'rabo', 'Bankafschrift: 124', 0, '', '', 'rabo 6', '');
INSERT INTO "journaal" VALUES(11, 11, 2008, '2008-06-10', 3, 'inkoop', '0623477347 - juni 2008', 0, 'hi', '5951011.73', '', '');
INSERT INTO "journaal" VALUES(12, 12, 2008, '2008-06-25', 3, 'inkoop', '0643795777 - 16-6/22-7', 0, 'tmobile', '901070203247', '', '');
INSERT INTO "journaal" VALUES(13, 13, 2008, '2008-06-26', 3, 'inkoop', 'BelBasis + ADSL 1-7/31-8', 0, 'kpn', '0182611557-0307', '', '');
INSERT INTO "journaal" VALUES(14, 14, 2008, '2008-07-07', 3, 'inkoop', 'ADSL Basic 6-7/6-8', 0, 'xs4all', '24102215', '', '');
INSERT INTO "journaal" VALUES(15, 15, 2008, '2008-07-03', 3, 'inkoop', '0651425883 - 3-7/2-8', 0, 'orange', '00001505010708', '', '');
INSERT INTO "journaal" VALUES(16, 16, 2008, '2008-07-10', 3, 'inkoop', '0623477347 - juli 08', 0, 'hi', '5951011.74', '', '');
INSERT INTO "journaal" VALUES(17, 17, 2008, '2008-07-28', 3, 'inkoop', '0623477347 - 23-7/23-8', 0, 'tmobile', '901071514459', '', '');
INSERT INTO "journaal" VALUES(18, 18, 2008, '2008-06-04', 3, 'inkoop', 'IMac SN.VM823WHT0KM', 0, 'apple', '9044011895', '', '');
INSERT INTO "journaal" VALUES(19, 19, 2008, '2008-08-11', 3, 'inkoop', 'Retour wgs. afronding Hi abonnement', 0, 'hi', '5951011.75', '', '');
INSERT INTO "journaal" VALUES(20, 20, 2008, '2008-08-03', 3, 'inkoop', '0651425883 - 3-8/2-9', 0, 'orange', '00005256140808', '', '');
INSERT INTO "journaal" VALUES(21, 21, 2008, '2008-08-07', 3, 'inkoop', 'ADSL Basic 6-8/6-9', 0, 'xs4all', '24421784', '', '');
INSERT INTO "journaal" VALUES(22, 22, 2008, '2008-08-26', 3, 'inkoop', '0623477347 - 23-8/23-9', 0, 'tmobile', '901072876695', '', '');
INSERT INTO "journaal" VALUES(23, 23, 2008, '2008-08-27', 3, 'inkoop', 'BelBasis + ADSL 1-9/31-10', 0, 'kpn', '0182611557-0309', '', '');
INSERT INTO "journaal" VALUES(24, 24, 2008, '2008-09-07', 3, 'inkoop', 'ADSL Basic 6-9/6-10', 0, 'xs4all', '24747064', '', '');
INSERT INTO "journaal" VALUES(25, 25, 2008, '2008-09-03', 3, 'inkoop', '0651425883 - 3-9/2-10', 0, 'orange', '00001913360908', '', '');
INSERT INTO "journaal" VALUES(26, 26, 2008, '2008-09-25', 3, 'inkoop', '0623477347 - 23-9/22-10', 0, 'tmobile', '901074320344', '', '');
INSERT INTO "journaal" VALUES(27, 27, 2008, '2008-10-07', 3, 'inkoop', 'ADSL Basic 6-10/6-11', 0, 'xs4all', '25062372', '', '');
INSERT INTO "journaal" VALUES(28, 28, 2008, '2008-10-03', 3, 'inkoop', '0651425883 - 3-10/2-11', 0, 'orange', '00002073751008', '', '');
INSERT INTO "journaal" VALUES(29, 29, 2008, '2008-06-17', 2, 'inkoop', 'MacAir sn: W8820004Y51', 0, 'apple', '9044127937', '', '');
INSERT INTO "journaal" VALUES(30, 30, 2008, '2008-10-23', 3, 'memo', 'Correctie bankst.124 Sigma Laservision', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(31, 31, 2008, '2008-09-30', 3, 'kas', 'Kasbetalingen 3e kwartaal 2008', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(32, 32, 2008, '2008-07-11', 3, 'verkoop', 'Workshop graffiti', 0, 'vonk', '8291', '', '');
INSERT INTO "journaal" VALUES(33, 33, 2008, '2008-04-14', 3, 'verkoop', 'Div werkzaamheden KCW site', 0, 'kcw', '8032', '', '');
INSERT INTO "journaal" VALUES(34, 34, 2008, '2008-08-25', 3, 'verkoop', 'Spuitwerkzaamheden', 0, 'jjmidholl', '8292', '', '');
INSERT INTO "journaal" VALUES(35, 35, 2008, '2008-07-18', 3, 'rabo', 'Bankafschrift: 125', 0, '', '', 'rabo 7', '');
INSERT INTO "journaal" VALUES(36, 36, 2008, '2008-08-15', 3, 'rabo', 'Bankafschrift: 126', 0, '', '', 'rabo 8', '');
INSERT INTO "journaal" VALUES(37, 37, 2008, '2008-08-11', 3, 'inkoop', 'Domeinregistraties', 0, 'transip', 'F2008102940', '', '');
INSERT INTO "journaal" VALUES(38, 38, 2008, '2008-09-01', 3, 'inkoop', 'Domeinregistraties', 0, 'transip', 'F2008111105', '', '');
INSERT INTO "journaal" VALUES(39, 39, 2008, '2008-09-16', 3, 'inkoop', 'Domeinregistraties', 0, 'transip', 'F2008118657', '', '');
INSERT INTO "journaal" VALUES(40, 40, 2008, '2008-09-09', 4, 'inkoop', 'Domeinregistraties', 0, 'transip', 'F2008124681', '', '');
INSERT INTO "journaal" VALUES(41, 41, 2008, '2008-09-26', 3, 'rabo', 'Bankafschrift: 127', 0, '', '', 'rabo 9', '');
INSERT INTO "journaal" VALUES(42, 42, 2008, '2008-09-30', 3, 'memo', 'Prive naar Kassaldo', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(43, 43, 2008, '2008-12-31', 4, 'kas', 'Kasbetalingen 4e kwartaal 2008', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(44, 44, 2008, '2008-10-27', 4, 'inkoop', '0623477347 - 23-10/22-11', 0, 'tmobile', '01075800403', '', '');
INSERT INTO "journaal" VALUES(45, 45, 2008, '2008-10-27', 4, 'inkoop', 'BelBasis + ADSL 1-11/31-12', 0, 'kpn', '0182611557-0311', '', '');
INSERT INTO "journaal" VALUES(46, 46, 2008, '2008-08-12', 4, 'verkoop', 'Onderhoud 3e kwartaal', 0, 'kcw', '28045', '', '');
INSERT INTO "journaal" VALUES(47, 47, 2008, '2008-10-28', 4, 'verkoop', 'Onderhoud 4e kwartaal', 0, 'kcw', '28095', '', '');
INSERT INTO "journaal" VALUES(48, 48, 2008, '2008-11-01', 4, 'inkoop', 'Spuitmateriaal', 0, 'vanbeek', '246230', '', '');
INSERT INTO "journaal" VALUES(49, 49, 2008, '2008-11-07', 4, 'inkoop', 'ADSL Basic 6-11/6-12', 0, 'xs4all', '25378236', '', '');
INSERT INTO "journaal" VALUES(50, 50, 2008, '2008-11-06', 4, 'inkoop', 'Mediatablet', 0, 'conrad', '9541946926', '', '');
INSERT INTO "journaal" VALUES(51, 51, 2008, '2008-11-03', 4, 'inkoop', '0651425886 - 3-11/2-12', 0, 'orange', '2418311108', '', '');
INSERT INTO "journaal" VALUES(52, 52, 2008, '2008-11-20', 4, 'inkoop', 'Security software Snitch for MacOSX', 0, 'diverse', 'U30298470', '', '');
INSERT INTO "journaal" VALUES(53, 53, 2008, '2008-11-26', 4, 'inkoop', '0623477347 - 23-11/22-12', 0, 'tmobile', '901077335109', '', '');
INSERT INTO "journaal" VALUES(54, 54, 2008, '2008-12-07', 4, 'inkoop', 'ADSL Basic 6-12/6-01', 0, 'xs4all', '25693810', '', '');
INSERT INTO "journaal" VALUES(55, 55, 2008, '2008-12-03', 4, 'inkoop', '0651425883 - 3-12/2-01', 0, 'orange', '00002171381208', '', '');
INSERT INTO "journaal" VALUES(56, 56, 2008, '2008-12-16', 4, 'inkoop', 'EveryDNS bijdrage DNS gebruik', 0, 'diverse', '16dec', '', '');
INSERT INTO "journaal" VALUES(57, 57, 2008, '2008-12-19', 4, 'inkoop', 'Cartridges', 0, '123inkt', '766013', '', '');
INSERT INTO "journaal" VALUES(58, 58, 2008, '2008-12-29', 4, 'inkoop', 'Flex zakelijk 23-11/22-12', 0, 'tmobile', '901078936459', '', '');
INSERT INTO "journaal" VALUES(59, 59, 2008, '2008-12-29', 4, 'inkoop', '8-12/20-12', 0, 'kpn', '0182611557-0301', '', '');
INSERT INTO "journaal" VALUES(60, 60, 2008, '2008-12-09', 4, 'inkoop', 'Zaalhuur presentatie', 0, 'vonk', '420050', '', '');
INSERT INTO "journaal" VALUES(62, 61, 2008, '2008-03-31', 1, 'memo', 'BTW egalisatie boeking periode 1', 0, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 1');
INSERT INTO "journaal" VALUES(63, 62, 2008, '2008-06-30', 2, 'memo', 'BTW egalisatie boeking periode 2', 0, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 2');
INSERT INTO "journaal" VALUES(64, 63, 2008, '2008-09-30', 3, 'memo', 'BTW egalisatie boeking periode 3', 0, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 3');
INSERT INTO "journaal" VALUES(65, 64, 2008, '2008-06-30', 2, 'memo', 'BTW teruggave 1e per. prive ontvangen', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(66, 65, 2008, '2008-06-30', 2, 'memo', 'Verschil periode1-aangifte', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(68, 2, 2009, '2009-01-01', 1, 'inkoop', 'Domeinregistraties', 0, 'transip', 'F2009000711', '', '');
INSERT INTO "journaal" VALUES(69, 66, 2008, '2008-10-24', 4, 'rabo', 'Bankafschrift: 128', 0, '', '', 'rabo 10', '');
INSERT INTO "journaal" VALUES(70, 67, 2008, '2008-11-21', 4, 'rabo', 'Bankafschrift: 129', 0, '', '', 'rabo 10', '');
INSERT INTO "journaal" VALUES(71, 68, 2008, '2008-11-01', 4, 'inkoop', 'Domeinregistratie multishots.nl', 0, 'transip', 'F2008141168', '', '');
INSERT INTO "journaal" VALUES(72, 69, 2008, '2008-11-20', 4, 'inkoop', 'Domeinregistratie ruudkooger.nl', 0, 'transip', 'F2008151040', '', '');
INSERT INTO "journaal" VALUES(73, 70, 2008, '2008-11-30', 4, 'inkoop', 'Domeinregistratie liekestraver.nl', 0, 'transip', 'F2008154146', '', '');
INSERT INTO "journaal" VALUES(74, 71, 2008, '2008-12-01', 4, 'inkoop', 'Domeinregistraties hid', 0, 'transip', 'F2008155218', '', '');
INSERT INTO "journaal" VALUES(75, 72, 2008, '2008-12-19', 4, 'inkoop', 'Spuitmateriaal', 0, 'henx', '3248', '', '');
INSERT INTO "journaal" VALUES(76, 73, 2008, '2008-12-19', 4, 'rabo', 'Bankafschrift: 130', 0, '', '', 'rabo 130', '');
INSERT INTO "journaal" VALUES(77, 3, 2009, '2009-01-03', 1, 'inkoop', '0651425883 - 3-1/2-2', 0, 'orange', '2004820109', '', '');
INSERT INTO "journaal" VALUES(78, 4, 2009, '2009-01-01', 1, 'kas', 'Kasbetalingen 1e kwartaal 2009', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(79, 5, 2009, '2009-01-24', 1, 'pin', 'Brandstof kachel kantoor', 0, 'Fixet de Bas', '570', '', '');
INSERT INTO "journaal" VALUES(80, 6, 2009, '2009-01-24', 1, 'pin', 'Vaktijdschrift', 0, 'AH', '90617', '', '');
INSERT INTO "journaal" VALUES(81, 74, 2008, '2008-12-31', 4, 'memo', 'BTW egalisatie boeking periode 4', 0, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 4');
INSERT INTO "journaal" VALUES(82, 7, 2009, '2009-01-07', 1, 'inkoop', 'ADSL Basic 6-01/6-02', 0, 'xs4all', '26008394', '', '');
INSERT INTO "journaal" VALUES(83, 75, 2008, '2008-12-31', 5, 'memo', 'Afschrijvingen', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(84, 76, 2008, '2008-12-31', 4, 'memo', 'Prive naar kas', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(85, 77, 2008, '2008-12-31', 5, 'memo', 'Huisvesting huur deel kantoor en machineruimte', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(86, 1, 2009, '2009-01-01', 0, 'begin', 'Beginbalans', 0, '', '', 'begin', 'Automatische boeking van beginbalans in het nieuwe boekjaar');
INSERT INTO "journaal" VALUES(87, 8, 2009, '2009-01-27', 1, 'inkoop', '23-12/22-01', 0, 'tmobile', '901080575403', '', '');
INSERT INTO "journaal" VALUES(88, 9, 2009, '2009-02-04', 1, 'inkoop', 'Domeinregistratie rampenoverleven.nl', 0, 'transip', '200900014426', '', '');
INSERT INTO "journaal" VALUES(89, 10, 2009, '2009-02-04', 1, 'verkoop', 'Onderhoud 1e kwartaal', 0, 'kcw', '29010', '', '');
INSERT INTO "journaal" VALUES(90, 11, 2009, '2009-01-01', 1, 'memo', 'Orange prive betaald', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(91, 12, 2009, '2009-01-01', 1, 'memo', 'Betalingsverschil KPN fact 0307', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(92, 13, 2009, '2009-02-04', 1, 'inkoop', 'Jaarlijkse bijdrage - 2009', 0, 'kvk', '929044932', '', '');
INSERT INTO "journaal" VALUES(93, 14, 2009, '2009-02-03', 1, 'inkoop', '0651425883 - 3-2/2-3', 0, 'orange', '1867240209', '', '');
INSERT INTO "journaal" VALUES(94, 15, 2009, '2009-02-07', 1, 'inkoop', 'ADSL Basic 6-02/6-03', 0, 'xs4all', '26326804', '', '');
INSERT INTO "journaal" VALUES(95, 16, 2009, '2009-02-26', 1, 'inkoop', '0623477347 - 23-02/22-03', 0, 'tmobile', '901082279965', '', '');
INSERT INTO "journaal" VALUES(96, 17, 2009, '2009-03-03', 1, 'inkoop', '0623477347 - 03-03/02-04', 0, 'orange', '2128460309', '', '');
INSERT INTO "journaal" VALUES(97, 18, 2009, '2009-03-07', 1, 'inkoop', 'ADSL Basic 6-03/6-04', 0, 'xs4all', '26643291', '', '');
INSERT INTO "journaal" VALUES(98, 19, 2009, '2009-02-26', 1, 'inkoop', 'Credit wgs eindafrekening', 0, 'kpn', '0182611557-303', '', '');
INSERT INTO "journaal" VALUES(99, 20, 2009, '2009-03-26', 1, 'inkoop', '0623477347 - 23-2/22-3', 0, 'tmobile', '901084029752', '', '');
INSERT INTO "journaal" VALUES(100, 21, 2009, '2009-04-01', 2, 'inkoop', 'Domeinen literature.nu, literatuurmetvrienden.nl', 0, 'transip', 'F0000.2009.0003.', '', '');
INSERT INTO "journaal" VALUES(101, 22, 2009, '2009-04-03', 2, 'inkoop', '0651425883 3-4/2-5', 0, 'orange', '2104090409', '', '');
INSERT INTO "journaal" VALUES(102, 23, 2009, '2009-04-07', 2, 'inkoop', 'ADSL Basic 6-4/6-5', 0, 'xs4all', '26957120', '', '');
INSERT INTO "journaal" VALUES(103, 24, 2009, '2009-04-01', 2, 'kas', 'Kasbetalingen 2e kwartaal 2009', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(105, 25, 2009, '2009-04-15', 2, 'inkoop', 'raov.nl', 0, 'transip', '20900036492', '', '');
INSERT INTO "journaal" VALUES(106, 26, 2009, '2009-04-13', 2, 'inkoop', 'Flitsset', 0, 'foka', '4986609', '', '');
INSERT INTO "journaal" VALUES(107, 27, 2009, '2009-04-20', 2, 'inkoop', 'Kantoormateriaal', 0, 'officec', '47062', '', '');
INSERT INTO "journaal" VALUES(108, 28, 2009, '2009-04-28', 2, 'inkoop', '0623477347 23-4/22-5', 0, 'tmobile', '901085828341', '', '');
INSERT INTO "journaal" VALUES(109, 29, 2009, '2009-03-31', 1, 'memo', 'BTW egalisatie boeking periode 1', 0, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 1');
INSERT INTO "journaal" VALUES(110, 30, 2009, '2009-07-01', 3, 'kas', 'Kasbetalingen 3e kwartaal 2009', 0, '', '', '', '');
INSERT INTO "journaal" VALUES(111, 31, 2009, '2009-05-03', 2, 'inkoop', '0651425883 3-5/2-6', 0, 'orange', '1368100509', '', '');
INSERT INTO "journaal" VALUES(112, 32, 2009, '2009-05-07', 2, 'inkoop', 'ADSL Basic 6-5/6-6', 0, 'xs4all', '27271652', '', '');
INSERT INTO "journaal" VALUES(113, 33, 2009, '2009-05-07', 2, 'inkoop', 'Spuitmateriaal', 0, 'henx', '3528', '', '');
INSERT INTO "journaal" VALUES(114, 34, 2009, '2009-05-19', 2, 'inkoop', 'Drukwerk folders', 0, 'dwdeal', 'F2009014731', '', '');
INSERT INTO "journaal" VALUES(115, 35, 2009, '2009-05-28', 2, 'inkoop', '0623477347 23-5/22-6', 0, 'tmobile', '901087680801', '', '');
INSERT INTO "journaal" VALUES(116, 36, 2009, '2009-06-07', 2, 'inkoop', 'ADSL Basic 6-6/6-7', 0, 'xs4all', '27584261', '', '');
INSERT INTO "journaal" VALUES(117, 37, 2009, '2009-06-03', 2, 'inkoop', '0651425883 3-6/2-7', 0, 'orange', '959800609', '', '');
INSERT INTO "journaal" VALUES(118, 38, 2009, '2009-06-08', 2, 'inkoop', 'Inkt printer', 0, '123inkt', '925101', '', '');
INSERT INTO "journaal" VALUES(119, 39, 2009, '2009-06-29', 2, 'inkoop', '0623477347 23-6/22-7', 0, 'tmobile', '901089575053', '', '');
INSERT INTO "journaal" VALUES(120, 40, 2009, '2009-06-29', 2, 'inkoop', 'Computermateriaal', 0, 'conrad', '9542255322', '', '');
INSERT INTO "journaal" VALUES(121, 41, 2009, '2009-04-17', 2, 'verkoop', 'Muurschilderingen', 0, 'woonpmh', '29014', '', '');
INSERT INTO "journaal" VALUES(122, 42, 2009, '2009-04-26', 2, 'verkoop', 'Workshop', 0, 'woonpmh', '29016', '', '');
INSERT INTO "journaal" VALUES(123, 43, 2009, '2009-05-07', 2, 'verkoop', 'Workshop', 0, 'sppernis', '29018', '', '');
INSERT INTO "journaal" VALUES(124, 44, 2009, '2009-05-11', 2, 'verkoop', 'Onderhoud 2e kwartaal', 0, 'kcw', '29019', '', '');
INSERT INTO "journaal" VALUES(125, 45, 2009, '2009-06-15', 2, 'verkoop', 'Schilderij Beatrix theater', 0, 'kunstig', '29025', '', '');
INSERT INTO "journaal" VALUES(126, 46, 2009, '2009-06-20', 2, 'verkoop', 'Workshop', 0, 'sppernis', '29026', '', '');
INSERT INTO "journaal" VALUES(127, 47, 2009, '2009-06-30', 2, 'memo', 'BTW egalisatie boeking periode 2', 0, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 2');
INSERT INTO "journaal" VALUES(128, 48, 2009, '2009-08-07', 3, 'inkoop', 'ADSL Basic 6-8/6-9', 0, 'xs4all', '28223309', '', '');
INSERT INTO "journaal" VALUES(129, 49, 2009, '2009-08-27', 3, 'inkoop', '0623477347 23-8/22-9', 0, 'tmobile', '901093352660', '', '');
INSERT INTO "journaal" VALUES(130, 50, 2009, '2009-08-18', 3, 'inkoop', 'Plusvermelding', 0, 'marktp', '200958603', '', '');
INSERT INTO "journaal" VALUES(131, 51, 2009, '2009-08-14', 3, 'inkoop', '0623477347 23-7/22-8', 0, 'tmobile', '901091433021', '', '');
INSERT INTO "journaal" VALUES(132, 52, 2009, '2009-07-07', 3, 'inkoop', 'ADSL Basic 6-7/6-8', 0, 'xs4all', '27898308', '', '');
INSERT INTO "journaal" VALUES(133, 53, 2009, '2009-09-07', 3, 'inkoop', 'Green Laser projector', 0, 'rgblaser', '1197', '', '');
INSERT INTO "journaal" VALUES(134, 54, 2009, '2009-09-07', 3, 'inkoop', 'ADSL Basic 6-9/6-10', 0, 'xs4all', '28545703', '', '');
INSERT INTO "journaal" VALUES(135, 55, 2009, '2009-09-28', 3, 'inkoop', '0623477347 23-9/22-10', 0, 'tmobile', '901095390990', '', '');
INSERT INTO "journaal" VALUES(136, 56, 2009, '2009-10-05', 4, 'inkoop', 'DMX kabels en sturing', 0, 'j&h', '47140', '', '');
INSERT INTO "journaal" VALUES(137, 57, 2009, '2009-10-06', 4, 'inkoop', 'Spuitmateriaal', 0, 'kramerart', '4039', '', '');
INSERT INTO "journaal" VALUES(138, 58, 2009, '2009-10-07', 4, 'inkoop', 'ADSL Basic 6-10/6-11', 0, 'xs4all', '28852349', '', '');
INSERT INTO "journaal" VALUES(139, 59, 2009, '2009-10-27', 4, 'inkoop', '0623477347 23-10/22-11', 0, 'tmobile', '901097465083', '', '');
INSERT INTO "journaal" VALUES(140, 60, 2009, '2009-08-06', 3, 'verkoop', 'Onderhoud 3e kwartaal', 0, 'kcw', '29042', '', '');
INSERT INTO "journaal" VALUES(141, 61, 2009, '2009-09-05', 3, 'verkoop', 'Workshop', 0, 'jjmidholl', '29028', '', '');
INSERT INTO "journaal" VALUES(142, 62, 2009, '2009-09-30', 3, 'memo', 'BTW egalisatie boeking periode 3', 0, '', '', 'egalisatie', 'Automatische BTW egalisatie boeking getriggerd door BTW consolidatie van periode 3');
INSERT INTO "journaal" VALUES(143, 63, 2009, '2009-12-31', 4, 'kas', 'Kasbetalingen 4e kwartaal 2009', 91.33, '', '', '', '');

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "meta"
--

DROP TABLE IF EXISTS "meta";
CREATE TABLE IF NOT EXISTS "meta" (
  "key" varchar(64) ,
  "value" text default ''
);

  CREATE UNIQUE INDEX IF NOT EXISTS "key" ON "meta" ("key");
--
-- Gegevens worden uitgevoerd voor tabel "meta"
--

INSERT INTO "meta" VALUES('versie', '1.0.0');
INSERT INTO "meta" VALUES('sqlversie', '1.3.2');
INSERT INTO "meta" VALUES('platform', 'linux');

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "pinbetalingen"
--

DROP TABLE IF EXISTS "pinbetalingen";
CREATE TABLE IF NOT EXISTS "pinbetalingen" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" int(11)  default '0',
  "boekjaar" int(11)  default '0',
  "datum" date  default '0000-00-00',
  "omschrijving" varchar(128)  default '',
  "factuurbedrag" decimal(12,2)  default '0.00',
  "relatiecode" varchar(32)  default '',
  "relatieid" int(11)  default '0',
  "factuurnummer" varchar(16)  default '' ,
  "voldaan" decimal(12,2)  default '0.00',
  "betaaldatum" date  default '0000-00-00'
);

  CREATE UNIQUE INDEX IF NOT EXISTS "idboekjaar" ON "pinbetalingen" ("id","boekjaar");
--
-- Gegevens worden uitgevoerd voor tabel "pinbetalingen"
--

INSERT INTO "pinbetalingen" VALUES(1, 79, 2009, '2009-01-24', 'Brandstof kachel kantoor', 43.95, 'Fixet de Bas', 0, '570', 0.00, '0000-00-00');
INSERT INTO "pinbetalingen" VALUES(2, 80, 2009, '2009-01-24', 'Vaktijdschrift', 5.99, 'AH', 0, '90617', 0.00, '0000-00-00');

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "stamgegevens"
--

DROP TABLE IF EXISTS "stamgegevens";
CREATE TABLE IF NOT EXISTS "stamgegevens" (
  "id" INTEGER PRIMARY KEY,
  "boekjaar" INTEGER NOT NULL,
  "code" char(1)  default '' ,
  "subcode" int(11) default 0 ,
  "label" varchar(128)  default '',
  "naam" varchar(32)  default '',
  "value" varchar(255)  default '',
  "tekst" text default ''
);

--
-- Gegevens worden uitgevoerd voor tabel "stamgegevens"
--

INSERT INTO "stamgegevens" VALUES(1, 2008, 'a', 1, 'Naam administratie', 'adminnaam', 'ML design & techniek', '');
INSERT INTO "stamgegevens" VALUES(2, 2008, 'a', 3, 'Contactgegevens', 'adminomschrijving', 'ML design & techniek\r\natt. Frank Kooger\r\nSirius 18\r\n2743 ME Waddinxveen\r\n\r\ntelefoon: 0182 611557\r\nfax: 0182 611557\r\nmobiel: 062 3477347\r\nemail: frank@ml-design.com', '');
INSERT INTO "stamgegevens" VALUES(3, 2008, 'b', 1, 'Lopend jaar', 'lopendjaar', '2009', '');
INSERT INTO "stamgegevens" VALUES(4, 2008, 'b', 3, 'Periode van', 'periodevan', '1', '');
INSERT INTO "stamgegevens" VALUES(5, 2008, 'b', 5, 'Periode tot', 'periodetot', '4', '');
INSERT INTO "stamgegevens" VALUES(6, 2008, 'b', 7, 'Extra periode', 'periodeextra', '5', '');
INSERT INTO "stamgegevens" VALUES(22, 2008, 'e', 25, 'Verkopen verlegde BTW', 'rkg_verkoopverlegd', '0', '');
INSERT INTO "stamgegevens" VALUES(21, 2008, 'e', 5, 'Rekening bankboek', 'rkg_bankboek', '1050', '');
INSERT INTO "stamgegevens" VALUES(20, 2008, 'e', 3, 'Rekening kasboek', 'rkg_kasboek', '1000', '');
INSERT INTO "stamgegevens" VALUES(19, 2008, 'e', 13, 'Rekening pinbetalingen', 'rkg_pinbetalingen', '2020', '');
INSERT INTO "stamgegevens" VALUES(18, 2008, 'g', 3, 'BTW percentage laag', 'btwlaag', '6', '');
INSERT INTO "stamgegevens" VALUES(17, 2008, 'g', 1, 'BTW percentage hoog', 'btwhoog', '19', '');
INSERT INTO "stamgegevens" VALUES(14, 2008, '', 0, 'Verschillenrekening', 'rkg_verschillen', '2500', '');
INSERT INTO "stamgegevens" VALUES(13, 2008, 'e', 17, 'Rekening BTW verkoop laag', 'rkg_btwverkooplaag', '2120', '');
INSERT INTO "stamgegevens" VALUES(12, 2008, 'e', 15, 'Rekening BTW verkoop hoog', 'rkg_btwverkoophoog', '2110', '');
INSERT INTO "stamgegevens" VALUES(8, 2008, 'e', 9, 'Rekening debiteuren', 'rkg_debiteuren', '1200', '');
INSERT INTO "stamgegevens" VALUES(9, 2008, 'e', 11, 'Rekening crediteuren', 'rkg_crediteuren', '1600', '');
INSERT INTO "stamgegevens" VALUES(10, 2008, 'e', 21, 'Rekening BTW inkopen', 'rkg_btwinkopen', '2200', '');
INSERT INTO "stamgegevens" VALUES(7, 2008, 'e', 1, 'Rekening kapitaal/privÃ©', 'rkg_kapitaalprive', '900', '');
INSERT INTO "stamgegevens" VALUES(23, 2008, 'e', 19, 'Rekening BTW Privegebruik', 'rkg_btwprivegebruik', '0', '');
INSERT INTO "stamgegevens" VALUES(24, 2008, 'e', 27, 'Rekening Diverse Opbrengsten', 'rkg_divopbrengsten', '8900', '');
INSERT INTO "stamgegevens" VALUES(25, 2008, 'e', 23, 'Rekening betaalde BTW', 'rkg_betaaldebtw', '2300', 'De tussenrekening waarop enerzijds het saldo van de BTW rekeningen en anderszijds de BTW afdracht wordt geboekt.');
INSERT INTO "stamgegevens" VALUES(26, 2008, 'e', 7, 'Rekening Prive rekeningcourant', 'rkg_priverekeningcourant', '1060', '');
INSERT INTO "stamgegevens" VALUES(27, 2008, 'e', 30, 'Omslagrekening Balans/VW', 'omslag', '4000', 'Bepaal vanaf welk rekeningnummer de Balansrekeningen eindigen en de VenW rekeningen beginnen.');
INSERT INTO "stamgegevens" VALUES(28, 2008,'e',26,'Verkopen geen BTW','rkg_verkoopgeenbtw','0','');

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "verkoopfacturen"
--

DROP TABLE IF EXISTS "verkoopfacturen";
CREATE TABLE IF NOT EXISTS "verkoopfacturen" (
  "id" INTEGER PRIMARY KEY,
  "journaalid" int(11)  default '0',
  "boekjaar" int(11)  default '0',
  "datum" date  default '0000-00-00',
  "omschrijving" varchar(128)  default '',
  "factuurbedrag" decimal(12,2)  default '0.00',
  "relatiecode" varchar(32)  default '',
  "relatieid" int(11)  default '0',
  "factuurnummer" varchar(16)  default '' ,
  "voldaan" decimal(12,2)  default '0.00',
  "betaaldatum" date  default '0000-00-00'
);

  CREATE UNIQUE INDEX IF NOT EXISTS "idboekjaar" ON "verkoopfacturen" ("id","boekjaar");
--
-- Gegevens worden uitgevoerd voor tabel "verkoopfacturen"
--

INSERT INTO "verkoopfacturen" VALUES(1, 32, 2008, '2008-07-11', 'Workshop graffiti', 214.20, 'vonk', 3, '8291', 214.20, '2008-07-16');
INSERT INTO "verkoopfacturen" VALUES(2, 33, 2008, '2008-04-14', 'Div werkzaamheden KCW site', 8663.20, 'kcw', 1, '8032', 8663.20, '2008-06-23');
INSERT INTO "verkoopfacturen" VALUES(3, 34, 2008, '2008-08-25', 'Spuitwerkzaamheden', 160.65, 'jjmidholl', 6, '8292', 160.65, '2008-09-12');
INSERT INTO "verkoopfacturen" VALUES(4, 46, 2008, '2008-08-12', 'Onderhoud 3e kwartaal', 2427.60, 'kcw', 1, '28045', 2427.60, '2008-10-31');
INSERT INTO "verkoopfacturen" VALUES(5, 47, 2008, '2008-10-28', 'Onderhoud 4e kwartaal', 2427.60, 'kcw', 1, '28095', 2427.60, '2008-11-17');
INSERT INTO "verkoopfacturen" VALUES(6, 89, 2009, '2009-02-04', 'Onderhoud 1e kwartaal', 3034.50, 'kcw', 1, '29010', 0.00, '0000-00-00');
INSERT INTO "verkoopfacturen" VALUES(7, 121, 2009, '2009-04-17', 'Muurschilderingen', 481.95, 'woonpmh', 9, '29014', 0.00, '0000-00-00');
INSERT INTO "verkoopfacturen" VALUES(8, 122, 2009, '2009-04-26', 'Workshop', 311.78, 'woonpmh', 9, '29016', 0.00, '0000-00-00');
INSERT INTO "verkoopfacturen" VALUES(9, 123, 2009, '2009-05-07', 'Workshop', 285.60, 'sppernis', 7, '29018', 0.00, '0000-00-00');
INSERT INTO "verkoopfacturen" VALUES(10, 124, 2009, '2009-05-11', 'Onderhoud 2e kwartaal', 2427.60, 'kcw', 1, '29019', 0.00, '0000-00-00');
INSERT INTO "verkoopfacturen" VALUES(11, 125, 2009, '2009-06-15', 'Schilderij Beatrix theater', 210.04, 'kunstig', 8, '29025', 0.00, '0000-00-00');
INSERT INTO "verkoopfacturen" VALUES(12, 126, 2009, '2009-06-20', 'Workshop', 348.67, 'sppernis', 7, '29026', 0.00, '0000-00-00');
INSERT INTO "verkoopfacturen" VALUES(13, 140, 2009, '2009-08-06', 'Onderhoud 3e kwartaal', 2427.60, 'kcw', 1, '29042', 0.00, '0000-00-00');
INSERT INTO "verkoopfacturen" VALUES(14, 141, 2009, '2009-09-05', 'Workshop', 476.00, 'jjmidholl', 6, '29028', 0.00, '0000-00-00');

-- --------------------------------------------------------

--
-- Tabel structuur voor tabel "voorkeuren"
--

DROP TABLE IF EXISTS "voorkeuren";
CREATE TABLE IF NOT EXISTS "voorkeuren" (
  "id" INTEGER PRIMARY KEY,
  "label" varchar(128)  default '',
  "naam" varchar(32)  default '',
  "value" varchar(255)  default ''
);

--
-- Gegevens worden uitgevoerd voor tabel "voorkeuren"
--

INSERT INTO "voorkeuren" VALUES(1, 'Facturen tonen in debiteuren/crediteurenstam', 'facturen_tonen', 'true');
INSERT INTO "voorkeuren" VALUES(2, 'Achtergrondkleur hoofdscherm (overschrijft config)', 'achtergrondkleur', '');


//
// Table structure for table "notities"
//
$struct['notities'] =<<<EOT

CREATE TABLE  "notities" (
  "id" INTEGER PRIMARY KEY,
  "tabel" VARCHAR(32) default '',
  "tabelid" INTEGER default '0' ,
  "tekst" text default ''
) ;
EOT;

INSERT INTO "notities" VALUES(1, 'btwaangiftes', 13, 'Door handmatige verwerking van de BTW cijfers wijkt het aangiftebedrag af van het boekingsbedrag.');
--
-- VIEWS
--

COMMIT;
