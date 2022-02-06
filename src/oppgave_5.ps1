#Oppgave_4
param (
    [Parameter()]
    [string]
    $Urlkortstokk = "https://nav-deckofcards.herokuapp.com/shuffle"
)
$ErrorActionPreference = 'Stop'

$response = Invoke-WebRequest -Uri $Urlkortstokk
$cards = $response.Content | ConvertFrom-Json
$kortstokk = @()
#$cards.GetType()
foreach ($card in $cards) {
    $kortstokk = $kortstokk + ($card.suit[0]+$card.value)
}
Write-Host "Kortstokk :$kortstokk"