#!/bin/bash
# Necessite Domoticz


temperature() {
    # $1: Pièce à Relevé Temp



    local -r order="$(jv_sanitize "$1")"
resultattemp="je mesure,... $1 est de "

    while read device; do
        local sdevice="$(jv_sanitize "$device" ".*")"

	if [[ "$order" =~ .*$sdevice.* ]]; then
            local address="$(echo $Temp_piece | jq -r ".devices[] | select(.name==\"$device\") | .address")"
say "$resultattemp $(curl -s "$relev_Tem_url/json.htm?type=devices&rid=$address" | jq -r '.result[0].Data' | sed "s/C/degrés/g" | sed "s/%/% dhumidité/g")"

       return $?
        fi

    done <<< "$(echo $Temp_piece | jq -r '.devices[].name')"
say "Pas de Temperature demande dans $1"    
jv_error "ERREUR: Pas de Temperature demande dans $1"
    return 1
}