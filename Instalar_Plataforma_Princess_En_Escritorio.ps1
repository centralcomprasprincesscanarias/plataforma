Add-Type -AssemblyName System.Windows.Forms
$ErrorActionPreference = "Stop"

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktop "Plataforma Princess.lnk"
$url = "https://centralcomprasprincesscanarias.github.io/plataforma/hub.html"
$iconPath = "\\shtabaiba\Comun$\maspalomas&tabaibac\Compras-Chef\PLATAFORMA PRINCESS\icono_plataforma_princess.ico"

$edgeCandidates = @(
    "$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe",
    "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
)

$chromeCandidates = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe"
)

$browser = $null
foreach ($p in $edgeCandidates + $chromeCandidates) {
    if (Test-Path $p) {
        $browser = $p
        break
    }
}

if (-not $browser) {
    [System.Windows.Forms.MessageBox]::Show("No se encontró Microsoft Edge ni Google Chrome en este equipo.","Plataforma Princess")
    exit 1
}

$wsh = New-Object -ComObject WScript.Shell
$shortcut = $wsh.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $browser
$shortcut.Arguments = "--app="$url""
$shortcut.WorkingDirectory = Split-Path $browser
if (Test-Path $iconPath) {
    $shortcut.IconLocation = "$iconPath,0"
}
$shortcut.Save()

Write-Host "OK: acceso directo creado en el escritorio:"
Write-Host $shortcutPath
