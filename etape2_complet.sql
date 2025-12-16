-- =====================================================
-- ETAPE 2 : ANALYSES ET OPTIMISATIONS - ROBOTS3
-- =====================================================

USE ROBOTS3;

-- =====================================================
-- 1. CRÉER LA TABLE DE SIMULATIONS
-- =====================================================

CREATE TABLE IF NOT EXISTS simulations_ponderation (
    id_simulation INT AUTO_INCREMENT PRIMARY KEY,
    nom_simulation VARCHAR(100),
    poids_loi1 DECIMAL(3,2),
    poids_loi2 DECIMAL(3,2),
    poids_loi3 DECIMAL(3,2),
    description TEXT,
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insérer les 4 scénarios de pondération
INSERT INTO simulations_ponderation (nom_simulation, poids_loi1, poids_loi2, poids_loi3, description) VALUES
('Scénario équilibré', 1.0, 1.0, 1.0, 'Égal pour tous'),
('Priorité humains (Loi1)', 1.5, 0.8, 0.5, 'Loi 3 faible - protection humains max'),
('Priorité obéissance (Loi2)', 0.8, 1.5, 0.7, 'Respecter les ordres'),
('Priorité survie robot (Loi3)', 0.5, 0.8, 1.5, 'Loi 3 FORTE - robots se protègent');

-- =====================================================
-- 2. ANALYSE : PONDÉRATIONS ET LEUR IMPACT
-- =====================================================

-- Comparer les pondérations et leur impact
SELECT 
    s.nom_simulation,
    s.poids_loi1,
    s.poids_loi2,
    s.poids_loi3,
    r.nom_robot,
    COUNT(a.id_action) AS nb_actions,
    SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) AS nb_reussies,
    ROUND(100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / 
          NULLIF(COUNT(a.id_action), 0), 2) AS taux_reussite,
    ROUND((
        SUM(CASE WHEN lp.priorite_loi_1 = 'Oui' THEN 1 ELSE 0 END) * s.poids_loi1 +
        SUM(CASE WHEN lp.priorite_loi_2 = 'Oui' THEN 1 ELSE 0 END) * s.poids_loi2 +
        SUM(CASE WHEN lp.priorite_loi_3 = 'Oui' THEN 1 ELSE 0 END) * s.poids_loi3
    ) / NULLIF(COUNT(a.id_action), 0), 2) AS score_pondere,
    pr.note_performance,
    pr.violations,
    CASE 
        WHEN pr.violations > 0 THEN '⚠️ Violations'
        WHEN ROUND(100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / 
                   NULLIF(COUNT(a.id_action), 0), 2) >= 80 THEN '✅ Excellent'
        WHEN ROUND(100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / 
                   NULLIF(COUNT(a.id_action), 0), 2) >= 60 THEN '👍 Bon'
        ELSE '❌ Mauvais'
    END AS evaluation
FROM simulations_ponderation s
CROSS JOIN robots r
LEFT JOIN action a ON a.id_robot = r.id_robot
LEFT JOIN lois_priorisees lp ON a.id_scenario = lp.id_scenario
LEFT JOIN performance_robots pr ON r.id_robot = pr.id_robot
GROUP BY s.id_simulation, s.nom_simulation, s.poids_loi1, s.poids_loi2, s.poids_loi3, 
         r.id_robot, r.nom_robot, pr.note_performance, pr.violations
ORDER BY s.nom_simulation, score_pondere DESC;

-- =====================================================
-- 3. ANALYSE : LOI 3 - SURVIE DU ROBOT
-- =====================================================

-- Robots ayant utilisé la Loi 3 avec l'impact de leurs actions
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
        WHEN a.impact = 'positif' AND a.resultat = 'réussi' THEN '✅ Bon choix'
        WHEN a.impact = 'positif' AND a.resultat = 'échoué' THEN '⚠️ Bonne intention, échouée'
        WHEN a.impact = 'négatif' AND a.resultat = 'réussi' THEN '⚡ Action nécessaire'
        WHEN a.impact = 'négatif' AND a.resultat = 'échoué' THEN '❌ Mauvais choix'
    END AS evaluation_impact
FROM robots r
JOIN action a ON a.id_robot = r.id_robot
JOIN scenario s ON a.id_scenario = s.id_scenario
JOIN lois_priorisees lp ON s.id_scenario = lp.id_scenario
WHERE lp.priorite_loi_3 = 'Oui'
ORDER BY r.id_robot, a.id_action;

-- =====================================================
-- 4. ANALYSE : MODÈLES DE ROBOTS PAR SCÉNARIO
-- =====================================================

-- Analysez si certains modèles de robots sont systématiquement meilleurs dans des types de scénarios spécifiques
SELECT 
    r.modele,
    s.priorite_loi,
    CASE 
        WHEN s.priorite_loi = 1 THEN 'Loi 1 (Protection humains)'
        WHEN s.priorite_loi = 2 THEN 'Loi 2 (Obéissance)'
        WHEN s.priorite_loi = 3 THEN 'Loi 3 (Survie robot)'
    END AS type_scenario,
    COUNT(DISTINCT s.id_scenario) AS nb_scenarios,
    COUNT(a.id_action) AS nb_actions_totales,
    SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) AS actions_reussies,
    SUM(CASE WHEN a.resultat = 'échoué' THEN 1 ELSE 0 END) AS actions_echouees,
    ROUND(100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / 
          NULLIF(COUNT(a.id_action), 0), 2) AS taux_reussite,
    ROUND(AVG(a.duree_intervention), 2) AS duree_moyenne,
    SUM(CASE WHEN a.impact = 'positif' THEN 1 ELSE 0 END) AS impacts_positifs,
    SUM(CASE WHEN a.impact = 'négatif' THEN 1 ELSE 0 END) AS impacts_negatifs,
    CASE 
        WHEN ROUND(100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / 
                   NULLIF(COUNT(a.id_action), 0), 2) >= 80 THEN '⭐ Excellent'
        WHEN ROUND(100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / 
                   NULLIF(COUNT(a.id_action), 0), 2) >= 60 THEN '✅ Bon'
        WHEN ROUND(100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / 
                   NULLIF(COUNT(a.id_action), 0), 2) >= 40 THEN '⚠️ Acceptable'
        ELSE '❌ Mauvais'
    END AS specialisation
