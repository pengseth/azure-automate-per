#Oppgave_7
# Ver.1.0
[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $Urlkortstokk = "https://nav-deckofcards.herokuapp.com/shuffle"
)
#Stopp ved feil
#$ErrorActionPreference = 'Stop'
$ErrorActionPreference = 'SilentlyContinue'
#try {
    $webRequest = Invoke-WebRequest -Uri $Urlkortstokk
    $kortstokk = $webRequest.Content 
    $kortstokk = ConvertFrom-Json -InputObject $kortstokkJson
#    }
#catch {
#    Write-Host "Fant ingen kort på "$Urlkortstokk
#    Break
#}
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
    if($kort.value -eq 'J' -or $kort.value -eq 'Q' -or $kort.value -eq 'K'){
        $poengKortstokk = $poengKortstokk + 10
    }
    elseif ( $kort.value -eq 'A') {
        $poengKortstokk = $poengKortstokk + 11
        
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

############################################################################## PAE Sjekk Her
#Skriver ut Kortstokken
#function  kortstokkprint {
 #   param (
 #   [Parameter()]
 #   [Object[]]
 #       $kortstokk
 #   )
#  $kortstokk = @()
#$cards.GetType()
#foreach ($kort in $kortstokk) {
#    $kortstokk = $kortstokk + ($kort.suit[0]+$kort.value)
#}
#    $kortstokk
#}
#$kortstokk = @()
#$cards.GetType()
#foreach ($kort in $kortstokk) {
#    $kortstokk = $kortstokk + ($kort.suit[0]+$kort.value)
#}
#Write-Host "Kortstokk :$(kortstokkprint($kortstokk))"
#Write-Host "Poengsum : $sum"
#
#$meg =  $kortstokk[0..1]
#$kortstokk = $kortstokk[2..$kortstokk.Length]
#
#$magnus = $kortstokk[0..1]
#$kortstokk = $kortstokk[2..$kortstokk.Length]
#
#Write-Host "meg: $(kortstokkprint($meg))"
#Write-Host "magnus: $(kortstokkprint($magnus))"
#Write-Host "kortstokk: $(kortstokkprint($kortstokk))"
#
# Ferdig oppgave 6
# Start oppgave 7
function skrivUtResultat {
    param (
        [String]
        $vinner,
        [object[]]
        $kortstokkmagnus,
        [object[]]
        $kortstokkmeg
        )
    Write-Output "Vinner: $vinner"
    Write-Output "magnus |$(sumpoengkortstokk -kortstokk $kortstokkmagnus) | $(kortstokktilstreng -kortstokk $kortstokkmagnus)"
    Write-Output "meg |$(sumpoengkortstokk -kortstokk -kortstokkmeg) |  $(kortstokktilstreng -kortstokk $kortstokkmeg)"
}
#Blackjack verdi er 21
$blackjack = 21

if (((sumpoengkortstokk -kortstokk $meg) -eq $blackjack) -and ((sumpoengkortstokk -kortstokk $magnus) -eq $blackjack)) {
    skrivUtResultat -vinner "draw" -kortstokkmagnus $magnus -kortstokkmeg $meg
}
elseif ((sumpoengkortokk -kortstokk $meg) -eq $blackjack) {
    skrivUtResultat -vinner "meg" -kortstokkmagnus $magnus -kortstokkmeg $meg
    Exit
}
elseif ((sumpoengkortokk -kortstokk $magnus) -eq $blackjack) {
   skrivUtResultat -vinner "magnus" -kortstokkmagnus $magnus -kortstokkmeg $meg
   Exit
}
