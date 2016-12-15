library(tidyr)
library(dplyr)
library(readr)

data <- read_csv('../../yelp-data/new_data/final_data/data_final.csv')
data <- data.frame(data)
head(data)
colnames(data)

my_data <- data %>% mutate(rating1 = ifelse(ReviewStars == 1, 1, 0))

colnames(my_data)
my_data <- my_data %>% select(business_id, city, latitude, longitude, name, open, review_count, 
                              BusinessStars, state, date, review_id, ReviewStars, text, user_id,
                              votes_cool, votes_funny, votes_useful, user_average_stars, user_compliments_cool,
                              user_compliments_cute, user_compliments_funny, user_compliments_hot, 
                              user_compliments_photos, user_compliments_profile, user_compliments_writer,
                              user_fans, user_name, user_review_count, user_votes_cool, user_votes_funny,
                              user_votes_useful, user_yelping_since, rating1)

my_data <- my_data %>% mutate(rating3 = ifelse(ReviewStars == 3, 1, 0))
my_data <- my_data %>% mutate(rating5 = ifelse(ReviewStars == 5, 1, 0))

View(my_data)

# export data to csv
write.csv(my_data, "../../yelp-data/new_data/final_data/manip_data.csv", row.names = FALSE)

