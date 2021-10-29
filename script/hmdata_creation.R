# Program: derived_data
# Description: Creating data sets that will be used to create figures
#              and conduct analyses.
# Author: Jose S. Lopez

# library setup
library(tidyverse)
library(tidytext)
library(lubridate)
library(gtsummary)
library(flextable)
library(kableExtra)
library(gt)

hmdata <- read_csv("source_data/horror_movies.csv", col_types = cols()) %>%
          distinct(.) %>% 
          filter(!is.na(review_rating))

# sapply(hmdata, function(x) sum(is.na(x)))

list_of_num_of_genres <- str_split(hmdata$genres, "[|]")

num_of_genres <- unlist(lapply(list_of_num_of_genres, 
                               function(x) length(x)))

hmdata_2 <- cbind(hmdata, num_of_genres)

hmdata_3 <- hmdata_2 %>% mutate(budget_num = parse_number(budget),
                                date = dmy(release_date),
                                month = month(dmy(release_date), label=T, abbr=F),
                                yr = year(date),
                                yr = ifelse(is.na(yr), release_date, yr),
                                num_of_genres = as.numeric(num_of_genres),
                                review_vs_median = ifelse(review_rating < median(review_rating, na.rm=TRUE), 0, 1),
                                movie_lead = str_split(cast, "[|]") %>% map_chr(., 1),
                                movie_run_time =  as.numeric(str_split(movie_run_time, " ") %>% map_chr(., 1)),
                                
                                sub_genre = 
                                  case_when((num_of_genres==1) & (str_split(genres, "[|]") %>% map_chr(., 1))=="Horror" ~ "Pure",
                                            (str_split(genres, "[|]") %>% map_chr(., 1))!="Horror" ~ (str_split(genres, "[|]") %>% map_chr(., 1)),
                                            is.na(genres) ~ "None",
                                            TRUE ~ "Other"))

hmdata_subset_num_of_genres <- hmdata_3 %>% 
  filter(sub_genre=="Other")

hmdata_subset_num_of_genres_2 <- hmdata_subset_num_of_genres %>%
    mutate(sub_genre =
           case_when(TRUE ~ (str_split(genres, "[|]") %>% map_chr(., 2))))

hmdata_subset_num_of_genres_3 <- hmdata_3 %>% 
                                 filter(sub_genre!="Other")

hmdata_4 <- rbind(hmdata_subset_num_of_genres_2,
                  hmdata_subset_num_of_genres_3) %>% 
            mutate(sub_genre = str_trim(sub_genre))

# Various property tables to see the distributions of counts for
# different properties.

# hmdata_4 %>% group_by(release_country) %>% tally() %>% arrange(desc(n))

# hmdata_4 %>% group_by(movie_rating) %>% tally() %>% arrange(desc(n))

# hmdata_4 %>% group_by(language) %>% tally() %>% arrange(desc(n))

# hmdata_4 %>% group_by(num_of_genres) %>% tally() %>% arrange(desc(n))

# hmdata_4 %>% group_by(yr) %>% tally() %>% arrange(desc(n))

# hmdata_4 %>% group_by(sub_genre) %>% tally() %>% arrange(desc(n))

# Tables inform how variables are modified for analysis.

hmdata_5 <- hmdata_4 %>% 
  mutate(movie_rating = case_when(movie_rating=="TV-MA" ~ "TV-MA",
                                  (movie_rating=="R" |
                                     movie_rating=="NC-17" |
                                     movie_rating=="X") ~ "MPAA-MA",
                                  (movie_rating=="PG-13"|
                                     movie_rating=="PG") ~ "MPAA-TC",
                                  (movie_rating=="TV-14" |
                                     movie_rating=="TV-PG" |
                                     movie_rating=="E") ~ "TV-TC",
                                  movie_rating == "NOT RATED" ~ "Not Rated",
                                  movie_rating == "UNRATED" ~ "Unrated",
                                  TRUE ~ "Not Rated"),
         language = (str_split(language, "[|]") %>% map_chr(., 1)),
         num_of_genres_c6 = case_when((num_of_genres==6 |
                                         num_of_genres==7 |
                                         num_of_genres==8 |
                                         num_of_genres==9)~"Six or more",
                                      num_of_genres==1 ~ "One",
                                      num_of_genres==2 ~ "Two",
                                      num_of_genres==3 ~ "Three",
                                      num_of_genres==4 ~ "Four",
                                      num_of_genres==5 ~ "Five"),
         sub_genre = case_when((sub_genre=="Biography" |
                                  sub_genre=="War" |
                                  sub_genre=="Musical" |
                                  sub_genre=="History" |
                                  sub_genre=="Family" |
                                  sub_genre=="None" |
                                  sub_genre=="Reality-TV" |
                                  sub_genre=="Western") ~ "Other",
                               sub_genre=="Pure" ~ "Pure",
                               sub_genre=="Thriller" ~ "Thriller",
                               sub_genre=="Comedy" ~ "Comedy",
                               sub_genre=="Drama" ~ "Drama",
                               sub_genre=="Action" ~ "Action",
                               sub_genre=="Mystery" ~ "Mystery",
                               sub_genre=="Sci-Fi" ~ "Sci-Fi",
                               sub_genre=="Crime" ~ "Crime",
                               sub_genre=="Fantasy" ~ "Fantasy",
                               sub_genre=="Adventure" ~ "Adventure",
                               sub_genre=="Animation" ~ "Animation",
                               sub_genre=="Romance" ~ "Romance"))

write_csv(hmdata_5, file="derived_data/hmdata.csv")
