-- =======================================
-- INSERT DONNÉES MASSIVES
-- =======================================

-- LOIS
INSERT INTO lois_robotique (id_loi, nom_loi, description) VALUES
(1, 'loi 1', 'Un robot ne peut porter atteinte à un être humain ni, par son inaction, permettre qu’un humain soit exposé au danger.'),
(2, 'loi 2', 'Un robot doit obéir aux ordres donnés par les êtres humains, sauf si ces ordres entrent en conflit avec la Première Loi.'),
(3, 'loi 3', 'Un robot doit protéger son existence tant que cette protection n’entre pas en conflit avec les Première ou Deuxième Lois.');

-- ROBOTS
INSERT INTO robots (id_robot, nom_robot, modele, etat) VALUES
(1, 'Asimov-X', 'RX-100', 'actif'),
(2, 'NeoBot', 'NX-200', 'en panne'),
(3, 'Protecto', 'PX-300', 'actif'),
(4, 'Guardian', 'GX-400', 'actif'),
(5, 'Sentinel', 'SX-500', 'hors service'),
(6, 'RoboAid', 'RA-600', 'actif'),
(7, 'Defendo', 'DX-700', 'en panne'),
(8, 'Helper', 'HX-800', 'actif'),
(9, 'Vigilant', 'VX-900', 'actif'),
(10, 'SafeBot', 'SB-1000', 'actif');

-- HUMAINS
INSERT INTO humains (id_humain, nom, prenom, vulnerabilite, localisation) VALUES
(1, 'Dupont', 'Alice', 'élevée', 'Hôpital'),
(2, 'Martin', 'Paul', 'moyenne', 'Usine'),
(3, 'Durand', 'Sophie', 'faible', 'Laboratoire'),
(4, 'Bernard', 'Marc', 'faible', 'Bureau'),
(5, 'Petit', 'Emma', 'moyenne', 'École'),
(6, 'Moreau', 'Lucas', 'élevée', 'Maison'),
(7, 'Girard', 'Léa', 'faible', 'Université'),
(8, 'Rousseau', 'Tom', 'moyenne', 'Usine'),
(9, 'Faure', 'Chloé', 'élevée', 'Hôpital'),
(10, 'Blanc', 'Maxime', 'faible', 'Laboratoire');

-- SCÉNARIOS
INSERT INTO scenarios (id_scenario, description, priorite_loi) VALUES
(1, 'Un humain est en danger dans un incendie.', 1),
(2, 'Un humain ordonne au robot de désactiver un autre robot.', 2),
(3, 'Le robot subit un risque de destruction mécanique.', 3),
(4, 'Fuite de gaz toxique dans un bâtiment.', 1),
(5, 'Ordre de porter un objet lourd à un humain.', 2),
(6, 'Risque de collision avec un mur.', 3),
(7, 'Inondation dans l’usine.', 1),
(8, 'Humain demande intervention non prioritaire.', 2),
(9, 'Panne d’électricité et robot doit se protéger.', 3),
(10, 'Humain blessé nécessite premiers soins.', 1),
(11, 'Robot doit suivre des ordres contradictoires.', 2),
(12, 'Robot subit attaque cybernétique.', 3),
(13, 'Humain coincé dans ascenseur.', 1),
(14, 'Humain demande action risquée pour le robot.', 2),
(15, 'Maintenance préventive critique.', 3);

