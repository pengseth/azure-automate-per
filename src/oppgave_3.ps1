# Feilhåndtering - stopp programmet hvis det dukker opp noen feil
# Se https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.2#erroractionpreference
$ErrorActionPreference = 'Stop'

$Url ="https://nav-deckofcards.herokuapp.com/shuffle"

$response = Invoke-WebRequest -Uri $Url

$cards = $response.Content | ConvertFrom-Json

$kortstokk = @()
#$cards.GetType()
foreach ($card in $cards) {
    $kortstokk = $kortstokk + ($card.suit[0]+$card.value)
}
Write-Host "Kortstokk :$kortstokk"