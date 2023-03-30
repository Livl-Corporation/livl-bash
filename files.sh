#!/bin/bash

# Importation des fonctions communes
source common.sh

# Définition des options du menu
MENU_OPTIONS=( "Afficher le répertoire courant " "Afficher la date et l'heure du système " "Afficher le nombre de fichiers et leur taille dans le répertoire courant " "Afficher le nombre de sous-répertoires dans le répertoire courant " "Afficher l'arborescence du répertoire courant avec une profondeur paramétrable " "Afficher le poids de chaque sous-répertoire dans le répertoire courant " "Changer le répertoire courant " "Rechercher les fichiers plus récents qu'une date donnée dans le répertoire courant " "Rechercher les fichiers plus récents qu'une date donnée dans tous les sous-répertoires de l'arborescence du répertoire courant " "Rechercher les fichiers plus anciens qu'une date donnée dans le répertoire courant " "Rechercher les fichiers plus anciens qu'une date donnée dans tous les sous-répertoires de l'arborescence du répertoire courant " "Rechercher les fichiers de poids supérieur à une valeur donnée dans le répertoire courant " "Rechercher les fichiers de poids supérieur à une valeur donnée dans tous les sous-répertoires de l'arborescence du répertoire courant " "Rechercher les fichiers de poids inférieur à une valeur donnée dans le répertoire courant " "Rechercher les fichiers de poids inférieur à une valeur donnée dans tous les sous-répertoires de l'arborescence du répertoire courant " "Rechercher tous les fichiers d'une extension donnée dans tous les sous-répertoires de l'arborescence du répertoire courant " "Rechercher tous les fichiers d'une extension donnée dans le répertoire courant " "Rechercher tous les fichiers dont le nom contient une chaîne de caractères dans tous les sous-répertoires de l'arborescence du répertoire courant " "Produire un fichier de sortie contenant le résultat de la recherche effectuée sans écraser les résultats précédents " "Rechercher des fichiers en fonction de leur contenu " "Filtre de recherche : date, taille, nom " "Quitter." )

# Définition des fonctions associées aux options du menu
MENU_ACTIONS=("show_pwd" "show_date" "show_files" "show_subdirs" "show_tree" "show_subdir_sizes" "change_dir" "search_newer" "search_newer_all" "search_older" "search_older_all" "search_size_gt" "search_size_gt_all" "search_size_lt" "search_size_lt_all" "search_ext_all" "search_ext_main" "search_name_all" "search_name_all_outfile" "search_content" "show_filter_menu")


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
    depth=$(ask_for_number "Entrez la profondeur souhaitée pour l'arborescence: ")
    find . -maxdepth $depth -type d -print | sed -e "s;[^/]*/;|____;g;s;____|; |;g" 
}
# f) Indiquer le poids de chaque sous-répertoire du répertoire courant
function show_subdir_sizes() {
    for dir in $(find . -mindepth 1 -maxdepth 1 -type d); do
        echo "$dir: $(du -sh $dir)"
    done
}
# g) Changer de répertoire courant pour poursuivre mes investigations
function change_dir() {
    newdir=$(ask_for_string "Entrez le chemin du répertoire dans lequel vous voulez aller: ") 
    if [ ! -d "$newdir" ]; then
        echo "Le répertoire $newdir n'existe pas."
        return
    fi
    cd "$newdir"
}
# h) Rechercher les fichiers plus récents qu’une date pour le répertoire courant 
function search_newer() {
    date=$(ask_for_date)
    find . -maxdepth 1 -type f ! -newermt "$date"
}
# i) Rechercher les fichiers plus récents qu’une date présents dans tous les sous-répertoires de l’arborescence du répertoire courant 
function search_newer_all() {
    date=$(ask_for_date)
    find . ! -newermt $date -type f
}
# j) Rechercher les fichiers plus anciens qu’une date pour le répertoire courant
function search_older() {
    date=$(ask_for_date)
    find . -maxdepth 1 -type f -newermt $date 
}
# k) Rechercher les fichiers plus anciens qu’une date présents dans tous les sous-répertoires de l’arborescence du répertoire courant
function search_older_all() {
    date=$(ask_for_date)
    find . -type f -newermt $date
}
# l) Rechercher les fichiers de poids supérieur à une valeur indiquée présents dans le répertoire courant
function search_size_gt() {
    size=$(ask_for_number "Entrez la taille minimale des fichiers (en Ko): ")
    find . -maxdepth 1 -type f -size +${size}k
}
# m) Rechercher les fichiers de poids supérieur à une valeur présents dans tous les sous-répertoires de l’arborescence du répertoire courant
function search_size_gt_all() {
    size=$(ask_for_number "Entrez la taille minimale des fichiers (en Ko):")
    find . -type f -size +${size}k
}
# n) Rechercher les fichiers de poids inférieur à une valeur indiquée présents dans le répertoire courant
function search_size_lt() {
    size=$(ask_for_number "Entrez la taille minimale des fichiers (en Ko): ")
    find . -maxdepth 1 -type f -size -${size}k
}
# o) Rechercher les fichiers de poids inférieur à une valeur indiquée présents dans tous les sous-répertoires de l’arborescence du répertoire courant
function search_size_lt_all() {
    size=$(ask_for_number "Entrez la taille minimale des fichiers (en Ko): ")
    find . -type f -size -${size}k
}
# p) Rechercher tous les fichiers d’une extension donnée présents dans tous les sous-répertoires de l’arborescence du répertoire courant
function search_ext_all() {
    ext=$(ask_for_string "Entrez l'extension des fichiers recherchés: ") 
    find . -type f -name "*.$ext"
}
# q) Rechercher tous les fichiers d’une extension donnée présents dans le répertoire courant 
function search_ext_main() {
    ext=$(ask_for_string "Entrez la chaine de caractères recherchée: ")
    find . -maxdepth 1 -type f -name "*.$ext"
}

