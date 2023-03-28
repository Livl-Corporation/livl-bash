# Systèmes d’exploitation - Shell script

## Commandes

a) Afficher le répertoire courant dans lequel je me trouve ;

b) Indiquez la date et l’heure du système ;

c) Indiquer le nombre de fichiers présents dans le répertoire courant et leur taille (en Ko, Mo ou Go à vous de définir l’unité la plus pertinente) ;

d) Indiquer le nombre de sous-répertoires présents dans le répertoire courant ;

e) Indiquer l’arborescence (en permettant de paramétrer une profondeur) du répertoire courant ;

f) Indiquer le poids (quantité de données) de chaque sous-répertoire du répertoire courant (veiller à comptabiliser tous les fichiers présents dans l’arborescence de chaque sous répertoire) ;

g) Changer de répertoire courant pour poursuivre mes investigations

h) Rechercher les fichiers plus récents qu’une date (définie en paramètre) pour le répertoire courant ;

i) Rechercher les fichiers plus récents qu’une date (définie en paramètre) présents dans tous les sous-répertoires de l’arborescence du répertoire courant ;

j) Rechercher les fichiers plus anciens qu’une date (définie en paramètre) pour le répertoire courant ;

k) Rechercher les fichiers plus anciens qu’une date (définie en paramètre) présents dans tous les sous-répertoires de l’arborescence du répertoire courant ;

l) Rechercher les fichiers de poids supérieur à une valeur indiquée présents dans le répertoire courant ;

m) Rechercher les fichiers de poids supérieur à une valeur présents dans tous les sous-répertoires de l’arborescence du répertoire courant ;

n) Rechercher les fichiers de poids inférieur à une valeur indiquée présents dans le répertoire courant ;

o) Rechercher les fichiers de poids inférieur à une valeur indiquée présents dans tous les sous-répertoires de l’arborescence du répertoire courant ;

p) Rechercher tous les fichiers d’une extension donnée (définie en paramètre) présents dans tous les sous-répertoires de l’arborescence du répertoire courant ;

q) Rechercher tous les fichiers d’une extension donnée (définie en paramètre) présents dans le répertoire courant ;

r) Rechercher tous les fichiers dont le nom contient une chaine de caractère (définie en paramètre) présents dans tous les sous-répertoires de l’arborescence du répertoire courant ;

s) Produire un fichier de sortie contenant le résultat de la recherche effectuée qui n’écrase pas les résultats de la recherche précédente (tenir compte par exemple de la date et l’heure système)

t) Proposer une fonctionnalité supplémentaire que vous jugez intéressante et qui manque à la liste précédente (argumentez votre choix)

### Interface

Proposer une interface grâce à un shell-script permettant d’effectuer les actions précédentes dans le cadre d’un menu interactif et permettant d’appliquer un filtre de recherche combinant les possibilités (taille ET/OU date ET/OU nom).

## Partie2 – Explorateur de processus

a) Identifier tous les processus présents sur le système et indiquer leur propriétaire

b) Identifier uniquement les processus actifs et indiquer leur propriétaire

c) Identifier les processus appartenant à un utilisateur donné en paramètre

d) Identifier les processus consommant le plus de mémoire et indiquer leur propriétaire

e) Identifier les processus dont le nom contient une chaine de caractères (définie en paramètre) et indiquer leur propriétaire

f) Produire un fichier de sortie contenant le résultat de la recherche effectuée qui n’écrase pas les résultats de la recherche précédente (tenir compte par exemple de la date et l’heure système)

g) Proposer une fonctionnalité supplémentaire que vous jugez intéressante et qui manque à la liste précédente (argumentez votre choix)

### Interface

Proposer une interface grâce à un shell-script permettant d’effectuer les actions précédentes dans le cadre d’un menu interactif et permettant d’appliquer un filtre de recherche combinant les possibilités (actif ET/OU mémoire ET/OU nom).

L’affichage du résultat sera rafraichi automatiquement toutes les 30 secondes.

## Partie3 – Explorateur de services

a) Identifier les services disponibles/installés sur le système

b) Identifier les services actifs sur le système

c) Identifier le statut d’un service dont le nom contient une chaine de caractères (définie en paramètre)

d) Proposer une fonctionnalité supplémentaire que vous jugez intéressante et qui manque à la liste précédente (argumentez votre choix)

### Interface

Proposer une interface grâce à un shell-script permettant d’effectuer les actions précédentes dans le cadre d’un menu interactif L’affichage du résultat sera rafraichi automatiquement toutes les 30 secondes.

## Partie4 - Interface globale

Proposer une interface globale regroupant l’ensemble des trois shell-scripts.

## Partie5 – Délégation de droits

Proposer une solution et la configuration permettant de déléguer l’usage de vos scripts à un simple utilisateur de façon à ce que celui-ci puisse consulter toutes les informations (fichiers, processus, services) sans pour autant avoir la possibilité d’interagir avec eux comme pourrait le faire un administrateur.

## Modalités de réalisation et de rendu

Le projet peut être réalisé seul ou en groupe de deux. Il doit être rendu sous forme d’une archive au format nom.tar.gz (où nom correspond à votre (ou vos noms pour les binômes) de famille). Cette archive devra comporter les scripts accompagnés d’un rapide mode d’emploi (au format texte) ainsi qu’un rapport (au format pdf).

Le rapport comportera la réponse à chacune des questions (commandes nécessaires pour exécuter les actions demandées).

Il comportera également une rubrique présentant les principales difficultés auxquelles vous vous êtes heurtés et les solutions éventuellement apportées. Vous indiquerez également les limitations de vos scripts et s’il y en a les extensions éventuelles que vous aurez réalisé.
