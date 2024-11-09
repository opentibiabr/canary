import os
import re
import argparse

# Functions that modify the file

def remove_constructor_and_destructor(content):
    # Remove the class constructor and destructor, including a blank line after the destructor
    pattern = r"explicit\s+\w+\(lua_State\* L\)\s*:\s*LuaScriptInterface\(\"[^\"]+\"\)\s*\{[^\}]*\}\n\s*~\w+\(\)\s*override\s*=\s*default;\n\s*\n?"
    content = re.sub(pattern, "", content, flags=re.DOTALL)
    return content

def remove_include_luascript(content):
    # Remove the specified include and the blank line below it
    pattern = r'#include\s+"lua/scripts/luascript.hpp"\n\n?'
    content = re.sub(pattern, "", content)
    return content

def remove_final_luascriptinterface(content):
    # Remove "final : LuaScriptInterface", "public LuaScriptInterface", "final :", and "LuaScriptInterface" alone
    pattern = r'final\s*:\s*public\s+LuaScriptInterface|public\s+LuaScriptInterface|final\s*:\s*|LuaScriptInterface\s*'
    content = re.sub(pattern, "", content)
    # Remove extra spaces between the class name and the opening block
    content = re.sub(r'class\s+(\w+)\s*\{', r'class \1 {', content)
    return content

def move_init_function_to_cpp(hpp_content, cpp_content, class_name):
    # Extracts the init function from the hpp, keeping the signature
    pattern = r'static void init\(lua_State\* L\)\s*\{[^\}]*\}'
    match = re.search(pattern, hpp_content, flags=re.DOTALL)
    if match:
        # Keep the function signature in the hpp, but remove the body
        init_function_signature = "static void init(lua_State* L);"
        hpp_content = re.sub(pattern, init_function_signature, hpp_content, flags=re.DOTALL)

        # Adjust the function signature for the cpp
        init_function = match.group()
        init_function = re.sub(r'static void\s+', f'void {class_name}::', init_function)
        # Remove extra indentation
        init_function = init_function.replace(' \n\t\t', '\n\t')
        # Remove the extra tab from the function closure
        init_function = init_function.replace('\n\t}', '\n}')

        # Add a blank line before and after the function
        init_function = f"\n{init_function}\n"

        # Add the function to the beginning of the cpp, after the includes
        last_include = re.findall(r'#include\s+<[^>]+>|#include\s+"[^"]+"', cpp_content)
        if last_include:
            last_include_pos = cpp_content.rfind(last_include[-1]) + len(last_include[-1])
            cpp_content = cpp_content[:last_include_pos] + "\n" + init_function + cpp_content[last_include_pos:]
        else:
            cpp_content = init_function + cpp_content
    return hpp_content, cpp_content

def add_include_to_cpp(cpp_content):
    # Add the new include after the last include, if it is not already present
    include_statement = '#include "lua/functions/lua_functions_loader.hpp"'
    if include_statement not in cpp_content:
        # Locate the last include
        last_include = re.findall(r'#include\s+<[^>]+>|#include\s+"[^"]+"', cpp_content)
        if last_include:
            last_include_pos = cpp_content.rfind(last_include[-1]) + len(last_include[-1])
            # Make sure there are not multiple line breaks before the include
            cpp_content = cpp_content[:last_include_pos].rstrip() + "\n" + include_statement + "\n\n" + cpp_content[last_include_pos:].lstrip()
    return cpp_content

