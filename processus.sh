#!/bin/bash

# Fonction pour afficher la liste de tous les processus
function list_all_processes() {
  echo "Liste de tous les processus:"
  ps -ef
}

# Fonction pour afficher la liste des processus actifs
function list_active_processes() {
  echo "Liste des processus actifs:"
  ps -ef | grep -v defunct | grep -v "<defunct>"
}

# Fonction pour afficher la liste des processus d'un utilisateur donné
function list_user_processes() {
  user=$1
  echo "Liste des processus de l'utilisateur $user:"
  ps -u "$user"
}

# Fonction pour afficher la liste des processus consommant le plus de mémoire
function list_memory_processes() {
  echo "Liste des processus consommant le plus de mémoire:"
  ps -eo pid,user,%mem,command --sort=-%mem | head
}

# Fonction pour afficher la liste des processus dont le nom contient une chaîne de caractères
function list_matching_processes() {
  pattern=$1
  echo "Liste des processus dont le nom contient '$pattern':"
  ps -eo pid,user,%mem,command | grep "$pattern"
}

# Fonction pour écrire la liste des processus correspondant à un critère de recherche dans un fichier
function write_processes_to_file() {
  pattern=$1
  file="processes_$(date +'%Y-%m-%d_%H-%M-%S').txt"
  echo "Écriture de la liste des processus correspondant à '$pattern' dans le fichier '$file'..."
  ps -eo pid,user,%mem,command | grep "$pattern" > "$file"
}

# Fonction pour afficher le menu principal
function show_main_menu() {
  while true; do
    echo "Menu principal:"
    echo "  1) Liste de tous les processus"
    echo "  2) Liste des processus actifs"
    echo "  3) Liste des processus d'un utilisateur donné"
    echo "  4) Liste des processus consommant le plus de mémoire"
    echo "  5) Liste des processus dont le nom contient une chaîne de caractères"
    echo "  6) Écrire la liste des processus correspondant à un critère de recherche dans un fichier"
    echo "  7) Fonctionnalité supplémentaire"
    echo "  8) Quitter"
    read -p "Entrez votre choix: " choice

    case $choice in
      1)
        list_all_processes
        ;;
      2)
        list_active_processes
        ;;
      3)
        read -p "Entrez le nom d'utilisateur: " user
        list_user_processes "$user"
        ;;
      4)
        list_memory_processes
        ;;
      5)
        read -p "Entrez la chaîne de caractères: " pattern
        list_matching_processes "$pattern"
        ;;
      6)
        read -p "Entrez la chaîne de caractères: " pattern
        write_processes_to_file "$pattern"
        ;;
      7)
        echo "Fonctionnalité supplémentaire à ajouter..."
        ;;
      8)
        echo "Au revoir!"
        exit 0
        ;;
      *)
        echo "Choix invalide"
        ;;
    esac

    # L’affichage du résultat sera rafraichi automatiquement toutes les 30 secondes.
    sleep 30
    done
}