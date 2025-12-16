CREATE DATABASE ROBOTS3;

USE ROBOTS3; 

CREATE TABLE robots (
    id_robot INT AUTO_INCREMENT PRIMARY KEY,
    nom_robot VARCHAR(100) NOT NULL,
    modele VARCHAR(100),
    etat ENUM('actif', 'inactif', 'maintenance') NOT NULL DEFAULT 'actif',
    date_activation DATE
);

CREATE TABLE ressource (
    id_ressource INT AUTO_INCREMENT PRIMARY KEY,
    id_robot INT NOT NULL,
    type_ressource ENUM('batterie', 'capteur', 'moteur', 'logiciel') NOT NULL,
    valeur_actuelle DECIMAL(6,2),
    valeur_max DECIMAL(6,2),
    unite ENUM ('V', 'mAh', '°C', '%') NOT NULL,
    etat ENUM('bon', 'moyen', 'critique') NOT NULL,
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot)
);

CREATE TABLE scenario (
    id_scenario INT AUTO_INCREMENT PRIMARY KEY,
    description TEXT,
    priorite_loi INT CHECK (priorite_loi IN (1,2,3)),
    date_creation DATETIME NOT NULL
);

CREATE TABLE action (
    id_action INT AUTO_INCREMENT PRIMARY KEY,
    id_robot INT,
    id_scenario INT, 
    description_action TEXT,
    resultat ENUM('réussi', 'échoué'),
    impact ENUM('positif', 'négatif'),
    duree_intervention INT,
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot),
    FOREIGN KEY (id_scenario) REFERENCES scenario(id_scenario)
);

CREATE TABLE maintenance (
    id_maintenance INT AUTO_INCREMENT PRIMARY KEY,
    id_robot INT NOT NULL,
    id_ressource INT,
    date_maintenance DATE NOT NULL,
    type_maintenance ENUM('préventive', 'corrective', 'accident', 'annuelle') NOT NULL,
    description_maintenance TEXT,
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot),
    FOREIGN KEY (id_ressource) REFERENCES ressource(id_ressource)
);

CREATE TABLE humain (
    id_humain INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    vulnerabilite ENUM('faible', 'moyenne', 'elevee'),
    localisation VARCHAR(100)
);

CREATE TABLE performance_robots (
    id_performance INT AUTO_INCREMENT PRIMARY KEY,
    id_robot INT NOT NULL,
    nb_scenarios_resolus INT,
    taux_reussite DECIMAL(5,2),
    violations INT,
    note_performance DECIMAL(5,2),
    periode VARCHAR(50),
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot)
);

CREATE TABLE lois_priorisees (
    id_lois INT AUTO_INCREMENT PRIMARY KEY,
    id_scenario INT,
    priorite_loi_1 ENUM('Oui', 'Non') NOT NULL,
    priorite_loi_2 ENUM('Oui', 'Non') NOT NULL,
    priorite_loi_3 ENUM('Oui', 'Non') NOT NULL,
    description TEXT,
    FOREIGN KEY (id_scenario) REFERENCES scenario(id_scenario)
);

CREATE TABLE evaluations_humaines (
    id_evaluation INT AUTO_INCREMENT PRIMARY KEY,
    id_robot INT NOT NULL,
    id_humain INT NOT NULL,
    note_performance INT CHECK (note_performance BETWEEN 0 AND 20),
    note_humaine TEXT,
    date_evaluation DATE NOT NULL,
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot),
    FOREIGN KEY (id_humain) REFERENCES humain(id_humain)
);

CREATE TABLE violations_lois (
    id_violation INT AUTO_INCREMENT PRIMARY KEY,
    id_robot INT NOT NULL,
    id_lois INT NOT NULL,
    gravite ENUM('faible', 'moyenne', 'grave'),
    description TEXT,
    date_violation DATE,
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot),
    FOREIGN KEY (id_lois) REFERENCES lois_priorisees(id_lois)
);

CREATE TABLE temps_intervention (
    id_temps INT PRIMARY KEY,
    id_action INT,
    id_robot INT,
    id_scenario INT,
    duree_intervention INT,  
    FOREIGN KEY (id_action) REFERENCES action(id_action),
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot),
    FOREIGN KEY (id_scenario) REFERENCES scenario(id_scenario)
);

CREATE TABLE etats_systeme (
    id_etat INT PRIMARY KEY,
    id_robot INT,
    type_etat VARCHAR(50),  
    gravite VARCHAR(20),   
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot)
);
