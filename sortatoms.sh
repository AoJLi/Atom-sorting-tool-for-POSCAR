#!/bin/bash

# Author: Aojie Li @ Lehigh University  10/03/2024

input_file="POSCAR"
output_file="POSCAR_sorted"

# Read the first 5 lines (to be mostly preserved)
head -n 5 "$input_file" > "$output_file"

# Extract the atom types and numbers
atom_types=($(sed -n '6p' "$input_file"))
atom_numbers=($(sed -n '7p' "$input_file"))

# Extract the lines from 10th line onward (coordinates and selective dynamics tags)
coordinates_and_tags=$(sed -n '10,$p' "$input_file")

# Create a dictionary for atom types and coordinates+tags
declare -A atom_dict
declare -A atom_count_dict
counter=1

# Separate coordinates and tags by atom type
for i in "${!atom_types[@]}"; do
    atom="${atom_types[i]}"
    count="${atom_numbers[i]}"

    # Add count to dictionary
    if [[ -z "${atom_count_dict[$atom]}" ]]; then
        atom_count_dict["$atom"]=$count
    else
        atom_count_dict["$atom"]=$(( atom_count_dict["$atom"] + count ))
    fi

    for ((j=0; j<count; j++)); do
        coord_line=$(echo "$coordinates_and_tags" | sed -n "${counter}p")
        atom_dict["$atom"]+="$coord_line"$'\n'
        ((counter++))
    done
done

# Sort atom types to group same types together
sorted_types=("Cu" "C" "O" "H")
declare -A sorted_atom_numbers

# Prepare new lines for atom types and numbers
new_atom_types=()
new_atom_numbers=()

for atom in "${sorted_types[@]}"; do
    # Get the count of atoms for the current type from atom_count_dict
    sorted_atom_numbers["$atom"]="${atom_count_dict["$atom"]}"
    new_atom_types+=("$atom")
    new_atom_numbers+=("${atom_count_dict["$atom"]}")
done

# Replace atom types and numbers in the output file
echo "${new_atom_types[@]}" | sed 's/ /   /g' >> "$output_file"
echo "${new_atom_numbers[@]}" | sed 's/ /   /g' >> "$output_file"

# Append the selective dynamics and cartesian lines (8th and 9th lines)
sed -n '8,9p' "$input_file" >> "$output_file"

# Append the sorted coordinates and tags to the output file
for atom in "${sorted_types[@]}"; do
    echo "${atom_dict["$atom"]}" | sed '/^$/d' >> "$output_file"
done

# Edit the title line
sed -i '1s/.*/Pd   C   O   H/' "$output_file"

echo "Reordering complete. Output saved in $output_file"
