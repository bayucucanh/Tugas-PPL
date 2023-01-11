#!/bin/bash


function buildiOSArchiveFlutter() {
    flutter build ipa --release --flavor prod -t lib/main_prod.dart --obfuscate --split-debug-info=build/app/debug-symbols
}

function createIPAWithProvisioning() {
    xcodebuild -exportArchive -exportOptionsPlist ios/exportAppStore.plist -archivePath build/ios/archive/Runner.xcarchive -exportPath "ios/distribution/prod" -allowProvisioningUpdates
}

function buildWebStaging() {
    flutter build web -t lib/main_staging.dart --web-renderer canvaskit
}

function buildWebProd() {
    flutter build web -t lib/main_prod.dart --web-renderer canvaskit
}

function uploadToAppStore() {
    echo "Checking Path IPA"
    pathFile="ios/distribution/prod/"
    pathFile+=\*.ipa
    echo "IPA PATH FILE : $pathFile"

    echo "Uploading to AppStore"
    xcrun altool --upload-app -f $pathFile --type ios -u apps@kunci.co.id -p ulmb-dbxn-yvvs-laar --verbose
}

function build_ios() {
    echo "Building IOS Archive"
    if buildiOSArchiveFlutter; then
        echo "Creating IPA File"
        if createIPAWithProvisioning; then
            if uploadToAppStore; then
                echo "Upload File IPA to AppStore Success"
                exit 1
            else
                echo "Failed uploading IPA to AppStore"
                exit 1
            fi
        else
            echo "Failed creating IPA using xcodebuild"
            exit 1
        fi
    else
        echo "Failed to creating archive via flutter"
        exit 1
    fi
}

function build_apk() {
    flutter build apk --release --flavor prod -t lib/main_prod.dart --obfuscate --split-debug-info=build/app/debug-symbols
}

function build_apk_staging() {
    flutter build apk --release --flavor staging -t lib/main_staging.dart --obfuscate --split-debug-info=build/app/debug-symbols
}

function build_appbundle() {
    flutter build appbundle --release --flavor prod -t lib/main_prod.dart --obfuscate --split-debug-info=build/app/debug-symbols
}

function flutter_upgrade() {
    flutter upgrade
}

Help()
{
    echo "    _____ _    _   _ _____ _____ _____ ____  "
    echo "|  ___| |  | | | |_   _|_   _| ____|  _ \ "
    echo "| |_  | |  | | | | | |   | | |  _| | |_) |"
    echo "|  _| | |__| |_| | | |   | | | |___|  _ < "
    echo '|_|   |_____\___/  |_|   |_| |_____|_| \_\'
    echo
    echo
    # Display Help
    echo "To build this project what you need is only enter a number what displayed below :"
    echo
    echo "1) Build apk"
    echo "2) Build apk staging"
    echo "3) Build app bundle"
    echo "4) Build IPA Archive & Upload to AppStore"
    echo "5) Build Web Production"
    echo "6) Build Web Staging"
    echo "7) Upgrading flutter to latest version"
    echo "8) Help Information"
    echo "9) Exiting the program"
    echo
}

echo "    _____ _    _   _ _____ _____ _____ ____  "
echo "|  ___| |  | | | |_   _|_   _| ____|  _ \ "
echo "| |_  | |  | | | | | |   | | |  _| | |_) |"
echo "|  _| | |__| |_| | | |   | | | |___|  _ < "
echo '|_|   |_____\___/  |_|   |_| |_____|_| \_\'
echo
echo

select build in apk apk_staging appbundle ios web web_staging upgrade_flutter help quit; do
    echo "Select from this option to build an app : "
    case $build in
    apk)
    build_apk;
    ;;
    apk_staging)
    build_apk_staging;
    ;;
    appbundle)
    build_appbundle;
    ;;
    ios)
    build_ios;
    ;;
    web)
    buildWebProd;
    ;;
    web_staging)
    buildWebStaging;
    ;;
    upgrade_flutter)
    flutter_upgrade;
    ;;
    help)
    Help;
    ;;
    quit)
    echo "Thank you"
    exit 1
    esac
done