PhyloCore User Manual

The python version of PhyloCore works on both Unix/Linux and Mac.



======================== DEPENDENCY ======================== 
 
PhyloCore.py depends on Biopython and Numpy. Make sure that Biopython (http://biopython.org/wiki/Download) and Numpy (http://www.scipy.org/scipylib/download.html) are properly installed. You can skip the installation step if Biopython and Numpy are already installed. To check whether you have Biopython and Numpy installed, open up a terminal and type the following commands 

	$ python
	>>> import numpy
	>>> import Bio

If that gives no error, you should be done and go straight to the section Running PhyloCore. If you get something like “ImportError: No module named …”. You need to install Biopython and Numpy by following the INSTALLATION instructions below.


======================== INSTALLATION ======================== 

You need the privilege of the system administrator to install PhyloCore. 

After download PhyloCore, first unpack it. In a terminal, go to where the downloaded PhyloCore package is and type

	tar -zxvf PhyloCore_python3.tar.gz


To install Biopython and Numpy, type

	cd PhyloCore_python3
	pip install -r requirements.txt

You might see warnings during installation. Ignore them.

For Mac users only: If you have not installed Xcode before, your will be prompted to download and install Xcode. Click OK to proceed. After you install Xcode, rerun the command ’sudo bash install_python_version.sh’ to finish installation. 
 

======================== RUNNING PhyloCore ========================

To run PhyloCore, in a terminal type
	
	python PhyloCore.py [Options]

Options:
	-i	(Required) Specify a OTU table. The OTU table needs to have taxonomy as the last column. See the file format requirement below.

	-t      (Optional) Specify a OTU tree in the newick format. The OTU tree should contain all OTUs in the OTU table. If an OTU tree is not provided, PhyloCore will construct a tree using the taxonomic information provided in the OTU table.

	-s      (Optional) Specify a sample ID list (with or without group information). When specified, only samples in the list will be used in core identification. The group information is optional and if provided will be used to identify weighted cores. See the file format requirement below.

	-o      (Optional) Specify an output file name. Default: PhyloCore_distribution.txt in current directory.

	-p	(Optional) Specify a threshold of prevalence. A node will be considered a core node if its prevalence is above the threshold. Default: 0.9

	-a 	(Optional) Specify a threshold of OTU relative abundance. OTUs with relative abundance lower than the threshold in a sample will be considered absent. Default: 0

	-l	(Optional) Taxonomy majority threshold. The taxonomy of a core is assigned to be the lowest common taxonomy shared by the majority of its descendent OTUs. For example, a threshold of 0.8 means that the taxonomy of a core is assigned to be the lowest common taxonomy shared by at least 80% of its descendent OTUs. Default: 0.8. 	

	-h	(Optional) Print a brief help message and exits.



======================== TEST Examples ================================

Two test datasets are provided for testing.

The toy dataset contains a simple OTU table with 7 OTUs from 8 samples, and a corresponding OTU tree.

To run a test, type

	python PhyloCore.py -i test/toy_otu_table.txt  

To identify cores with a user provided tree and a sample list

	python PhyloCore.py -i test/toy_otu_table.txt -t test/toy_rep_set.tre -s test/toy_ID_list.txt


Expected results are shown in OUTPUT FILES section. Again, only the OTU table is required. All other options are optional. 


Below is an example of analyzing a real dataset from Caporaso et al., 2011, Moving pictures of the human microbiome. Genome Biology 12 R50. 16S rRNA sequence data were downloaded from the paper and the OTU table (Caporaso_otu_table_taxon.txt) and the tree (Caporaso_rep_set.tre) were generated from the downloaded sequences using QIIME. 

	python PhyloCore.py -i test/Caporaso_otu_table_taxon.txt -t test/Caporaso_rep_set.tre -o Caporaso_core.txt


Expected results: after the job is finished, you should see a file named Caporaso_core.txt. It should contain a table of 469 columns by 19 rows. The first column lists the core names, followed by one column each for 467 samples, and one column for core taxonomic information at the end. There are 20 rows: the first row is a header, followed by 19 rows of core taxa.


      
======================== INPUT FILES AND FORMAT ========================

1.OTU table
The OTU table should be a tab-delimited table, with sample IDs in the first row, OTU IDs in the first column, and taxonomy in the last column. OTU table should be in plain text format. OTU table converted from the biom format can be readily read by PhyloCore (See instructions at http://biom-format.org/). See test/toy_otu_table.txt for an example.
      
OTU table format guidelines:
	a. The 1st column header must contain word "OTU".
	b. The last column must contain taxonomy assignment for each OTU. Taxonomic levels should be separated by semicolons. 
		E.g. k__Bacteria; p__Bacteroidetes; c__Bacteroidia; o__Bacteroidales; f__Prevotellaceae; g__Prevotella; s__
	c. OTU table should contain read numbers, but not the relative abundances.


2.OTU tree (optional)
The OTU tree should be a tree in the newick format. It should contain all OTUs in the OTU table. See test/toy_rep_set.tre for an example.	

3.Subset list (optional)
Specify a sample ID list (with or without group information). If a list is provided, then only samples in the list will be used in core identification. All other samples will be ignored. This list should contain ONLY ONE sample per line, and no header. The group information is optional and if provided, should be placed in the second column that is separated from the sample list (first column) by a tab. See test/toy_ID_list.txt for an example.



======================== OUTPUT FILES AND FORMAT ========================

PhyloCore generates a tab-delimited table, which list all the core taxa it identifies. The default name of the file is PhyloCore_distribution.txt unless the user specifies otherwise using the -o option. The table also contains the relative abundance of each core taxa in each sample. Core taxa are listed in first column and sample IDs are listed in first row. The last column contains taxonomy for each core taxon.

If user specifies a sample ID list, PhyloCore will also generate a table named ‘subset_PhyloCore_distribution.txt’ with only samples in the list.

OTUs appearing in the OTU table but not in the OTU tree will be written to otu_not_in_tree.log.

Example results from the toy test dataset (run: python PhyloCore.py -i test/toy_otu_table.txt -t test/toy_rep_set.tre -s test/toy_ID_list.txt):


PhyloCore_distribution.txt:

Cores	RL186	RL205	RL251	RL200	RL203	RL197	RL241	Taxonomydenovo0	0.076923077	0.476190476	0.322580645	0.041666667	0	0.769230769	0.714285714	k__Bacteria; p__Firmicutes; c__Clostridia; o__Clostridiales; f__Lachnospiraceae; g__; s__denovo1	0.076923077	0.047619048	0.032258065	0.416666667	0.333333333	0	0.071428571	k__Bacteria; p__Firmicutes; c__Clostridia; o__Clostridiales; f__Veillonellaceae; g__Megasphaera; s__denovo9	0.769230769	0.476190476	0.322580645	0.416666667	0.333333333	0.076923077	0.071428571	k__Bacteria; p__Firmicutes; c__Erysipelotrichi; o__Erysipelotrichales; f__Erysipelotrichaceae; g__[Eubacterium]; s__biforme



subset_PhyloCore_distribution.txt:

Cores	RL205	RL186	RL200	RL251	Taxonomy
denovo0	0.47619047619	0.0769230769231	0.0416666666667	0.322580645161	k__Bacteria; p__Firmicutes; c__Clostridia; o__Clostridiales; f__Lachnospiraceae; g__; s__
denovo1	0.047619047619	0.0769230769231	0.416666666667	0.0322580645161	k__Bacteria; p__Firmicutes; c__Clostridia; o__Clostridiales; f__Veillonellaceae; g__Megasphaera; s__
denovo9	0.47619047619	0.769230769231	0.416666666667	0.322580645161	k__Bacteria; p__Firmicutes; c__Erysipelotrichi; o__Erysipelotrichales; f__Erysipelotrichaceae; g__[Eubacterium]; s__biforme



======================== Additional Example Usage =============================

Find Core taxa with >=90% prevalence (default) in all samples
 
	python PhyloCore.py -i otu_table_taxon.txt 
		

Find Core taxa with >=90% prevalence (default) in all samples given an OTU tree
 
	python PhyloCore.py -i otu_table_taxon.txt -t otu_tree.tre 


Find Core taxa with >=80% prevalence in a subset of samples given an OTU tree

	python PhyloCore.py -i otu_table_taxon.txt -t otu_tree.tre -s subsetID_list.txt -p 0.8


Find Core taxa with >=80% prevalence in a subset of samples given an OTU tree, OTUs with <0.1 relative abundances are ignored.

	python PhyloCore.py -i otu_table_taxon.txt -t otu_tree.tre -s subsetID_list.txt -p 0.8 -a 0.1


 
======================== CITATION ======================== 

When publishing work that is based on the results from PhyloCore please cite: ########



======================== LICENSE ========================  
PhyloCore is free software: you may redistribute it and/or modify its under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or any later version.

PhyloCore is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details (http://www.gnu.org/licenses/).


======================== AUTHOR ========================  
Tiantian Ren, Martin Wu - <http://wolbachia.biology.virginia.edu/WuLab/Home.html>
For any other inquiries send an Email to Tiantian Ren: tr3br@virginia.edu
