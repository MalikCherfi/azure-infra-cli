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

# Réponses - TP Module 4 : Réseau CLI

## Question 1
**Vous avez 251 adresses utilisables dans subnet-frontend. Si vous utilisez App Service VNet Integration, Azure réserve un bloc /28 minimum par plan App Service. Combien de plans App Service maximum pouvez-vous intégrer dans ce sous-réseau ?**

4^2 est égal à 16 donc chaque plan App Service peut contenir 16 adresses - les 5 utilisées par Azure soit 11 adresses. On divise 251 par 16 pour savoir combien de bloc de 16 adresses on peut rentrer dans les 251 adresses disponible ce qui donne environ 15.

## Question 2
**Quelle règle bloque tout le trafic entrant depuis Internet par défaut ? Quel est son numéro de priorité ?
Pourquoi AllowVnetInBound a-t-elle la priorité 65000 et DenyAllInBound la priorité 65500 ?
Si vous créez une règle avec la priorité 100, sera-t-elle appliquée avant ou après AllowVnetInBound ?**

1 . C'est la règle DenyAllInBound, le numéro de priorité est 65500
2 . Elle à une priorité plus petite pour que l'application de la règle ne soit pas effacé par la règle DenyAllInBound, on défini les deux seule expection puis on refuse toute les autres.
3 . Elle sera appliqué avant.

## Question 3
**Un paquet arrive sur le port 22 (SSH) depuis Internet. Dans quel ordre les règles sont-elles évaluées et quelle est la décision finale ?**

. On check la règle "Allow-Http" qui à la plus petite priorité ( 100 ) - elle n'est pas appliqué car elle regarde le port 80
. On check la règle "Allow-Https" qui à la priorité 110 - elle n'est pas appliqué car elle regarde le port 443
. On passe à la règle "Deny-All-Inbound" qui elle est appliqué car elle contient le port 22

Résultat la connexion entrante est refusé.
