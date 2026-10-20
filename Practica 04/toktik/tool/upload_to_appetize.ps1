<#
.SYNOPSIS
    Sube el APK de TokTik a Appetize.io y muestra el enlace para compartir.

.DESCRIPTION
    Necesita un API token de Appetize:
      1. Entra a https://appetize.io y crea una cuenta (el plan Free sirve).
      2. Ve a Account -> API Tokens y genera uno.
      3. Guardalo en la sesion de PowerShell:
             $env:APPETIZE_API_TOKEN = "tu_token"

    La primera vez crea una app nueva. Si despues pasas -PublicKey (el codigo
    que aparece en el enlace https://appetize.io/app/XXXXXXXX) actualiza esa
    misma app en lugar de crear otra.

.EXAMPLE
    .\tool\upload_to_appetize.ps1

.EXAMPLE
    .\tool\upload_to_appetize.ps1 -PublicKey abcd1234efgh5678
#>
param(
    [string]$Apk = (Join-Path $PSScriptRoot "..\build\app\outputs\flutter-apk\app-release.apk"),
    [string]$Token = $env:APPETIZE_API_TOKEN,
    [string]$PublicKey = "",
    [string]$Note = "TokTik - Practica DMI",
    [string]$Timeout = "180"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) {
    throw "No se encontro curl.exe (viene incluido en Windows 10/11)."
}

if (-not (Test-Path -LiteralPath $Apk)) {
    throw "No existe el APK: $Apk`nCompilalo antes con: flutter build apk --release"
}

if ([string]::IsNullOrWhiteSpace($Token)) {
    Write-Host ""
    Write-Host "Falta el API token de Appetize." -ForegroundColor Yellow
    Write-Host "  1. Crea una cuenta en https://appetize.io/signup"
    Write-Host "  2. Account -> API Tokens -> Generate"
    Write-Host "  3. Ejecuta:  `$env:APPETIZE_API_TOKEN = ""tu_token"""
    Write-Host ""
    exit 1
}

$apkPath = (Resolve-Path -LiteralPath $Apk).Path
$sizeMb = [math]::Round((Get-Item -LiteralPath $apkPath).Length / 1MB, 1)
$url = "https://api.appetize.io/v1/apps"
if ($PublicKey) { $url = "$url/$PublicKey" }

$mode = if ($PublicKey) { "Actualizando la app $PublicKey" } else { "Creando una app nueva" }
Write-Host "$mode con $apkPath ($sizeMb MB)..." -ForegroundColor Cyan
Write-Host "Puede tardar varios minutos si el APK es grande."

$curlArgs = @(
    "-sS", "--fail-with-body",
    "-X", "POST", $url,
    "-H", "X-API-KEY: $Token",
    "-F", "file=@$apkPath",
    "-F", "platform=android",
    "-F", "note=$Note",
    "-F", "timeout=$Timeout",
    "-F", "appPermissions.run=public"
)

$json = & curl.exe @curlArgs
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "La subida fallo (codigo $LASTEXITCODE)." -ForegroundColor Red
    Write-Host $json
    exit $LASTEXITCODE
}

try {
    $resp = $json | ConvertFrom-Json
} catch {
    Write-Host "Respuesta inesperada de Appetize:" -ForegroundColor Red
    Write-Host $json
    exit 1
}

$key = $resp.publicKey
Write-Host ""
Write-Host "Listo. Enlace para compartir:" -ForegroundColor Green
Write-Host "  https://appetize.io/app/$key" -ForegroundColor Green
Write-Host ""
Write-Host "Con parametros utiles (ejemplo):"
Write-Host "  https://appetize.io/app/$key?device=pixel7&osVersion=13.0&scale=75"
Write-Host ""
Write-Host "Para actualizar esta misma app mas adelante:"
Write-Host "  .\tool\upload_to_appetize.ps1 -PublicKey $key"
