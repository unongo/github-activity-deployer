#!/bin/bash

# Check if parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <parameter> that represent part of github filename"
    exit 1
fi

# Switch github user
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa_${1}

# Update codebase
git fetch origin master
git reset --hard origin/master


# Generate a random name for the file
name=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

# Create the filename with the provided parameter
filename="results/${name}_${1}.txt"

# Generate the hash
hash=$(sha256sum <<< "$filename" | awk '{print $1}')

# Create the file and write the hash inside
echo "$hash" > "$filename"
echo "File created: $filename"

# Add the file to the repository
git add .

# Commit the changes
git commit -m "Add file $filename"

# Push the changes to GitHub
git push origin master