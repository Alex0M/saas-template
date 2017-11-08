#!/bin/bash

echo "[+] Building ..."

echo " | [+] Static ..."
pushd static
npm i
npm run build
popd
echo " | [-] Static"

echo " | [+] Service ..."
pushd service
mvn clean install
popd
echo " | [-] Service"

echo "[-] Building"
