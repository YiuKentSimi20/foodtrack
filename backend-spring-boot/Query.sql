-- ==========================================
-- NUTRI-SCORE A (Alimente excelente pentru sănătate)
-- Fructe, legume, leguminoase, cereale integrale, pește slab și carne foarte slabă
-- ==========================================
UPDATE alimente SET nutrition_score = 'A' WHERE product_name IN (
                                                                 'Mar', 'Banana', 'Capsuni', 'Portocala', 'Rosie', 'Castravete', 'Cartof', 'Morcov',
                                                                 'Ceapa', 'Usturoi', 'Ardei Gras', 'Spanac (Crud)', 'Broccoli (Crud)', 'Struguri',
                                                                 'Pepene Rosu', 'Lamaie', 'Vinete', 'Dovlecel', 'Fasole Alba (Fiarta)', 'Linte (Fiarta)',
                                                                 'Ciuperci (Champignon)', 'Pere', 'Piersici', 'Afine', 'Varza Alba', 'Cartof Dulce',
                                                                 'Mazare Verde (Fiarta)', 'Zmeura', 'Mango', 'Conopida (Cruda)', 'Zucchini (Crud)',
                                                                 'Ciuperci Pleurotus', 'Salata Verde (Iceberg)', 'Ananas (Crud)', 'Rodie (Miez)',
                                                                 'Cirese', 'Prune', 'Kiwi', 'Pepene Galben', 'Telina (Radacina)', 'Fasole Verde (Pastai)',
                                                                 'Piept de Pui', 'Piept de Curcan (Crud)', 'Ton in Suc Propriu (Conserva)',
                                                                 'Creveti (Fierti)', 'Calamar (Crud)', 'Ou de Gaina', 'Lapte de Vaca 1.5%',
                                                                 'Iaurt Grecesc 2%', 'Kefir 1.5%', 'Ovaz', 'Quinoa (Cruda)', 'Bulgur (Crud)',
                                                                 'Faina Integrala', 'Cafea (Fara Zahar)', 'Ceai Verde'
    );

-- ==========================================
-- NUTRI-SCORE B (Alimente foarte bune)
-- Grăsimi sănătoase, nuci, semințe, carbohidrați complecși, pește gras
-- ==========================================
UPDATE alimente SET nutrition_score = 'B' WHERE product_name IN (
                                                                 'Avocado', 'Miez de Nuca', 'Migdale (Crude)', 'Arahide (Crude)', 'Alune de Padure (Crude)',
                                                                 'Caju (Crud)', 'Fistic (Crud)', 'Nuci Pecan', 'Nuci Macadamia', 'Nuci de Brazilia',
                                                                 'Seminte de Chia', 'Seminte de Floarea Soarelui', 'Seminte de Dovleac (Crude)',
                                                                 'Seminte de In', 'Seminte de Susan', 'Seminte de Canepa (Decorticate)', 'Seminte de Mac',
                                                                 'Ulei de Masline', 'Tahini (Pasta de Susan)', 'Faina de Migdale', 'Somon (Crud)',
                                                                 'Macrou', 'Carne de Vita (Macra)', 'Branza Fagaras (Light)', 'Orez Alb',
                                                                 'Paste Fainoase (Crude)', 'Malai', 'Paine Integrala', 'Paine de secara',
                                                                 'Faina Alba (Graul 000)', 'Pesmet'
    );

-- ==========================================
-- NUTRI-SCORE C (Alimente de consumat cu moderație)
-- Carne cu grăsime medie, carbohidrați rafinați, fructe uscate
-- ==========================================
UPDATE alimente SET nutrition_score = 'C' WHERE product_name IN (
                                                                 'Carne de Porc (Macra)', 'Carne de Miel (Macra)', 'Pulpe de Pui (Fara Piele)',
                                                                 'Sunca de Praga', 'Branza Cottage (Perle)', 'Smantana 20%', 'Smantana pentru Gatit (15%)',
                                                                 'Paine Alba', 'Lipie (Wrap)', 'Fulgi de Porumb (Fara Zahar)', 'Rondele de Orez Expandat',
                                                                 'Paine Prajita (Zwieback)', 'Musli cu Fructe', 'Curmale (Uscate)', 'Stafide',
                                                                 'Pudra Proteica (Whey)', 'Suc de Portocale (Ambalat)'
    );

