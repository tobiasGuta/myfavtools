#!/bin/bash

# Install Nuclei using Go
echo "Installing Nuclei..."
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Clone the DirSearch repository
echo "Cloning DirSearch repository..."
git clone https://github.com/maurosoria/dirsearch.git --depth 1
