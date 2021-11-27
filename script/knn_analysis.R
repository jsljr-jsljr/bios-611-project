# Program: knn_analysis
# Description: Predicting good versus bad review ratings based on
#              observed median in data set.
# Author: Jose S. Lopez

# library setup
library(tidyverse);
library(caret);
library(rpart);
library(randomForest);
library(flextable);
library(gtsummary);
library(gt);
library(broom);
webshot::install_phantomjs(force = TRUE)
library(webshot);


#Creating analysis data set
hmdata <- read_csv("work/derived_data/hmdata.csv", show_col_types = FALSE) %>% 
  distinct(.) %>% 
  select(-title, -genres, -release_date, -release_country, 
         -plot, -cast, -filming_locations, -budget, -date,
         -movie_lead, -review_rating, -review_rating, -num_of_genres, 
        -language, -num_of_genres_c6, -sub_genre) %>%
  mutate(review_bin = as.factor(review_vs_median)) %>% 
  select(-review_vs_median) %>%
  drop_na()

#Fit KNN model based on data set
hmdata_knnFit_1 <- train(review_bin ~.,
                         data = hmdata,
                         method = "knn",
                         preProcess = c("center", "scale"),
                         tuneLength = 10)
knn_fit_10 <- list()
predicted_knn_fit_outcome_10 <- list()
accuracy_knn_fit_rates_10 <- list()
knn_table <- list()

tt_knn_indices_10 <- createFolds(y=hmdata$review_bin, k=10)

for(f in 1:length(tt_knn_indices_10)){
  hmdata_knn_train_10 <- hmdata[-tt_knn_indices_10[[f]],]
  hmdata_knn_test_10  <- hmdata[tt_knn_indices_10[[f]],]
  
  knn_fit_10[[f]] <- train(review_bin ~.,
                            data = hmdata_knn_train_10,
                            method = "knn",
                            preProcess = c("center", "scale"),
                            tuneGrid = hmdata_knnFit_1$bestTune)
  
  predicted_knn_fit_outcome_10[[f]] <- predict(knn_fit_10[[f]],
                                                newdata = hmdata_knn_test_10)
  
  #Get accuracy rates form output
  accuracy_knn_fit_rates_10[[f]] <- c(confusionMatrix(predicted_knn_fit_outcome_10[[f]],
                                                       hmdata_knn_test_10$review_bin, positive = "1")$byClass, "fold"=f)
  
}

knn_accuracy_df <- data.frame(do.call("rbind", accuracy_knn_fit_rates_10)) %>% select(Sensitivity, Specificity, Recall, Precision, F1)

#measure_means <- flextable(as.data.frame(t(sapply(knn_accuracy_df, mean))))

#save_as_image(measure_means, 
#              "analysis/table_measures_means.png", 
#              expand=10, 
#              webshot = "webshot")

#measure_stds <- flextable(as.data.frame((t(sapply(knn_accuracy_df, sd)))))

#save_as_image(measure_stds, 
#              "analysis/table_measures_stds.png", 
#              expand=10, 
#              webshot = "webshot")

Statistic <- c('Mean', 'Std Error')


knn_table_1 <- flextable(cbind(Statistic,rbind(as.data.frame(t(sapply(knn_accuracy_df, mean))),
                                               as.data.frame((t(sapply(knn_accuracy_df, sd)))))))

save_as_image(knn_table_1, 
              "analysis/knn_table.png", 
              expand=10, 
              webshot = "webshot")
