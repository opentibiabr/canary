"""
Script for processing Lua files in a project.

This script is designed to modify `.lua` files in the root directory of the project and all of its subdirectories.
The following modifications are made to each `.lua` file:
1. Remove empty callback functions.
2. Remove the 'onAppear' callback function entirely, including its corresponding `end`.
3. Clean up unnecessary blank lines resulting from the removal of callback functions.

Usage:
1. Save this script in the `docs/python-scripts` directory of your project.
2. Open a terminal and navigate to the `docs/python-scripts` directory:
   cd path/to/your/project/docs/python-scripts
3. Run the script using Python:
   python convert_monsters_callbacks.py

Prerequisites:
- Ensure Python 3 is installed.
- Make sure you have read and write permissions for all `.lua` files in the project directory.

Output:
- The script will print the root directory being processed.
- At the end, it will output the number of files that were modified.

Example:
Root path: /path/to/your/project
Script completed. Modified 5 file(s).
"""

import re
import os

def get_root_path():
    """Get the root path of the project (two levels above the current script directory)."""
    return os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))

def process_lua_code(code):
    """Process the Lua code: remove specific callbacks and clean up empty lines.

    Args:
        code (str): The Lua code to be processed.

    Returns:
        str: The modified Lua code.
    """
    # Remove specific callbacks including 'onAppear' and empty callbacks
    code = re.sub(r'\n?mType\.onAppear = function\(.*?\)\n(.*?)\nend\n?', '', code, flags=re.DOTALL)
    code = re.sub(r'\n?mType\.\w+ = function\(.*?\) end\n?', '', code)

    # Remove extra blank lines created by the removal of callbacks
    code = re.sub(r'\n{3,}', '\n\n', code)  # Limit multiple blank lines to just two

    return code

def process_lua_file(file_path):
    """Process a single Lua file by applying the required modifications.

    Args:
        file_path (str): The path to the Lua file to be processed.

    Returns:
        bool: True if the file was modified and saved, False otherwise.
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            code = file.read()
    except Exception as e:
        print(f"Error reading file {file_path}: {e}")
        return False

    original_code = code
    modified_code = process_lua_code(code)

    if modified_code != original_code:
        try:
            with open(file_path, 'w', encoding='utf-8') as file:
                file.write(modified_code)
            return True
        except Exception as e:
            print(f"Error writing file {file_path}: {e}")
    return False

def process_all_lua_files(root_path):
    """Process all Lua files in the root path and its subdirectories.

    Args:
        root_path (str): The root directory in which to search for Lua files.

    Returns:
        int: The count of modified Lua files.
    """
    modified_files_count = 0

    for dirpath, _, filenames in os.walk(root_path):
        for filename in filenames:
            if filename.endswith(".lua"):
                file_path = os.path.join(dirpath, filename)
                if process_lua_file(file_path):
                    modified_files_count += 1

    return modified_files_count

def main():
    """Main function to run the script.

    This function determines the root path of the project, processes all Lua files
    found in the root path and subdirectories, and prints the number of files modified.
    """
    root_path = get_root_path()
    print(f"Root path: {root_path}")

    modified_files_count = process_all_lua_files(root_path)
    print(f"Script completed. Modified {modified_files_count} file(s).")

if __name__ == "__main__":
    main()
