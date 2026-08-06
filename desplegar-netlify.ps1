<#
.SINOPSIS
    Despliega este sitio en Netlify sin conectar la cuenta de GitHub.

.DESCRIPCION
    Empaqueta el sitio en un ZIP y lo sube directamente a la API de Netlify.
    No requiere Node, ni el CLI de Netlify, ni autorizar ninguna aplicacion
    en GitHub: la unica credencial es un token personal de Netlify.

.REQUISITOS
    Un token personal de Netlify, que se crea en:
      Netlify -> User settings -> Applications -> Personal access tokens
      -> New access token

    Se pasa mediante variable de entorno, para que no quede escrito en ningun
    fichero ni en el historial de Git:

      $env:NETLIFY_AUTH_TOKEN = "el-token"

    Para que persista entre sesiones de PowerShell:
      [Environment]::SetEnvironmentVariable("NETLIFY_AUTH_TOKEN","el-token","User")

.EJEMPLOS
    # Primera vez: crea el sitio en el equipo indicado y lo despliega
    .\desplegar-netlify.ps1 -CrearSitio -Nombre "microbiota-tmf-hgugm"

    # Veces siguientes: reutiliza el sitio guardado en .netlify-site-id
    .\desplegar-netlify.ps1

    # Desplegar en un sitio concreto ya existente
    .\desplegar-netlify.ps1 -SiteId "a1b2c3d4-..."

    # Ver los sitios disponibles en la cuenta
    .\desplegar-netlify.ps1 -Listar
#>

[CmdletBinding()]
param(
    [string]$SiteId,
    [switch]$CrearSitio,
    [string]$Nombre,
    [string]$Equipo = "esehomo",
    [switch]$Listar,
    [string]$Token = $env:NETLIFY_AUTH_TOKEN
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$raiz      = $PSScriptRoot
$ficheroId = Join-Path $raiz ".netlify-site-id"
$api       = "https://api.netlify.com/api/v1"

# --- Token ----------------------------------------------------------------

if (-not $Token) {
    Write-Host ""
    Write-Host "Falta el token de Netlify." -ForegroundColor Red
    Write-Host ""
    Write-Host "  1. Crea uno en: Netlify -> User settings -> Applications"
    Write-Host "                    -> Personal access tokens -> New access token"
    Write-Host "  2. Y ponlo en la variable de entorno:"
    Write-Host ""
    Write-Host '     $env:NETLIFY_AUTH_TOKEN = "el-token"' -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

$cabeceras = @{ Authorization = "Bearer $Token" }

function Invoke-Netlify {
    param([string]$Ruta, [string]$Metodo = "Get", $Cuerpo)
    $p = @{ Uri = "$api$Ruta"; Method = $Metodo; Headers = $cabeceras }
    if ($null -ne $Cuerpo) {
        $p.Body        = ($Cuerpo | ConvertTo-Json -Compress)
        $p.ContentType = "application/json"
    }
    return Invoke-RestMethod @p
}

# --- Listar sitios --------------------------------------------------------

if ($Listar) {
    Write-Host "`nSitios en la cuenta:`n"
    Invoke-Netlify "/sites" | ForEach-Object {
        "  {0,-32} {1,-40} {2}" -f $_.name, $_.ssl_url, $_.id
    }
    Write-Host ""
    exit 0
}

# --- Determinar el sitio de destino ---------------------------------------

if ($CrearSitio) {
    if (-not $Nombre) { throw "Con -CrearSitio hay que indicar tambien -Nombre." }
    Write-Host "Creando el sitio '$Nombre' en el equipo '$Equipo'..."
    $sitio  = Invoke-Netlify "/$Equipo/sites" "Post" @{ name = $Nombre }
    $SiteId = $sitio.id
    Set-Content -Path $ficheroId -Value $SiteId -Encoding ascii
    Write-Host "  creado: $($sitio.ssl_url)" -ForegroundColor Green
}
elseif (-not $SiteId) {
    if ($env:NETLIFY_SITE_ID)  { $SiteId = $env:NETLIFY_SITE_ID }
    elseif (Test-Path $ficheroId) { $SiteId = (Get-Content $ficheroId -Raw).Trim() }
    else {
        throw "No se sabe donde desplegar. Usa -CrearSitio -Nombre <nombre> la primera vez, o -SiteId <id>."
    }
}

# --- Empaquetar el sitio --------------------------------------------------
# Se construye el ZIP entrada por entrada, forzando la barra inclinada en las
# rutas: Compress-Archive puede usar la barra invertida de Windows y entonces
# Netlify no reconoce la estructura de carpetas.

Add-Type -AssemblyName System.IO.Compression | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null

$zip = Join-Path $env:TEMP "netlify-microbiota-tmf.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }

$excluidos = @(".netlify-site-id", ".gitignore")
$ficheros = Get-ChildItem $raiz -Recurse -File | Where-Object {
    $_.FullName -notmatch '\\\.git\\' -and
    $_.Extension -ne ".ps1" -and
    $excluidos -notcontains $_.Name
}

$flujo   = [System.IO.File]::Open($zip, [System.IO.FileMode]::Create)
$archivo = New-Object System.IO.Compression.ZipArchive($flujo, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($f in $ficheros) {
        $rel     = $f.FullName.Substring($raiz.Length + 1).Replace('\', '/')
        $entrada = $archivo.CreateEntry($rel, [System.IO.Compression.CompressionLevel]::Optimal)
        $salida  = $entrada.Open()
        try {
            $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
            $salida.Write($bytes, 0, $bytes.Length)
        } finally { $salida.Dispose() }
    }
} finally {
    $archivo.Dispose()
    $flujo.Dispose()
}

$tam = [math]::Round((Get-Item $zip).Length / 1KB, 1)
Write-Host "Empaquetados $($ficheros.Count) ficheros ($tam KB)."

# --- Desplegar ------------------------------------------------------------

Write-Host "Subiendo a Netlify..."
$despliegue = Invoke-RestMethod -Uri "$api/sites/$SiteId/deploys" -Method Post `
    -Headers $cabeceras -InFile $zip -ContentType "application/zip"

Write-Host "  despliegue $($despliegue.id) en estado '$($despliegue.state)'."

# Espera a que Netlify termine de procesarlo
$intentos = 0
while ($despliegue.state -notin @("ready", "error") -and $intentos -lt 40) {
    Start-Sleep -Seconds 3
    $intentos++
    $despliegue = Invoke-Netlify "/deploys/$($despliegue.id)"
}

Remove-Item $zip -Force

Write-Host ""
if ($despliegue.state -eq "ready") {
    Write-Host "Despliegue completado." -ForegroundColor Green
    Write-Host "  $($despliegue.ssl_url)"
    if ($despliegue.deploy_ssl_url) { Write-Host "  version concreta: $($despliegue.deploy_ssl_url)" }
} elseif ($despliegue.state -eq "error") {
    Write-Host "El despliegue ha fallado: $($despliegue.error_message)" -ForegroundColor Red
    exit 1
} else {
    Write-Host "Sigue procesandose. Consulta el panel de Netlify." -ForegroundColor Yellow
}
Write-Host ""
