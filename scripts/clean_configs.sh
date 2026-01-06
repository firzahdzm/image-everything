#!/bin/bash

# Clean old configs before training
echo "Cleaning old training configs..."

CONFIG_DIR="/dataset/configs"

if [ -d "$CONFIG_DIR" ]; then
    echo "Found config directory: $CONFIG_DIR"
    
    # List configs
    echo "Current configs:"
    ls -lh "$CONFIG_DIR"/*.toml 2>/dev/null || echo "No .toml configs found"
    ls -lh "$CONFIG_DIR"/*.yaml 2>/dev/null || echo "No .yaml configs found"
    
    # Ask for confirmation
    read -p "Delete all configs? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "$CONFIG_DIR"/*.toml
        rm -f "$CONFIG_DIR"/*.yaml
        echo "✅ Configs deleted. New configs will be generated on next training."
    else
        echo "❌ Cancelled."
    fi
else
    echo "Config directory not found: $CONFIG_DIR"
fi
