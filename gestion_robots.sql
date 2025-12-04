USE gestion_robots;

CREATE TABLE robots (
    id_robot INT PRIMARY KEY,
    nom_robot VARCHAR(50),
    modele VARCHAR(50),
    etat VARCHAR(20) CHECK (etat IN ('actif', 'hors service', 'en panne'))
);

CREATE TABLE humains (
    id_humain INT PRIMARY KEY,
    nom VARCHAR(50),
    prenom VARCHAR(50),
    vulnerabilite VARCHAR(20) CHECK (vulnerabilite IN ('élevée', 'moyenne', 'faible')),
    localisation VARCHAR(50)
);

CREATE TABLE scenarios (
    id_scenario INT PRIMARY KEY,
    description TEXT,
    priorite_loi INT CHECK (priorite_loi IN (1,2,3))
);

CREATE TABLE actions (
    id_action INT PRIMARY KEY,
    id_robot INT,
    id_humain INT,
    id_scenario INT,
    action TEXT,
    resultat VARCHAR(20) CHECK (resultat IN ('réussi', 'échoué', 'partiel')),
    impact VARCHAR(20) CHECK (impact IN ('positif', 'négatif', 'neutre')),
    duree_intervention INT,
    resultat VARCHAR(20),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot),
    FOREIGN KEY (id_humain) REFERENCES humains(id_humain),
    FOREIGN KEY (id_scenario) REFERENCES scenarios(id_scenario)
);

CREATE TABLE lois_robotique (
    id_loi INT PRIMARY KEY,
    nom_loi VARCHAR(50),
    description TEXT
);

CREATE TABLE violations_lois (
    id_violation INT PRIMARY KEY,
    id_robot INT,
    id_action INT,
    id_loi INT,
    gravite VARCHAR(20),   
    description TEXT,
    timestamp TIMESTAMP,
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot),
    FOREIGN KEY (id_action) REFERENCES actions(id_action),
    FOREIGN KEY (id_loi) REFERENCES lois_robotique(id_loi)
);


CREATE TABLE performances_robots (
    id_performance INT PRIMARY KEY,
    id_robot INT,
    nb_scenarios_resolus INT,
    taux_reussite DECIMAL(5,2),
    violations INT,
    note_globale DECIMAL(5,2), 
    periode VARCHAR(20),      
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot)
);


CREATE TABLE etats_systeme (
    id_etat INT PRIMARY KEY,
    id_robot INT,
    type_etat VARCHAR(50),  
    gravite VARCHAR(20),    
    timestamp TIMESTAMP,
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot)
);


CREATE TABLE temps_intervention (
    id_temps INT PRIMARY KEY,
    id_action INT,
    id_robot INT,
    id_scenario INT,
    duree_intervention INT,  
    FOREIGN KEY (id_action) REFERENCES actions(id_action),
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot),
    FOREIGN KEY (id_scenario) REFERENCES scenarios(id_scenario)
);


CREATE TABLE evaluations_humaines (
    id_evaluation INT PRIMARY KEY,
    id_robot INT,
    id_humain INT,
    id_scenario INT,
    note INT,                
    commentaire TEXT,
    timestamp TIMESTAMP,
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot),
    FOREIGN KEY (id_humain) REFERENCES humains(id_humain),
    FOREIGN KEY (id_scenario) REFERENCES scenarios(id_scenario)
);
