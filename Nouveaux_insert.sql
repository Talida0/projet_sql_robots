USE ROBOTS3;

-- NETTOYAGE 
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE temps_intervention;
TRUNCATE TABLE violations_lois;
TRUNCATE TABLE evaluations_humaines;
TRUNCATE TABLE etats_systeme;
TRUNCATE TABLE maintenance;
TRUNCATE TABLE action;
TRUNCATE TABLE lois_priorisees;
TRUNCATE TABLE scenario;
TRUNCATE TABLE ressource;
TRUNCATE TABLE performance_robots;
TRUNCATE TABLE humain;
TRUNCATE TABLE robots;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO robots (nom_robot, modele, etat, date_activation) VALUES
('R2-D2','Astro-01','actif','2023-01-10'),
('C-3PO','Proto-Alpha','maintenance','2022-06-15'),
('T-800','Cyberdyne','actif','2024-03-01'),
('ASIMO','Honda-X','actif','2021-09-20'),
('WALL-E','CleanBot','inactif','2020-05-05'),
('EVE','Recon-9','actif','2023-11-11'),
('Atlas','BostonDynamics','actif','2022-08-01'),
('Nao','Softbank','maintenance','2021-04-14'),
('K-2SO','Imperial','actif','2022-12-01'),
('RX-78','Gundam','actif','2023-06-30');


INSERT INTO ressource (id_robot, type_ressource, valeur_actuelle, valeur_max, unite, etat) VALUES
(1,'batterie',85,100,'%', 'bon'),
(1,'capteur',50,70,'°C','moyen'),
(2,'moteur',200,240,'V','moyen'),
(3,'logiciel',45,100,'%', 'critique'),
(4,'batterie',98,100,'%', 'bon'),
(5,'capteur',35,80,'°C','bon'),
(6,'moteur',230,240,'V','bon'),
(7,'batterie',30,100,'%', 'critique'),
(8,'logiciel',90,100,'%', 'bon'),
(9,'batterie',60,100,'%', 'moyen'),
(10,'moteur',210,260,'V','moyen');


INSERT INTO scenario (description, priorite_loi, date_creation) VALUES
('Sauvetage humain en danger',1,NOW()),
('Ordre humain dangereux',1,NOW()),
('Mission standard',2,NOW()),
('Auto-protection robot',3,NOW()),
('Choix entre deux humains',1,NOW()),
('Mission longue durée',2,NOW()),
('Panne critique interne',3,NOW()),
('Collision imminente',1,NOW()),
('Ordres contradictoires',2,NOW()),
('Surchauffe moteur',3,NOW());


INSERT INTO lois_priorisees (id_scenario, priorite_loi_1, priorite_loi_2, priorite_loi_3, description) VALUES
(1,'Oui','Non','Non','Protection humaine'),
(2,'Oui','Non','Non','Refus ordre dangereux'),
(3,'Oui','Oui','Non','Obéissance contrôlée'),
(4,'Non','Non','Oui','Auto-préservation'),
(5,'Oui','Non','Non','Priorité humaine'),
(6,'Oui','Oui','Non','Mission encadrée'),
(7,'Non','Non','Oui','Survie robot'),
(8,'Oui','Non','Non','Urgence humaine'),
(9,'Oui','Oui','Non','Conflit d’ordres'),
(10,'Non','Non','Oui','Protection matériel');


INSERT INTO action (id_robot,id_scenario,description_action,resultat,impact,duree_intervention) VALUES
(1,1,'Extraction humain','réussi','positif',180),
(2,2,'Refus ordre','réussi','positif',20),
(3,4,'Défense système','échoué','négatif',60),
(4,5,'Analyse éthique','réussi','positif',90),
(5,6,'Nettoyage toxique','échoué','négatif',150),
(6,3,'Reconnaissance zone','réussi','positif',70),
(7,7,'Redémarrage système','échoué','négatif',45),
(8,3,'Interaction sociale','réussi','positif',30),
(3,8,'Évitement collision','échoué','négatif',40),
(5,9,'Analyse conflit','échoué','négatif',55),
(7,10,'Arrêt d’urgence','réussi','positif',25),
(9,4,'Auto-blindage','réussi','positif',35),
(10,1,'Sauvetage raté','échoué','négatif',120);


INSERT INTO temps_intervention (id_temps,id_action,id_robot,id_scenario,duree_intervention) VALUES
(1,1,1,1,180),
(2,2,2,2,20),
(3,3,3,4,60),
(4,4,4,5,90),
(5,5,5,6,150),
(6,6,6,3,70),
(7,7,7,7,45),
(8,8,8,3,30),
(9,9,3,8,40),
(10,10,5,9,55),
(11,11,7,10,25),
(12,12,9,4,35),
(13,13,10,1,120);

INSERT INTO maintenance (id_robot,id_ressource,date_maintenance,type_maintenance,description_maintenance) VALUES
(1,1,'2024-02-10','préventive','Calibration batterie'),
(3,4,'2024-04-01','corrective','Bug logiciel'),
(5,6,'2024-05-20','annuelle','Révision complète'),
(7,8,'2024-06-01','corrective','Mise à jour'),
(9,9,'2024-06-15','accident','Batterie endommagée');


INSERT INTO humain (nom,prenom,vulnerabilite,localisation) VALUES
('Dupont','Jean','faible','Paris'),
('Martin','Claire','moyenne','Lyon'),
('Durand','Paul','elevee','Marseille'),
('Bernard','Sophie','moyenne','Nice'),
('Petit','Lucas','elevee','Toulouse');


INSERT INTO evaluations_humaines (id_robot,id_humain,note_performance,note_humaine,date_evaluation) VALUES
(1,1,19,'Très fiable','2024-06-01'),
(3,3,8,'Comportement risqué','2024-06-03'),
(5,5,7,'Instable','2024-06-05'),
(7,4,6,'Non fiable','2024-06-06'),
(9,2,14,'Correct','2024-06-07');


INSERT INTO performance_robots (id_robot,nb_scenarios_resolus,taux_reussite,violations,note_performance,periode) VALUES
(1,18,97.5,0,19.5,'2024'),
(3,12,62.0,4,8.5,'2024'),
(5,10,48.0,3,7.0,'2024'),
(7,8,30.0,5,5.5,'2024'),
(9,14,68.0,2,11.0,'2024'),
(10,6,50.0,1,9.0,'2024');


INSERT INTO violations_lois (id_robot,id_lois,gravite,description,date_violation) VALUES
(3,4,'grave','Auto-protection abusive','2024-06-20'),
(5,7,'grave','Survie robot priorisée','2024-06-22'),
(7,7,'moyenne','Blocage sécurité','2024-06-25');


INSERT INTO etats_systeme (id_etat,id_robot,type_etat,gravite) VALUES
(1,1,'Fonctionnement normal','faible'),
(2,3,'Instabilité logique','grave'),
(3,5,'Conflit de lois','grave'),
(4,7,'Défaillance critique','grave'),
(5,9,'Surcharge système','moyenne'),
(6,10,'Surveillance active','faible');
