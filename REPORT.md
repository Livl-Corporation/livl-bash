# Raport

## Réponse aux questions

* Partie 1 : [files.sh](files.sh)
* Partie 2 : [processes.sh](processes.sh)
* Partie 3 : [services.sh](services.sh)
* Partie 4 : [main.sh](main.sh)
* Partie 5 : [delegate.sh](delegate.md)

## Difficultés, limitations et extensions

### Partie 1 : Fichiers

@jvondermark

#### **Filtres**

La consigne sur l'implémentation d'un système de filtre n'étant pas très détaillé, nous avons dû en faire notre propre interprétation.
Nous avons choisi un menu permettant de sélectionner les filtres souhaités de manière intéractive.
La grande flexibilité de la commande find nous a permis de traduire les entrées de l'utilisateur en commande `find` facilement.

##### **Difficultés**

Le gros du travail a été de proposer une interface console interactive à l'utilisateur.
Il a été plus complexe d'implémenter proprement une interface compréhensible que de traduire les entrées de l'utilisateur en commande `find`.

### Partie 2 : Processus

@jvondermark

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

@jvondermark

### Partie 4 : Menu principal

@jvondermark

### Partie 5 : Délégation

@franckg28