# r) Rechercher tous les fichiers dont le nom contient une chaine de caractère présents dans tous les sous-répertoires de l’arborescence du répertoire courant
function search_name_all() {
    string=$(ask_for_string "Entrez la chaine de caractères recherchée: ")
    find . -type f -name "*$string*"
}

# s) Produire un fichier de sortie contenant le résultat de la recherche effectuée qui n’écrase pas les résultats de la recherche précédente (tenir compte par exemple de la date et l’heure système)
function search_name_all_outfile() {
    string=$(ask_for_string "Entrez la chaine de caractères recherchée: ")
    find . -type f -name "*$string*" > search_results.txt
}

# t) Rechercher des fichiers en fonction de leur contenu
function search_content() {
    text=$(ask_for_string "Entrez le texte recherché dans les fichiers: ")
    grep -r "$text" .
}


# Fonction pour afficher le menu
function show_menu() {
    echo -e "${RED}${BOLD}    ____________    ______   ${YELLOW}_______  __ ____  __    ____  ____  __________  "
    echo -e "${RED}   / ____/  _/ /   / ____/  ${YELLOW}/ ____/ |/ // __ \/ /   / __ \/ __ \/ ____/ __ \ "
    echo -e "${RED}  / /_   / // /   / __/    ${YELLOW}/ __/  |   // /_/ / /   / / / / /_/ / __/ / /_/ / "
    echo -e "${RED} / __/ _/ // /___/ /___   ${YELLOW}/ /___ /   |/ ____/ /___/ /_/ / _, _/ /___/ _, _/  "
    echo -e "${RED}/_/   /___/_____/_____/  ${YELLOW}/_____//_/|_/_/   /_____/\____/_/ |_/_____/_/ |_|   ${RESET}"

    display_list_of_option "${MENU_OPTIONS[@]}"
}

function search_files() {
    filters=$1

    command="find . -type f $filters"
    echo "Commande: $command"

    # Affichage des fichiers correspondant aux critères
    echo "Résultats de la recherche:"
    results=$(eval "$command" | grep -v '^.$')
    if [[ -z $results ]]; then
        error_message "Aucun fichier ne correspond aux critères de recherche."
    else
        echo "$results"
    fi
}

# Menu pour les critères de recherche
function show_filter_menu() {
    filters=""

    while true; do

        mode=""
        choix=""
        
        # Si des filtres sont déjà actifs
        if [[ -n $filters ]]; then
            echo "- Choisir une action -"
            echo " [a] Ajouter un filtre ET"
            echo " [e] Ajouter un filtre OU"
            echo " [s] Lancer la recherche avec les critères sélectionnés"
            echo " [m] Retour au menu principal"
            choix_mode=$(ask_for_string "Entrez une lettre: ")

            # Selection du mode de filtre
            if [[ $choix_mode == "a" ]]; then
                mode="-and"
                choix=""
            elif [[ $choix_mode == "e" ]]; then
                mode="-or"
                choix=""
            fi
        fi

        # Si aucun filtre n'est actif
        # Si le choix est vide ou qu'il n'est ni à 's' ni 'm'
        if [[ -z $choix || ( $choix != "s" && $choix != "m" ) ]]; then
            echo "- Choix du filtre -"
            echo "  [n] Nom de fichier"
            echo "  [i] Taille de fichier"
            echo "  [d] Date de création"
            echo "- Actions -"
            echo "  [s] Lancer la recherche avec les critères sélectionnés"
            echo "  [m] Retour au menu principal"

            choix=$(ask_for_string "Entrez une lettre: ")
        fi
        
        case $choix in
        'n')
            file_name=$(ask_for_string "Nom de fichier: ") 
            filters+=" $mode -name '$file_name'"
            ;;
        'i')
            min_size=$(ask_for_number "Taille minimale (en Ko): ")
            max_size=$(ask_for_number "Taille maximale (en Ko): ")
            filters+=" $mode -size +${min_size}k -size -${max_size}k"
            ;;
        'd')
            min_date=$(ask_for_date "Date minimale (format: YYYY-MM-DD): ")
            max_date=$(ask_for_date "Date maximale (format: YYYY-MM-DD): ")
            if [[ $min_date > $max_date ]]; then
                error_message "La date de début doit être antérieure à la date de fin."
                continue
            fi
            filters+=" $mode -newermt '$min_date' ! -newermt '$max_date'"
            ;;
        's')
            if [[ -z filters ]]; then
                error_message "Veuillez sélectionner au moins un critère de recherche."
            else
                search_files "$filters"
            fi
            ;;
        'm')
            break
            ;;
        *)
            error_message "Choix invalide"
            ;;
        esac

    done
}

# Menu interactif
while true; do
    clear

    show_menu
    read -p "Entrez votre choix (1-${#MENU_OPTIONS[@]}): " choice

    if ((choice >= 1 && choice <= ${#MENU_ACTIONS[@]})); then
        run_menu_option "$choice" "${MENU_OPTIONS[$choice-1]}" "${MENU_ACTIONS[$choice-1]}"
    elif ((choice == ${#MENU_OPTIONS[@]})); then
        exit 0
    else
        error_message "Choix invalide"
    fi
done