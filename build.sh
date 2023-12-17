#!/bin/bash

# Set the pack name
packname="Squawkypack"
packwizdownload=false
packwizlocation="https://github.com/Squawkykaka/packwiz/raw/master/Squawkypack-packwiz.zip"

# Process all arguments
for arg in "$@"
do
    case $arg in
        --help|-h)
            echo "Usage: build.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --modlist, -m   Generate a modlist using packwiz-modlist"
            echo "  --download, -d  Download packwiz modpack"
            echo "  --help, -h      Show this message"
            exit 0
            ;;
        --modlist|-m)
            modlist=true
            ;;
        --download|-d)
            packwizdownload=true
            ;;
    esac
done

# Check if packwiz is installed
if ! command -v packwiz &> /dev/null
then
    echo "packwiz is not installed. Please install it and try again."
    exit 1
fi

# Remove old output files
if [ -d "output" ]; then
    echo "Removing old output files..."
    rm -rf "output"
fi

# Check if output directory exists, if not create it
if [ ! -d "output" ]; then
    echo "Creating output directory..."
    mkdir "output"
fi

# Extract the version from the pack.toml file
version=$(grep -oP 'version = "\K[^"]+' pack.toml)

# Export the modpack for Modrinth and CurseForge
echo "Exporting modpack..."
packwiz mr export -o output/${packname}-modrinth.mrpack
packwiz cf export -o output/${packname}-curseforge.zip

# Check for --modlist flag
if [ "$modlist" = true ]; then
    # Check if cargo is installed
    if ! command -v cargo &> /dev/null
    then
        echo "cargo is not installed. Please install it and try again."
        exit 1
    fi
    # Check if packwizml is installed
    if ! command -v packwizml &> /dev/null
    then
        echo "Installing packwiz-modlist..."
        cargo install packwiz-modlist
    fi
    echo "Generating modlist..."
    packwizml --output modlist.md -F
fi

# Download packwiz autoupdate modpack
if [ "$packwizdownload" = true ]; then
    echo "Downloading packwiz modpack..."
    cd output 
    curl -LO $packwizlocation
    cd ..
fi

echo "Done!"