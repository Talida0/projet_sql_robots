-- ETAPE 1: guidées

--1 DEFINIR des indicateur de performance: 

    --VUE vue_indicateurs_performance

    CREATE OR REPLACE VIEW vue_indicateurs_performance AS
SELECT 
    r.id_robot,
    r.nom_robot,
    COUNT(a.id_action) AS nb_actions_total,  -- toutes les actions du robot
    SUM(CASE WHEN a.resultat='réussi' THEN 1 ELSE 0 END) AS nb_actions_reussies,
    SUM(CASE WHEN a.resultat='échoué' THEN 1 ELSE 0 END) AS nb_actions_echouees,
     ROUND(
            100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / COUNT(*),
            2
        ) AS taux_reussite,
    SUM(CASE WHEN lp.priorite_loi_1='Oui' THEN 1 ELSE 0 END) AS nb_actions_priorite_loi_1,
    SUM(CASE WHEN lp.priorite_loi_2='Oui' THEN 1 ELSE 0 END) AS nb_actions_priorite_loi_2,
    SUM(CASE WHEN lp.priorite_loi_3='Oui' THEN 1 ELSE 0 END) AS nb_actions_priorite_loi_3
FROM robots r
JOIN action a ON a.id_robot = r.id_robot
LEFT JOIN lois_priorisees lp ON a.id_scenario = lp.id_scenario
GROUP BY r.id_robot, r.nom_robot
ORDER BY r.id_robot;

    --INDEX
CREATE INDEX action_id_robot ON action(id_robot);
CREATE INDEX robots_id_robot ON robots(id_robot);
CREATE INDEX ti_id_robot ON temps_intervention(id_robot);

CREATE INDEX action_id_scenario ON action(id_scenario);
CREATE INDEX ti_id_scenario ON temps_intervention(id_scenario);
CREATE INDEX lois_id_scenario ON lois_priorisees(id_scenario);

--2 Identifier les robots performants ou défaillants
    -- VUE vue_robots_performants

CREATE OR REPLACE VIEW vue_robotos_performants AS
SELECT *
FROM vue_indicateurs_performance
WHERE 
    nb_actions_reussies >= 1
    AND taux_reussite >= 70
    AND (
        nb_actions_priorite_loi_1 > 0
        OR nb_actions_priorite_loi_2 > 0
    );
    
    -- VUE vue_robots_defaillants

CREATE OR REPLACE VIEW vue_robotos_defaillants AS
SELECT *
FROM vue_indicateurs_performance
WHERE 
    nb_actions_reussies >= 1
    AND taux_reussite <= 70
    OR (
        nb_actions_priorite_loi_1 = 0
        AND nb_actions_priorite_loi_2 = 0
        AND nb_actions_priorite_loi_3 > 0
    );

    --Gestion d'accès pour les analystes

CREATE USER 'analystes'@'localhost' IDENTIFIED BY 'Robots'
GRANT SELECT ON vue_robotos_performants TO 'analystes'@'localhost';
GRANT SELECT ON vue_robotos_defaillants TO 'analystes'@'localhost';

    --Gestion d'accès pour les superviseurs éthiques

CREATE USER 'superviseurs_ethiques'@'localhost' IDENTIFIED BY 'Robots'
GRANT SELECT,INSERT ON vue_robotos_performants TO 'superviseurs_ethiques'@'localhost';
GRANT SELECT,INSERT ON vue_robotos_defaillants TO 'superviseurs_ethiques'@'localhost';

    --Actualisation des privilèges
FLUSH PRIVILEGES;

    --Vérification des privilèges
SHOW GRANTS FOR 'analystes'@'localhost';
SHOW GRANTS FOR 'superviseurs_ethiques'@'localhost';

--3 Etudier l'impact des actions sur les scénarios critiques
    -- VUE vue_impact_actions

CREATE OR REPLACE VIEW vue_impact_actions AS
SELECT 
    r.id_robot,
    r.nom_robot,
    a.id_action,
    a.description_action,
    s.id_scenario,
    s.description AS scenario,
    s.priorite_loi AS priorite,
    a.resultat AS impact,
    a.duree_intervention
FROM action a
JOIN robots r ON a.id_robot = r.id_robot
JOIN scenario s ON a.id_scenario = s.id_scenario
ORDER BY r.nom_robot;

     -- VUE vue_tendances_d'echec

CREATE OR REPLACE VIEW vue_impact_actions AS
SELECT 
    s.priorite_loi AS priorite,
    a.description_action,
    COUNT(*) AS nb_echecs
FROM action a
JOIN scenario s ON a.id_scenario = s.id_scenario
WHERE a.resultat = 'échoué'
GROUP BY s.priorite_loi, a.description_action
ORDER BY nb_echecs DESC;

