# Raport

## Réponse aux questions

* Partie 1 : [files.sh](files.sh)
* Partie 2 : [processes.sh](processes.sh)
* Partie 3 : [services.sh](services.sh)
* Partie 4 : [main.sh](main.sh)
* Partie 5 : [delegate.sh](delegate.md)

> Chaque script contient un commentaire en début de chaque fonction indiquant le numéro de la question à laquelle elle répond.

## Difficultés, limitations et extensions

### Partie 1 : Fichiers

#### **Menu principal**
Vu le nombre de fonctions différentes qu'on a implémenté, lorsqu'on affichait tout dans le menu principal, et quand on attendait que l'utilisateur choississe un numéro pour éxécuter une des fonctions, le nombre de lignes de code était trop grand dans le `case`. On a décidé d'implémenter un moyen générique permettant d'afficher le menu et d'éxécuter une des fonctions grâce à deux constantes `MENU_OPTIONS` (étant la description de chaque méthode) et `MENU_ACTIONS` (étant le nom de la méthode à éxécuter) qui sont des tableaux qui permettent de réduire drastiquement le nombre de ligne de code.
> Cette implémentation est utilisée dans les autres scripts.

#### **Filtres**

La consigne sur l'implémentation d'un système de filtre n'étant pas très détaillé, nous avons dû en faire notre propre interprétation.
Nous avons choisi un menu permettant de sélectionner les filtres souhaités de manière intéractive.
La grande flexibilité de la commande find nous a permis de traduire les entrées de l'utilisateur en commande `find` facilement.

##### **Difficultés**

Le gros du travail a été de proposer une interface console interactive à l'utilisateur.
Il a été plus complexe d'implémenter proprement une interface compréhensible que de traduire les entrées de l'utilisateur en commande `find`.

### Partie 2 : Processus

#### **Filtres**

Contrairement à la partie 1, nous avons choisi de ne pas implémenter un système de filtre interactif.
Nous avons préféré implémenter un système de filtre par argument.
Cela nous a permis de simplifier le code et de rendre l'interface plus simple.
Puisque nous passons par un menu principal, il n'est pas posssible de passer directement des arguments à la commande.
Nous avons donc créé une fonction intermédiaire présentant les options disponibles en proposant à l'utilisateur d'entrer les options qui seront ensuite passsé en argument à la fonction de filtrage.

##### **Difficultés**

La commande `ps` est bien plus limité que `find` en terme de possibilité de filtrage.
Tout les processus de filtrages sont donc effectués sur la sortie de la commande `ps` à l'aide des commandes `grep` et `awk`.

##### **Limitations**

Il n'y a pas de possibilité de choisir pour chaque filtre si il doit s'agir d'un filtre ET ou OU.

### Partie 3 : Services

Aucune difficulté particulière n'a été rencontrée lors de la réalisation de cette partie.

### Partie 4 : Menu principal

Aucune difficulté particulière n'a été rencontrée lors de la réalisation de cette partie.

### Partie 5 : Délégation

Il a fallu imaginer une manière de donner uniquement des droits d'execution à certains utilisateurs.
Nous avons pour cela utilisé les groupes.
Le script `delegate.sh` permet de créer un groupe `livl-bash` et d'y ajouter un utilisateur.
Une fois ce groupe créé et l'utilisateur ajouté, il est possible de donner les droits d'execution au script `main.sh` à ce groupe.

### Général

#### **Fonctions communes**
Nous avons choisi de créer un fichier nommé `common.sh` qui contient des fonctions utilisées par plusieurs scripts. Il permet de réduire la duplication de code et de rendre le code plus lisible. Par exemple, il y a une énorme redondance dans chaque fonction de chaque script quand on demande à l'utilisateur de rentrer un nombre / une date / ou une chaine de caractères. La difficulté rencontré à été qu'il était impossible de retourner une chaine de caractère donc la méthode a été de faire un `echo` de la chaine de caractère et de la récupérer dans une variable dans le fonction appelante.

#### **Affichage**
Nous avons aussi implémenté une méthode permettant de rafraichir l'affichage de la console après qu'une fonction du menu choisis par l'utilisateur se termine. On a rajouté un timer qui décrémente chaque seconde de 30 secondes et qui l'affiche à chaque fois à l'écran. Lorsque le timer arrive à 0, la console est rafraichie et la fonction sera réappelée. Si l'utilisateur appuie sur une touche, cela le redirige vers le menu principal.

#### **Style de la console**
Nous avons grandement opté à une solution de style de console qui permet de rendre le menu plus lisible et plus agréable à l'oeil. Nous avons utilisé des couleurs et des caractères spéciaux pour rendre le menu plus lisible.


## Conclusion

Nous avions bien épluché énormément de combine de bash. Néanmoins nous nous sommes rendu compte à certains moments que faire des scripts en bash présente des limites (comme par exemple le fait qu'il est impossible de retourner une valeur autre qu'un nombre dans une fonction bash).