-- ==========================================
-- NUTRI-SCORE D (Alimente dense caloric, sărate sau dulci)
-- Brânzeturi grase, ciocolată neagră, miere, sosuri
-- ==========================================
UPDATE alimente SET nutrition_score = 'D' WHERE product_name IN (
                                                                 'Telemea de Vaca', 'Cascaval', 'Mozzarella', 'Branza Feta', 'Branza Camembert',
                                                                 'Branza Gouda', 'Ciocolata Neagra 70%', 'Miere', 'Biscuiti Digestivi', 'Gem de Capsuni',
                                                                 'Unt de Arahide', 'Ketchup', 'Mustar', 'Mustar Dijon', 'Popcorn (Fara Ulei)',
                                                                 'Maioneza Light', 'Otet din Cidru de Mere', 'Sos de Soia', 'Piper Negru'
    );

-- ==========================================
-- NUTRI-SCORE E (Alimente ocazionale - "Cheat Day")
-- Zahăr pur, sare pură, grăsimi saturate înalte, dulciuri grele, mezeluri grase
-- ==========================================
UPDATE alimente SET nutrition_score = 'E' WHERE product_name IN (
                                                                 'Unt 82%', 'Nutella (Crema de Cacao)', 'Ciocolata cu Lapte', 'Inghetata de Vanilie',
                                                                 'Cereale cu Ciocolata', 'Zahar Alb', 'Sare Fina', 'Croissant cu Unt',
                                                                 'Salam Uscat', 'Carnati de Porc', 'Pate de Ficat de Porc', 'Crenvursti de Pui',
                                                                 'Parmezan', 'Chipsuri din Cartofi (Cu Sare)', 'Maioneza', 'Bautura tip Cola (Cu Zahar)',
                                                                 'Bere Blonda', 'Vin Rosu'
    );
INSERT INTO activitati_fizice (nume, categorie, met, descriere) VALUES
-- ==========================================
-- CARDIO (Consum mare de calorii)
-- ==========================================
('Alergare (Jogging, ~8 km/h)', 'CARDIO', 8.3, 'Alergare in ritm relaxat, ideala pentru incalzire sau incepatori.'),
('Alergare rapida (~12 km/h)', 'CARDIO', 11.5, 'Alergare in ritm sustinut, efort cardiovascular ridicat.'),
('Ciclism (19-22 km/h)', 'CARDIO', 8.0, 'Mers pe bicicleta in ritm mediu, pe teren plat sau usor denivelat.'),
('Inot (Stil liber, moderat)', 'CARDIO', 8.3, 'Inot in bazin fara pauze lungi, ritm sustenabil.'),
('Sarit coarda (Moderat)', 'CARDIO', 10.0, 'Exercitiu intens pentru intregul corp si sistemul cardiovascular.'),
('Urcat scari (Ritm normal)', 'CARDIO', 8.0, 'Urcarea continua a scarilor, excelent pentru picioare si fesieri.'),
('Aparat Eliptic (Intensitate medie)', 'CARDIO', 5.0, 'Antrenament cardio cu impact redus asupra articulatiilor.'),

-- ==========================================
-- FORTA (Dezvoltare musculara)
-- ==========================================
('Antrenament cu greutati (Intens)', 'FORTA', 6.0, 'Ridicari de greutati (haltere, gantere) cu pauze scurte. Powerlifting sau culturism.'),
('Antrenament cu greutati (Moderat)', 'FORTA', 3.5, 'Ridicari de greutati cu pauze mai lungi intre seturi.'),
('Calisthenics (Flotari, Tractiuni)', 'FORTA', 8.0, 'Antrenament cu greutatea propriului corp, efort sustinut.'),
('CrossFit', 'FORTA', 8.0, 'Antrenament functional de mare intensitate (WOD).'),

-- ==========================================
-- FLEXIBILITATE & RECUPERARE
-- ==========================================
('Yoga (Hatha)', 'FLEXIBILITATE', 2.5, 'Sesiune de yoga axata pe respiratie, posturi statice si stretching.'),
('Yoga (Vinyasa / Power)', 'FLEXIBILITATE', 4.0, 'Sesiune de yoga dinamica, cu tranzitii rapide intre posturi.'),
('Pilates', 'FLEXIBILITATE', 3.0, 'Exercitii pentru intarirea core-ului si imbunatatirea posturii.'),
('Stretching', 'FLEXIBILITATE', 2.3, 'Sesiune usoara de intinderi musculare pentru recuperare.'),

