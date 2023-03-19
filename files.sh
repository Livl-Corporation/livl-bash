#!/bin/bash

# a) Afficher le répertoire courant
function show_pwd() {
    pwd
}
# b) Indiquez la date et l’heure du système
function show_date() {
    date
}
# c) Indiquer le nombre de fichiers présents dans le répertoire courant et leur taille
function show_files() {
    echo "Nombre de fichiers: $(find . -maxdepth 1 -type f | wc -l) $(du -sh . | cut -f1)"
}
# d) Indiquer le nombre de sous-répertoires présents dans le répertoire courant
function show_subdirs() {
    echo "Nombre de sous-répertoires: $(ls -l | grep ^d | wc -l)"
}
# e) Indiquer l’arborescence du répertoire courant avec une profondeur paramétrable
function show_tree() {
    read -p "Entrez la profondeur souhaitée pour l'arborescence: " depth
    if [[ ! "$depth" =~ ^[0-9]+$ ]]; then
        echo "La profondeur doit être un nombre entier positif."
        exit 1
    fi
    find . -maxdepth $depth
}
# f) Indiquer le poids de chaque sous-répertoire du répertoire courant
function show_subdir_sizes() {
    for dir in $(find . -mindepth 1 -maxdepth 1 -type d); do
        echo "$dir: $(du -sh $dir)"
    done
}
# g) Changer de répertoire courant pour poursuivre mes investigations
function change_dir() {
    read -p "Entrez le chemin du répertoire dans lequel vous voulez aller: " newdir
    if [[ ! -d "$newdir" ]]; then
        echo "Le répertoire spécifié n'existe pas."
        exit 1
    fi
    cd "$newdir"
}
# h) Rechercher les fichiers plus récents qu’une date pour le répertoire courant 
function search_newer() {
    read -p "Entrez la date (au format YYYY-MM-DD): " date
    find . -maxdepth 1 -type f ! -newermt $date
}
# i) Rechercher les fichiers plus récents qu’une date présents dans tous les sous-répertoires de l’arborescence du répertoire courant 
function search_newer_all() {
    read -p "Entrez la date (au format YYYY-MM-DD): " date2
    find . ! -newermt $date2
}
# j) Rechercher les fichiers plus anciens qu’une date pour le répertoire courant
function search_older() {
    read -p "Entrez la date (au format YYYY-MM-DD): " date3
    find . -maxdepth 1 -type f -newermt $date3
}
# k) Rechercher les fichiers plus anciens qu’une date présents dans tous les sous-répertoires de l’arborescence du répertoire courant
function search_older_all() {
    read -p "Entrez la date (au format YYYY-MM-DD): " date4
    find . -type f -newermt $date4
}
# l) Rechercher les fichiers de poids supérieur à une valeur indiquée présents dans le répertoire courant
function search_size_gt() {
    read -p "Entrez la taille minimale des fichiers (en Ko): " size
    find . -maxdepth 1 -type f -size +${size}k
}
# m) Rechercher les fichiers de poids supérieur à une valeur présents dans tous les sous-répertoires de l’arborescence du répertoire courant
function search_size_gt_all() {
    read -p "Entrez la taille minimale des fichiers (en Ko): " size2
    find . -type f -size +${size2}k
}
# n) Rechercher les fichiers de poids inférieur à une valeur indiquée présents dans le répertoire courant
function search_size_lt() {
    read -p "Entrez la taille maximale des fichiers (en Ko): " size3
    find . -maxdepth 1 -type f -size -${size3}k
}
# o) Rechercher les fichiers de poids inférieur à une valeur indiquée présents dans tous les sous-répertoires de l’arborescence du répertoire courant
function search_size_lt_all() {
    read -p "Entrez la taille maximale des fichiers (en Ko): " size4
    find . -type f -size -${size4}k
}
# p) Rechercher tous les fichiers d’une extension donnée présents dans tous les sous-répertoires de l’arborescence du répertoire courant
function search_ext_all() {
    read -p "Entrez l'extension des fichiers recherchés: " ext1
    find . -type f -name "*.$ext1"
}
# q) Rechercher tous les fichiers d’une extension donnée présents dans le répertoire courant 
function search_ext_main() {
    read -p "Entrez l'extension des fichiers recherchés: " ext2
    find . -maxdepth 1 -type f -name "*.$ext2"
}

# r) Rechercher tous les fichiers dont le nom contient une chaine de caractère présents dans tous les sous-répertoires de l’arborescence du répertoire courant
function search_name_all() {
    read -p "Entrez la chaine de caractères recherchée: " string1
    find . -type f -name "*$string1*"
}

# s) Produire un fichier de sortie contenant le résultat de la recherche effectuée qui n’écrase pas les résultats de la recherche précédente
function search_name_all_outfile() {
    read -p "Entrez le nom du fichier de sortie: " outfile
    datestr=$(date +"%Y%m%d%H%M%S")
    outfile="${outfile}_${datestr}.txt"
    find . > $outfile
}

# t) Proposer une fonctionnalité supplémentaire que vous jugez intéressante et qui manque à la liste précédente
# Une fonctionnalité intéressante pourrait être de rechercher des fichiers en fonction de leur contenu. Par exemple :
function search_content() {
    read -p "Entrez le texte recherché dans les fichiers: " text1
    grep -r "$text1" .
}

