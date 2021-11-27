# Program: figure_creation
# Description: Creating figures that provide context for what our data
#              looks like.
# Author: Jose S. Lopez

# library setup
library(tidyverse);
library(broom);
library(gtsummary);
library(flextable);
library(gt);
library(GGally);
library(scales);
library(ggpubr);
webshot::install_phantomjs()
library(webshot);

hmdata_5 <- read_csv("derived_data/hmdata.csv", col_types = cols())

#---------------------------#
#--------- Table 1 ---------#
#---------------------------#
table_1a_01 <- tbl_summary(data = hmdata_5,
                           by =  review_vs_median,
                           statistic = list(all_continuous() ~ "{mean} ({sd})",
                                            all_categorical() ~ "{n} ({p}%)"),
                           include = c("movie_rating", 
                                       "movie_run_time", 
                                       
                                       "budget_num", 
                                       "num_of_genres_c6",
                                       "sub_genre",
                                       "month"),
                           digits = list(all_continuous() ~ 2,
                                         all_categorical() ~ 2),
                           missing = "no",
                           label = c('movie_rating' ~ 'Movie rating',
                                     'movie_run_time' ~ 'Run time',
                                     'budget_num' ~ 'Movie budget',
                                     'num_of_genres_c6' ~ 'Number of genres',
                                     'sub_genre' ~ 'Sub-genre',
                                     'month' ~ 'Month')) %>%
  add_n() %>%
  add_p(test = list(all_continuous() ~ "aov",
                    all_categorical() ~ "chisq.test")) %>%
  as_flex_table() %>%
  bold(bold = TRUE, part = "header") %>%
  add_header_lines(values = "Table 1. Summary Statistics for Review Rating Machine Learning Variables of Interest")

save_as_image(table_1a_01, 
              "figures/table_1.png", 
              expand=10, 
              webshot = "webshot")

#---------------------------#
#--------- Table 2 ---------#
#---------------------------#

Variable <- c('Title', 'Genres', 'Release date', 'Release country',
              'MPAA rating', 'Review rating', 'Movie run time', 'Plot', 'Cast', 
              'Language', 'Filming locations', 'Budget', 'Number of genres', 'Budget number', 
              'Date', 'Month', 'Year', 'Review versus median', 'Movie lead', 'Subgenre', '6 category number of genres')

table_2 <- cbind(Variable, as.data.frame(sapply(hmdata_5, function(x) sum(is.na(x)))))

table_2 <- flextable(table_2) %>% 
           set_header_labels('sapply(hmdata, function(x) sum(is.na(x)))' = 'Counts') %>%
           add_header_lines('Table 2. Missing counts for cleaned data set')

save_as_image(table_2, 
              "figures/table_2.png", 
              expand=10, 
              webshot = "webshot")

#----------------------------------#
#--------- Figures 1, 2, 3 --------#
#----------------------------------#

hmdata_5$month = factor(hmdata_5$month,
                        levels = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", "NA"))

p1 = ggplot(hmdata_5, aes(x = month, fill = sub_genre))

p1 = p1 + geom_bar() + ggtitle("Figure 1.a. Counts of Films by Release Month distinguished \n by Movie Sub-genre")

p1 = p1 + labs(x = "Release Month", y = "Count", fill = 'Sub genre')

p1 = p1 + theme(legend.key.size = unit(0.5, 'cm'))

p1 = p1 + scale_fill_viridis_d(option="inferno")

p1 = p1 + theme(axis.text.x=element_text(size=11, angle=30, vjust=.8, hjust=0.8))

p1

ggsave("figures/figure_1.png", p1)

p2 = ggplot(hmdata_5, aes(x = month, fill = as.factor(yr)))

p2 = p2 + geom_bar() + ggtitle("Figure 1.b. Counts of Films by Release Month distinguished \n by Release Year")

p2 = p2 + labs(x = "Release Month", y = "Count", fill = 'Year')

p2 = p2 + scale_fill_viridis_d(option="inferno")

p2 = p2 + theme(axis.text.x=element_text(size=11, angle=30, vjust=.8, hjust=0.8))

p2

ggsave("figures/figure_2.png", p2)

p3 = ggplot(hmdata_5, aes(x = month, fill = as.factor(num_of_genres_c6)))

p3 = p3 + geom_bar() + ggtitle("Figure 1.c. Counts of Films by Release Month distinguished \n by Number of Genres Listed for the Movie")

p3 = p3 + labs(x = "Release Month", y = "Count", fill = 'No. of Genres')

p3 = p3 + scale_fill_viridis_d(option="inferno")

p3 = p3 + theme(axis.text.x=element_text(size=11, angle=30, vjust=.8, hjust=0.8))

p3

ggsave("figures/figure_3.png", p3)

#----------------------------------#
#--------- Figures 4, 5, 6 --------#
#----------------------------------#

p4 <- hmdata_5 %>% filter(sub_genre!="Pure") %>%
  ggplot(aes(x = sub_genre, y = review_rating, fill = sub_genre)) +
  geom_boxplot(alpha = .75) +
  labs(x = "Sub genre", y = "Review Rating", fill = "Sub genre") +
  scale_fill_viridis_d(option="inferno") +
  ggtitle("Figure 2.a. Distribution of Review Ratings by Sub Genre") +
  theme(axis.text.x = element_text(angle =45, hjust = 1),
        legend.key.size = unit(0.5, 'cm'))

p4

ggsave("figures/figure_4.png", p4)

p5 = ggplot(hmdata_5, aes(x = yr, y = review_rating, fill = as.factor(yr)))

p5 = p5 + geom_boxplot(alpha = .75) + 
  labs(x = "Release Year", y = "Review Rating", fill = "Year") +
  scale_fill_viridis_d(option="inferno") +
  ggtitle("Figure 2.b. Distribution of Review Ratings by Year")

p5

ggsave("figures/figure_5.png", p5)

p6 = ggplot(hmdata_5, aes(x = num_of_genres_c6, y = review_rating, fill = num_of_genres_c6))

p6 = p6 + geom_boxplot(alpha = .75) +
  labs(x = "No. of Genres", y = "Review Rating", fill = "No. of Genres") + 
  scale_fill_viridis_d(option="inferno") +
  ggtitle("Figure 2.c. Distribution of Review Ratings by Number \n of Genres Listed for the Movie")

p6

ggsave("figures/figure_6.png", p6)

#----------------------------------#
#--------- Figures 7 & 8 ----------#
#----------------------------------#

p7 = ggplot(hmdata_5 %>% filter(!is.na(movie_run_time)), aes(x = movie_run_time, y = review_rating, color = yr))

p7 = p7 + geom_point() + facet_wrap(~yr, ncol=1, nrow=6) +
  scale_color_viridis_c(option = "inferno") +
  labs(x = "Movie Run Time", y = "Review Rating") +
  ggtitle("Figure 3.a. Scatter Plot of Movie Run Time \n against Review Ratings")

p7

ggsave("figures/figure_7.png", p7)

p8 = ggplot(hmdata_5 %>% filter(!is.na(budget_num)) %>% filter(!is.na(review_rating)), aes(x = budget_num, y = review_rating, color = yr))

p8 = p8 + geom_point() + scale_x_log10() + 
  facet_wrap(~yr, ncol=2, nrow=3) +
  scale_color_viridis_c(option = "inferno") +
  labs(x = "Log Scaled Movie Budget",
       y = "Review Rating") +
  ggtitle("Figure 3.b. Scatter Plot of Log Scaled Budget \n against Review Ratings")

p8

ggsave("figures/figure_8.png", p8)
