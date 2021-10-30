# README

:construction: Note that this project is still underconstruction and data needs further cleaned and modified correctly. For example, recently it has been discovered that budgets must also be modified such that are all changed to one currency. :construction:

## What does this project contain?
This repository contains the data, code, and results of an analysis of horror movie ratings of horror movies that were released between the years of 2012 and 2017 (horror movies include theatrical, television, and ancillary market releases). The motivation is simply an interest in horror movies and wondering whether there are any factors that give a good indication that a horror movie will be reviewed better than others!

## What is the source data?
This analysis is based derived from IMDB first put on Kaggle and then hosted on https://github.com/rfordatascience/tidytuesday, which is where I sourced the data from. The data contains information on 3,328 different horror movies. Examples of included properties are genre(s), release data, release country, MPAA rating, and movie run time (in minutes). The data consists of 12 columns, 11 of which pertain to the movie properties, and the remaining 1 column peratins to what I considered the outcome in my analysis - the review rating (which ranged from 1 to 10).

If you wish to replicate this exact analysis, please utilize the csvs located in the source_data folder of this repository.

## How do I build the docker image?
Run the following commands to set up a docker image. Note for the second command, you should insert your own unique password and change the path in the command to the bios-611-project folder in your directory. Refer to Commands.md for more commands.

Command to build docker image:

``docker build . -t dockerfile``

Command to run docker image (RStudio):

``docker run --rm -p 8080:8080 -p 8787:8787 -e PASSWORD=<insert your own unique password> -v <insert path to bios-611-project folder>:/home/rstudio/work -t dockerfile``

Example:

``docker run --rm -p 8080:8080 -p 8787:8787 -e PASSWORD=hellofuture -v C:/Users/offic/MS/FALL2021/BIOS611/bios-611-project:/home/rstudio/work -t dockerfile``

## How do I conduct the analysis and construct the report?
To create the bios-611-project-report pdf, run the following commands in your R terminal. Make sure you are running these commands from the ``/work`` folder once you have brought up the Rstudio image.

``make derived_data/hmdata.csv``

``make figures/table_1.png``

``make figures/figure_1.png``

``make figures/figure_2.png``

``make figures/figure_3.png``

``make figures/figure_4.png``

``make figures/figure_5.png``

``make figures/figure_6.png``

``make figures/figure_7.png``

``make figures/figure_8.png``

``make analysis/knn_table.png``

These commands will create the relevant datasets, figures, and analysis tables. Note that any one of the ``make figures/figure_i.png`` or  ``make figures/table_1.png`` will generate all figures and the table.

## How do I construct the Rshiny app?

Run the following command in your rstudio terminal to run the rshiny app.

``PORT=8788 make shiny_app``

Open a new tab in your browser to http:/localhost:8788 and the app will be available to interact with.