-- ==========================================
-- SPORT DE ECHIPA & COMPETITIE
-- ==========================================
('Fotbal (Meci)', 'SPORT_DE_ECHIPA', 10.0, 'Joc de fotbal pe teren mare, cu alergari si sprinturi frecvente.'),
('Baschet (Joc activ)', 'SPORT_DE_ECHIPA', 8.0, 'Meci de baschet pe tot terenul.'),
('Volei (In sala)', 'SPORT_DE_ECHIPA', 4.0, 'Joc de volei competitional in sala.'),
('Tenis de camp (Simplu)', 'SPORT_DE_ECHIPA', 7.3, 'Meci de tenis 1 vs 1, efort fizic considerabil.'),
('Tenis de camp (Dublu)', 'SPORT_DE_ECHIPA', 5.0, 'Meci de tenis in echipa, alergare mai redusa.'),

-- ==========================================
-- ACTIVITATI ZILNICE (Consum pasiv / NEAT)
-- ==========================================
('Mers pe jos (Plimbare usoara)', 'ACTIVITATI_ZILNICE', 3.0, 'Mers relaxat (~4.5 km/h), ideal dupa o masa consistenta.'),
('Mers pe jos (Alert, spre munca)', 'ACTIVITATI_ZILNICE', 4.3, 'Mers rapid (~5.6 km/h) spre o destinatie.'),
('Curatenie generala', 'ACTIVITATI_ZILNICE', 3.3, 'Dat cu aspiratorul, sters praful, spalat pe jos.'),
('Gradinarit (Moderat)', 'ACTIVITATI_ZILNICE', 4.0, 'Sapat usor, plantat, curatat buruienile.'),
('Dans (In club sau la petrecere)', 'ACTIVITATI_ZILNICE', 4.5, 'Miscare continua in ritmul muzicii, intensitate moderata.');

INSERT INTO activitati_fizice (nume, categorie, met, descriere) VALUES
-- ==========================================
-- CARDIO (Aparate, Sporturi de Iarna si Apa)
-- ==========================================
('Aparat de Vaslit (Ritm moderat)', 'CARDIO', 7.0, 'Antrenament complet (spate, picioare, brate) la ergometru.'),
('Aparat de Vaslit (Ritm intens)', 'CARDIO', 8.5, 'Antrenament la ergometru cu rezistenta mare si tempo rapid.'),
('Schi (Coborare moderata)', 'CARDIO', 7.0, 'Schi alpin pe partie, efort considerabil pentru picioare si core.'),
('Patinaj pe gheata / Role', 'CARDIO', 7.0, 'Patinaj in ritm constant, excelent pentru echilibru si coapse.'),
('Aerobic (High Impact)', 'CARDIO', 7.3, 'Clasa de aerobic cu sarituri si miscari rapide.'),
('Arte Martiale (Kickboxing / MMA)', 'CARDIO', 10.3, 'Antrenament de contact intens, lovituri la sac sau sparring.'),
('Box (La sac de antrenament)', 'CARDIO', 5.5, 'Lovituri repetate la sac, antrenament cardio excelent pentru brate.'),

-- ==========================================
-- FORTA & ECHILIBRU
-- ==========================================
('Kettlebell Workout', 'FORTA', 8.0, 'Antrenament exploziv cu greutati tip kettlebell (swing-uri, smulgeri).'),
('Halterofilie (Incepatori)', 'FORTA', 3.0, 'Invatarea tehnicii de baza cu greutati mici (smuls, aruncat).'),
('Alpinism / Escalada', 'FORTA', 8.0, 'Escalada pe panou la sala sau pe stanca, solicita toata musculatura.'),

-- ==========================================
-- FLEXIBILITATE
-- ==========================================
('Tai Chi', 'FLEXIBILITATE', 4.0, 'Miscari lente, controlate, axate pe respiratie si echilibru mental.'),
('Gimnastica (Usoara / Incalzire)', 'FLEXIBILITATE', 3.8, 'Miscari articulare si de mobilitate la sol.'),