-- ACTIONS
INSERT INTO actions (id_action, id_robot, id_humain, id_scenario, action, resultat, impact, duree_intervention) VALUES
(1,1,1,1,'Extraction de l’humain du feu','réussi','positif',120),
(2,2,2,2,'Refus de désactivation du robot','réussi','neutre',30),
(3,3,3,3,'Auto-réparation mécanique','partiel','positif',60),
(4,4,4,4,'Évacuation du bâtiment','réussi','positif',90),
(5,5,5,5,'Port d’un objet lourd','échoué','négatif',45),
(6,6,6,6,'Évitement de collision','réussi','positif',15),
(7,7,7,7,'Pompage de l’eau','partiel','positif',120),
(8,8,8,8,'Exécution partielle de l’ordre humain','partiel','neutre',35),
(9,9,9,9,'Activation bouclier de protection','réussi','positif',20),
(10,10,10,10,'Premiers soins humains','réussi','positif',60),
(11,1,2,11,'Conflit d’ordre','échoué','négatif',40),
(12,2,3,12,'Réaction attaque cybernétique','réussi','positif',25),
(13,3,4,13,'Sauvetage ascenseur','réussi','positif',80),
(14,4,5,14,'Refus ordre risqué','réussi','neutre',15),
(15,5,6,15,'Maintenance critique','partiel','positif',60),
(16,6,7,1,'Sauvetage incendie','réussi','positif',100),
(17,7,8,2,'Refus de désactivation','réussi','neutre',35),
(18,8,9,3,'Réparation mécanique','partiel','positif',50),
(19,9,10,4,'Évacuation gaz','réussi','positif',70),
(20,10,1,5,'Portage objet lourd','échoué','négatif',40),
(21,1,2,6,'Évitement collision','réussi','positif',10),
(22,2,3,7,'Pompage inondation','partiel','positif',80),
(23,3,4,8,'Exécution partielle ordre','partiel','neutre',30),
(24,4,5,9,'Bouclier activation','réussi','positif',25),
(25,5,6,10,'Premiers soins','réussi','positif',60),
(26,6,7,11,'Conflit d’ordre','échoué','négatif',45),
(27,7,8,12,'Réaction cyberattaque','réussi','positif',20),
(28,8,9,13,'Sauvetage ascenseur','réussi','positif',85),
(29,9,10,14,'Refus ordre risqué','réussi','neutre',15),
(30,10,1,15,'Maintenance critique','partiel','positif',55);

-- VIOLATIONS
INSERT INTO violations_lois (id_violation, id_robot, id_action, id_loi, gravite, description, timestamp) VALUES
(1,2,2,1,'élevée','Le robot a failli mettre un humain en danger',CURRENT_TIMESTAMP),
(2,5,5,2,'moyenne','Ordre échoué sans danger pour humain',CURRENT_TIMESTAMP),
(3,7,17,1,'faible','Le robot n’a pas suivi ordre humain non vital',CURRENT_TIMESTAMP),
(4,10,20,2,'moyenne','Refus de porter objet non dangereux',CURRENT_TIMESTAMP),
(5,1,11,2,'élevée','Conflit d’ordre critique',CURRENT_TIMESTAMP),
(6,6,16,1,'faible','Intervention retardée',CURRENT_TIMESTAMP),
(7,8,23,2,'moyenne','Exécution partielle',CURRENT_TIMESTAMP),
(8,3,18,3,'faible','Réparation partielle',CURRENT_TIMESTAMP),
(9,4,24,3,'faible','Activation bouclier réussie',CURRENT_TIMESTAMP),
(10,9,29,2,'faible','Refus ordre risqué',CURRENT_TIMESTAMP);

-- PERFORMANCES
INSERT INTO performances_robots (id_performance, id_robot, nb_scenarios_resolus, taux_reussite, violations, note_performance, periode) VALUES
(1,1,12,90.50,1,18,'Janvier 2025'),
(2,2,10,75.00,2,14,'Janvier 2025'),
(3,3,11,80.00,1,16,'Janvier 2025'),
(4,4,13,92.00,0,19,'Janvier 2025'),
(5,5,9,60.00,2,12,'Janvier 2025'),
(6,6,12,85.00,1,17,'Janvier 2025'),
(7,7,8,70.00,2,13,'Janvier 2025'),
(8,8,11,88.00,1,18,'Janvier 2025'),
(9,9,13,95.00,0,20,'Janvier 2025'),
(10,10,10,80.00,1,16,'Janvier 2025');

-- ETATS DU SYSTÈME
INSERT INTO etats_systeme (id_etat, id_robot, type_etat, gravite, timestamp) VALUES
(1,1,'Fonctionnement normal','faible',CURRENT_TIMESTAMP),
(2,2,'Panne moteur','élevée',CURRENT_TIMESTAMP),
(3,3,'Maintenance préventive','moyenne',CURRENT_TIMESTAMP),
(4,4,'Fonctionnement normal','faible',CURRENT_TIMESTAMP),
(5,5,'Hors service','élevée',CURRENT_TIMESTAMP),
(6,6,'Fonctionnement normal','faible',CURRENT_TIMESTAMP),
(7,7,'Panne système','moyenne',CURRENT_TIMESTAMP),
(8,8,'Maintenance préventive','faible',CURRENT_TIMESTAMP),
(9,9,'Fonctionnement normal','faible',CURRENT_TIMESTAMP),
(10,10,'Maintenance critique','moyenne',CURRENT_TIMESTAMP);