def process_files(hpp_file_path, cpp_file_path):
    with open(hpp_file_path, 'r', encoding='utf-8') as hpp_file:
        hpp_content = hpp_file.read()

    with open(cpp_file_path, 'r', encoding='utf-8') as cpp_file:
        cpp_content = cpp_file.read()

    # Get the class name from the hpp file
    class_name_match = re.search(r'class\s+(\w+)', hpp_content)
    class_name = class_name_match.group(1) if class_name_match else None

    if class_name:
        # Apply all modifications
        hpp_content = remove_constructor_and_destructor(hpp_content)
        hpp_content = remove_include_luascript(hpp_content)
        hpp_content = remove_final_luascriptinterface(hpp_content)
        hpp_content, cpp_content = move_init_function_to_cpp(hpp_content, cpp_content, class_name)
        cpp_content = add_include_to_cpp(cpp_content)

        # Save the modified files
        with open(hpp_file_path, 'w', encoding='utf-8') as hpp_file:
            hpp_file.write(hpp_content)

        with open(cpp_file_path, 'w', encoding='utf-8') as cpp_file:
            cpp_file.write(cpp_content)

        print(f'Modifications applied to: {hpp_file_path} and {cpp_file_path}')

def main(directory):
    # Scan the specified folder and find all .hpp and .cpp files
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.hpp'):
                hpp_file_path = os.path.join(root, file)
                cpp_file_path = hpp_file_path.replace('.hpp', '.cpp')
                if os.path.exists(cpp_file_path):
                    process_files(hpp_file_path, cpp_file_path)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Apply modifications to .hpp and .cpp files according to specifications.')
    parser.add_argument('directory', type=str, nargs='?', default='../../src/lua/functions/', help='Path of the directory to be scanned.')
    args = parser.parse_args()

    main(args.directory)

# Functions you want to migrate to static calls
functions_to_convert = [
    "getNumber", 
    "getBoolean", 
    "getString", 
    "getUserdata",
    "getScriptEnv",
    "getCreature",
    "getPlayer",
    "getPosition",
    "getOutfit",
    "getThing",
    "getUserdataShared",
    "getUserdataType",
    "getRawUserDataShared",
    "getErrorDesc",
    "getFormatedLoggerMessage",
    "getField",
    "getFieldString",
    "getVariant",
    "getGuild",
    "isTable",
    "isString",
    "isNumber",
    "isBoolean",
    "isNil",
    "isFunction",
    "isUserdata",
    "reportError",
    "reportErrorFunc",
    "pushInstantSpell",
    "pushVariant",
    "pushOutfit",
    "pushCylinder",
    "pushBoolean",
    "pushString",
    "pushUserdata",
    "pushPosition",
    "setMetatable",
    "setWeakMetatable",
    "setCreatureMetatable",
    "setItemMetatable",
    "setField",
    "registerVariable",
    "registerGlobalMethod",
    "registerGlobalVariable",
    "registerGlobalBoolean",
    "registerMethod",
    "registerClass",
    "registerTable",
    "registerSharedClass",
    "registerMetaMethod",
]

# Files you want to exclude from scanning (relative paths)
files_to_exclude = [
    os.path.normpath("lua_functions_loader.cpp"),
    os.path.normpath("lua_functions_loader.hpp")
]

def convert_to_static(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    original_content = content  # Keep the original content to check for changes

    for function in functions_to_convert:
        # Regex to capture function calls and replace them with Lua::function
        # Skip calls that are part of g_configManager() and handle both regular and template functions
        pattern = r'(?<!\w)(?<!g_configManager\(\)\.)' + re.escape(function) + r'(<.*?>)?\('
        replacement = rf'Lua::{function}\1('
        content = re.sub(pattern, replacement, content)

    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(content)
        print(f'File converted: {file_path}')
    else:
        print(f'No changes made to file: {file_path}')

def main(directory):
    # Scan the specified folder and find all .cpp and .hpp files
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(('.cpp', '.hpp')):
                file_path = os.path.normpath(os.path.join(root, file))
                
                # Check if the file is in the exclusion list
                if any(os.path.basename(file_path) == exclude_file for exclude_file in files_to_exclude):
                    print(f'File ignored: {file_path}')
                    continue  # Skip the specified files

                convert_to_static(file_path)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Convert functions to static calls.')
    parser.add_argument('directory', type=str, nargs='?', default='../../src/lua/functions/', help='Path of the directory to be scanned.')

    main(args.directory)
