$Url ="https://nav-deckofcards.herokuapp.com/shuffle"
$response = Invoke-WebRequest -Uri $Url
$cards = $response.Content | ConvertFrom-Json
$kortstokk = @()
#$cards.GetType()
foreach ($card in $cards) {
    $kortstokk = $kortstokk + ($card.suit[0]+$card.value)
}
Write-Host "Kortstokk :$kortstokk"