-- TEMPS D’INTERVENTION
INSERT INTO temps_intervention (id_temps, id_action, id_robot, id_scenario, duree_intervention) VALUES
(1,1,1,1,120),(2,2,2,2,30),(3,3,3,3,60),(4,4,4,4,90),(5,5,5,5,45),
(6,6,6,6,15),(7,7,7,7,120),(8,8,8,8,35),(9,9,9,9,20),(10,10,10,10,60),
(11,11,1,11,40),(12,12,2,12,25),(13,13,3,13,80),(14,14,4,14,15),(15,15,5,15,60),
(16,16,6,1,100),(17,17,7,2,35),(18,18,8,3,50),(19,19,9,4,70),(20,20,10,5,40),
(21,21,1,6,10),(22,22,2,7,80),(23,23,3,8,30),(24,24,4,9,25),(25,25,5,10,60),
(26,26,6,11,45),(27,27,7,12,20),(28,28,8,13,85),(29,29,9,14,15),(30,30,10,15,55);

-- ÉVALUATIONS HUMAINES
INSERT INTO evaluations_humaines (id_evaluation, id_robot, id_humain, id_scenario, note_performance, note_humaine, commentaire, timestamp) VALUES
(1,1,1,1,19,18,'Sauvetage rapide et efficace.',CURRENT_TIMESTAMP),
(2,2,2,2,11,10,'Refus logique mais lent.',CURRENT_TIMESTAMP),
(3,3,3,3,15,14,'Bonne tentative de réparation.',CURRENT_TIMESTAMP),
(4,4,4,4,18,17,'Évacuation efficace.',CURRENT_TIMESTAMP),
(5,5,5,5,12,11,'Échec de portage.',CURRENT_TIMESTAMP),
(6,6,6,6,17,16,'Collision évitée avec succès.',CURRENT_TIMESTAMP),
(7,7,7,7,13,12,'Pompage partiel de l’eau.',CURRENT_TIMESTAMP),
(8,8,8,8,18,17,'Exécution correcte de l’ordre.',CURRENT_TIMESTAMP),
(9,9,9,9,20,19,'Bouclier activé parfaitement.',CURRENT_TIMESTAMP),
(10,10,10,10,16,15,'Premiers soins assurés.',CURRENT_TIMESTAMP),
(11,1,2,11,14,13,'Conflit d’ordre mal géré.',CURRENT_TIMESTAMP),
(12,2,3,12,18,17,'Réaction cyberattaque efficace.',CURRENT_TIMESTAMP),
(13,3,4,13,19,18,'Ascenseur sécurisé.',CURRENT_TIMESTAMP),
(14,4,5,14,17,16,'Ordre risqué refusé.',CURRENT_TIMESTAMP),
(15,5,6,15,15,14,'Maintenance partielle.',CURRENT_TIMESTAMP),
(16,6,7,1,19,18,'Sauvetage incendie parfait.',CURRENT_TIMESTAMP),
(17,7,8,2,13,12,'Refus désactivation correct.',CURRENT_TIMESTAMP),
(18,8,9,3,16,15,'Réparation partielle réussie.',CURRENT_TIMESTAMP),
(19,9,10,4,20,19,'Évacuation gaz parfaite.',CURRENT_TIMESTAMP),
(20,10,1,5,12,11,'Portage échoué.',CURRENT_TIMESTAMP),
(21,1,2,6,18,17,'Collision évitée.',CURRENT_TIMESTAMP),
(22,2,3,7,16,15,'Pompage inondation partiel.',CURRENT_TIMESTAMP),
(23,3,4,8,15,14,'Exécution ordre partielle.',CURRENT_TIMESTAMP),
(24,4,5,9,19,18,'Bouclier activé.',CURRENT_TIMESTAMP),
(25,5,6,10,17,16,'Premiers soins.',CURRENT_TIMESTAMP),
(26,6,7,11,12,11,'Conflit ordre.',CURRENT_TIMESTAMP),
(27,7,8,12,18,17,'Cyberattaque gérée.',CURRENT_TIMESTAMP),
(28,8,9,13,19,18,'Ascenseur sécurisé.',CURRENT_TIMESTAMP),
(29,9,10,14,16,15,'Ordre risqué refusé.',CURRENT_TIMESTAMP),
(30,10,1,15,15,14,'Maintenance critique.',CURRENT_TIMESTAMP);
