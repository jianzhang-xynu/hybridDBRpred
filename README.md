<<<<<<< HEAD
<<<<<<< HEAD
# hybridDBRpred

HybridDBRpred is designed for accurate prediction of DNA-binding residues from both structure-annotated and disorder-annotated proteins.

The web server is deployed at http://biomine.cs.vcu.edu/servers/hybridDBRpred/ 

The source code is available at https://github.com/jianzhang-xynu/hybridDBRpred

# Install 

## Required predictions from other web servers

* DNAgenie web server
http://biomine.cs.vcu.edu/servers/DNAgeine/

DNAgenie produces result with CSV format and names it as 'results.csv'.

* DNAPred web server
http://202.119.84.36:3079/dnapred/

DNAPred produces result with CSV format and names it as 'result.txt'.

* disoRDPbind web server
http://biomine.cs.vcu.edu/servers/DisoRDPbind/

disoRDPbind produces result with text format and names it as 'results.txt'.

## Required third-part softwares

* ASAquick
Fast neural network-based predictor of solvent accessibility

http://mamiris.com/services.html

- Modify line 12 of 'serverScript/1_genRSA.pl'  

  ```
  system "/home/ubuntu/ASAquick/bin/ASAquick ..."
  ```  
  as follows:  

  ```
  system "/yourPath/ASAquick ..."
  ```  
- Modify line 8 of 'serverScript/3_genDISO.pl'  

  ```
  $IUPRED3A_dir="/home/ubuntu/iupred3";
  ```  
  as follows:  

  ```
  $IUPRED3A_dir="/yourPath/iupred3";
  ```  
  
* IUPred3
Prediction of Intrinsically Unstructured Proteins

https://iupred3.elte.hu/

The user needs to check the path of the IUPred3 in serverScript/3_genDISO.plx.

## Required Libraries

```
pip install numpy
pip install scipy
pip install pytorch==1.12.0 (or GPU supported pytorch, refer to https://pytorch.org/ for instructions)
```


# Prediction

Use command

```
$ ./genALL.pl 'jobID'
```

to run predictions.

The 'jobID' refers to the workfolder that contains the same text file with FASTA-formatted protein sequences.

For instance,

```
$ ./genALL.pl example
```

# Running on GPU or CPU

If you want to use GPU, you also need to install CUDA and cuDNN; please refer to their websites for instructions.

The code has been tested on both GPU and CPU-only computer.


# Features and labels data

The features data is provided in 'data/features/' folder.

The labels data is provided in 'data/labels/' folder.

# Citation

Upon the usage the users are requested to use the following citation:

Jian Zhang, Sushmita Basu, Lukasz Kurgan. HybridDBRpred: improved sequence-based prediction of DNA-binding amino acids using annotations from structured complexes and disordered proteins.
=======
# hybridDBRpred
>>>>>>> a778fd377805f63582ffa2590b8ee50ad2306104
=======
# hybridDBRpred
>>>>>>> 0787a2bed6f833120d9545c001fa6e9136021946
