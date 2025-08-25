---
title: Plan d'assurance qualité (PAQ)
date: "25/08/2025"
version: 1.0
---

Le PAQ est un document de projet qui décrit comment la qualité sera organisée, suivie et garantie tout au long du cycle de vie d’un produit ou service (par exemple un site ou une application web).

# Objectifs du plan
Garantir la qualité du produit final (performance, accessibilité, sécurité, conformité aux besoins).
Définir les pratiques, outils et responsabilités pour chaque étape du cycle de développement.
Réduire les risques de régressions et d’anomalies en production.

# Périmètre
Ce plan est conçu pour répondre de manière générale à un projet construit et réalisé par noesya. Il peut être précisé par un document complémentaire pour des projets spécifiques.

## Stack
Le stack technique type utilisé est :
Développement back Ruby on Rails
Base de données PostgreSQL
Développement front HTML
Développement Javascript ES6 natif
Feuilles de styles CSS avec préprocesseur SASS

## Environnement
Les projets s'appuient, sauf exigence contraire, sur un ensemble de 4 environnements :
- environnement de développement local
- environnement de test
- environnement de préproduction (iso prod)
- environnement de production
Les environnements de test et de préproduction sont parfois absents, en fonction des contraintes budgétaires ou des réalités fonctionnelles.

# Référentiels et standards
noesya connait et applique les bonnes pratiques de sécurité (OWASP Top 10).
noesya connait et applique les bonnes pratiques UX / accessibilité (WCAG 2.1, RGAA si applicable).
noesya applique également des standards internes (conventions de nommage, workflows git, …).

# Organisation et responsabilités
Chaque projet dispose en interne chez noesya :
- d’un·e chef·fe de projet qui valide les besoins, priorise.
- d’un·e ou plusieurs développeurs·ses qui implémentent les fonctionnalités en respectant les standards.
- d’un·e référent·e qualité qui définit les tests et contrôle la conformité.
Le Client participe également aux phases de recette.

# Processus qualité
## Gestion du code
Le code est déposé sur une forge logicielle incluant des mécaniques de contrôle de version, généralement GitHub, avec des workflows définis (système de branches, fusion par pull requests, …).
Une revue de code est obligatoire avant de fusionner des évolutions de code.
## Gestion des environnements
Le travail est effectué sur un environnement de développement, puis envoyé sur un environnement de préproduction pour tests et recettage, et enfin déployé en production.
Le déploiement est automatisé.
L’environnement de production est sauvegardé tous les jours.
## Vérification et validation
Les développements sont systématiquement soumis à différents tests avant d’être livrés, selon la complexité du projet, en fonction de la pertinence des tests automatisés et des budgets alloués :
- tests unitaires (couverture minimale définie).
- tests d’intégration (API, flux critiques).
- tests fonctionnels (par scénarios utilisateurs).
- tests de performance (charge, temps de réponse).
- tests d’accessibilité (audit manuel + outils).
- tests de sécurité (audit code + scan vulnérabilités).
## Recette
Au besoin et pour les projets plus complexes (selon budget), un plan de recette peut être rédigé (critères d’acceptation, cas de test).
Dans tous les cas le projet se conclut par une phase de recette utilisateur qui doit être validée par le client avant mise en production.

# Outils qualité

## Linters
ESLint, Rubocop.
## Tests
RSpec, Minitest, CodeCoverage.
## CI/CD 
GitHub Actions, CircleCI.
## Monitoring 
Qlty (anciennement CodeClimate), logs centralisés.
## Outils accessibilité
Lighthouse.
## Interception d'exception
Les éventuels bugs des projets sont via un outil (SmartBear BugSnag) qui prévient à la fois sur un canal Slack dédié et en ouvrant des GitHub Issues.

# Révisions
1.0 Date of change: 25/08/2025 - Responsible: Technical team - Summary of Change: Initial release
