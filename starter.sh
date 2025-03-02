#!/bin/bash
##
## @khalidbelk, 2025
## ts-express-starter
## Easily setup a Typescript & Express minimalist server
##

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Check if a command exists in the user's PATH
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Build the server and provide instructions for running it
build_server() {
    if npm run build; then
        echo -e "${GREEN}Server built successfully !${NC}\n"
        echo -e "Access the ${GREEN}project${NC} directory and use one of these commands to run it: \n"
        echo -e "\t Development mode:                           npm run dev"
        echo -e "\t Production mode (compiled):                 npm start\n"
        return 0
    else
        echo -e "${RED}Failed to build the server.${NC}\n"
        return 1
    fi
}

# Check if Node.js is installed
if ! command_exists node; then
    echo -e "${RED}Error: Node.js is not installed. Please install Node.js to continue.${NC}\n"
    exit 1
else
    echo -e "${GREEN}Node is installed. Proceeding to create the project directory...${NC}\n"
fi

# Check if NPM is installed
if ! command_exists npm; then
    echo -e "${RED}Error: npm is not installed. Please install npm to continue.${NC}\n"
    exit 1
fi

# Check if Typescript is installed globally and install if not
if ! command_exists tsc;  then
    echo -e "${RED}TypeScript not found. Installing...${NC}\n"
    npm install -g typescript
fi

# Check if JQ is installed and try to install it if not
if ! command_exists jq;  then
    echo -e "${RED}JQ not found. Trying to install...${NC}\n"
    if command_exists brew; then
        brew install jq
    elif command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y jq
    elif command_exists dnf; then
        sudo dnf install -y jq
    else
        echo -e "${RED}Error: Unable to install jq. Please install it manually and try again.${NC}\n"
        exit 1
    fi
fi

# Verify JQ installation
echo -e "Verifying if JQ is installed...\n"
if command_exists jq; then
    echo -e "${GREEN}JQ found successfully !.${NC}\n"
else
    echo -e "${RED}Error: JQ wasn't found. Please install it manually and try again.${NC}\n"
    exit 1
fi

# Create project
mkdir project && cd project

# Setup node project & Install dependencies
npm init -y && npm i express typescript ts-node body-parser dotenv

# Install dev dependencies
npm i -save-dev typescript ts-node-dev

# Save types
npm i -save-dev @types/express @types/node

# Create needed files inside the project
mkdir src && mv ../static/index.ts src/index.ts && mv ../static/tsconfig.json ./ && mv ../static/gitignore .gitignore

# Update package.json scripts
jq '.scripts = {"start": "node dist/index.js", "dev": "ts-node-dev --respawn --transpile-only src/index.ts", "build": "tsc"}' package.json > temp.json && mv temp.json package.json

# Install project deps & build the server
if npm i; then
    echo -e "\n${GREEN}Project dependencies installed successfully !${NC}\n"
    echo -e "Going to build the server..."
    build_server
else
    echo -e "${RED}Failed to install project dependencies.${NC}"
    exit 1
fi