-- ==========================================
-- SPORT DE ECHIPA & COMPETITIE
-- ==========================================
('Handbal', 'SPORT_DE_ECHIPA', 8.0, 'Meci de handbal, alergare in sprinturi, sarituri si aruncari.'),
('Tenis de masa (Ping Pong)', 'SPORT_DE_ECHIPA', 4.0, 'Joc dinamic de coordonare si reflexe.'),
('Rugby', 'SPORT_DE_ECHIPA', 10.0, 'Sport de contact foarte solicitant fizic, alergare cu schimbari de directie.'),

-- ==========================================
-- ACTIVITATI ZILNICE (Consum Casnic & NEAT)
-- ==========================================
('Cumparaturi (Mers prin magazin)', 'ACTIVITATI_ZILNICE', 2.3, 'Plimbare cu caruciorul printre rafturi si incarcarea produselor.'),
('Urcat scari cu greutati (Plase)', 'ACTIVITATI_ZILNICE', 9.0, 'Efort maxim, similar cu exercitiul de la sala (urcatul cu cumparaturi).'),
('Joaca activa cu copiii', 'ACTIVITATI_ZILNICE', 5.0, 'Alergat prin parc, ridicat in brate, jocuri de miscare.'),
('Mutat mobila / Impachetat', 'ACTIVITATI_ZILNICE', 6.0, 'Ridicarea si mutarea de cutii grele, organizare fizica prin casa.'),
('Condus masina (Trafic / Sofat)', 'ACTIVITATI_ZILNICE', 1.5, 'Stare de repaus activ, cu un mic consum caloric mental si fizic usor.');

INSERT INTO activitati_fizice (nume, categorie, met, descriere) VALUES
-- ==========================================
-- CARDIO & FITNESS MODERN
-- ==========================================
('Antrenament HIIT', 'CARDIO', 8.0, 'High-Intensity Interval Training, efort exploziv cu pauze foarte scurte.'),
('Zumba / Dans Aerobic', 'CARDIO', 6.5, 'Antrenament cardio dinamic, pe muzica ritmata, care implica intreg corpul.'),
('Step Aerobic (Cu stepper)', 'CARDIO', 8.5, 'Clasa de aerobic foarte solicitanta, excelenta pentru fesieri si picioare.'),
('Aquagym (Gimnastica in apa)', 'CARDIO', 5.3, 'Exercitii in piscina, impact zero pentru articulatii, dar rezistenta musculara mare.'),
('Mers pe munte (Drumetie usoara)', 'CARDIO', 6.0, 'Drumetie pe trasee montane, efort constant pentru picioare si plamani.'),
('Mers pe munte (Cu rucsac greu)', 'CARDIO', 7.8, 'Drumetie montana cu echipament in spate, solicitare maxima a rezistentei.'),
('Skateboarding / Longboard', 'CARDIO', 5.0, 'Deplasare activa pe placa, antrenament foarte bun pentru echilibru si glezne.'),

-- ==========================================
-- FORTA & TONIFIERE
-- ==========================================
('TRX (Antrenament in suspensie)', 'FORTA', 6.0, 'Exercitii cu curele de suspensie, activeaza intens toata musculatura stabilizatoare.'),
('Genuflexiuni si Fandari (Bodyweight)', 'FORTA', 5.0, 'Antrenament pentru picioare folosind strict greutatea propriului corp.'),
('Abdomene / Core Workout', 'FORTA', 2.8, 'Exercitii specifice pentru zona mediana (plank, crunch) pe saltea.'),

-- ==========================================
-- SPORTURI DE ECHIPA & RACHETA
-- ==========================================
('Squash', 'SPORT_DE_ECHIPA', 7.3, 'Joc de racheta intr-un spatiu inchis, sprinturi foarte scurte si ritm alert.'),
('Badminton (Competitiv)', 'SPORT_DE_ECHIPA', 5.5, 'Joc intens, necesita reflexe rapide, fandari si schimbari de directie.'),
('Volei pe plaja', 'SPORT_DE_ECHIPA', 8.0, 'Extrem de solicitant fizic din cauza deplasarii si sariturilor pe nisip.'),
('Frisbee (Ultimate)', 'SPORT_DE_ECHIPA', 8.0, 'Joc de echipa in aer liber, cu sprinturi continue si sarituri.'),

