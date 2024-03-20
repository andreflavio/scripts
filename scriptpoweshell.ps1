# Importar o módulo 'Path'
Import-Module Path

# Obter o diretório de instalação do Node.js
$nodePath = (Get-Item -Path 'C:\Program Files\nodejs\node.exe').DirectoryName

# Adicionar o diretório do Node.js ao Path
Set-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Environment\Path' -Value "$($env:Path);$($nodePath)"

# Registrar o módulo 'npm' no PowerShell
Set-ExecutionPolicy RemoteSigned
Register-Module -Name npm -Path '$($nodePath)\node_modules\npm\bin\npm-cli.js'

# Definir o alias 'npm' para o módulo 'npm'
Set-Alias -Name npm -Value npm

# Configurar o VS Code para usar o npm
$vscodeSettingsPath = (Get-Item -Path '$env:APPDATA\Code\User\settings.json').FullName
$vscodeSettings = Get-Content $vscodeSettingsPath | ConvertTo-Json

# Adicionar a configuração "npm.packageManager" ao VS Code
if (-Not ($vscodeSettings.hasOwnProperty('npm.packageManager'))) {
  $vscodeSettings.npm.packageManager = 'npm'
  Set-Content $vscodeSettingsPath -Value (ConvertTo-Json $vscodeSettings -Compress)
}

# Reiniciar o PowerShell
Restart-Shell

# Mensagem de sucesso
Write-Host "O PowerShell foi configurado com sucesso para usar o npm!"
