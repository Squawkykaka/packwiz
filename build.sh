#!/bin/bash

# Check if packwiz is installed
if ! command -v packwiz &> /dev/null
then
    echo "packwiz is not installed. Please install it and try again."
    exit
fi

# Set the pack name
packname="Squawkypack"
packwizdownload="true"
packwizlocation="https://github.com/Squawkykaka/packwiz/raw/master/Squawkypack-packwiz.zip"

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
version=$(awk -F' = ' '/^version/ {print $2}' pack.toml)

# Export the modpack for Modrinth and CurseForge
echo "Exporting modpack..."
packwiz mr export -o output/${packname}-modrinth.mrpack
packwiz cf export -o output/${packname}-curseforge.zip

# Download packwiz autoupdate modpack
if [ "$packwizdownload" = "true" ]; then
    echo "Downloading packwiz modpack..."
    cd output 
    curl -LO $packwizlocation
    cd ..
fi

echo "Done!"