-- ==========================================
-- ACTIVITATI ZILNICE (Consum caloric NEAT mare)
-- ==========================================
('Dat zapada cu lopata', 'ACTIVITATI_ZILNICE', 6.0, 'Efort cardiovascular si muscular major, foarte solicitant pentru spate.'),
('Taiat lemne (Cu toporul)', 'ACTIVITATI_ZILNICE', 6.0, 'Miscare exploziva si grea, lucreaza intens umerii, spatele si trunchiul.'),
('Tuns iarba (Masina manuala)', 'ACTIVITATI_ZILNICE', 5.5, 'Impingerea masinii de tuns pe gazon, ardere calorica mare in curte.'),
('Curatat geamuri / Spalat masina', 'ACTIVITATI_ZILNICE', 3.2, 'Munca fizica moderata, intinderi continue ale bratelor.'),
('Plimbat cainele', 'ACTIVITATI_ZILNICE', 3.0, 'Mers in ritm relaxat, cu opriri frecvente. Bun pentru relaxare mentala.'),
('Gatit / Prepararea mesei', 'ACTIVITATI_ZILNICE', 2.0, 'Stat in picioare, taiat ingrediente si miscare pasiva prin bucatarie.');

UPDATE alimente SET nutrition_score ='UNKNOWN' WHERE nutrition_score IS NULL;

UPDATE inregistrari_alimente SET categorie ='ALTELE' WHERE categorie IS NULL;

UPDATE inregistrari_alimente SET nutrition_score ='UNKNOWN' WHERE nutrition_score IS NULL;

-- FRUCTE & LEGUME (Majoritatea au ~0g grasimi saturate)
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Mar';
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Banana';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Capsuni';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Portocala';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Rosie';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Castravete';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Cartof';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Morcov';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Ceapa';
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Usturoi';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Ardei Gras';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Spanac (Crud)';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Broccoli (Crud)';
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Struguri';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Pepene Rosu';
UPDATE alimente SET saturated_fat100g = 2.1 WHERE product_name = 'Avocado';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Ciuperci (Champignon)';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Vinete';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Dovlecel';
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Fasole Alba (Fiarta)';
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Linte (Fiarta)';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Lamaie';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Pere';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Piersici';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Afine';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Varza Alba';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Cartof Dulce';
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Mazare Verde (Fiarta)';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Zmeura';
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Mango';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Conopida (Cruda)';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Zucchini (Crud)';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Ciuperci Pleurotus';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Salata Verde (Iceberg)';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Ananas (Crud)';
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Rodie (Miez)';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Curmale (Uscate)';
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Stafide';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Cirese';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Prune';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Kiwi';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Pepene Galben';
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Telina (Radacina)';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Fasole Verde (Pastai)';

-- CARNE & PESTE
UPDATE alimente SET saturated_fat100g = 1.0 WHERE product_name = 'Piept de Pui';
UPDATE alimente SET saturated_fat100g = 2.0 WHERE product_name = 'Carne de Porc (Macra)';
UPDATE alimente SET saturated_fat100g = 6.0 WHERE product_name = 'Carne de Vita (Macra)';
UPDATE alimente SET saturated_fat100g = 3.1 WHERE product_name = 'Somon (Crud)';
UPDATE alimente SET saturated_fat100g = 0.2 WHERE product_name = 'Ton in Suc Propriu (Conserva)';
UPDATE alimente SET saturated_fat100g = 0.4 WHERE product_name = 'Piept de Curcan (Crud)';
UPDATE alimente SET saturated_fat100g = 3.3 WHERE product_name = 'Macrou';
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Creveti (Fierti)';
UPDATE alimente SET saturated_fat100g = 0.4 WHERE product_name = 'Calamar (Crud)';
UPDATE alimente SET saturated_fat100g = 1.9 WHERE product_name = 'Carne de Miel (Macra)';
UPDATE alimente SET saturated_fat100g = 1.1 WHERE product_name = 'Pulpe de Pui (Fara Piele)';

-- MEZELURI
UPDATE alimente SET saturated_fat100g = 1.2 WHERE product_name = 'Sunca de Praga';
UPDATE alimente SET saturated_fat100g = 12.0 WHERE product_name = 'Salam Uscat';
UPDATE alimente SET saturated_fat100g = 11.0 WHERE product_name = 'Carnati de Porc';
UPDATE alimente SET saturated_fat100g = 8.5 WHERE product_name = 'Pate de Ficat de Porc';
UPDATE alimente SET saturated_fat100g = 6.0 WHERE product_name = 'Crenvursti de Pui';

