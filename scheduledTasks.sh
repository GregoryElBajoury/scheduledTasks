#!/bin/bash
# A TESTER
# Définit le répertoire et le fichier de sortie
OUTPUT_DIRECTORY="$HOME"
OUTPUT_FILE="${OUTPUT_DIRECTORY}/tasks_and_processes_$(hostname).txt"

# Fonction pour récupérer les tâches cron
get_cron_tasks() {
    echo "### Tâches Cron pour l'utilisateur $USER ###" >> "$OUTPUT_FILE"
    crontab -l 2>/dev/null >> "$OUTPUT_FILE"
    echo -e "\n### Tâches Cron système ###" >> "$OUTPUT_FILE"
    cat /etc/crontab 2>/dev/null >> "$OUTPUT_FILE"
}

# Fonction pour récupérer les processus en cours d'exécution
get_running_processes() {
    echo -e "\n### Processus en cours d'exécution ###" >> "$OUTPUT_FILE"
    ps aux >> "$OUTPUT_FILE"
}

# Fonction pour récupérer les timers systemd
get_systemd_timers() {
    echo -e "\n### Timers systemd ###" >> "$OUTPUT_FILE"
    systemctl list-timers --all >> "$OUTPUT_FILE"
}

# Vérifie si le fichier de sortie existe déjà, si oui, le supprime
if [ -f "$OUTPUT_FILE" ]; then
    rm "$OUTPUT_FILE"
fi

# Appelle les fonctions pour collecter les données
get_cron_tasks
get_running_processes
get_systemd_timers

# Imprime le chemin du fichier de sortie
echo "Les tâches et processus ont été enregistrés dans le fichier : $OUTPUT_FILE"
