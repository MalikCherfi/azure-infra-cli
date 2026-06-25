# Réponses — TP Module 2 : Services de calcul Azure

## Question 1
**Avez-vous installé PHP ? Apache ? Un serveur ? Qu'est-ce que cela illustre sur le modèle PaaS ?**

Non. Le modèle PaaS fournit tous les outils nécessaires pour déployer une application web. On s'occupe uniquement du code applicatif, Azure gère le reste.

## Question 2
**Combien de serveurs avez-vous provisionné ? Que se passe-t-il si 10 000 utilisateurs appellent cette fonction simultanément ?**

Aucun. Azure Functions scale automatiquement jusqu'à 200 instances en parallèle. Les instances traitent les requêtes simultanément. Si la charge dépasse la capacité des 200 instances, les requêtes en excès attendent qu'une instance se libère.

## Question 3
**En quoi ACI est-il différent d'une Function App ? Quand préférieriez-vous ACI à une Function App ?**

Avec ACI on fournit une image Docker complète, alors qu'avec Azure Functions on fournit uniquement du code. Le mode de facturation est également différent : ACI facture à la seconde de fonctionnement du conteneur, tandis qu'Azure Functions facture à l'exécution (à la requête).

ACI est préférable quand :
- L'environnement d'exécution nécessite des dépendances système non disponibles dans Azure Functions.
- On dispose déjà d'une image Docker existante à déployer rapidement
- On veut un environnement totalement contrôlé

## Question finale
**Pour une startup qui lance une nouvelle API avec un trafic imprévisible et un budget limité, quel service choisiriez-vous et pourquoi ?**

Azure Functions est le choix le plus adapté pour une startup avec un trafic imprévisible et un budget limité. Si personne n'appelle l'API, on ne paie rien. Le scaling automatique jusqu'à 200 instances gère les pics de trafic sans configuration supplémentaire, ce qui réduit également la charge opérationnelle.