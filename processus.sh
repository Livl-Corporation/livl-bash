#!/bin/bash

while true; do
    clear
    echo "Menu:"
    echo "1. Identifier tous les processus présents sur le système et indiquer leur propriétaire"
    echo "2. Identifier uniquement les processus actifs et indiquer leur propriétaire"
    echo "3. Identifier les processus appartenant à un utilisateur donné en paramètre"
    echo "4. Identifier les processus consommant le plus de mémoire et indiquer leur propriétaire"
    echo "5. Identifier les processus dont le nom contient une chaine de caractères (définie en paramètre) et indiquer leur propriétaire"
    echo "6. Produire un fichier de sortie contenant le résultat de la recherche effectuée qui n’écrase pas les résultats de la recherche précédente (tenir compte par exemple de la date et l’heure système)"
    echo "7. Proposer une fonctionnalité supplémentaire que vous jugez intéressante et qui manque à la liste précédente (argumentez votre choix)"
    echo "8. Quitter"
    read -p "Entrez votre choix: " choice

    case $choice in
        1)
            ps aux
            ;;
        2)
            ps r | 
            ;;
        3)
            read -p "Entrez le nom d'utilisateur: " username
            pgrep -u $username 
            ;;
        4)
            ps aux --sort=-%mem | head
            ;;
        5)
            read -p "Entrez la chaîne de caractères: " string
            pgrep -f $string
            ;;
        6)
             output_file="processes_$(date +'%Y-%m-%d_%H-%M-%S').txt"
             ps aux |  > $output_file
             echo "Résultats enregistrés dans $output_file"
             ;;
        7)
             ps aux --sort=-%cpu | head
             ;; 
        8)
             exit 0
             ;;
        *)
           echo "Choix invalide."
           ;;
   esac

   read -p "Entrez une chaîne de caractères pour filtrer les résultats (laissez vide pour ne pas filtrer): " search_term

   sleep 30s
done
