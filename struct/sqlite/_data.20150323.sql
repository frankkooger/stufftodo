--
-- PostgreSQL database dump
--


--
-- Data for Name: btwkeys; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO btwkeys VALUES (1, 'rkg_btwverkoophoog', 'btwv', 1, '1a', '1a', 'Leveringen/diensten belast met hoog tarief', 'BTW bedragen verkopen hoog', 'Verkopen hoog', 2008, 1);
INSERT INTO btwkeys VALUES (2, 'rkg_btwverkooplaag', 'btwv', 1, '1b', '1b', 'Leveringen/diensten belast met laag tarief', 'BTW bedragen verkopen laag', 'Verkopen laag', 2008, 1);
INSERT INTO btwkeys VALUES (3, 'rkg_btwoverig', 'btwv', 0, '1c', '1c', 'Leveringen/diensten belast met overige tarieven behalve 0%', 'BTW bedragen verkopen overig', 'Verkopen overig', 2008, 1);
INSERT INTO btwkeys VALUES (4, 'rkg_btwprivegebruik', 'btwv', 1, '1d', '1d', 'Privégebruik', 'BTW bedragen privégebruik', 'BTW privégebruik', 2008, 1);
INSERT INTO btwkeys VALUES (5, 'verkopen_geenbtw', 'sal', 1, '1e', '1e', 'Leveringen/diensten belast met 0% of niet bij u belast', 'Verkopen 0% BTW', '', 2008, 1);
INSERT INTO btwkeys VALUES (6, 'verkopen_verlegdebtw', 'sal', 1, '1e', '', '', 'Verkopen verlegde BTW', '', 2008, 1);
INSERT INTO btwkeys VALUES (7, 'verkopen_partbtwmateriaal', 'sal', 1, '1a', '', '', 'Verkopen part materialen', '', 2008, 1);
INSERT INTO btwkeys VALUES (8, 'rkg_btwnaarmijverlegd', 'btwv', 0, '2a', '2a', 'Leveringen/diensten waarbij de heffing van BTW naar u is verlegd', 'BTW bedragen naar mij verlegd', 'BTW naar mij verlegd', 2008, 1);
INSERT INTO btwkeys VALUES (9, 'verkopen_buiteneu', 'sal', 0, '3a', '3a', 'Leveringen naar landen buiten de EU (uitvoer)', 'Verkopen buiten EU', '', 2008, 1);
INSERT INTO btwkeys VALUES (10, 'verkopen_binneneu', 'sal', 1, '3b', '3b', 'Leveringen naar/diensten in landen binnen de EU', 'Verkopen binnen EU', '', 2008, 1);
INSERT INTO btwkeys VALUES (12, 'verkopen_installatieeu', 'sal', 0, '3c', '3c', 'Installatie/afstandsverkopen binnen de EU', 'Verkopen installaties binnen EU', '', 2008, 1);
INSERT INTO btwkeys VALUES (15, 'subtotaal5a', 'sub', 1, '5a', '5a', 'Verschuldigde omzetbelasting: rubrieken 1 tm 4', '', '', 2008, 1);
INSERT INTO btwkeys VALUES (16, 'rkg_btwinkopen', 'btwi', 1, '5b', '5b', 'Voorbelasting', 'BTW bedragen inkopen', 'Inkopen', 2008, 1);
INSERT INTO btwkeys VALUES (17, 'rkg_btwautokosten', 'btwi2', 1, '5b', '', 'Voorbelasting autokosten', 'BTW bedragen autokosten', 'BTW autokosten', 2008, 1);
INSERT INTO btwkeys VALUES (11, 'rkg_btwpartmateriaal', 'btwi80', 1, '5b', '', 'Voorbelasting partiele materialen', 'BTW bedragen partiele materialen', 'BTW part.mat.', 2008, 1);
INSERT INTO btwkeys VALUES (18, 'subtotaal5c', 'sub', 1, '5c', '5c', 'Subtotaal: 5a min 5b', '', '', 2008, 1);
INSERT INTO btwkeys VALUES (19, 'rkg_5dregeling', 'btw', 1, '5d', '5d', 'Vermindering volgens kleinondernemersregeling', '', '', 2008, 1);
INSERT INTO btwkeys VALUES (20, 'totaal5e', 'tot', 1, '5e', '5e', 'Totaal', '', '', 2008, 1);
INSERT INTO btwkeys VALUES (21, 'rkg_betaaldebtw', 'betbtw', 1, '', '', '', 'Rekening betaalde BTW', '', 2008, 1);
INSERT INTO btwkeys VALUES (22, 'dervingbtw_partbtwmateriaal', 'calc', 1, '', '', '', 'Derving BTW partiele materialen', '', 2008, 1);
INSERT INTO btwkeys VALUES (23, 'inkopen_partbtwmateriaal', 'sal', 1, '', '', '', 'Inkopen partiele materialen', '', 2008, 1);
INSERT INTO btwkeys VALUES (24, 'verkopen_vrijgesteldebtw', 'sal', 1, '1e', '', '', 'Verkopen vrijgestelde BTW', '', 2008, 1);
INSERT INTO btwkeys VALUES (25, 'verkopen_privegebruik', 'sal', 1, '1d', '', '', 'Omzet privégebruik', '', 2008, 1);
INSERT INTO btwkeys VALUES (26, 'verkopen_hoog', 'sal', 1, '1a', '', '', 'Verkopen BTW hoog', '', 2008, 1);
INSERT INTO btwkeys VALUES (27, 'verkopen_laag', 'sal', 1, '1b', '', '', 'Verkopen BTW laag', '', 2008, 1);
INSERT INTO btwkeys VALUES (28, 'rkg_btwpartmateriaal', 'btwi80', 0, '5b', '', 'Voorbelasting partiele materialen', 'BTW bedragen partiele materialen', 'BTW part.mat.', 2013, 1);
INSERT INTO btwkeys VALUES (29, 'rkg_btwpartmateriaal', 'btwi80', 0, '5b', '', 'Voorbelasting partiele materialen', 'BTW bedragen partiele materialen', 'BTW part.mat.', 2012, 0);
INSERT INTO btwkeys VALUES (13, 'rkg_btwbuiteneu', 'btwv', 0, '4a', '4a', 'Leveringen/diensten uit landen buiten de EU', 'BTW bedragen inkopen buiten EU', 'Levering van buiten EU', 2008, 1);
INSERT INTO btwkeys VALUES (14, 'inkopen_binneneu', 'sal', 1, '4b', NULL, 'Leveringen/diensten uit landen binnen de EU', 'Inkopen binnen EU', NULL, 2013, 1);
INSERT INTO btwkeys VALUES (30, 'rkg_btwinkopeneuontv', 'btwv', 1, '5b', '', 'Voorbelasting verwerving binnen EU', 'BTW bedragen inkopen EU te ontvangen', 'Inkopen binnen EU', 2013, 1);
INSERT INTO btwkeys VALUES (30, 'rkg_btwinkopeneubet', 'btwv', 1, '4b', '4b', 'Leveringen/diensten uit landen binnen de EU', 'BTW bedragen inkopen binnen EU te betalen', NULL, 2013, 1);


