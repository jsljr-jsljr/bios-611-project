PHONY: clean

clean:
	rm derived_data/*
	rm figures/*
	rm analysis/*

derived_data/hmdata.csv: source_data/horror_movies.csv
	Rscript hmdata_creation.R

figures/figure_1.png: derived_data/hmdata.csv
	Rscript figure_creation.R

figures/figure_2.png: derived_data/hmdata.csv
	Rscript figure_creation.R

figures/figure_3.png: derived_data/hmdata.csv
	Rscript figure_creation.R

figures/figure_4.png: derived_data/hmdata.csv
	Rscript figure_creation.R

figures/figure_5.png: dervied_data/hmdata.csv
	Rscript figure_creation.R

figures/figure_6.png: derived_data/hmdata.csv
	Rscript figure_creation.R

figures/figure_7.png: derived_data/hmdata.csv
	Rscript figure_creation.R

figures/figure_8.png:  derived_data/hmdata.csv
	Rscript figure_creation.R

figures/table_1.png:  derived_data/hmdata.csv
	Rscript figure_creation.R
