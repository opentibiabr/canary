import os

# Path to the directory containing C++ files (.cpp)
directory_path = "path/to/src"

def normalize_include_line(line):
	# Normalize the include line by removing extra spaces and using '/' as separator
	return ' '.join(line.strip().split()).replace('\\', '/')

def correct_include_path(line, correct_include):
	# Check if the include line matches the correct include, regardless of the path
	if line.strip().startswith('#include') and ('"' + correct_include.split('/')[-1] + '"') in line:
		return f'#include "{correct_include}"\n'
	return line

# Function to modify files and correct their own includes
def modify_includes(directory):
	for root, dirs, files in os.walk(directory):
		for filename in files:
			if filename.endswith('.cpp'):
				file_path = os.path.join(root, filename)
				correct_include = f"{os.path.relpath(root, directory).replace('\\', '/')}/{filename.replace('.cpp', '.hpp')}"

				# Remove './' from the beginning of the path, if present
				if correct_include.startswith('./'):
					correct_include = correct_include[2:]

				include_statement = f'#include "{correct_include}"\n'

				with open(file_path, 'r', encoding='utf8') as file:
					lines = file.readlines()

				corrected_lines = []
				include_found = False
				include_renamed = False
				include_at_correct_position = False

				# Normalize lines and correct includes as necessary
				for i, line in enumerate(lines):
					normalized_line = normalize_include_line(line)
					if correct_include in normalized_line:
						# If the correct include was found and is in the correct position
						include_found = True
						if i == next((idx for idx, l in enumerate(lines) if l.strip().startswith('#include')), i):
							include_at_correct_position = True
						if include_at_correct_position:
							corrected_lines.append(line)  # Keep the original include if it is correct and in the right position
					elif filename.replace('.cpp', '.hpp') in normalized_line:
						# Replace any old version of the include with the corrected version
						corrected_lines.append(correct_include_path(line, correct_include))
						include_renamed = True
					else:
						corrected_lines.append(line)

				# If the include was found but not in the correct position, or was renamed, move it to the first include position
				if (include_found and not include_at_correct_position) or include_renamed:
					# Remove any occurrence of the correct include that is out of place
					corrected_lines = [line for line in corrected_lines if line.strip() != include_statement.strip()]
					# Find the first include position and insert the correct include
					first_include_index = next((i for i, line in enumerate(corrected_lines) if line.strip().startswith('#include')), len(corrected_lines))
					corrected_lines.insert(first_include_index, include_statement)
					# Add a blank line immediately after the first include, if necessary
					if first_include_index + 1 < len(corrected_lines) and not corrected_lines[first_include_index + 1].isspace():
						corrected_lines.insert(first_include_index + 1, '\n')

				# Write the changes back to the file only if modifications were made
				if corrected_lines != lines:
					with open(file_path, 'w', encoding='utf8') as file:
						file.writelines(corrected_lines)

# Call the function to modify the files
modify_includes(directory_path)
