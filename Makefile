PHONY: clean

clean:
	rm -f derived_data/*
	rm -f figures/*
	rm -f analysis/*
	rm -f report.pdf

report.pdf: report.Rmd derived_data/hmdata.csv figures/table_1.png figures/figure_1.png figures/figure_2.png figures/figure_3.png figures/figure_4.png figures/figure_5.png figures/figure_6.png figures/figure_7.png figures/figure_8.png
	R -e "rmarkdown::render('report.Rmd',output_format='pdf_document')"

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

figures/figure_5.png: derived_data/hmdata.csv
	Rscript script/figure_creation.R

figures/figure_6.png: derived_data/hmdata.csv
	Rscript script/figure_creation.R

figures/figure_7.png: derived_data/hmdata.csv
	Rscript script/figure_creation.R

figures/figure_8.png: derived_data/hmdata.csv
	Rscript script/figure_creation.R

figures/table_1.png: derived_data/hmdata.csv
	Rscript script/figure_creation.R

figures/table_2.png: derived_data/hmdata.csv
	Rscript script/figure_creation.R

analysis/knn_table.png: derived_data/hmdata.csv
	Rscript script/knn_analysis.R

.PHONY: shiny_app
# Make target for Rshiny interactive scatter plot
shiny_app: derived_data/hmdata.csv script/shiny_app_01.R
	Rscript script/shiny_app_01.R ${PORT}
