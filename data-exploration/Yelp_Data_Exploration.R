library(tidyr)
library(dplyr)
library(readr)
library(ggplot2)
library(sqldf)

# tips <- read_csv('data/yelp_academic_dataset_tip.csv')
# checkin <- read_csv('data/yelp_academic_dataset_checkin.csv')
# user <- read_csv('data/yelp_academic_dataset_user.csv')
business <- read_csv('data/yelp_academic_dataset_business.csv')
# reviews <- read_csv('data/yelp_academic_dataset_review.csv')

View(business)

# subset biz df, assumption:all of them should be restaurants if they are steakhouses or french...
biz_subset = sqldf("SELECT * FROM business WHERE categories like '%Steakhouses%' 
                   OR categories like '%French%';")
nrow(biz_subset)
View(biz_subset)
sqldf("SELECT COUNT(categories) from biz_subset where categories like '%Restaurants%'")
View(sqldf("SELECT categories from biz_subset where categories like '%Restaurants%'"))
# looks good!

# write.csv(biz_subset, "data/biz_subset.csv")

# explore biz subset...
biz_subset_gp <- ggplot(biz_subset)
# biz_subset_gp + aes(x='attributes_Price Range')+
#  geom_histogram() +
#  ggtitle("Histogram of Case Cost") +
#  labs(x="Case Cost",y="Frequency")

barplot(table(biz_subset$'attributes_Price Range'))
barplot(table(biz_subset$'attributes_Noise Level'))
barplot(table(biz_subset$'attributes_Alcohol'))
barplot(table(biz_subset$'attributes_Attire'))
barplot(table(biz_subset$'attributes_Good for Kids'))
barplot(table(biz_subset$'attributes_Takes Reservations'))
barplot(table(biz_subset$'attributes_Take-out')) # may not care about true vals? 
barplot(table(biz_subset$'attributes_Waiter Service')) # also may not care about false vals??
barplot(table(biz_subset$'attributes_Wi-Fi'))


# load joined dataset, which was done using python pandas
data1 <- read_csv('data.csv')
View(data1)

# reviews with the word steak in it

steak_subset = sqldf("SELECT * FROM data1 WHERE text like '%Steak%' 
                   OR text like '%steak%';")

View(steak_subset) # 39k...
nrow(steak_subset)
sqldf("SELECT COUNT(DISTINCT business_id) FROM steak_subset;") # 851 businesses



