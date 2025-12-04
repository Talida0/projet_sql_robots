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
    resultat VARCHAR(20),
    timestamp TIMESTAMP,
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot),
    FOREIGN KEY (id_humain) REFERENCES humains(id_humain),
    FOREIGN KEY (id_scenario) REFERENCES scenarios(id_scenario)
);
