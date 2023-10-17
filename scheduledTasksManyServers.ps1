# Liste des noms d'hôte ou des adresses IP des machines distantes
$servers = @('NomServer1', 'NomServer2') # Remplacez par vos noms de serveur

# Script à exécuter sur chaque machine distante
$scriptBlock = {
    # Obtenez le nom de la machine une seule fois
    $computerName = [System.Environment]::MachineName

    # Obtenez la liste de toutes les tâches planifiées
    Get-ScheduledTask | ForEach-Object {
        # Obtenez des informations supplémentaires sur la tâche
        $info = Get-ScheduledTaskInfo $_

        # Déterminez si la tâche exécute un script
        $actions = $_.Actions | ForEach-Object { $_.Execute }
        $isScript = $actions -join ' ' -match '\.(ps1|bat|cmd|vbs)$'

        # Créez un objet personnalisé avec les propriétés souhaitées et retournez-le
        [PSCustomObject]@{
            'Machine' = $computerName
            'Nom de la Tache' = $_.TaskName
            'Chemin de la Tache' = $_.TaskPath
            'Etat' = $_.State
            'Action' = $actions -join ', '
            'Precedente Execution' = $info.LastRunTime
            'Prochaine Execution' = $info.NextRunTime
            'Est un script' = $isScript
        }
    }
}

# Exécutez le script sur chaque machine distante et stockez les résultats dans une variable
$results = Invoke-Command -ComputerName $servers -ScriptBlock $scriptBlock -Credential (Get-Credential)

# Définissez le chemin du fichier sur la machine locale
$filePath = "$HOME\tachesPlanifiees.csv"

# Exportez les résultats dans un fichier CSV sur la machine locale, en sélectionnant uniquement les colonnes souhaitées
$results | 
    Select-Object 'Machine', 'Nom de la Tache', 'Chemin de la Tache', 'Etat', 'Action', 'Prochaine Execution', 'Précédente Execution', 'Est un script' |
    Export-Csv -Path $filePath -NoTypeInformation -Delimiter ";"

# Affichez le chemin du fichier
Write-Host "Les taches sont enregistrees dans le fichier : $filePath"
