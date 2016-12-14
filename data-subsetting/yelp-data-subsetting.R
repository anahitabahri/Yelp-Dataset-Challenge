library(tidyr)
library(dplyr)
library(readr)
library(ggplot2)
library(sqldf)

business <- read_csv('../../yelp-data/yelp_academic_dataset_business.csv')

################################################################################################

# subset biz df, assumption: all of them should be restaurants if they are steakhouses or french...
biz_subset = sqldf("SELECT * FROM business WHERE categories like '%Steakhouses%' 
                   OR categories like '%French%';")
nrow(biz_subset) # 1112
# View(biz_subset)

sqldf("SELECT COUNT(categories) from biz_subset where categories like '%Restaurants%'")
View(sqldf("SELECT categories from biz_subset where categories like '%Restaurants%'"))
# looks good!

# export biz subset
write.csv(biz_subset, "../../yelp-data/biz_subset.csv", row.names = FALSE)

# read biz subset, with renamed columns (and few removed cols)
biz_update <- read_csv('../../yelp-data/biz_edit.csv')
nrow(biz_update) # 1112
biz_update <- data.frame(biz_update)
head(biz_update)

################################################################################################

# load joined dataset, which was done using python pandas
data1 <- read_csv('../../yelp-data/data.csv')
data1 <- data.frame(data1)
View(data1)
sqldf("SELECT COUNT(DISTINCT business_id) FROM data1;") # 1101

# reviews with the word steak in it
steak_subset = sqldf("SELECT * FROM data1 WHERE text like '%Steak%' OR text like '%steak%';")

nrow(steak_subset) # 39k...
sqldf("SELECT COUNT(DISTINCT business_id) FROM steak_subset;") # 844 businesses

# export steak_subset
write.csv(steak_subset, "../../yelp-data/steak_subset.csv", row.names = FALSE)
