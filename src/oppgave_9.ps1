#Oppgave_9
# Ver.1.0
[CmdletBinding()]
param (
    [Parameter()]
    [string]
#    $Urlkortstokk = "https://nav-deckofcards.herokuapp.com/shuffle"
#    $Urlkortstokk = 'https://azure-gvs-test-cases.azurewebsites.net/api/vinnermeg'
#    $Urlkortstokk = 'https://azure-gvs-test-cases.azurewebsites.net/api/vinnermagnus'
     $Urlkortstokk = 'https://azure-gvs-test-cases.azurewebsites.net/api/tapermagnus'   
#    $Urlkortstokk = 'https://azure-gvs-test-cases.azurewebsites.net/api/vinnerdraw' 
 )
#Stopp ved feil
$ErrorActionPreference = 'SilentlyContinue'
#$ErrorActionPreference = [System.Management.Automations.ActionPreference]::SilentlyContinue

$webRequest = Invoke-WebRequest -Uri $Urlkortstokk
$kortstokk = $webRequest.Content | ConvertFrom-Json

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

function kortstokkTilStreng {
    [OutputType([string])]
    param (
        [Object[]]
        $kortstokk
    )
    $streng = ''
    foreach ($kort in $kortstokk) {
        $streng = $streng + "$($kort.suit[0])" + "$($kort.value)"
        if ($kort -ne $kortstokk[-1]) {
            $streng += ","
        }
    } 
    return $streng
}

Write-Output "Kortstokk: $(kortstokkTilStreng -kortstokk $kortstokk)"

function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [Object[]]
        $kortstokk
    )
    $poengKortstokk = 0

foreach ($kort in $kortstokk) {
    $poengKortstokk += switch ($kort.value) {
        { $_ -cin @('J', 'Q', 'K') } { 10 }
        'A' { 11 }
        default { $kort.value }
    }
 }
    return $poengKortstokk
}

Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"

#################

$meg =  $kortstokk[0..1]
Write-Output "meg: $(kortstokkTilStreng -kortstokk $meg)"

$kortstokk = $kortstokk[2..$kortstokk.Count]

$magnus =  $kortstokk[0..1]
Write-Output "magnus: $(kortstokkTilStreng -kortstokk $magnus)"

$kortstokk = $kortstokk[2..$kortstokk.Count]
Write-Output "Kortstokk: $(kortstokkTilStreng - kortstokk $kortstokk)"

function skrivUtResultat {
    param (
        [String]
        $vinner,
        [object[]]
        $kortstokkmagnus,
        [object[]]
        $kortstokkmeg
        )
# Her benyttes "Write-Output" som returnerer en streng
    Write-Output "Vinner: $vinner"
    Write-Output "magnus | $(sumpoengkortstokk -kortstokk $kortstokkmagnus) | $(kortstokktilstreng -kortstokk 
    $kortstokkmagnus)"
    Write-Output "meg    | $(sumpoengkortstokk -kortstokk $kortstokkmeg) | $(kortstokktilstreng -kortstokk 
    $kortstokkmeg)"
}
# Blackjack verdi er 21
$blackjack = 21

if (((sumpoengkortstokk -kortstokk $meg) -eq $blackjack) -and ((sumpoengkortstokk -kortstokk $magnus) -eq $blackjack)) {
    skrivUtResultat -vinner "draw" -kortstokkmagnus $magnus -kortstokkmeg $meg
}
if ((sumpoengkortstokk -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortstokkmagnus $magnus -kortstokkmeg $meg
    exit
}
elseif ((sumpoengkortstokk -kortstokk $magnus) -eq $blackjack) {
   skrivUtResultat -vinner "magnus" -kortstokkmagnus $magnus -kortstokkmeg $meg
   exit
}

while ((sumpoengkortstokk -kortstokk $meg) -lt 17) {
    $meg += $kortstokk[0]
    $kortstokk = $kortstokk[1..$kortstokk.Count]
}

if ((sumpoengkortstokk -kortstokk $meg) -gt $blackjack) {
    skrivUtResultat -vinner $magnus -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}
# Start Oppgave 9
while ((sumPoengKortstokk -kortstokk $magnus) -le (sumPoengKortstokk -kortstokk $meg)) {
    $magnus += $kortstokk[0]
    $kortstokk = $kortstokk[1..$kortstokk.count]
}

# Magnus taper spillet hvis poengsummen er høyere enn 21
if ((sumPoengKortstokk -kortstokk $magnus) -gt $blackjack) {
    skrivUtResultat -vinner "meg" -kortStokkMagnus $magnus -kortStokkMeg $meg
    exit
}