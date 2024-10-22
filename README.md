# Project 1: MD Simulations of RNA Acridine:G-quadruplexes

Note: You are strongly encouraged to work together.  However, each person is responsible for producing and submitting their own work.

Overview: Overview: We will perform CHARMM MD simulations with NAMD of a RNA G-quadruplex with a docked acridine molecule in explicit solvent on the DEAC cluster. Will it stay there? If so, how does it affect the RNA G-quadruplex?

## Part 3. MD simulations of the RNA G-quadruplexes with Docked Acridines

Website References: [ NAMD Tutorial ](http://www.ks.uiuc.edu/Training/Tutorials/namd/namd-tutorial-unix-html/index.html)

We have discussed in class that molecular docking algorithms are by nature a low resolution approach to determine how ligands binds to a receptor. There are a number of significant issues with the approach, but it is typically a good first step that will lead to false positives and false negatives. We will refine the molecular docking prediction with MD simulations to support (or contradict). Much of these instructions (Steps 1-13) are nearly identical to the ones from Project 1, Part 2, so be sure to pay attention to the subtle differences.

Instructions:

1. Open the Terminal program and log into the DEAC cluster.
2. 2. Change directory to your project directory (see Part 0, Part 1):
   ```
   cd /deac/phy/classes/phy620/[username]
   ```
   where [username] should be replaced by your username.

3. Clone this repository by using the following command (See Part 0, Part 4):
  ```
  git clone [repository url]
  ```
 This repository has a subdirectory called __ANO__ and you will perform MD simulations of a G-quadruplex with a docked acridine molecule there. In the directory are three subdirectories: 1) input_data, 2) setup, and 3) simulations. The key difference between this repository and the one for the previous project is that there are now files for the acridine molecule and for analyzing the trajectories:

   | File | Description |
  | --- | --- |
  | input_data/45S.pdb | PDB file containing the coordinates of a G-quadruplex. |
  | input_data/k.pdb | PDB file containing the coordinates of potassium ions in the G-quadruplex. |
  | **input_data/ANO.pdb** | **PDB file containing the coordinates of acridine ligand.** |
  | setup/top_all36_prot_na.rtf | CHARMM force field topology file for proteins and nucleic acids |
  | **setup/top_all36_cgenff.rtf** | **CHARMM force field topology file for small molecules (needed for acridines)** |
  | setup/setup.pgn | VMD script to convert the 45S.pdb and k.pdb file into a format that can be readily used by NAMD. |
  | setup/solvate.pgn | VMD script to add a water box and NaCl ions. |
  | setup/Klean.sh | A “reset” script. If you get in trouble and you need to start over, run this script. It should get you back to the beginning (I think, I hope, knock on wood). |
  | simulations/par_all36_prot_na.prm | CHARMM force field parameter file for proteins and nucleic acids |
  | **simulations/par_all36_cgenff.prm** | **CHARMM force field parameter file for small molecules (needed for acridines)** |
  | **simulations/ANO.str** | **CHARMM force field parameter file for the acridine** |
  | simulations/equil_1e.conf | NAMD configuration file for running the “equilibration” portion of the MD simulation. |
  | simulations/dyna.temp | NAMD configuration file template for running the “production run” portion of the MD simulation. |
  | simulations/gen_scripts.sh | Script to generate NAMD configuration files during production run. |
  | simulations/md.slurm | SLURM script for running MD simulation on the cluster. |
  | **simulations/catdcd** | **A program that takes several dcd trajectory files and concatenates them into a single dcd trajectory file.** |
  | **simulations/dist.tcl** | **VMD script to calculate the base-to-base center of mass distances in a trajectory.** |
  | **simulations/dihe.tcl** | **VMD script to calculate the torsional angles defined by tetrad guanine bases in a trajectory.** |

  To ensure that you have generated the file correctly, I strongly suggest that you use VMD to visualize the 45S.pdb, k.pdb, and ANO.pdb files. It should look something like this (Well, sort of. I did take some minor artistic liberties by changing the representations of the acridine and ions):
  
  ![image](https://github.com/user-attachments/assets/812bce22-8bbc-4e23-b956-52149dcf3dd7)

  
4. Copy the 45S.pdb, k.pdb, and ANO.pdb files to the “setup” subdirectory.

5. Next we will use the VMD script setup.pgn to convert the 45S.pdb, k.pdb, and ANO.pdb files into a set of NAMD-style files that it is used to handling. 

Just as before, this is a generic script for any biomolecule. You will need to modify it using the VS Code program. 

a) Open “setup.pgn” using __nano__.
b) Replace all instances of “[ID]” (including brackets!) with “45S”.

