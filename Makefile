PHONY: clean

clean:
	rm -f derived_data/*
	rm -f figures/*
	rm -f analysis/*

derived_data/hmdata.csv: source_data/horror_movies.csv
	Rscript script/hmdata_creation.R

figures/figure_1.png: derived_data/hmdata.csv
	Rscript script/figure_creation.R

figures/figure_2.png: derived_data/hmdata.csv
	Rscript script/figure_creation.R

figures/figure_3.png: derived_data/hmdata.csv
	Rscript script/figure_creation.R

figures/figure_4.png: derived_data/hmdata.csv
	Rscript script/figure_creation.R

figures/figure_5.png: dervied_data/hmdata.csv
	Rscript script/figure_creation.R

figures/figure_6.png: derived_data/hmdata.csv
	Rscript script/figure_creation.R

figures/figure_7.png: derived_data/hmdata.csv
	Rscript script/figure_creation.R

figures/figure_8.png:  derived_data/hmdata.csv
	Rscript script/figure_creation.R

figures/table_1.png:  derived_data/hmdata.csv
	Rscript script/figure_creation.R

.PHONY: shiny_app
# Make target for Rshiny interactive scatter plot
shiny_app: derived_data/hmdata.csv script/shiny_app_01.R
	Rscript script/shiny_app_01.R ${PORT}
