# recommending-lines-replication-package

This reproduce package is created for paper "Where Should I Look at? Recommending Lines thatReviewers Should Pay Attention To".

## Description

There are two main parts in our work. The first part is data process(see data_process folder) part to process the raw dataset and generate csv files. 
We implement the experiment for this part with Python, Jupyter notebook for IDE and Conda for environment.
The second part is data evaluation(see data_eval folder) part to evaluate the experiment result with csv files generated in previous step. We use R and R studio for IDE in this part. The package structure with respect to RQ is as follows:
```
    .
    ├── ...
    ├── data_eval                 # Data evaluation (R)
    │   ├── RQ1_analysis.R.       # File level evaluation for RQ1
    │   ├── RQ2-3-analysis.R      # Line level evaluation for RQ2-3
    │   └── motivation.R          # Motivation 
    ├── data_process              # Data process (Python)
    │   ├── commented             # Predict the inline comment location
    │   │   ├── dataset               # dataset
    │   │   ├── csv               # output files of data process
    │   │   ├── eval_file         # input and output files for ngram average entropy
    │   │   ├── fileLevel         # raw data for file level model
    │   │   ├── lime-feature-model    # trained LIME model
    │   │   ├── lineLevel             # raw data for line level model
    │   └── └── ml-model               # trained file-level model
    │   │   ├── File_Level.ipynb  # File level data process for RQ1
    │   │   ├── Line_level.ipynb  # Line level data process for RQ2-3
    │   ├── revised               # Predict the lines to be revised
    │   │   ├── File_Level.ipynb  # File level data process for RQ1
    │   │   └── Line_level.ipynb  # Line level data process for RQ2-3
    ├── SLP-Core                  # ngram baseline approach
    ├── env                       # Conda environment files
    └── ...
```   
## Getting Started

### Dependencies

## System dependencies
* For data process part, we use Ubuntu 20.04.3 LTS
* For data evaluation part, we use macOS Big Sur (11.3)

## Package dependencies
|                      | Packages                                                                                                        |
|----------------------|-----------------------------------------------------------------------------------------------------------------|
| Data Process(Python) | sklearn, numpy, pandas, scipy, lime, time,  pickle, math, warnings, os, operator, matplotlib, csv,math,imblearn |
| Data Evaluation(R)   | ggplot2,dplyr,tidyverse,gridExtra,ggpubr                                                                        |

### Installing

For data process part, we save our conda environment file in env folder. Create the new env with file:
```
conda env create -f environment.yml
```
```
conda activate YOUR_ENV
```
It will install all dependencies need for the experiment.

### Executing program

Due to the upload limitation of Github for the file size, we save our dataset and prebuild repoduce packpage at:
Now we can start running the experiment. Just run each script from top to down. 

https://github.com/SLP-team/SLP-Core/blob/master/src/main/java/slp/core/example/EntropyForEachLine.java
## License

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for details


