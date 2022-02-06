#Oppgave_5
param (
    [Parameter()]
    [string]
    $Urlkortstokk = "https://nav-deckofcards.herokuapp.com/shuffle"
)
$ErrorActionPreference = 'Stop'

$response = Invoke-WebRequest -Uri $Urlkortstokk
$cards = $response.Content | ConvertFrom-Json

# $sum = 0
# foreach ($card in $cards) {
#     $sum += switch ($card.value){
#         'J' { 10 }
#         'Q' { 10 }
#         'K' { 10 }
#         'A' { 11 }
#         Default { $card.value }
#     }
# }
foreach ($card in $cards) {
    if($card.value -ceq 'J' -or $card.value -ceq 'Q' -or $card.value -ceq 'K'){
        $poengKortstokk = $poengKortstokk + 10
    }
    elseif ( $card.value -ceq 'A') {
        $poengKortstokk = $poengKortstokk + 11
        
    }
}
#Skriver ut Kortstokken
$kortstokk = @()
#$cards.GetType()
foreach ($card in $cards) {
    $kortstokk = $kortstokk + ($card.suit[0]+$card.value)
}
Write-Host "Kortstokk :$kortstokk"
Write-Host "Poengsum : $sum"
