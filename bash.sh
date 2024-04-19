#!/bin/bash

# Directory to start searching from
root_dir="C:\Users\samue\Documents"

# Search for directories containing "VSDS" in their name and then search for .py files in them
find "$root_dir" -type d -name "*nieuw*" -exec sh -c '
  for dir do
    find "$dir" -type f -name "*.py"
  done
' sh {} +
