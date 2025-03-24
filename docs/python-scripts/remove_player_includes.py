import os
import re
import argparse

# List of includes to remove
includes_to_remove = [
    '#include "creatures/players/wheel/player_wheel.hpp"',
    '#include "creatures/players/vip/player_vip.hpp"',
    '#include "creatures/players/achievement/player_achievement.hpp"',
    '#include "creatures/players/cyclopedia/player_badge.hpp"',
    '#include "creatures/players/cyclopedia/player_cyclopedia.hpp"',
    '#include "creatures/players/cyclopedia/player_title.hpp"',
    '#include "creatures/players/wheel/wheel_gems.hpp"',
]

# List of method calls to update from '->' to '.'
methods_to_update = [
    'wheel',
    'vip',
    'achiev',
    'badge',
    'title',
    'cyclopedia'
    'm_wheelPlayer'
]

def remove_includes(content):
    for include in includes_to_remove:
        # Remove the specific include statement
        include_pattern = r'^' + re.escape(include) + r'\s*\n'
        content = re.sub(include_pattern, '', content, flags=re.MULTILINE)

        # Remove only the blank lines below the removed include
        content = re.sub(r'(' + re.escape(include) + r'\s*\n)\n+', r'\1', content)
    
    return content

def update_method_calls(content):
    for method in methods_to_update:
        # Replace 'method()->' with 'method().' for each method in the list
        pattern = rf'\b{method}\(\)->'
        replacement = f'{method}().'
        content = re.sub(pattern, replacement, content)
    
    return content

def process_files(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # Apply the include removal
    modified_content = remove_includes(content)

    # Apply the method call update
    modified_content = update_method_calls(modified_content)

    # Save the modified file if changes were made
    if content != modified_content:
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(modified_content)
        print(f'Modifications applied to: {file_path}')
    else:
        print(f'No modifications needed for: {file_path}')

def main(directory):
    # Traverse the specified folder and find all .hpp and .cpp files
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(('.cpp', '.hpp')):
                file_path = os.path.join(root, file)
                process_files(file_path)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Remove specific includes and update method calls in .cpp and .hpp files.')
    parser.add_argument('directory', type=str, nargs='?', default='../../src/', help='Path of the directory to be scanned.')
    args = parser.parse_args()

    main(args.directory)
