# recommending-lines-reproduce-package

This reproduce package is created for paper "Where Should I Look at? Recommending Lines thatReviewers Should Pay Attention To".

## Description

There are two main parts in our work. The first part is data process(see data_process folder) part to process the raw dataset and generate csv files. 
We implement the experiment for this part with Python, Jupyter notebook for IDE and Conda for environment.
The second part is data evaluation(see data_eval folder) part to evaluate the experiment result with csv files generated in previous step. We use R and R studio for IDE in this part. The package structure with respect to RQ is as follows:

   .
   ├── data_eval                 # Data evaluation (R)
   │   ├── figures
   │   ├── RQ1_analysis.R. #File level evaluation for RQ1
   │   ├── RQ2-3-analysis.R #Line level evaluation for RQ2-3
   │   ├── motivation.R #Motivation 
   ├── data_process              # Data process (Python)
   │   ├── commented #Predict the inline comment location
   │   │   ├── File_Level.ipynb #File level data process for RQ1
   │   │   ├── Line_level.ipynb #Line level data process for RQ2-3
   │   ├── revised #Predict the lines to be revised
   │   │   ├── File_Level.ipynb #File level data process for RQ1
   │   │   ├── Line_level.ipynb #Line level data process for RQ2-3
   ├── env                     # Conda environment files
   └── README.md

    .
    ├── ...
    ├── docs                    # Documentation files (alternatively `doc`)
    │   ├── TOC.md              # Table of contents
    │   ├── faq.md              # Frequently asked questions
    │   ├── misc.md             # Miscellaneous information
    │   ├── usage.md            # Getting started guide
    │   └── ...                 # etc.
    └── ...
    
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

* For data process part, we save our conda environment file in env folder. Create the new env with file:
* ```
* conda env create -f environment.yml
* ```
* It will install all dependencies need for the experiment.

### Executing program

Now we can start running the experiment. 

## Help

Any advise for common problems or issues.
```
command to run if program contains helper info
```

## Authors

Contributors names and contact info

ex. Dominique Pizzie  
ex. [@DomPizzie](https://twitter.com/dompizzie)

## Version History

* 0.2
    * Various bug fixes and optimizations
    * See [commit change]() or See [release history]()
* 0.1
    * Initial Release

## License

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for details

## Acknowledgments

Inspiration, code snippets, etc.
* [awesome-readme](https://github.com/matiassingers/awesome-readme)
* [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
* [dbader](https://github.com/dbader/readme-template)
* [zenorocha](https://gist.github.com/zenorocha/4526327)
* [fvcproductions](https://gist.github.com/fvcproductions/1bfc2d4aecb01a834b46)