--
-- Data for Name: dagboeken; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO dagboeken VALUES (1, 'begin', 'begin', 'Beginbalans', 2130, 0, 0.00, 0, 2008, 1);
INSERT INTO dagboeken VALUES (2, 'memo', 'memo', 'Memoriaal', 2130, 0, 0.00, 0, 2008, 1);
INSERT INTO dagboeken VALUES (3, 'kas', 'kas', 'Kas en prive', 1060, 0, 0.00, 0, 2008, 1);
INSERT INTO dagboeken VALUES (8, 'bank', 'amro', 'Amrobank', 1050, 0, 0.00, 0, 2008, 1);
INSERT INTO dagboeken VALUES (5, 'inkoop', 'inkoop', 'Inkoopboek', 1600, 0, 0.00, 0, 2008, 1);
INSERT INTO dagboeken VALUES (6, 'verkoop', 'verkoop', 'Verkoopboek', 1200, 0, 0.00, 0, 2008, 1);
INSERT INTO dagboeken VALUES (7, 'pin', 'pin', 'Pinbetalingen', 2020, 0, 0.00, 0, 2008, 1);


--
-- Data for Name: grootboekstam; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO grootboekstam VALUES (102, 2012, 1, 4270, NULL, 3, 2, 0, 0, 'Reiskosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (153, 2013, 1, 5030, NULL, 0, 2, 0, 0, 'BTW derving partiele materialen', '', '');
INSERT INTO grootboekstam VALUES (1, 2010, 1, 100, NULL, 0, 1, 0, 0, 'Inventaris', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (2, 2010, 1, 150, NULL, 0, 1, 0, 0, 'Afschrijving inventaris', '', '');
INSERT INTO grootboekstam VALUES (98, 2012, 1, 4260, NULL, 0, 2, 0, 0, 'Bankkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (99, 2012, 0, 4350, NULL, 0, 2, 0, 0, 'Bankkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (101, 2012, 0, 4490, NULL, 0, 2, 0, 0, 'Diverse kosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (103, 2012, 0, 4400, NULL, 0, 2, 0, 0, 'Reiskosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (105, 2012, 0, 4300, NULL, 0, 2, 0, 0, 'Afschrijvingen', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (114, 2012, 1, 4299, NULL, 0, 3, 2, 0, 'Sub algemene kosten', '', '');
INSERT INTO grootboekstam VALUES (136, 2012, 1, 4199, NULL, 0, 3, 2, 0, 'Totaal Huisvestingskosten', '', '');
INSERT INTO grootboekstam VALUES (134, 2012, 1, 4395, NULL, 0, 3, 2, 0, 'Totaal Promotiekosten', '', '');
INSERT INTO grootboekstam VALUES (106, 2012, 1, 4399, NULL, 0, 3, 3, 0, 'Totaal algemene kosten', '', '');
INSERT INTO grootboekstam VALUES (138, 2012, 0, 4710, NULL, 0, 2, 0, 0, 'Brandstof auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (69, 2010, 1, 2210, NULL, 0, 1, 0, 0, 'Te ontvangen BTW autokosten', 'rkg_btwautokosten', '');
INSERT INTO grootboekstam VALUES (5, 2010, 1, 300, NULL, 0, 1, 0, 0, 'Software', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (6, 2010, 1, 350, NULL, 0, 1, 0, 0, 'Afschrijving software', '', '');
INSERT INTO grootboekstam VALUES (7, 2010, 1, 500, NULL, 0, 1, 0, 0, 'Leningen', '', '');
INSERT INTO grootboekstam VALUES (10, 2010, 1, 1050, NULL, 0, 1, 0, 0, 'Amrobank', '', '');
INSERT INTO grootboekstam VALUES (12, 2010, 1, 1100, NULL, 0, 1, 0, 0, 'Nog te ontvangen', '', '');
INSERT INTO grootboekstam VALUES (14, 2010, 1, 1500, NULL, 0, 1, 0, 0, 'Nog te betalen', '', '');
INSERT INTO grootboekstam VALUES (16, 2010, 1, 1999, NULL, 0, 3, 3, 0, 'Totaal activa/passiva', '', '');
INSERT INTO grootboekstam VALUES (17, 2010, 1, 2010, NULL, 0, 1, 0, 0, 'Kruisposten', '', '');
INSERT INTO grootboekstam VALUES (18, 2010, 1, 2020, NULL, 0, 1, 0, 0, 'Betalingen onderweg', '', '');
INSERT INTO grootboekstam VALUES (19, 2010, 1, 2099, NULL, 0, 3, 1, 0, 'Totaal hulprekeningen', '', '');
INSERT INTO grootboekstam VALUES (20, 2010, 1, 2110, NULL, 0, 1, 0, 0, 'Af te dragen BTW hoog tarief', 'rkg_btwverkoophoog', '');
INSERT INTO grootboekstam VALUES (21, 2010, 1, 2120, NULL, 0, 1, 0, 0, 'Af te dragen BTW laag tarief', 'rkg_btwverkooplaag', '');
INSERT INTO grootboekstam VALUES (24, 2010, 1, 2399, NULL, 0, 3, 1, 0, 'Totaal periodieke BTW', '', '');
INSERT INTO grootboekstam VALUES (25, 2010, 1, 2500, NULL, 0, 1, 0, 0, 'Verschillenrekening', '', '');
INSERT INTO grootboekstam VALUES (26, 2010, 1, 2899, NULL, 0, 3, 3, 0, 'Totaal tussenrekeningen', '', '');
INSERT INTO grootboekstam VALUES (28, 2010, 1, 3999, NULL, 0, 3, 7, 0, 'Totaal balans', '', '');
INSERT INTO grootboekstam VALUES (29, 2010, 1, 4010, NULL, 0, 2, 0, 0, 'Personeelskosten', '', '');
INSERT INTO grootboekstam VALUES (30, 2010, 1, 4020, NULL, 0, 2, 0, 0, 'Uitbesteed werk', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (32, 2010, 1, 4200, NULL, 0, 2, 0, 0, 'Documentatiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (40, 2010, 1, 4300, NULL, 0, 2, 0, 0, 'Afschrijvingen', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (41, 2010, 1, 4350, NULL, 0, 2, 0, 0, 'Bankkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (42, 2010, 1, 4400, NULL, 0, 2, 0, 0, 'Reiskosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (43, 2010, 1, 4490, NULL, 0, 2, 0, 0, 'Diverse kosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (44, 2010, 1, 4499, NULL, 0, 3, 3, 0, 'Totaal algemene kosten', '', '');
INSERT INTO grootboekstam VALUES (49, 2010, 1, 4699, NULL, 0, 3, 3, 0, 'Totaal specifieke kosten', '', '');
INSERT INTO grootboekstam VALUES (50, 2010, 1, 4900, NULL, 0, 2, 0, 0, 'Voordelig/nadelig saldo', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (51, 2010, 1, 4999, NULL, 0, 3, 5, 0, 'Totaal kosten', '', '');
INSERT INTO grootboekstam VALUES (52, 2010, 1, 8010, NULL, 0, 2, 0, 0, 'Verkopen Atelier', '', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (53, 2010, 1, 8199, NULL, 0, 3, 3, 0, 'Totaal verkopen', '', '');
INSERT INTO grootboekstam VALUES (54, 2010, 1, 8410, NULL, 0, 2, 0, 0, 'Rente opbrengsten', '', '');
INSERT INTO grootboekstam VALUES (56, 2010, 1, 8980, NULL, 0, 3, 3, 0, 'Totaal diverse opbrengsten', '', '');
INSERT INTO grootboekstam VALUES (57, 2010, 1, 8985, NULL, 0, 3, 5, 0, 'Totaal opbrengsten', '', '');
INSERT INTO grootboekstam VALUES (58, 2010, 1, 8990, NULL, 0, 3, 7, 0, 'Totaal verlies en winst', '', '');
INSERT INTO grootboekstam VALUES (59, 2010, 1, 8999, NULL, 0, 3, 8, 0, 'Totaal administratie', '', '');
INSERT INTO grootboekstam VALUES (60, 2010, 1, 8120, NULL, 0, 2, 0, 0, 'Verkopen Workshops 0% BTW', 'verkopen_geenbtw', 'verkopen_geenbtw');
INSERT INTO grootboekstam VALUES (61, 2010, 1, 4099, NULL, 0, 3, 3, 0, 'Totaal personeelskosten', '', '');
INSERT INTO grootboekstam VALUES (63, 2010, 1, 8020, NULL, 0, 2, 0, 0, 'Verkopen Kunst laag', '', 'rkg_btwverkooplaag');
INSERT INTO grootboekstam VALUES (68, 2010, 1, 4799, NULL, 0, 3, 3, 0, 'Totaal autokosten', '', '');
INSERT INTO grootboekstam VALUES (72, 2010, 1, 8140, NULL, 0, 2, 0, 0, 'Verkopen kunst partiele materialen', 'verkopen_partbtwmateriaal', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (74, 2010, 1, 2220, NULL, 0, 1, 0, 0, 'Te ontvangen BTW partiele materialen', 'rkg_btwpartmateriaal', '');
INSERT INTO grootboekstam VALUES (76, 2011, 1, 4780, NULL, 0, 2, 0, 0, 'Prive bijtelling auto', '', '');
INSERT INTO grootboekstam VALUES (79, 2011, 1, 4599, NULL, 0, 3, 3, 0, 'Totaal Promotiekosten', '', '');
INSERT INTO grootboekstam VALUES (80, 2011, 1, 4699, NULL, 0, 3, 3, 0, 'Totaal Inkoopkosten', '', '');
INSERT INTO grootboekstam VALUES (81, 2011, 1, 4199, NULL, 0, 3, 3, 0, 'Totaal Huisvestingskosten', '', '');
INSERT INTO grootboekstam VALUES (83, 2012, 1, 8010, NULL, 0, 2, 0, 0, 'Verkopen Atelier', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (84, 2012, 1, 8020, NULL, 0, 2, 0, 0, 'Verkopen Kunst laag', 'verkopen_laag', 'rkg_btwverkooplaag');
INSERT INTO grootboekstam VALUES (87, 2013, 1, 210, NULL, 0, 1, 0, 0, 'Auto Nissan Nv200 5-VKH-50', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (65, 2010, 1, 4720, NULL, 0, 2, 0, 0, 'Verzekering auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (66, 2010, 1, 4730, NULL, 0, 2, 0, 0, 'Wegenbelasting auto', '', '');
INSERT INTO grootboekstam VALUES (36, 2010, 1, 4235, NULL, 0, 2, 0, 0, 'Kantinekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (64, 2010, 1, 4710, NULL, 0, 2, 0, 0, 'Brandstof auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (8, 2010, 1, 900, NULL, 0, 1, 0, 0, 'Kapitaal/prive', '', '');
INSERT INTO grootboekstam VALUES (88, 2013, 1, 260, NULL, 0, 1, 0, 0, 'Afschrijving Nissan Nv200', '', '');
INSERT INTO grootboekstam VALUES (3, 2010, 1, 200, NULL, 0, 1, 0, 0, 'Auto Opel Combo 88-BH-JP', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (104, 2012, 1, 4610, NULL, 0, 2, 0, 0, 'Afschrijvingen', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (47, 2010, 1, 4520, NULL, 0, 2, 0, 0, 'Productiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (108, 2012, 1, 4620, NULL, 0, 2, 0, 0, 'Afschrijving Opel', '', '');
INSERT INTO grootboekstam VALUES (82, 2011, 1, 250, NULL, 0, 1, 0, 0, 'Afschrijving Opel Combo', '', '');
INSERT INTO grootboekstam VALUES (109, 2013, 1, 4630, NULL, 0, 2, 0, 0, 'Afschrijving Nissan', '', '');
INSERT INTO grootboekstam VALUES (33, 2010, 1, 4210, NULL, 0, 2, 0, 0, 'Klein apparatuur', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (38, 2010, 1, 4245, NULL, 0, 2, 0, 0, 'Internetkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (37, 2010, 1, 4240, NULL, 0, 2, 0, 0, 'Telefoonkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (73, 2010, 1, 4620, NULL, 0, 2, 0, 0, 'BTW derving partiele materialen', 'dervingbtw_partbtwmateriaal', '');
INSERT INTO grootboekstam VALUES (15, 2010, 1, 1600, NULL, 0, 1, 0, 0, 'Crediteuren', '', '');
INSERT INTO grootboekstam VALUES (45, 2010, 1, 4500, NULL, 0, 2, 0, 0, 'Promotiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (48, 2010, 1, 4600, NULL, 0, 2, 0, 0, 'Inkopen', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (67, 2010, 1, 4740, NULL, 0, 2, 0, 0, 'Overige kosten auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (75, 2011, 1, 8030, NULL, 0, 2, 0, 0, 'Verkopen Buitenland', 'verkopen_binneneu', '');
INSERT INTO grootboekstam VALUES (91, 2012, 1, 8080, NULL, 0, 2, 0, 0, 'Logo en Ontwerp zakelijk', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (27, 2010, 1, 3010, NULL, 0, 1, 0, 0, 'Voorraad', '', '');
INSERT INTO grootboekstam VALUES (46, 2010, 1, 4510, NULL, 1, 2, 0, 0, 'Acquisitiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (77, 2011, 1, 2150, NULL, 1, 1, 0, 0, 'Af te dragen BTW Privegebruik', 'rkg_btwprivegebruik', '');
INSERT INTO grootboekstam VALUES (55, 2010, 1, 8900, NULL, 0, 2, 0, 0, 'Diverse opbrengsten', 'rkg_5dregeling', '');
INSERT INTO grootboekstam VALUES (140, 2012, 0, 4730, NULL, 0, 2, 0, 0, 'Wegenbelasting auto', '', '');
INSERT INTO grootboekstam VALUES (142, 2012, 0, 4740, NULL, 0, 2, 0, 0, 'Overige kosten auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (143, 2012, 0, 4720, NULL, 0, 2, 0, 0, 'Verzekering auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (31, 2010, 1, 4100, NULL, 0, 2, 0, 0, 'Huisvestingskosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (113, 2012, 0, 4780, NULL, 0, 2, 0, 0, 'Prive bijtelling auto', '', '');
INSERT INTO grootboekstam VALUES (117, 2012, 0, 4600, NULL, 0, 2, 0, 0, 'Inkopen', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (118, 2012, 1, 5020, NULL, 0, 2, 0, 0, 'Inkopen partiele materialen', 'inkopen_partbtwmateriaal', '');
INSERT INTO grootboekstam VALUES (120, 2012, 1, 5030, NULL, 0, 2, 0, 0, 'BTW derving partiele materialen', 'dervingbtw_partbtwmateriaal', '');
INSERT INTO grootboekstam VALUES (122, 2012, 1, 5050, NULL, 0, 2, 0, 0, 'Kosten uitbesteed werk e.a. externe kosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (124, 2012, 0, 4699, NULL, 0, 3, 3, 0, 'Totaal Inkoopkosten', '', '');
INSERT INTO grootboekstam VALUES (125, 2012, 0, 4020, NULL, 0, 2, 0, 0, 'Uitbesteed werk', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (144, 2012, 0, 4499, NULL, 0, 3, 3, 0, 'Totaal algemene kosten', '', '');
INSERT INTO grootboekstam VALUES (135, 2012, 1, 4599, NULL, 0, 3, 4, 0, 'Totaal algemene kosten', '', '');
INSERT INTO grootboekstam VALUES (126, 2012, 1, 5999, NULL, 0, 3, 5, 0, 'Totaal kosten', '', '');
INSERT INTO grootboekstam VALUES (130, 2012, 0, 4500, NULL, 0, 2, 0, 0, 'Promotiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (131, 2012, 1, 4320, NULL, 0, 2, 0, 0, 'Acquisitiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (128, 2012, 1, 4499, NULL, 0, 3, 2, 0, 'Netto autokosten', '', '');
INSERT INTO grootboekstam VALUES (146, 2012, 0, 4799, NULL, 0, 2, 0, 0, 'Totaal autokosten', '', '');
INSERT INTO grootboekstam VALUES (145, 2012, 1, 4595, NULL, 0, 3, 3, 0, 'Totaal autokosten', '', '');
INSERT INTO grootboekstam VALUES (107, 2012, 1, 4699, NULL, 0, 3, 4, 0, 'Totaal Afschrijvingen', '', '');
INSERT INTO grootboekstam VALUES (147, 2012, 0, 4999, NULL, 0, 3, 5, 0, 'Totaal kosten', '', '');
INSERT INTO grootboekstam VALUES (123, 2012, 1, 5099, NULL, 0, 3, 4, 0, 'Totaal Inkoopkosten', '', '');
INSERT INTO grootboekstam VALUES (23, 2010, 1, 2300, NULL, 0, 1, 0, 0, 'BTW met de fiscus te verrekenen', 'rkg_betaaldebtw', '');
INSERT INTO grootboekstam VALUES (149, 2013, 1, 4260, NULL, 0, 2, 0, 0, 'Bankkosten', '', '');
INSERT INTO grootboekstam VALUES (150, 2013, 1, 4235, NULL, 0, 2, 0, 0, 'Kantinekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (94, 2012, 1, 8190, NULL, 0, 2, 0, 0, 'Verkopen Overig', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (152, 2013, 1, 2140, NULL, 0, 1, 0, 0, 'Af te dragen BTW verwerving binnen  EU ', 'rkg_btwinkopeneubet', '');
INSERT INTO grootboekstam VALUES (154, 2013, 1, 2240, NULL, 0, 1, 0, 0, 'Te ontvangen BTW verwerving binnen EU', 'rkg_btwinkopeneuontv', '');
INSERT INTO grootboekstam VALUES (151, 2013, 1, 5015, NULL, 0, 2, 0, 0, 'Inkopen binnen EU', 'inkopen_binneneu', 'rkg_btwinkopeneuontv');
INSERT INTO grootboekstam VALUES (62, 2010, 1, 8110, NULL, 0, 2, 0, 0, 'Verkopen Workshops', '', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (85, 2012, 1, 8110, NULL, 0, 2, 0, 0, 'Verkopen Workshops', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (155, 2013, 1, 8085, NULL, 0, 2, 0, 0, 'Logo en Ontwerp prive', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (97, 2013, 1, 5060, NULL, 0, 2, 0, 0, 'Inkoopkosten overig', '', '');
INSERT INTO grootboekstam VALUES (22, 2010, 1, 2200, NULL, 0, 1, 0, 0, 'Te ontvangen BTW', 'rkg_btwinkopen', '');
INSERT INTO grootboekstam VALUES (112, 2012, 1, 4520, NULL, 0, 2, 0, 0, 'Prive bijtelling auto', '', '');
INSERT INTO grootboekstam VALUES (71, 2010, 1, 4610, NULL, 0, 2, 0, 0, 'Inkopen partiele materialen', 'inkopen_partbtwmateriaal', 'rkg_btwpartmateriaal');
INSERT INTO grootboekstam VALUES (119, 2012, 0, 4610, NULL, 0, 2, 0, 0, 'Inkopen partiele materialen', 'inkopen_partbtwmateriaal', '');
INSERT INTO grootboekstam VALUES (133, 2012, 0, 4520, NULL, 0, 2, 0, 0, 'Productiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (96, 2013, 1, 200, NULL, 0, 1, 0, 0, 'Auto Opel Combo 88-BH-JP', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (121, 2012, 0, 4620, NULL, 0, 2, 0, 0, 'BTW derving partiele materialen', 'dervingbtw_partbtwmateriaal', '');
INSERT INTO grootboekstam VALUES (92, 2012, 1, 8065, NULL, 0, 2, 0, 0, 'Schilderijen prive', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (90, 2012, 1, 8070, NULL, 0, 2, 0, 0, 'Wandschilderingen zakelijk', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (100, 2012, 1, 4290, NULL, 0, 2, 0, 0, 'Diverse kosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (129, 2012, 1, 4310, NULL, 0, 2, 0, 0, 'Promotiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (110, 2012, 1, 4420, NULL, 0, 2, 0, 0, 'Verzekering auto', '', '');
INSERT INTO grootboekstam VALUES (11, 2010, 1, 1060, NULL, 0, 1, 0, 0, 'Rekening courant prive', '', '');
INSERT INTO grootboekstam VALUES (141, 2012, 1, 4440, NULL, 0, 2, 0, 0, 'Overige kosten auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (13, 2010, 1, 1200, NULL, 0, 1, 0, 0, 'Debiteuren', '', '');
INSERT INTO grootboekstam VALUES (39, 2010, 1, 4250, NULL, 0, 2, 0, 0, 'Portikosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (139, 2012, 1, 4430, NULL, 0, 2, 0, 0, 'Wegenbelasting auto', '', '');
INSERT INTO grootboekstam VALUES (93, 2012, 1, 8075, NULL, 0, 2, 0, 0, 'Schilderijen zakelijk', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (148, 2013, 1, 4250, NULL, 0, 2, 0, 0, 'Portikosten', '', '');
INSERT INTO grootboekstam VALUES (111, 2012, 1, 4450, NULL, 1, 2, 0, 0, 'Onderhoud auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (34, 2010, 1, 4220, NULL, 5, 2, 0, 0, 'Atelierkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (89, 2012, 1, 8060, NULL, 3, 2, 0, 0, 'Wandschilderingen prive', 'verkopen_hoog', 'rkg_btwverkoophoog');
INSERT INTO grootboekstam VALUES (137, 2012, 1, 4410, NULL, 16, 2, 0, 0, 'Brandstof auto', '', 'rkg_btwautokosten');
INSERT INTO grootboekstam VALUES (35, 2010, 1, 4230, NULL, 5, 2, 0, 0, 'Kantoorkosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (116, 2012, 1, 5010, NULL, 2, 2, 0, 0, 'Inkopen', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (115, 2012, 1, 4510, NULL, 1, 2, 0, 0, 'BTW privé gebruik auto', '', '');
INSERT INTO grootboekstam VALUES (132, 2012, 0, 4510, NULL, 1, 2, 0, 0, 'Acquisitiekosten', '', 'rkg_btwinkopen');
INSERT INTO grootboekstam VALUES (156, 2013, 1, 4510, NULL, 1, 2, 0, 0, 'BTW privé gebruik auto', '', '');


--
-- Data for Name: kostenplaatsen; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO kostenplaatsen VALUES (1, 100000, 900000, 0, 'Activa');
INSERT INTO kostenplaatsen VALUES (2, 110000, 100000, 0, 'Vaste activa');
INSERT INTO kostenplaatsen VALUES (3, 120000, 110000, 0, 'Immateriele vaste activa');
INSERT INTO kostenplaatsen VALUES (4, 121000, 120000, 0, 'Overige immateriele vaste activa');
INSERT INTO kostenplaatsen VALUES (5, 122000, 121000, 1, 'Intellectuele eigendom');
INSERT INTO kostenplaatsen VALUES (6, 123000, 120000, 1, 'Goodwill');
INSERT INTO kostenplaatsen VALUES (7, 130000, 110000, 0, 'Materiele vaste activa');
INSERT INTO kostenplaatsen VALUES (8, 131000, 130000, 0, 'Bedrijfsgebouwen en terreinen');
INSERT INTO kostenplaatsen VALUES (9, 132000, 130000, 0, 'Machines en installaties');
INSERT INTO kostenplaatsen VALUES (10, 133000, 130000, 0, 'Overige materiele vaste activa');
INSERT INTO kostenplaatsen VALUES (11, 134000, 133000, 0, 'Bedrijfsauto''s');
INSERT INTO kostenplaatsen VALUES (12, 134100, 134000, 1, 'Opel');
INSERT INTO kostenplaatsen VALUES (13, 134200, 134000, 1, 'Nissan');
INSERT INTO kostenplaatsen VALUES (14, 140000, 110000, 0, 'Financiele vaste activa');
INSERT INTO kostenplaatsen VALUES (15, 150000, 100000, 0, 'Vlottende activa');
INSERT INTO kostenplaatsen VALUES (16, 160000, 150000, 0, 'Voorraden excl. onderhanden werk');
INSERT INTO kostenplaatsen VALUES (17, 161000, 160000, 1, 'Voorraad atelier');
INSERT INTO kostenplaatsen VALUES (18, 170000, 150000, 0, 'Vorderingen');
INSERT INTO kostenplaatsen VALUES (19, 171000, 170000, 1, 'Debiteuren');
INSERT INTO kostenplaatsen VALUES (20, 180000, 150000, 0, 'Effecten');
INSERT INTO kostenplaatsen VALUES (21, 190000, 150000, 0, 'Liquide middelen');
INSERT INTO kostenplaatsen VALUES (22, 191100, 190000, 1, 'Kas');
INSERT INTO kostenplaatsen VALUES (23, 191200, 190000, 1, 'ABN-AMRO bank');
INSERT INTO kostenplaatsen VALUES (24, 191500, 190000, 1, 'Prive rekening courant');
INSERT INTO kostenplaatsen VALUES (25, 300000, 900000, 0, 'Passiva');
INSERT INTO kostenplaatsen VALUES (26, 310000, 300000, 0, 'Eigen vermogen');
INSERT INTO kostenplaatsen VALUES (27, 311000, 310000, 0, 'Gestort en opgevraagd kapitaal');
INSERT INTO kostenplaatsen VALUES (28, 311100, 311000, 0, 'Gestort kapitaal');
INSERT INTO kostenplaatsen VALUES (29, 311200, 311000, 0, 'Opgevraagd kapitaal');
INSERT INTO kostenplaatsen VALUES (30, 320000, 300000, 0, 'Voorzieningen');
INSERT INTO kostenplaatsen VALUES (31, 321000, 320000, 0, 'Voorzieningen voor pensioenen');
INSERT INTO kostenplaatsen VALUES (32, 322000, 320000, 0, 'Voorzieningen voor belastingen');
INSERT INTO kostenplaatsen VALUES (33, 322100, 322000, 1, 'Voorziening voor Inkomstenbelasting');
INSERT INTO kostenplaatsen VALUES (34, 322200, 322000, 1, 'Voorziening voor Omzetbelasting');
INSERT INTO kostenplaatsen VALUES (35, 323000, 320000, 0, 'Voorzieningen overige');
INSERT INTO kostenplaatsen VALUES (36, 330000, 300000, 0, 'Langlopende schulden');
INSERT INTO kostenplaatsen VALUES (37, 331000, 330000, 0, 'Schulden aan kredietinstellingen');
INSERT INTO kostenplaatsen VALUES (38, 331100, 331000, 1, 'Financiering Nissan');
INSERT INTO kostenplaatsen VALUES (39, 332000, 330000, 0, 'Schulden aan leveranciers en handelskredieten');
INSERT INTO kostenplaatsen VALUES (40, 333000, 330000, 0, 'Belastingen en premies sociale verzekeringen');
INSERT INTO kostenplaatsen VALUES (41, 333100, 333000, 1, 'Omzetbelasting af te dragen');
INSERT INTO kostenplaatsen VALUES (42, 350000, 300000, 0, 'Kortlopende schulden');
INSERT INTO kostenplaatsen VALUES (43, 351000, 350000, 0, 'Schulden aan kredietinstellingen');
INSERT INTO kostenplaatsen VALUES (44, 352000, 350000, 0, 'Schulden aan leveranciers en handelskredieten');
INSERT INTO kostenplaatsen VALUES (45, 352100, 352000, 1, 'Crediteuren');
INSERT INTO kostenplaatsen VALUES (46, 353000, 350000, 0, 'Belastingen en premies sociale verzekeringen');
INSERT INTO kostenplaatsen VALUES (47, 400000, 900000, 0, 'Kosten');
INSERT INTO kostenplaatsen VALUES (48, 410000, 400000, 0, 'Personeelskosten');
INSERT INTO kostenplaatsen VALUES (49, 420000, 400000, 0, 'Overige bedrijfskosten');
INSERT INTO kostenplaatsen VALUES (50, 430000, 420000, 0, 'Huisvestingskosten');
INSERT INTO kostenplaatsen VALUES (51, 431000, 430000, 1, 'Huur atelier Boskoop');
INSERT INTO kostenplaatsen VALUES (52, 432000, 430000, 1, 'Overige kosten huisvesting');
INSERT INTO kostenplaatsen VALUES (53, 440000, 420000, 0, 'Onderhoudskosten overige materiele vaste activa');
INSERT INTO kostenplaatsen VALUES (54, 450000, 420000, 0, 'Verkoopkosten');
INSERT INTO kostenplaatsen VALUES (55, 451000, 450000, 1, 'Promotiekosten');
INSERT INTO kostenplaatsen VALUES (56, 452000, 450000, 1, 'Acquisitiekosten');
INSERT INTO kostenplaatsen VALUES (57, 460000, 420000, 0, 'Andere kosten');
INSERT INTO kostenplaatsen VALUES (58, 461000, 460000, 1, 'Atelierkosten');
INSERT INTO kostenplaatsen VALUES (59, 462000, 460000, 1, 'Kantoorkosten');
INSERT INTO kostenplaatsen VALUES (60, 463000, 460000, 1, 'Kantinekosten');
INSERT INTO kostenplaatsen VALUES (61, 464000, 460000, 1, 'Klein apparatuur');
INSERT INTO kostenplaatsen VALUES (62, 465000, 460000, 1, 'Telefoon Internet Porti');
INSERT INTO kostenplaatsen VALUES (63, 468000, 460000, 1, 'Diverse kosten');
INSERT INTO kostenplaatsen VALUES (64, 470000, 420000, 0, 'Kosten auto''s');
INSERT INTO kostenplaatsen VALUES (65, 471000, 470000, 0, 'Kosten Opel');
INSERT INTO kostenplaatsen VALUES (66, 471100, 471000, 1, 'Brandstof Opel');
INSERT INTO kostenplaatsen VALUES (67, 471200, 471000, 1, 'Onderhoud en reparatie Opel');
INSERT INTO kostenplaatsen VALUES (68, 471300, 471000, 1, 'Verzekering Opel');
INSERT INTO kostenplaatsen VALUES (69, 471400, 471000, 1, 'Wegenbelasting Opel');
INSERT INTO kostenplaatsen VALUES (70, 471500, 471000, 1, 'Overige kosten Opel');
INSERT INTO kostenplaatsen VALUES (71, 471700, 471000, 1, 'BTW privegebruik Opel');
INSERT INTO kostenplaatsen VALUES (72, 471800, 471000, 1, 'Prive-bijtelling Opel');
INSERT INTO kostenplaatsen VALUES (73, 471900, 471000, 1, 'Saldo verkoop Opel');
INSERT INTO kostenplaatsen VALUES (74, 481000, 470000, 0, 'Kosten Nissan');
INSERT INTO kostenplaatsen VALUES (75, 481100, 481000, 1, 'Brandstof Nissan');
INSERT INTO kostenplaatsen VALUES (76, 481200, 481000, 1, 'Onderhoud en reparatie Nissan');
INSERT INTO kostenplaatsen VALUES (77, 481300, 481000, 1, 'Verzekering Nissan');
INSERT INTO kostenplaatsen VALUES (78, 481400, 481000, 1, 'Wegenbelasting Nissan');
INSERT INTO kostenplaatsen VALUES (79, 481500, 481000, 1, 'Overige kosten Nissan');
INSERT INTO kostenplaatsen VALUES (80, 481700, 481000, 1, 'BTW privegebruik Nissan');
INSERT INTO kostenplaatsen VALUES (81, 481800, 481000, 1, 'Prive-bijtelling Nissan');
INSERT INTO kostenplaatsen VALUES (82, 481900, 481000, 1, 'Saldo verkoop Nissan');
INSERT INTO kostenplaatsen VALUES (83, 500000, 400000, 0, 'Afschrijvingen');
INSERT INTO kostenplaatsen VALUES (84, 510000, 470000, 0, 'Afschrijvingen auto''s');
INSERT INTO kostenplaatsen VALUES (85, 511000, 471000, 1, 'Afschrijving Opel');
INSERT INTO kostenplaatsen VALUES (86, 512000, 481000, 1, 'Afschrijving Nissan');
INSERT INTO kostenplaatsen VALUES (87, 520000, 500000, 0, 'Afschrijvingen materiele activa');
INSERT INTO kostenplaatsen VALUES (88, 530000, 500000, 0, 'Afschrijvingen vlottende activa');
INSERT INTO kostenplaatsen VALUES (89, 531000, 530000, 1, 'Afschrijving materialen');
INSERT INTO kostenplaatsen VALUES (90, 532000, 530000, 1, 'Afschrijving debiteuren');
INSERT INTO kostenplaatsen VALUES (91, 600000, 400000, 0, 'Inkoopkosten');
INSERT INTO kostenplaatsen VALUES (92, 610000, 600000, 1, 'Inkoop materialen');
INSERT INTO kostenplaatsen VALUES (93, 620000, 600000, 1, 'Kosten uitbesteed werk e.a. externe kosten');
INSERT INTO kostenplaatsen VALUES (94, 700000, 900000, 0, 'Financiele baten en lasten');
INSERT INTO kostenplaatsen VALUES (95, 710000, 700000, 1, 'Opbrengsten banktegoeden');
INSERT INTO kostenplaatsen VALUES (96, 730000, 700000, 1, 'Waardevermindering van vorderingen');
INSERT INTO kostenplaatsen VALUES (97, 770000, 700000, 1, 'Kosten van schulden, rentelasten etc.');
INSERT INTO kostenplaatsen VALUES (98, 800000, 900000, 0, 'Totaal opbrengsten: fiscaal');
INSERT INTO kostenplaatsen VALUES (99, 810000, 800000, 0, 'Netto-omzet');
INSERT INTO kostenplaatsen VALUES (100, 820000, 800000, 1, 'Overige opbrengsten');
INSERT INTO kostenplaatsen VALUES (101, 820000, 810000, 0, 'Opbrengsten zakelijk');
INSERT INTO kostenplaatsen VALUES (102, 821000, 820000, 1, 'Schilderijen zakelijk');
INSERT INTO kostenplaatsen VALUES (103, 822000, 820000, 1, 'Spuitwerk zakelijk');
INSERT INTO kostenplaatsen VALUES (104, 823000, 820000, 1, 'Ontwerp en logos zakelijk');
INSERT INTO kostenplaatsen VALUES (105, 824000, 820000, 1, 'Workshops zakelijk');
INSERT INTO kostenplaatsen VALUES (106, 830000, 810000, 0, 'Opbrengsten prive');
INSERT INTO kostenplaatsen VALUES (107, 831000, 830000, 1, 'Schilderijen prive');
INSERT INTO kostenplaatsen VALUES (108, 832000, 830000, 1, 'Spuitwerk prive');
INSERT INTO kostenplaatsen VALUES (109, 833000, 830000, 1, 'Ontwerp en logos prive');
INSERT INTO kostenplaatsen VALUES (110, 834000, 830000, 1, 'Workshops prive');
INSERT INTO kostenplaatsen VALUES (111, 850000, 810000, 0, 'Opbrengsten buitenland');
INSERT INTO kostenplaatsen VALUES (112, 851000, 850000, 1, 'Opbrengsten Duitsland');
INSERT INTO kostenplaatsen VALUES (113, 852000, 850000, 1, 'Opbrengsten Belgie');
INSERT INTO kostenplaatsen VALUES (114, 900000, NULL, 0, 'Batig saldo');


--
-- Data for Name: meta; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO meta VALUES ('versie', '1.0.0');
INSERT INTO meta VALUES ('platform', 'linux');
INSERT INTO meta VALUES ('sqlversie', '1.17.0');


--
-- Data for Name: stamgegevens; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO stamgegevens VALUES (1, 2008, 'a', 1, 'Naam administratie', 'adminnaam', 'KoogerKunst', '');
INSERT INTO stamgegevens VALUES (2, 2008, 'a', 3, 'Contactgegevens', 'adminomschrijving', 'B.Koekenbier
B. Koekenbier
Langetuin 82
1689JD  Hoorn

mobiel: 06 15955099
email: b.koekenbier@hotmail.com', '');
INSERT INTO stamgegevens VALUES (4, 2008, 'b', 3, 'Periode van', 'periodevan', '1', '');
INSERT INTO stamgegevens VALUES (5, 2008, 'b', 5, 'Periode tot', 'periodetot', '4', '');
INSERT INTO stamgegevens VALUES (6, 2008, 'b', 7, 'Extra periode', 'periodeextra', '5', '');
INSERT INTO stamgegevens VALUES (21, 2008, 'e', 5, 'Rekening bankboek', 'rkg_bankboek', '1050', '');
INSERT INTO stamgegevens VALUES (20, 2008, 'e', 3, 'Rekening kasboek', 'rkg_kasboek', '1000', '');
INSERT INTO stamgegevens VALUES (19, 2008, 'e', 13, 'Rekening pinbetalingen', 'rkg_pinbetalingen', '2020', '');
INSERT INTO stamgegevens VALUES (18, 2008, 'g', 3, 'BTW percentage laag', 'btwverkooplaag', '6', '');
INSERT INTO stamgegevens VALUES (14, 2008, ' ', 0, 'Verschillenrekening', 'rkg_verschillen', '2500', '');
INSERT INTO stamgegevens VALUES (8, 2008, 'e', 9, 'Rekening debiteuren', 'rkg_debiteuren', '1200', '');
INSERT INTO stamgegevens VALUES (9, 2008, 'e', 11, 'Rekening crediteuren', 'rkg_crediteuren', '1600', '');
INSERT INTO stamgegevens VALUES (7, 2008, 'e', 1, 'Rekening kapitaal/prive', 'rkg_kapitaalprive', '900', '');
INSERT INTO stamgegevens VALUES (24, 2008, 'e', 27, 'Rekening Diverse Opbrengsten', 'rkg_divopbrengsten', '8900', '');
INSERT INTO stamgegevens VALUES (26, 2008, 'e', 7, 'Rekening Prive rekeningcourant', 'rkg_priverekeningcourant', '1060', '');
INSERT INTO stamgegevens VALUES (27, 2008, 'e', 30, 'Omslagrekening Balans/VW', 'omslag', '4000', 'Bepaal vanaf welk rekeningnummer de Balansrekeningen eindigen en de VenW rekeningen beginnen.');
INSERT INTO stamgegevens VALUES (17, 2008, 'g', 1, 'BTW percentage hoog', 'btwverkoophoog', '21', '');
INSERT INTO stamgegevens VALUES (3, 2008, 'b', 1, 'Lopend jaar', 'lopendjaar', '2013', '');



--
-- Data for Name: voorkeuren; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO voorkeuren VALUES (1, 'Facturen tonen in debiteuren/crediteurenstam', 'facturen_tonen', 'true');
INSERT INTO voorkeuren VALUES (2, 'Achtergrondkleur hoofdscherm (overschrijft config)', 'achtergrondkleur', '');


--
-- Data for Name: vwbtw; Type: TABLE DATA; Schema: public; Owner: -
--

