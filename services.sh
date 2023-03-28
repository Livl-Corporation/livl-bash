#!/bin/bash

# a) Identifier les services disponibles/installés sur le système
list_services() {
    systemctl list-unit-files --type=service --no-pager
}

# b) Identifier les services actifs sur le système
list_active_services() {
    systemctl list-units --type=service --state=active --no-pager
}

# c) Identifier le statut d’un service dont le nom contient une chaine de caractères (définie en paramètre)
check_service_status() {
    local service_name=$1
    systemctl status $service_name
}

# Proposer une fonctionnalité supplémentaire : redémarrer un service dont le nom contient une chaîne de caractères (définie en paramètre)
restart_service() {
    local service_name=$1
    systemctl restart $service_name
}

show_menu() {
    clear
    echo "Explorateur de services"
    echo "-----------------------"
    echo "1. Liste des services disponibles/installés"
    echo "2. Liste des services actifs"
    echo "3. Vérifier le statut d'un service"
    echo "4. Redémarrer un service"
    echo "5. Quitter"
    echo
}

# Boucle principale du programme
while true; do
    show_menu
    read -p "Entrez une option : " choice

    # check if input is a number and if it is between 1 and 5
    if ! [[ $choice =~ ^[1-5]$ ]]; then
        echo "Option invalide"
        read "Appuyez sur une touche pour continuer..."
        continue
    fi

    case $choice in
        1)
            list_services
            read -p "Appuyez sur une touche pour continuer..." -n1
            ;;
        2)
            list_active_services
            read -p "Appuyez sur une touche pour continuer..." -n1
            ;;
        3)
            read -p "Entrez le nom du service à vérifier : " service_name
            if [ -z "$service_name" ]; then
                echo "Nom de service invalide"
            else
                check_service_status "$service_name"
            fi
            read -p "Appuyez sur une touche pour continuer..." -n1
            ;;
        4)
            read -p "Entrez le nom du service à redémarrer : " service_name
            if [ -z "$service_name" ]; then
                echo "Nom de service invalide"
            else
                restart_service "$service_name"
            fi
            read -p "Appuyez sur une touche pour continuer..." -n1
            ;;
        5)
            exit 0
            ;;
    esac

    # Rafraîchit l'affichage toutes les 30 secondes

done
