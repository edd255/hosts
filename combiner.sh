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

wget https://raw.githubusercontent.com/libreddit/libreddit-instances/master/instances.json
jq ".instances | .[] | .url" instances.json >> temp
sed -i 's/"//g' temp
sed -i 's/null//g' temp
sed -i 's/  //g' temp
sed -i 's/\t//g' temp
sed -i "s/https:\/\///g" temp
sed -i "s/\///g" temp
sed -i '/^[[:blank:]]*$/ d' temp
sed -i 's/^/0\.0\.0\.0 /' temp
cat temp >> hosts
rm instances.json
rm temp

wget https://codeberg.org/teddit/teddit/raw/branch/main/instances.json
jq ".[] | .url" instances.json >> temp
sed -i 's/"//g' temp
sed -i 's/null//g' temp
sed -i 's/  //g' temp
sed -i 's/\t//g' temp
sed -i "s/https:\/\///g" temp
sed -i "s/\///g" temp
sed -i '/^[[:blank:]]*$/ d' temp
sed -i 's/^/0\.0\.0\.0 /' temp
cat temp >> hosts
rm instances.json
rm temp