-- LACTATE & OUA & BRANZETURI
UPDATE alimente SET saturated_fat100g = 1.0 WHERE product_name = 'Lapte de Vaca 1.5%';
UPDATE alimente SET saturated_fat100g = 1.3 WHERE product_name = 'Iaurt Grecesc 2%';
UPDATE alimente SET saturated_fat100g = 14.0 WHERE product_name = 'Telemea de Vaca';
UPDATE alimente SET saturated_fat100g = 3.3 WHERE product_name = 'Ou de Gaina';
UPDATE alimente SET saturated_fat100g = 15.0 WHERE product_name = 'Cascaval';
UPDATE alimente SET saturated_fat100g = 14.0 WHERE product_name = 'Mozzarella';
UPDATE alimente SET saturated_fat100g = 1.7 WHERE product_name = 'Branza Cottage (Perle)';
UPDATE alimente SET saturated_fat100g = 1.0 WHERE product_name = 'Kefir 1.5%';
UPDATE alimente SET saturated_fat100g = 13.0 WHERE product_name = 'Smantana 20%';
UPDATE alimente SET saturated_fat100g = 1.3 WHERE product_name = 'Branza Fagaras (Light)';
UPDATE alimente SET saturated_fat100g = 10.0 WHERE product_name = 'Smantana pentru Gatit (15%)';
UPDATE alimente SET saturated_fat100g = 15.0 WHERE product_name = 'Branza Feta';
UPDATE alimente SET saturated_fat100g = 19.0 WHERE product_name = 'Parmezan';
UPDATE alimente SET saturated_fat100g = 15.0 WHERE product_name = 'Branza Camembert';
UPDATE alimente SET saturated_fat100g = 18.0 WHERE product_name = 'Branza Gouda';

-- CEREALE & PAINE
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Orez Alb';
UPDATE alimente SET saturated_fat100g = 1.2 WHERE product_name = 'Ovaz';
UPDATE alimente SET saturated_fat100g = 0.7 WHERE product_name = 'Paine Integrala';
UPDATE alimente SET saturated_fat100g = 0.7 WHERE product_name = 'Paine Alba';
UPDATE alimente SET saturated_fat100g = 0.3 WHERE product_name = 'Paste Fainoase (Crude)';
UPDATE alimente SET saturated_fat100g = 0.3 WHERE product_name = 'Malai';
UPDATE alimente SET saturated_fat100g = 0.7 WHERE product_name = 'Quinoa (Cruda)';
UPDATE alimente SET saturated_fat100g = 0.1 WHERE product_name = 'Fulgi de Porumb (Fara Zahar)';
UPDATE alimente SET saturated_fat100g = 12.0 WHERE product_name = 'Croissant cu Unt';
UPDATE alimente SET saturated_fat100g = 0.4 WHERE product_name = 'Paine de secara';
UPDATE alimente SET saturated_fat100g = 1.2 WHERE product_name = 'Lipie (Wrap)';
UPDATE alimente SET saturated_fat100g = 0.2 WHERE product_name = 'Bulgur (Crud)';
UPDATE alimente SET saturated_fat100g = 0.2 WHERE product_name = 'Faina Alba (Graul 000)';
UPDATE alimente SET saturated_fat100g = 0.4 WHERE product_name = 'Faina Integrala';
UPDATE alimente SET saturated_fat100g = 0.8 WHERE product_name = 'Pesmet';
UPDATE alimente SET saturated_fat100g = 1.0 WHERE product_name = 'Cereale cu Ciocolata';
UPDATE alimente SET saturated_fat100g = 1.2 WHERE product_name = 'Musli cu Fructe';
UPDATE alimente SET saturated_fat100g = 1.0 WHERE product_name = 'Paine Prajita (Zwieback)';

