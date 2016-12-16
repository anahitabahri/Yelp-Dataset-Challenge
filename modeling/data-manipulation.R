library(tidyr)
library(dplyr)
library(readr)

##################### GET REVIEWS WITH RATINGS 1, 3, 5, MUTATE COLS ##################### 

data <- read_csv('../../yelp-data/new_data/final_data/data_final.csv')
data <- data.frame(data)
head(data)
colnames(data)


my_data <- data %>% select(business_id, city, latitude, longitude, name, open, review_count, 
                           BusinessStars, state, date, review_id, ReviewStars, text, user_id,
                           votes_cool, votes_funny, votes_useful, user_average_stars, user_compliments_cool,
                           user_compliments_cute, user_compliments_funny, user_compliments_hot, 
                           user_compliments_photos, user_compliments_profile, user_compliments_writer,
                           user_fans, user_name, user_review_count, user_votes_cool, user_votes_funny,
                           user_votes_useful, user_yelping_since)

my_data <- my_data %>% mutate(rating1 = ifelse(ReviewStars == 1, 1, 0))
my_data <- my_data %>% mutate(rating3 = ifelse(ReviewStars == 3, 1, 0))
my_data <- my_data %>% mutate(rating5 = ifelse(ReviewStars == 5, 1, 0))

View(my_data)

# export data to csv
write.csv(my_data, "../../yelp-data/new_data/final_data/manip_data.csv", row.names = FALSE)

##################### MANIPULATE MANIP_DATA2 FILE FOR MODELING ##################### 
data <- read_csv('../../yelp-data/new_data/final_data/manip_data2.csv')
data <- data.frame(data)

colnames(data)

# let's select a few columns: PriceRange, business_id, city, latitude,
# longitude, review_count, BusinessStars, state, date, review_id, ReviewStars,
# text (? i don't think so), experience, price, wine, cheese, sauce

my_data <- data %>% select(PriceRange, business_id, city, latitude, longitude, review_count, 
                           BusinessStars, state, date, review_id, ReviewStars, 
                           experience, price, wine, cheese, sauce)

View(my_data)

# export so we don't have to do manipulation again...
write.csv(my_data, "../../yelp-data/new_data/final_data/data_modeling.csv", row.names = FALSE)



##################### MANIPULATE MANIP_DATA FILE FOR FURTHER MANIPULATION ##################### 
data <- read_csv('../../yelp-data/new_data/final_data/manip_data.csv')
data <- data.frame(data)
colnames(data)

mean(data$votes_funny) # 0.50
max(data$votes_funny) # 145
mean(data$votes_useful) # 1.31
max(data$votes_useful) # 158

library(ggplot2)

# create a ggplot object
data_gp <- ggplot(data)
data_gp + aes(x=votes_funny)+
  geom_histogram() +
  ggtitle("Histogram of Funny Votes") +
  labs(x="Funny Votes",y="Frequency") +
  scale_x_continuous(limits = c(2,25))

data_gp + aes(x=votes_useful)+
  geom_histogram() +
  ggtitle("Histogram of Useful Votes") +
  labs(x="Useful Votes",y="Frequency") +
  scale_x_continuous(limits = c(2,25))

# let's just pick 4 for both...

my_data <- data %>% mutate(funny = ifelse(votes_funny > 3, 1, 0))
my_data <- my_data %>% mutate(useful = ifelse(votes_useful > 3, 1, 0))

write.csv(my_data, "../../yelp-data/new_data/final_data/data_votes.csv", row.names = FALSE)
