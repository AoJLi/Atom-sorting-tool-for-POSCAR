# Atom-sorting-tool-for-POSCAR
This is an atomic order sorting tool for POSCAR (which is an input file that stores the atom coordinate in VASP). 

Why do we need this tool?   
1, When we edit POSCAR file in VASP for DFT calculation, sometimes for convenience, we'll directly add new atoms in GUI (for example, ASE GUI), but the atoms that are newly added will not be merged into exsiting atoms coordinate in POSCAR, they will dangle at the end of the list. However, to succefully run a DFT job in VASP, we need to make sure the atom order in POSCAR and POTCAR are the same, and usually the atom order in POTCAR file are fixed. Therefore, we need a script to fix the atom order in POSCAR after we adding new atoms.   
2, Since most of the DFT calculations are performed in linux system, I wrote this scipt in bash for convenience.   
  
How this script works?   
1, It will use "POSCAR" as input file, sort the atom order with thier coordinate, and generate the new "POSCAR_sorted" file as output file.  
2, It will preserve the "F" or "T" tags after the each atom's coordinate.   
3, It will only change the title (line 1), atom order (line 6), atom number (line 7), and atom coordinate (everything after line 9), all the other lines will be preserved as original POSCAR file.   
  
How to use this bash script?   
1, Put "sortatoms.sh" in the same directory with the POSCAR you need to change.  
2, Modify the variable "sorted_types" based on your own system, for example, for my system, it's "sorted_types=("Cu" "C" "O" "H") ", also change the title line at the end of the file.   
3, run "chmod u+x sortatoms.sh" in command line to make it executable.   
4, run the script using "./sortatoms.sh".  
  
   
Author: Aojie Li @ Lehigh University
