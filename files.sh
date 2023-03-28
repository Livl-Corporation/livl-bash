#!/bin/bash

source common.sh

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
        error_message "La profondeur doit être un nombre entier positif."
        show_tree
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
        error_message "Le répertoire spécifié n'existe pas."
        change_dir
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

# t) Rechercher des fichiers en fonction de leur contenu
function search_content() {
    read -p "Entrez le texte recherché dans les fichiers: " text1
    if [[ -z "$text1" ]]; then
        error_message "Vous devez entrer un texte à rechercher."
        search_content
    fi
    grep -r "$text1" .
}

# Définition des options du menu
options=(
    "Afficher le répertoire courant "
    "Afficher la date et l'heure du système "
    "Afficher le nombre de fichiers et leur taille dans le répertoire courant "
    "Afficher le nombre de sous-répertoires dans le répertoire courant "
    "Afficher l'arborescence du répertoire courant avec une profondeur paramétrable "
    "Afficher le poids de chaque sous-répertoire dans le répertoire courant "
    "Changer le répertoire courant "
    "Rechercher les fichiers plus récents qu'une date donnée dans le répertoire courant "
    "Rechercher les fichiers plus récents qu'une date donnée dans tous les sous-répertoires de l'arborescence du répertoire courant "
    "Rechercher les fichiers plus anciens qu'une date donnée dans le répertoire courant "
    "Rechercher les fichiers plus anciens qu'une date donnée dans tous les sous-répertoires de l'arborescence du répertoire courant "
    "Rechercher les fichiers de poids supérieur à une valeur donnée dans le répertoire courant "
    "Rechercher les fichiers de poids supérieur à une valeur donnée dans tous les sous-répertoires de l'arborescence du répertoire courant "
    "Rechercher les fichiers de poids inférieur à une valeur donnée dans le répertoire courant "
    "Rechercher les fichiers de poids inférieur à une valeur donnée dans tous les sous-répertoires de l'arborescence du répertoire courant "
    "Rechercher tous les fichiers d'une extension donnée dans tous les sous-répertoires de l'arborescence du répertoire courant "
    "Rechercher tous les fichiers d'une extension donnée dans le répertoire courant "
    "Rechercher tous les fichiers dont le nom contient une chaîne de caractères dans tous les sous-répertoires de l'arborescence du répertoire courant "
    "Produire un fichier de sortie contenant le résultat de la recherche effectuée sans écraser les résultats précédents "
    "Rechercher des fichiers en fonction de leur contenu "
    "Filtre de recherche : date, taille, nom "
    "Quitter."
)

# Fonction pour afficher le menu
function show_menu() {

    echo -e "${RED}${BOLD}    ____________    ______   ${YELLOW}_______  __ ____  __    ____  ____  __________  "
    echo -e "${RED}   / ____/  _/ /   / ____/  ${YELLOW}/ ____/ |/ // __ \/ /   / __ \/ __ \/ ____/ __ \ "
    echo -e "${RED}  / /_   / // /   / __/    ${YELLOW}/ __/  |   // /_/ / /   / / / / /_/ / __/ / /_/ / "
    echo -e "${RED} / __/ _/ // /___/ /___   ${YELLOW}/ /___ /   |/ ____/ /___/ /_/ / _, _/ /___/ _, _/  "
    echo -e "${RED}/_/   /___/_____/_____/  ${YELLOW}/_____//_/|_/_/   /_____/\____/_/ |_/_____/_/ |_|   ${RESET}"

    display_list_of_option "${options[@]}"

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
            read -p "Entrez votre choix: " choix

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
            read -p "Entrez votre choix: " choix
        fi
        
        case $choix in
        'n')
            read -p "Nom de fichier: " file_name 
            filters+=" $mode -name '$file_name'"
            ;;
        'i')
            read -p "Taille minimale (en Ko): " min_size
            read -p "Taille maximale (en Ko): " max_size
            filters+=" $mode -size +${min_size}k -size -${max_size}k"
            ;;
        'd')
            read -p "Date minimale (format: YYYY-MM-DD): " min_date
            read -p "Date maximale (format: YYYY-MM-DD): " max_date
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
    read -p "Entrez votre choix (1-${#options[@]}): " choix
    
    case $choix in
        1) 
            run_menu_option "$choice" "${options[$choix-1]}" "show_pwd";;
        2)  
            run_menu_option "$choice" "${options[$choix-1]}" "show_date";;
        3) 
            run_menu_option "$choice" "${options[$choix-1]}" "show_files";;
        4)  
            run_menu_option "$choice" "${options[$choix-1]}" "show_subdirs";;
        5)  
            run_menu_option "$choice" "${options[$choix-1]}" "show_tree";;
        6)  
            run_menu_option "$choice" "${options[$choix-1]}" "show_subdirs_size";;
        7)  
            run_menu_option "$choice" "${options[$choix-1]}" "change_dir";;
        8)  
            run_menu_option "$choice" "${options[$choix-1]}" "search_newer";;
        9)  
            run_menu_option "$choice" "${options[$choix-1]}" "search_newer_all";;
        10)  
            run_menu_option "$choice" "${options[$choix-1]}" "search_older";;
        11)  
            run_menu_option "$choice" "${options[$choix-1]}" "search_older_all";;
        12) 
            run_menu_option "$choice" "${options[$choix-1]}" "search_size_gt";;
        13)  
            run_menu_option "$choice" "${options[$choix-1]}" "search_size_gt_all";;
        14)  
            run_menu_option "$choice" "${options[$choix-1]}" "search_size_lt";;
        15)  
            run_menu_option "$choice" "${options[$choix-1]}" "search_size_lt_all";;
        16)  
            run_menu_option "$choice" "${options[$choix-1]}" "search_ext_all";;
        17)  
            run_menu_option "$choice" "${options[$choix-1]}" "search_ext_main";;
        18)  
            run_menu_option "$choice" "${options[$choix-1]}" "search_name_all";;
        19) 
            run_menu_option "$choice" "${options[$choix-1]}" "search_name_all_outfile";;
        20)  
            run_menu_option "$choice" "${options[$choix-1]}" "search_content";;
        21)  
            run_menu_option "$choice" "${options[$choix-1]}" "show_filter_menu";;
        22) exit 0 ;;
        *) error_message "Choix invalide" ;;
    esac
done