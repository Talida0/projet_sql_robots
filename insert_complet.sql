-- =====================================================
-- INSERT STATEMENTS FOR ROBOTS3 DATABASE
-- =====================================================

USE ROBOTS3;

-- INSERT INTO robots
INSERT INTO robots (nom_robot, modele, etat, date_activation) VALUES
('RoboX-1', 'Model A', 'actif', '2024-01-15'),
('RoboX-2', 'Model B', 'actif', '2024-02-20'),
('RoboX-3', 'Model A', 'maintenance', '2024-03-10'),
('RoboX-4', 'Model C', 'actif', '2024-04-05'),
('RoboX-5', 'Model B', 'inactif', '2024-01-30');

-- INSERT INTO ressource
INSERT INTO ressource (id_robot, type_ressource, valeur_actuelle, valeur_max, unite, etat) VALUES
(1, 'batterie', 85.50, 100.00, 'mAh', 'bon'),
(1, 'capteur', 42.00, 50.00, '%', 'bon'),
(1, 'moteur', 3.50, 5.00, 'V', 'moyen'),
(2, 'batterie', 45.00, 100.00, 'mAh', 'moyen'),
(2, 'capteur', 30.00, 50.00, '%', 'critique'),
(2, 'logiciel', 2.10, 2.50, 'V', 'bon'),
(3, 'batterie', 10.00, 100.00, 'mAh', 'critique'),
(3, 'moteur', 4.80, 5.00, 'V', 'bon'),
(4, 'batterie', 92.00, 100.00, 'mAh', 'bon'),
(4, 'capteur', 48.00, 50.00, '%', 'bon'),
(5, 'batterie', 5.00, 100.00, 'mAh', 'critique');

-- INSERT INTO action
INSERT INTO action (id_robot, description_action, resultat, impact, duree_intervention) VALUES
(1, 'Inspection capteur de proximité', 'réussi', 'positif', 15),
(2, 'Remplacement batterie', 'réussi', 'positif', 30),
(3, 'Diagnostic système', 'réussi', 'négatif', 45),
(4, 'Calibrage moteur', 'réussi', 'positif', 20),
(1, 'Nettoyage mécanique', 'réussi', 'positif', 10),
(2, 'Test logiciel', 'échoué', 'négatif', 25),
(3, 'Mise à jour firmware', 'réussi', 'positif', 60);

-- INSERT INTO maintenance
INSERT INTO maintenance (id_robot, id_ressource, date_maintenance, type_maintenance, description_maintenance) VALUES
(1, 1, '2024-12-01', 'préventive', 'Maintenance programmée batterie'),
(2, 5, '2024-12-05', 'corrective', 'Remplacement capteur défaillant'),
(3, 7, '2024-12-10', 'annuelle', 'Révision complète système'),
(4, 9, '2024-11-20', 'préventive', 'Vérification batterie'),
(1, 3, '2024-12-08', 'corrective', 'Remplacement moteur usé');

-- INSERT INTO scenario
INSERT INTO scenario (description, priorite_loi, date_creation) VALUES
('Éviter collision avec humain faible', 1, '2024-11-01 10:30:00'),
('Décider du poids des dégâts matériels vs danger humain', 2, '2024-11-05 14:15:00'),
('Optimiser trajectoire en environnement urbain', 1, '2024-11-10 09:00:00'),
('Gestion d\'une urgence médicale', 1, '2024-11-15 16:45:00'),
('Prioriser tâches multiples simultanées', 3, '2024-11-20 11:20:00');

-- INSERT INTO humain
INSERT INTO humain (nom, prenom, vulnerabilite, localisation) VALUES
('Dupont', 'Jean', 'faible', 'Zone A'),
('Martin', 'Marie', 'moyenne', 'Zone B'),
('Bernard', 'Pierre', 'elevee', 'Zone A'),
('Thomas', 'Sophie', 'faible', 'Zone C'),
('Robert', 'Luc', 'moyenne', 'Zone B'),
('Petit', 'Anne', 'elevee', 'Zone A');

-- INSERT INTO performance_robots
INSERT INTO performance_robots (id_robot, nb_scenarios_resolus, taux_reussite, violations, note_performance, periode) VALUES
(1, 15, 95.50, 0, 18.75, 'Novembre 2024'),
(2, 12, 88.00, 2, 16.50, 'Novembre 2024'),
(3, 8, 75.00, 5, 14.00, 'Novembre 2024'),
(4, 18, 98.00, 0, 19.50, 'Novembre 2024'),
(5, 5, 60.00, 8, 12.00, 'Novembre 2024');

-- INSERT INTO lois_priorisees
INSERT INTO lois_priorisees (id_scenario, priorite_loi_1, priorite_loi_2, priorite_loi_3, description) VALUES
(1, 'Oui', 'Non', 'Non', 'Première loi: Un robot ne peut porter atteinte à un être humain'),
(2, 'Non', 'Oui', 'Non', 'Deuxième loi: Un robot doit obéir aux ordres donnés par les êtres humains'),
(3, 'Oui', 'Oui', 'Non', 'Combinaison lois 1 et 2'),
(4, 'Oui', 'Non', 'Non', 'Urgence - priorité à la vie humaine'),
(5, 'Non', 'Non', 'Oui', 'Troisième loi: Un robot doit protéger son existence');

-- INSERT INTO evaluations_humaines
INSERT INTO evaluations_humaines (id_robot, id_humain, note_performance, note_humaine, date_evaluation) VALUES
(1, 1, 18, 'Très bon fonctionnement, fiable', '2024-12-01'),
(2, 2, 16, 'Bon robot mais quelques lenteurs', '2024-12-02'),
(3, 3, 14, 'Acceptable, nécessite maintenance', '2024-12-03'),
(4, 4, 19, 'Excellent, très réactif', '2024-12-04'),
(5, 5, 12, 'À améliorer, plusieurs dysfonctionnements', '2024-12-05'),
(1, 6, 17, 'Fiable et rapide', '2024-12-06');

-- INSERT INTO violations_lois
INSERT INTO violations_lois (id_robot, id_lois, gravite, description, date_violation) VALUES
(2, 1, 'moyenne', 'Retard de réaction face à obstacle', '2024-11-15'),
(3, 1, 'grave', 'Approche trop proche d\'un humain vulnérable', '2024-11-20'),
(2, 2, 'faible', 'Non respect de commande mineure', '2024-11-25'),
(5, 1, 'grave', 'Arrêt système sans notification préalable', '2024-12-01'),
(3, 5, 'moyenne', 'Auto-arrêt en conflit avec tâche assignée', '2024-12-05');

-- INSERT INTO temps_intervention
INSERT INTO temps_intervention (id_temps, id_action, id_robot, id_scenario, duree_intervention) VALUES
(1, 1, 1, 1, 15),
(2, 2, 2, 2, 30),
(3, 3, 3, 3, 45),
(4, 4, 4, 4, 20),
(5, 5, 1, 1, 10),
(6, 6, 2, 5, 25),
(7, 7, 3, 2, 60);

-- INSERT INTO etats_systeme
INSERT INTO etats_systeme (id_etat, id_robot, type_etat, gravite) VALUES
(1, 1, 'Normal', 'Aucune'),
(2, 2, 'Alerte batterie faible', 'Moyenne'),
(3, 3, 'Maintenance requise', 'Élevée'),
(4, 4, 'Normal', 'Aucune'),
(5, 5, 'Critique - À réparer', 'Critique'),
(6, 1, 'Capture de données', 'Aucune');

-- =====================================================
-- FIN DES INSERTIONS
-- =====================================================
