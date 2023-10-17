#!/bin/bash
# A TESTER
# Liste des machines distantes
SERVERS=('server1' 'server2')  # Remplacez par vos noms de serveur

# Boucle sur chaque serveur pour exécuter le script à distance
for SERVER in "${SERVERS[@]}"; do

    # Définit le fichier de sortie
    OUTPUT_FILE="$HOME/tasks_and_processes_$SERVER.txt"

    # Exécute le script à distance et sauvegarde les résultats localement
    ssh "$SERVER" bash -c "'
         Fonction pour récupérer les tâches cron
        get_cron_tasks() {
            echo \"### Tâches Cron pour l'utilisateur \$USER ###\"
            crontab -l 2>/dev/null
            echo -e \"\n### Tâches Cron système ###\"
            cat /etc/crontab 2>/dev/null
        }

        # Fonction pour récupérer les processus en cours d'exécution
        get_running_processes() {
            echo -e \"\n### Processus en cours d'exécution ###\"
            ps aux
        }

        # Fonction pour récupérer les timers systemd
        get_systemd_timers() {
            echo -e \"\n### Timers systemd ###\"
            systemctl list-timers --all
        }

        # Appelle les fonctions pour collecter les données
        get_cron_tasks
        get_running_processes
        get_systemd_timers
    '" > "$OUTPUT_FILE"

    # Imprime le chemin du fichier de sortie
    echo "Les tâches et processus de $SERVER ont été enregistrés dans le fichier : $OUTPUT_FILE"
done
