#!/bin/bash

urls=(
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts"
    "https://hosts.oisd.nl/"
)

touch hosts

for url in "${urls[@]}"; do
    wget "${url}" -O temp
    cat temp >> hosts
    rm temp
done

grep -o '^[^#]*' hosts | sponge hosts
sed -i 's/  //g' hosts
sed -i 's/\t//g' hosts
sed -i '/^[[:blank:]]*$/ d' hosts
sort hosts | uniq | sponge hosts
