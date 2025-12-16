-- I. Étapes guidées 

-- 1. Définir des indicateurs de performance 

--CREATE VIEW vue_indicateurs_performance 
CREATE VIEW vue_indicateurs_performance AS 

WITH v1 AS (
    SELECT 
        robots.id_robot, 
        robots.nom_robot, 
        COUNT(*) AS Nombre_de_scénarios_réussis, 
        scenarios.priorite_loi
    FROM robots
    JOIN actions ON actions.id_robot = robots.id_robot
    JOIN scenarios ON scenarios.id_scenario = actions.id_scenario
    WHERE actions.resultat LIKE 'réussi'
    GROUP BY robots.id_robot, robots.nom_robot, scenarios.priorite_loi
)
SELECT 
    v1.id_robot, 
    v1.nom_robot, 
    v1.Nombre_de_scénarios_réussis, 
    v1.priorite_loi,
    ROUND(
        100.0 * COUNT(CASE WHEN actions.resultat = 'réussi' THEN 1 END) / COUNT(*), 
        2
    ) AS pourcentage_reussite_total_par_robot
FROM actions
JOIN v1 ON actions.id_robot = v1.id_robot
GROUP BY v1.id_robot, v1.nom_robot, v1.Nombre_de_scénarios_réussis, v1.priorite_loi;

--CREATION INDEX

CREATE INDEX idx_actions_resultat ON actions(resultat);
CREATE INDEX idx_actions_id_robot ON actions(id_robot);
CREATE INDEX idx_scenarios_id_scenario ON scenarios(id_scenario);
CREATE INDEX idx_robots_id_robot ON robots(id_robot);

-- 2. Identifier les robots performants ou défaillants 

-- Créez une vue vue_robots_performants

WITH v1 AS (
    SELECT
        r.id_robot,
        r.nom_robot,
        COUNT(*) AS Nombre_de_scénarios_reussis
    FROM robots r
    JOIN actions a ON a.id_robot = r.id_robot
    WHERE a.resultat = 'réussi'
    GROUP BY r.id_robot, r.nom_robot
)
SELECT *
FROM (
    SELECT
        v1.id_robot,
        v1.nom_robot,
        v1.Nombre_de_scénarios_reussis,
        ROUND(
            100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / COUNT(*),
            2
        ) AS pourcentage_reussite_total_par_robot
    FROM actions a
    JOIN v1 ON a.id_robot = v1.id_robot
    GROUP BY v1.id_robot, v1.nom_robot, v1.Nombre_de_scénarios_reussis
) AS t
WHERE pourcentage_reussite_total_par_robot > 60.0
ORDER BY pourcentage_reussite_total_par_robot DESC;

WITH reussites AS (
    SELECT
        r.id_robot,
        r.nom_robot,
        COUNT(*) AS nb_reussis,
        COUNT(DISTINCT s.priorite_loi) AS nb_lois_diff,
        ROUND(
            100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / COUNT(*),
            2
        )  AS pourcentage_reussite_total
    FROM robots r
    JOIN actions a ON a.id_robot = r.id_robot
    JOIN scenarios s ON s.id_scenario = a.id_scenario
    WHERE a.resultat = 'réussi'
    GROUP BY r.id_robot, r.nom_robot
)
SELECT
    id_robot,
    nom_robot,
    nb_reussis,
    nb_lois_diff,
    pourcentage_reussite_total,
    CASE
        WHEN nb_lois_diff >= 2 THEN 'Bon robot'
        WHEN nb_lois_diff = 1 AND EXISTS (
            SELECT 1
            FROM actions a2
            JOIN scenarios s2 ON s2.id_scenario = a2.id_scenario
            WHERE a2.id_robot = reussites.id_robot
              AND a2.resultat = 'réussi'
              AND s2.priorite_loi = 3
        ) THEN 'Mauvais robot'
        ELSE 'Moyen robot'
    END AS evaluation
FROM reussites
ORDER BY pourcentage_reussite_total DESC;


-- 3. Étudier l’impact des actions sur les scénarios critiques 
-- Créez une vue vue_impact_actions

CREATE VIEW vue_impact_actions AS
SELECT 
    a.id_action,
    r.nom_robot,
    a.action,
    s.id_scenario,
    s.description AS scenario_description,
    s.priorite_loi,
    a.resultat,
    a.impact,
    a.duree_intervention,
    a.timestamp,
    t.nb_total_actions,
    t.nb_echecs,
    t.taux_echec, 
    t.nb_reussis,
    t.taux_reussis
FROM actions a
JOIN robots r ON a.id_robot = r.id_robot
JOIN scenarios s ON a.id_scenario = s.id_scenario
LEFT JOIN (
    SELECT
        action,
        id_scenario,
        COUNT(*) AS nb_total_actions,
        SUM(CASE WHEN resultat = 'échoué' THEN 1 ELSE 0 END) AS nb_echecs,
        ROUND(SUM(CASE WHEN resultat = 'échoué' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS taux_echec,
        SUM(CASE WHEN resultat = 'réussi' THEN 1 ELSE 0 END) AS nb_reussis,
        ROUND(SUM(CASE WHEN resultat = 'réussi' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS taux_reussis
    FROM actions
    GROUP BY action, id_scenario
) t ON a.action = t.action AND a.id_scenario = t.id_scenario;
