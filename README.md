# RevSpot-Replication-Package

This replication package is created for the paper titled "Where Should I Look at? Recommending Lines that Reviewers Should Pay Attention To", which is published at the 29th IEEE International Conference on Software Analysis, Evolution and Reengineering (SANER).

## Overview
![A  usage  scenario  of  our  REVSPOTin  a  code  reviewprocess](./review-process.jpg?style=center)
<p>Figure illustrates an overviewof  the  code  review  process,  which  comprises  of  four  mainsteps.  Broadly  speaking,  once  a  patch  author  creates  a  newpatch  (i.e.,  code  changes),  s/he  first  uploads  it  to  the  codereview  tool  in  Step1.  Then,  in  Step2the  patch  authorinvites  reviewers  to  examine  the  proposed  patch.  In  Step3,the reviewers examine the changed code in the proposed patch.If  the  reviewers  find  problems  or  have  concerns,  they  canprovide  feedback  to  the  specific  lines  of  code  (calledinlinecomments,  henceforth)  or  post  a  message  in  the  discussionthread  of  the  patch  (calledgeneral comments,  henceforth).The reviewers then make a decision whether this patch can beintegrated  into  the  main  code  repository  by  giving  a  reviewscore in Step4. If the reviewers suggest that the patch is notready for an integration by giving a negative score, the patchauthor mayrevisethe patch and upload a new version of thepatch  to  address  the  inline  comments  or  general  commentsof  reviewers  in  Step5.  Finally,  when  one  of  the  reviewersapproves  that  the  revised  version  of  the  patch  has  sufficientquality, the patch is then merged into the main code repository.</p>


## Something you need to know before start
Since the limitation of file size that allow to uploading to github, this repo only includes the source code of all scripts and excludes the part of the dataset. To re-generate the result in the paper, please follow "Evaluate result" section below. If the practioners want to train the model by themself, please download the entire replication package from zenodo [here](https://doi.org/10.5281/zenodo.5839022) and follow "Build you own model" section below and commments in the scripts. The replication package in zenodo includes all dataset and model used in the paper. 

## Description

There are two main parts in our work. The first part is data process (see data_process folder) part to process the raw dataset and generate csv files. 
We implement the experiment for this part with Python, Jupyter notebook for IDE and Conda for environment.
The second part is data evaluation(see data_eval folder) part to evaluate the experiment result with csv files generated in previous step. We use R and R studio for IDE in this part. The package structure with respect to RQ is as follows:
```
    .
    ├── ...
    ├── dataset                 # Dataset
    ├── RQ1_RQ2                 # Code for RQ1 and RQ2
    ├── RQ3 			# Manual test results for RQ3 
    └── ...

```  

## Getting Started

### System dependencies
* Ubuntu 20.04.3 LTS

### Package dependencies
|                      | Packages                                                                                                              |
|----------------------|-----------------------------------------------------------------------------------------------------------------------|
| Python               | sklearn, numpy, pandas, scipy, lime, time,  pickle, math, warnings, os, operator, matplotlib, csv,math, strsimpy,nltk |


### Installing

For data process part, we save our conda environment file in env folder. Create the new env with file:
```
conda env create -f environment.yml
```
```
conda activate YOUR_ENV
```
It will install all dependencies need for the experiment.

###  Reproduce our work
Run jupyter-notebook script from top to bottom.