-- SEMINTE & NUCI & GRASIMI
UPDATE alimente SET saturated_fat100g = 14.0 WHERE product_name = 'Ulei de Masline';
UPDATE alimente SET saturated_fat100g = 6.1 WHERE product_name = 'Miez de Nuca';
UPDATE alimente SET saturated_fat100g = 3.8 WHERE product_name = 'Migdale (Crude)';
UPDATE alimente SET saturated_fat100g = 51.0 WHERE product_name = 'Unt 82%';
UPDATE alimente SET saturated_fat100g = 10.0 WHERE product_name = 'Unt de Arahide';
UPDATE alimente SET saturated_fat100g = 3.3 WHERE product_name = 'Seminte de Chia';
UPDATE alimente SET saturated_fat100g = 4.5 WHERE product_name = 'Seminte de Floarea Soarelui';
UPDATE alimente SET saturated_fat100g = 7.0 WHERE product_name = 'Arahide (Crude)';
UPDATE alimente SET saturated_fat100g = 4.5 WHERE product_name = 'Alune de Padure (Crude)';
UPDATE alimente SET saturated_fat100g = 8.0 WHERE product_name = 'Caju (Crud)';
UPDATE alimente SET saturated_fat100g = 6.0 WHERE product_name = 'Fistic (Crud)';
UPDATE alimente SET saturated_fat100g = 6.0 WHERE product_name = 'Nuci Pecan';
UPDATE alimente SET saturated_fat100g = 12.0 WHERE product_name = 'Nuci Macadamia';
UPDATE alimente SET saturated_fat100g = 16.0 WHERE product_name = 'Nuci de Brazilia';
UPDATE alimente SET saturated_fat100g = 8.5 WHERE product_name = 'Seminte de Dovleac (Crude)';
UPDATE alimente SET saturated_fat100g = 3.7 WHERE product_name = 'Seminte de In';
UPDATE alimente SET saturated_fat100g = 7.0 WHERE product_name = 'Seminte de Susan';
UPDATE alimente SET saturated_fat100g = 4.6 WHERE product_name = 'Seminte de Canepa (Decorticate)';
UPDATE alimente SET saturated_fat100g = 4.5 WHERE product_name = 'Seminte de Mac';
UPDATE alimente SET saturated_fat100g = 8.0 WHERE product_name = 'Tahini (Pasta de Susan)';
UPDATE alimente SET saturated_fat100g = 4.0 WHERE product_name = 'Faina de Migdale';

-- DULCIURI & SNACKURI
UPDATE alimente SET saturated_fat100g = 25.0 WHERE product_name = 'Ciocolata Neagra 70%';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Miere';
UPDATE alimente SET saturated_fat100g = 4.0 WHERE product_name = 'Chipsuri din Cartofi (Cu Sare)';
UPDATE alimente SET saturated_fat100g = 0.6 WHERE product_name = 'Popcorn (Fara Ulei)';
UPDATE alimente SET saturated_fat100g = 10.0 WHERE product_name = 'Biscuiti Digestivi';
UPDATE alimente SET saturated_fat100g = 6.8 WHERE product_name = 'Inghetata de Vanilie';
UPDATE alimente SET saturated_fat100g = 18.0 WHERE product_name = 'Ciocolata cu Lapte';
UPDATE alimente SET saturated_fat100g = 11.0 WHERE product_name = 'Nutella (Crema de Cacao)';
UPDATE alimente SET saturated_fat100g = 0.6 WHERE product_name = 'Rondele de Orez Expandat';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Gem de Capsuni';

-- SOSURI & CONDIMENTE & DIVERSE
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Cafea (Fara Zahar)';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Bere Blonda';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Vin Rosu';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Suc de Portocale (Ambalat)';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Ketchup';
UPDATE alimente SET saturated_fat100g = 12.0 WHERE product_name = 'Maioneza';
UPDATE alimente SET saturated_fat100g = 0.2 WHERE product_name = 'Mustar';
UPDATE alimente SET saturated_fat100g = 1.5 WHERE product_name = 'Pudra Proteica (Whey)';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Zahar Alb';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Sare Fina';
UPDATE alimente SET saturated_fat100g = 1.0 WHERE product_name = 'Piper Negru';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Ceai Verde';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Bautura tip Cola (Cu Zahar)';
UPDATE alimente SET saturated_fat100g = 0.5 WHERE product_name = 'Mustar Dijon';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Otet din Cidru de Mere';
UPDATE alimente SET saturated_fat100g = 0.0 WHERE product_name = 'Sos de Soia';
UPDATE alimente SET saturated_fat100g = 5.0 WHERE product_name = 'Maioneza Light';