Note: The only difference between this file and the previous file you used is that there are new commands for using ANO.pdb. Otherwise, this file is the same as before since we are otherwise doing the same thing.

After you’re done, save your changes and exit out of the program

6. Run the VMD script using the following command:
```
module load apps/vmd/1.9.4a57
vmd -dispdev text -e setup.pgn
```

7. Next we will use the VMD script solvate.pgn file to add a water box and sodium and chloride ions to our G-quadruplex with acridine. Again, this is a generic script for any biomolecule. You will need to modify it using the __nano__ program. 

  a. Open “solvate.pgn” using __nano__. 
  
  b. Replace all instances of “[ID]” with “45S”.

After you’re done, save your changes and exit out of the program

Run the VMD script using the following command:
```
vmd -dispdev text -e solvate.pgn
```

Copy the 45S_wbi.psf and 45S_wbi.pdb files to the “simulations” subdirectory.

8. Use __nano__ to open up the 45S_wbi.pdb file. On the first line, first column is “CRYST1”. The next three sets of numbers are the x-, y-, and z-dimensions of the water box. Save the water box dimensions. Exit out of the program.

9. Next we will use the NAMD configuration file equil_1e.conf file to read in the G-quadruplex + water box + ions and run 50 ps equilibration by raising the temperature from 0 K to 298 K. We will be using periodic boundary conditions and various cutoff methods we discussed in class. Again, this is a generic script for any biomolecule. You will need to modify it using the __nano__ program. 

  a. Open “equil_1e.conf” using __nano__. 
  
  b. Replace all instances of “[ID]” with “45S”.
  
  c. Replace the instances of [XPBC], [YPBC], and [ZPBC] with the x-, y-, and z-dimensions of the water box (to the tenth place precision) from Step 8.

10. Next we will use the NAMD configuration file template file dyna.temp to read in the MD simulation state from the previous step and continue for 1 ns. Again, this is a generic script for any biomolecule. You will need to modify it using the VS Code program.

  a. Open “dyna.temp” using __nano__. 
  
  b. Replace all instances of “[ID]” with “45S”.

After you’re done, save your changes and exit out of the program

11. Next we will set up 10 ns of MD simulations of 1 ns parts using the dyna.temp file. Type the following command:

```
for ((i=2; i<=11; i++)); do ./gen_scripts.sh $i; done
```

This is a nifty little program that I wrote that will write NAMD configuration file for doing the 1st nanosecond of MD simulation and then the 2nd nanosecond and so forth until the end.

12. Next we will set up the SLURM script for running MD simulations on the cluster. Again, this is a generic script for any biomolecule. You will need to modify it using the VS Code program..

  a. Open “md.slurm” using __nano__. 
  
  b. Replace all instances of “[username]” with your username and [ID] with “45S”.

After you’re done, save your changes and exit out of the program.

13. In steps 9-12, we set up the equilibration and production run portions of the MD simulation and even the SLURM script to request computers from the DEAC cluster to run it, but we did not actually run it. (No, we have not been using the full power of the DEAC cluster yet.) We will be using the SLURM queuing system.

How to use the SLURM queuing system:
Three main commands:
  1.	sbatch -> submit to the queue.
  2.	squeue -> check the status of the queue.
  3.	scancel -> cancel a submission to the queue.

