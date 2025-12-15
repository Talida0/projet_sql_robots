CREATE TABLE robots (
    id_robot INT AUTO_INCREMENT PRIMARY KEY,
    nom_robot VARCHAR(100) NOT NULL,
    modele_robot VARCHAR(100),
    date_activation DATE,
    etat ENUM('actif', 'inactif', 'en maintenance') NOT NULL DEFAULT 'actif'
);

CREATE TABLE action (
    id_action INT AUTO_INCREMENT PRIMARY KEY,
    id_robot INT,
    type_action VARCHAR(100) NOT NULL,
    date_action DATETIME NOT NULL,
    description TEXT,
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot)
)

CREATE TABLE maintenance (
    id_maintenance INT AUTO_INCREMENT PRIMARY KEY,
    id_robot INT,
    date_maintenance DATE NOT NULL,
    type _maintenance ENUM('annuelle', 'corrective', 'préventive', 'accident') NOT NULL,
    FOREIGN KEY (id_robot) REFERENCES robots(id_robot)
);

CREATE TABLE scenario (
    id_scenario INT AUTO_INCREMENT PRIMARY KEY,
    nom_scenario VARCHAR(100) NOT NULL,
    description TEXT,
    date_creation DATETIME NOT NULL
);

CREATE TABLE lois_priorisees (
    id_lois INT AUTO_INCREMENT PRIMARY KEY,
    id_scenario INT,
    priorite_loi_1 ENUM('Oui', 'Non') NOT NULL,
    priorite_loi_2 ENUM('Oui', 'Non') NOT NULL,
    priorite_loi_3 ENUM('Oui', 'Non') NOT NULL,
    description TEXT,
    FOREIGN KEY (id_scenario) REFERENCES scenario(id_scenario)
)