# Définition des options du menu
options=(
        "Afficher le répertoire courant dans lequel je me trouve ;"
        "Indiquez la date et l’heure du système ;"
        "Indiquer le nombre de fichiers présents dans le répertoire courant et leur taille (en Ko,Mo ou Go à vous de définir l’unité la plus pertinente) ;"
        "Indiquer le nombre de sous-répertoires présents dans le répertoire courant ;"
        "Indiquer l’arborescence (en permettant de paramétrer une profondeur) du répertoire courant ;"
        "Indiquer le poids (quantité de données) de chaque sous-répertoire du répertoire courant (veiller à comptabiliser tous les fichiers présents dans l’arborescence de chaque sous répertoire) ;"
        "Changer de répertoire courant pour poursuivre mes investigations ;"
        "Rechercher les fichiers plus récents qu’une date (définie en paramètre) pour le répertoire courant ;"
        "Rechercher les fichiers plus récents qu’une date (définie en paramètre) présents dans tous les sous-répertoires de l’arborescence du répertoire courant ;"
        "Rechercher les fichiers plus anciens qu’une date (définie en paramètre) pour le répertoire courant ;"
        "Rechercher les fichiers plus anciens qu’une date (définie en paramètre) présents dans tous les sous-répertoires de l’arborescence du répertoire courant ;"
        "Rechercher les fichiers de poids supérieur à une valeur indiquée présents dans le répertoire courant ;"
        "Rechercher les fichiers de poids supérieur à une valeur présents dans tous les sousrépertoires de l’arborescence du répertoire courant ;"
        "Rechercher les fichiers de poids inférieur à une valeur indiquée présents dans le répertoire courant ;"
        "Rechercher les fichiers de poids inférieur à une valeur indiquée présents dans tous les sous-répertoires de l’arborescence du répertoire courant ;"
        "Rechercher tous les fichiers d’une extension donnée (définie en paramètre) présents dans tous les sous-répertoires de l’arborescence du répertoire courant ;"
        "Rechercher tous les fichiers d’une extension donnée (définie en paramètre) présents dans le répertoire courant ;"
        "Rechercher tous les fichiers dont le nom contient une chaine de caractère (définie en paramètre) présents dans tous les sous-répertoires de l’arborescence du répertoire courant ;"
        "Produire un fichier de sortie contenant le résultat de la recherche effectuée qui n’écrase pas les résultats de la recherche précédente (tenir compte par exemple de la date et l’heure système)"
        "Proposer une fonctionnalité supplémentaire que vous jugez intéressante et qui manque à la liste précédente (argumentez votre choix)"
        "Filtre de recherche: date - taille - nom"
        "Quitter")

# Fonction pour afficher le menu
show_menu() {
    echo "========================================"
    echo "Menu principal"
    echo "========================================"
    for index in "${!options[@]}"; do
        echo "$((index+1)). ${options[$index]}"
    done
    echo "========================================"
}

function search_files() {
    file_name=$1
    min_size=$2
    max_size=$3
    min_date=$4
    max_date=$5

    command="find . -type f"
    if [[ -n $file_name ]]; then
        command+=" -name '$file_name'"
    fi
    if [[ -n $min_size ]]; then
        command+=" -size +${min_size}k"
    fi
    if [[ -n $max_size ]]; then
        command+=" -size -${max_size}k"
    fi
    if [[ -n $min_date ]]; then
        command+=" -newermt '$min_date'"
    fi
    if [[ -n $max_date ]]; then
        command+=" ! -newermt '$max_date'"
    fi

    # Affichage des fichiers correspondant aux critères
    echo "Résultats de la recherche:"
    results=$(eval "$command" | grep -v '^.$')
    if [[ -z $results ]]; then
        echo "Aucun fichier ne correspond aux critères de recherche."
    else
        echo "$results"
    fi
}

# Menu pour les critères de recherche
function show_filter_menu() {
    file_name=""
    min_size=""
    max_size=""
    min_date=""
    max_date=""

    while true; do
        echo "Critères de recherche disponibles:"
        echo "  1) Nom de fichier"
        echo "  2) Taille de fichier"
        echo "  3) Date de création"
        echo "  4) Rechercher avec les critères sélectionnés"
        echo "  5) Retour au menu principal"
        read -p "Entrez votre choix: " choix

        case $choix in
        1)
            read -p "Nom de fichier: " file_name
            ;;
        2)
            read -p "Taille minimale (en Ko): " min_size
            read -p "Taille maximale (en Ko): " max_size
            ;;
        3)
            read -p "Date minimale (format: YYYY-MM-DD): " min_date
            read -p "Date maximale (format: YYYY-MM-DD): " max_date
            ;;
        4)
            if [[ -z $file_name && -z $min_size && -z $max_size && -z $min_date && -z $max_date ]]; then
                echo "Veuillez sélectionner au moins un critère de recherche."
            else
                search_files "$file_name" "$min_size" "$max_size" "$min_date" "$max_date"
            fi            ;;
        5)
            break
            ;;
        *)
            echo "Choix invalide"
            ;;
        esac
    done
}


# Menu interactif
while true; do
    show_menu

    read -p "Entrez votre choix: " choix
    case $choix in
        1) show_pwd ;;
        2) show_date ;;
        3) show_files ;;
        4) show_subdirs ;;
        5) show_tree ;;
        6) show_subdirs_size ;;
        7) change_dir ;;
        8) search_newer ;;
        9) search_newer_all ;;
        10) search_older ;;
        11) search_older_all ;;
        12) search_size_gt ;;
        13) search_size_gt_all ;;
        14) search_size_lt ;;
        15) search_size_lt_all ;;
        16) search_ext_all ;;
        17) search_ext_main ;;
        18) search_name_all ;;
        19) search_name_all_outfile ;;
        20) search_content ;;
        21) show_filter_menu ;;
        22) exit 0 ;;
        *) echo "Choix invalide" ;;
    esac
done