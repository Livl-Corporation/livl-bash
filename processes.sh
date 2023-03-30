#!/bin/bash

# Source the common.sh script
source common.sh

# Définition des options du menu
MENU_OPTIONS=("Liste de tous les processus" "Liste des processus actifs" "Liste des processus d'un utilisateur donné" "Liste des processus consommant le plus de mémoire" "Liste des processus dont le nom contient une chaîne de caractères" "Écrire la liste des processus correspondant à un critère de recherche dans un fichier" "Tuer un processus par son ID" "Quitter")
# Définition des noms de fonctions associées aux options du menu
MENU_ACTIONS=("list_all_processes" "list_active_processes" "list_user_processes" "list_memory_processes" "list_matching_processes" "write_processes_to_file" "kill_process_by_id" "filter_process_ask_args")

# a) Identifier tous les processus présents sur le système et indiquer leur propriétaire
function list_all_processes() {
  ps -ef
}

# b) Fonction pour afficher la liste des processus actifs
function list_active_processes() {
  ps -ef | grep -v defunct | grep -v "<defunct>"
}

# c) Identifier les processus appartenant à un utilisateur donné en paramètre
function list_user_processes() {
  user=$(ask_for_string "Entrez le nom d'utilisateur: ")
  # check if user exist in /etc/passwd
  if ! id -u "$user" >/dev/null 2>&1 ; then
    error_message "L'utilisateur $user n'existe pas"
    list_user_processes
  fi
  ps -u "$user"
}

# d) Identifier les processus consommant le plus de mémoire et indiquer leur propriétaire
function list_memory_processes() {
  ps aux --sort=-%mem | awk '{print $2,$1,$4,$11}' | head -n 11 | column -t 
}

# e) Identifier les processus dont le nom contient une chaine de caractères (définie en paramètre) et indiquer leur propriétaire
function list_matching_processes() {
  pattern=$(ask_for_string "Entrez une chaîne de caractères pour lister les processus : ")

  # Rechercher les processus dont le nom contient la chaîne de caractères
  processes=$(ps aux | grep "$pattern" | grep -v grep)

  if [ -z "$processes" ]; then # Si aucun processus n'a été trouvé
    echo "Aucun processus ne correspond à la chaîne de caractères \"$pattern\"."
    return
  fi

  echo "Les processus suivants ont été trouvés :"
  echo "$processes" | while read user pid cpu mem vsz rss tty stat start time command
  do
    echo "PID: $pid - Propriétaire: $user"
  done
}

# f) Produire un fichier de sortie contenant le résultat de la recherche effectuée qui n’écrase pas les résultats de la recherche précédente (tenir compte par exemple de la date et l’heure système)
function write_processes_to_file() {
  pattern=$(ask_for_string "Entrez une chaîne de caractères pour lister les processus : ")
  output_file="processes_$pattern_$(date +%Y%m%d_%H%M%S).txt"

  # Rechercher les processus dont le nom contient la chaîne de caractères
  processes=$(ps aux | grep "$pattern" | grep -v grep)

  if [ -z "$processes" ]; then # Si aucun processus n'a été trouvé
    echo "Aucun processus ne correspond à la chaîne de caractères \"$pattern\"."
    return
  fi

  echo "Les processus suivants ont été trouvés :"
  echo "$processes" | while read user pid cpu mem vsz rss tty stat start time command
  do
    echo "PID: $pid - Propriétaire: $user"
  done > "$output_file"

  echo "Résultats de la recherche enregistrés dans le fichier \"$output_file\"."
}

# g) Proposer une fonctionnalité supplémentaire que vous jugez intéressante et qui manque à la liste précédente (argumentez votre choix)
# Tuer un processus par son ID
function kill_process_by_id() {
  pid=$(ask_for_number "Entrez l'ID du processus à tuer : ")

  if ! ps -p "$pid" > /dev/null; then
    echo "Le processus avec l'ID $pid n'existe pas."
    return
  fi

  # Demander confirmation avant de tuer le processus
  read -p "Êtes-vous sûr de vouloir tuer le processus avec l'ID $pid ? (y/n) " confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    kill $pid
    echo "Le processus avec l'ID $pid a été tué."
  else
    echo "Le processus avec l'ID $pid n'a pas été tué."
  fi
}


function filter_process_help() {
  echo "MENU_OPTIONS:"
  echo "  -a, --actifs          Afficher uniquement les processus actifs"
  echo "  -m, --memoire <N>     Afficher les processus avec une utilisation mémoire supérieure à N"
  echo "  -n, --nom <NAME>       Afficher les processus avec le nom NAME"
}


# Fonction pour afficher la liste des processus avec des filtres
function filter_process() {
    # MENU_OPTIONS par défaut
    ACTIVE=false
    MAX_MEMORY=0
    NAME=""

    # Analyse des MENU_OPTIONS
    while [[ $# -gt 0 ]]
    do
        key="$1"
        case $key in
            -a|--actifs)
            ACTIVE=true
            shift
            ;;
            -m|--memoire)
            MAX_MEMORY=$2
            shift
            shift
            ;;
            -n|--nom)
            NAME="$2"
            shift
            shift
            ;;
            *)
            echo "Option invalide : $1"
            return 1
            ;;
        esac
    done

    # Construction de la commande ps avec les filtres
    CMD="ps -eo pid,user,%mem,command"

    if [ "$ACTIVE" = true ]; then
        CMD="$CMD | grep -v defunct | grep -v '<defunct>'"
    fi

    if [ "$MAX_MEMORY" -gt 0 ]; then
        CMD="$CMD | awk '\$3 > $MAX_MEMORY'"
    fi
    
    if [ -n "$NAME" ]; then
        CMD="$CMD | grep $NAME"
    fi
    echo "Commande : $CMD"
    eval $CMD
}

function filter_process_ask_args() {
  filter_process_help
  args=$(ask_for_string "Entrez les arguments pour exécuter la fonction lister_processus : ")
  filter_process $args
}

function show_menu() {
    clear
    
    echo -e "${RED}${BOLD}    ____  ____  ____  ______________________   ${YELLOW} _______  __ ____  __    ____  ____  __________ "
    echo -e "${RED}   / __ \/ __ \/ __ \/ ____/ ____/ ___/ ___/   ${YELLOW}/ ____/ |/ // __ \/ /   / __ \/ __ \/ ____/ __ \ "
    echo -e "${RED}  / /_/ / /_/ / / / / /   / __/  \__ \\__ \   ${YELLOW}/ __/  |   // /_/ / /   / / / / /_/ / __/ / /_/ / "
    echo -e "${RED} / ____/ _, _/ /_/ / /___/ /___ ___/ /__/ /  ${YELLOW}/ /___ /   |/ ____/ /___/ /_/ / _, _/ /___/ _, _/  "
    echo -e "${RED}/_/   /_/ |_|\____/\____/_____//____/____/  ${YELLOW}/_____//_/|_/_/   /_____/\____/_/ |_/_____/_/ |_|   ${RESET}"
                                                                                               

    display_list_of_option "${MENU_OPTIONS[@]}"
}

# Fonction pour afficher le menu principal

while true; do
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