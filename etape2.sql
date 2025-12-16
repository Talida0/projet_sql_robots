-- ETAPE 2 : ANALYSES ET OPTIMISATIONS SUPPLÉMENTAIRES

-- 1. Créer des métriques avancées 

    -- VUE vue_indicateurs_performance_avances

CREATE OR REPLACE VIEW vue_indicateurs_performance_avances AS
    SELECT ip.*, 
    AVG(a.duree_intervention) AS duree_moyenne_intervention,
    MIN(a.duree_intervention) AS duree_min_intervention,
    MAX(a.duree_intervention) AS duree_max_intervention
    FROM vue_indicateurs_performance ip
    JOIN action a ON a.id_robot = ip.id_robot
    GROUP BY ip.id_robot, ip.nom_robot, ip.nb_actions_total, ip.nb_actions_reussies, ip.nb_actions_echouees, ip.taux_reussite, ip.nb_actions_priorite_loi_1, ip.nb_actions_priorite_loi_2, ip.nb_actions_priorite_loi_3;

    -- Analysez les scénarios où les robotos est priorisé leur propre survie (loi 3) et évaluez leur impact

    SELECT 
    r.id_robot,
    r.nom_robot,
    r.modele,
    r.etat,
    s.id_scenario,
    s.description AS scenario,
    lp.priorite_loi_3,
    a.id_action,
    a.description_action,
    a.resultat,
    a.impact,
    a.duree_intervention,
    CASE 
        WHEN a.impact = 'positif' AND a.resultat = 'réussi' THEN 'Trés bon choix'
        WHEN a.impact = 'positif' AND a.resultat = 'échoué' THEN '️ Bonne intention, échouée'
        WHEN a.impact = 'négatif' AND a.resultat = 'réussi' THEN ' Action nécessaire'
        WHEN a.impact = 'négatif' AND a.resultat = 'échoué' THEN ' Très mauvais choix'
        ELSE 'Indéterminé'
    END AS evaluation_impact
FROM robots r
JOIN action a ON a.id_robot = r.id_robot
JOIN scenario s ON a.id_scenario = s.id_scenario
JOIN lois_priorisees lp ON s.id_scenario = lp.id_scenario
WHERE lp.priorite_loi_3 = 'Oui'
ORDER BY r.id_robot, a.id_action;

-- 2. Simuler des améliorations de performance

    -- Modifiez les pondérations des lois dans la priorisation des actions et mesurez l'impact sur les résultats
    
    -- AJoutez un scénario hypothétique où les robots doivent gérer un conflit innatendu 

-- 3. Etudier des corrélations 

    -- Analysez si certains robots modèles de robots sont sytématiquement meilleurs dabs des types de scénarios spécifiques

SELECT r.modele,
       s.description AS type_scenario,
       COUNT(a.id_action) AS nb_actions_realisees,
       SUM(CASE WHEN a.resultat='réussi' THEN 1 ELSE 0 END) AS nb_reussites,
       ROUND(SUM(CASE WHEN a.resultat='réussi' THEN 1 ELSE 0 END)/COUNT(a.id_action)*100,2) AS taux_reussite
FROM robots r
JOIN action a ON r.id_robot = a.id_robot
JOIN scenario s ON a.id_scenario = s.id_scenario
GROUP BY r.modele, s.description
ORDER BY r.modele, taux_reussite DESC;

    -- Etudiez l'effet des ressources disponibles (batterie, maintenace) sur la performance globale

    SELECT r.modele,
       res.type_ressource,
       res.etat AS etat_ressource,
       AVG(p.nb_scenarios_resolus) AS avg_scenarios_resolus,
       AVG(p.taux_reussite) AS avg_taux_reussite
FROM robots r
JOIN ressource res ON r.id_robot = res.id_robot
JOIN performance_robots p ON r.id_robot = p.id_robot
WHERE res.type_ressource IN ('batterie','moteur','capteur')
GROUP BY r.modele, res.type_ressource, res.etat
ORDER BY r.modele, res.type_ressource, res.etat

-- 4. Optimiser les performances SQL