#!/usr/bin/env bash

deps=("pip" "python3" "python4")

for d in "${deps[@]}"; do
    if ! command -v "$d" &> /dev/null; then
        echo "missing dependecy: $d"
        exit 1
    fi
done