To submit your md.slurm script to the DEAC cluster, type “sbatch md.slurm”. The check on whether everything is okay, type “squeue –u [username]” where [username] is your username. If it is running, your job will show up as below. 

![image](https://github.com/user-attachments/assets/cc67b75d-21c1-43d3-b1f8-3554b7d94063)

In the “ST” column, an “R” indicates that it is currently running and a “PD” indicates that it is waiting (or pending) in the queue.

I strongly recommend that you periodically “baby-sit” your MD simulation until it is finished.  Note: This should take at least 24 hours, but no longer than two days. Wait patiently until your simulations are finished. If something seems wrong, contact me.

14. In each of your directories, you have now generated 10 ns MD simulation trajectories that have been separated into individual 1 ns trajectories. First, we will concatenated them using the following command (note: the brackets are real brackets and not something that you be replaced):

```
catdcd -o 45S_wbi.dcd 45S_wbi_[2-9]e.dcd 45S_wbi_1[01]e.dcd
```

A new file will be generated that contains a single concatenated dcd trajectory file named 45S_wbi.dcd.

15. We will monitor the trajectories using two geometric measures: 1) the base-to-base center of mass distances (dist.tcl) and 2) the torsional angle defined by tetrad guanine bases (dihe.tcl):

![image](https://github.com/user-attachments/assets/953b96e6-a587-47f3-9639-d7ba2b86fb3c) ![image](https://github.com/user-attachments/assets/df3b5b46-3e49-4188-b2b2-2d867531efa5)

There exists two sets of tetrads in each of the RNA G-quadruplexes you simulated. Using VMD, you will identify the residue number of each guanine that is in a tetrad. Use the Label feature in VMD and select the four guanines. 

![image](https://github.com/user-attachments/assets/f29af900-1e5f-4018-b0ad-a641c81fdfce) ![image](https://github.com/user-attachments/assets/b0395708-675b-4726-9193-d3b59c01e598)

Repeat the same exercise for both tetrads and make a note of their relative locations. In particular, you will need to know the numbering of guanines that are on opposite sides (in the above example, #3 and #15 are opposites as are #11 and #24) and the order of the tetrads (#3, #11, #15, and #24).

16. Use __nano__ to open dist.tcl. In the file:
a) Replace all instances of “[ID]” (including brackets!) with “45S”.
b) On lines 12-46, there are instances of “[RESID1]” and “[RESID2]” with the pairs of guanines that are on opposite sides of a tetrad. There are six pairs that you will have to replace. Use the guanine numbering that you obtained from Step 16 to replace them.  

After you’re done, save your changes and exit out of the program.

Run the VMD script using the following command (it will take about 2 minutes for it to complete):
```
vmd -dispdev text -e dist.tcl
```

If you set up and ran the dist.tcl file correctly, there will be a new file that results: dist.dat. In the file, the first column is time (in units of picoseconds) and the next 6 columns correspond to the individual base-to-base distances for the pairs of guanines you identified in Step 16.

17. Use Excel or some other graphing program to graph the dist.dat file. I am assuming that you are familiar with graphing programs, but let me know if you run into any difficulties with this step.

18. Use __nano__ to open dihe.tcl. In the file:
a) Replace all instances of “[ID]” (including brackets!) with “45S”.
b) On lines 12-46, there are instances of “[RESID1]”, “[RESID2]”, “[RESID3]”, and “[RESID4]” with the four guanines that are in a tetrad. There are two sets that you will have to replace. Use the guanine numbering that you obtained from Step 16 to replace them.  

After you’re done, save your changes and exit out of the program.

Run the VMD script using the following command (it will take about 2 minutes for it to complete):
```
vmd -dispdev text -e dihe.tcl
```

If you set up and ran the dihe.tcl file correctly, there will be a new file that results: dihe.dat. In the file, the first column is time (in units of picoseconds) and the next 3 columns correspond to the individual torsional angles for the tetrads you identified.

__You will turn in images of 2 graphs corresponding to the base-to-base distances and torsional angles.__