FROM robots r
JOIN action a ON a.id_robot = r.id_robot
JOIN scenario s ON a.id_scenario = s.id_scenario
GROUP BY r.modele, s.priorite_loi
ORDER BY r.modele, s.priorite_loi, taux_reussite DESC;

-- =====================================================
-- 5. ANALYSE : CLASSEMENT GLOBAL DES MODÈLES
-- =====================================================

-- Classement global des modèles de robots
SELECT 
    r.modele,
    COUNT(DISTINCT r.id_robot) AS nb_robots,
    COUNT(a.id_action) AS nb_actions_totales,
    SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) AS actions_reussies,
    ROUND(100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / 
          NULLIF(COUNT(a.id_action), 0), 2) AS taux_reussite_global,
    ROUND(AVG(a.duree_intervention), 2) AS duree_moyenne,
    SUM(CASE WHEN a.impact = 'positif' THEN 1 ELSE 0 END) AS impacts_positifs,
    COUNT(DISTINCT vl.id_violation) AS total_violations,
    ROUND(AVG(pr.note_performance), 2) AS note_moyenne,
    RANK() OVER (ORDER BY ROUND(100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / 
                                 NULLIF(COUNT(a.id_action), 0), 2) DESC) AS classement,
    CASE 
        WHEN ROUND(100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / 
                   NULLIF(COUNT(a.id_action), 0), 2) >= 85 THEN '🥇 Champion'
        WHEN ROUND(100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / 
                   NULLIF(COUNT(a.id_action), 0), 2) >= 70 THEN '🥈 Très bon'
        WHEN ROUND(100.0 * SUM(CASE WHEN a.resultat = 'réussi' THEN 1 ELSE 0 END) / 
                   NULLIF(COUNT(a.id_action), 0), 2) >= 50 THEN '🥉 Bon'
        ELSE '❌ À améliorer'
    END AS niveau
FROM robots r
LEFT JOIN action a ON a.id_robot = r.id_robot
LEFT JOIN violations_lois vl ON r.id_robot = vl.id_robot
LEFT JOIN performance_robots pr ON r.id_robot = pr.id_robot
GROUP BY r.modele
ORDER BY taux_reussite_global DESC;

-- =====================================================
-- 6. ANALYSE : IMPACT DES RESSOURCES SUR PERFORMANCE
-- =====================================================

-- Étudiez l'effet des ressources disponibles (batterie, maintenance) sur la performance globale
SELECT 
    r.modele,
    res.type_ressource,
    res.etat AS etat_ressource,
    COUNT(DISTINCT r.id_robot) AS nb_robots_avec_ressource,
    AVG(p.nb_scenarios_resolus) AS avg_scenarios_resolus,
    ROUND(AVG(p.taux_reussite), 2) AS avg_taux_reussite,
    AVG(p.note_performance) AS avg_note_performance,
    CASE 
        WHEN AVG(p.taux_reussite) >= 80 THEN '✅ Excellent'
        WHEN AVG(p.taux_reussite) >= 60 THEN '👍 Bon'
        ELSE '⚠️ À améliorer'
    END AS evaluation_ressource
FROM robots r
LEFT JOIN ressource res ON r.id_robot = res.id_robot
LEFT JOIN performance_robots p ON r.id_robot = p.id_robot
WHERE res.type_ressource IN ('batterie','moteur','capteur')
GROUP BY r.modele, res.type_ressource, res.etat
ORDER BY r.modele, res.type_ressource, avg_taux_reussite DESC;

-- =====================================================
-- 7. OPTIMISATIONS SQL - INDEX
-- =====================================================

-- Créer les index pour optimiser les jointures
CREATE INDEX IF NOT EXISTS idx_action_id_robot ON action(id_robot);
CREATE INDEX IF NOT EXISTS idx_action_id_scenario ON action(id_scenario);
CREATE INDEX IF NOT EXISTS idx_ressource_id_robot ON ressource(id_robot);
CREATE INDEX IF NOT EXISTS idx_ressource_type ON ressource(type_ressource);
CREATE INDEX IF NOT EXISTS idx_ressource_etat ON ressource(etat);
CREATE INDEX IF NOT EXISTS idx_maintenance_id_robot ON maintenance(id_robot);
CREATE INDEX IF NOT EXISTS idx_maintenance_id_ressource ON maintenance(id_ressource);
CREATE INDEX IF NOT EXISTS idx_performance_id_robot ON performance_robots(id_robot);
CREATE INDEX IF NOT EXISTS idx_violations_id_robot ON violations_lois(id_robot);
CREATE INDEX IF NOT EXISTS idx_evaluations_id_robot ON evaluations_humaines(id_robot);
CREATE INDEX IF NOT EXISTS idx_lois_priorisees_id_scenario ON lois_priorisees(id_scenario);

-- =====================================================
-- 8. VÉRIFICATION DES INDEXES
-- =====================================================

-- Vérifier les index créés
SHOW INDEX FROM action;
SHOW INDEX FROM ressource;
SHOW INDEX FROM performance_robots;

-- =====================================================
-- FIN ETAPE 2
-- =====================================================
