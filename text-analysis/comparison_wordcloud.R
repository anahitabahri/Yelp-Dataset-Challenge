setwd("~/Documents/MSSP/FA2016/App Mult Reg + MV Methods/Final Project/yelp-data/new_data/final_data")

require(tm)
require(SnowballC)
require(wordcloud)
require(stringr)
require(dplyr)
library(readr)

# LOAD TEXT FILES
rating_1_text = scan(file = "text_1.txt", what = 'list')
rating_2_text = scan(file = "text_2.txt", what = 'list')
rating_3_text = scan(file = "text_3.txt", what = 'list')
rating_4_text = scan(file = "text_4.txt", what = 'list')
rating_5_text = scan(file = "text_5.txt", what = 'list')

# CLEAN TEXT: LOWER
clean_rating_1 = tolower(rating_1_text)
clean_rating_2 = tolower(rating_2_text)
clean_rating_3 = tolower(rating_3_text)
clean_rating_4 = tolower(rating_4_text)
clean_rating_5 = tolower(rating_5_text)

# REMOVE STOPWORDS (used this, not tm_map because that ran for 1+ hour with no avail)
stopwords = stopwords('english')

clean_rating_1 <- unlist(strsplit(clean_rating_1, " "))
clean_rating_1 <- clean_rating_1[!clean_rating_1 %in% stopwords]

clean_rating_2 <- unlist(strsplit(clean_rating_2, " "))
clean_rating_2 <- clean_rating_2[!clean_rating_2 %in% stopwords]

clean_rating_3 <- unlist(strsplit(clean_rating_3, " "))
clean_rating_3 <- clean_rating_3[!clean_rating_3 %in% stopwords]

clean_rating_4 <- unlist(strsplit(clean_rating_4, " "))
clean_rating_4 <- clean_rating_4[!clean_rating_4 %in% stopwords]

clean_rating_5 <- unlist(strsplit(clean_rating_5, " "))
clean_rating_5 <- clean_rating_5[!clean_rating_5 %in% stopwords]


# JOIN TEXTS IN A VECTOR FOR EACH RATING 
rating_1 = paste(clean_rating_1, collapse=" ")
rating_2 = paste(clean_rating_2, collapse=" ")
rating_3 = paste(clean_rating_3, collapse=" ")
rating_4 = paste(clean_rating_4, collapse=" ")
rating_5 = paste(clean_rating_5, collapse=" ")

# PUT EVERYTHING IN A SINGLE VECTOR
all = c(rating_1, rating_2, rating_3, rating_4, rating_5)

# CREATE CORPUS
corpus = Corpus(VectorSource(all))

# REMOVE ANYTHING OTHER THAN ENGLISH LETTERS / SPACE
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
corpus <- tm_map(corpus, content_transformer(removeNumPunct))

# CREATE TDM
tdm = TermDocumentMatrix(corpus)

# CONVERT AS MATRIX
tdm = as.matrix(tdm)

# ADD COL NAMES
colnames(tdm) = c("Rating 1", "Rating 2", "Rating 3", "Rating 4", "Rating 5")

# COMPARISON CLOUD
comparison.cloud(tdm, random.order=FALSE, 
# colors = c("#ffb5b5", "#8bf2ea", "#f6fd86", "#fe92ff", "#c1f99d"),
# colors = c("#ed0a3f", "#e77200", "#fed85d", "#01786f", "#2d383a"),
# colors = c("#511031", "#832323", "#df7866", "#f4ef80", "#71bd73"),
# colors = c("#87205e", "#52e5e5", "#e55252", "#20877d", "#c0f000"),
# colors = c("#98507c", "#806d88", "#688b94", "#4fa8a0", "#37c5ac"),
colors = c("#5a1341", "#9c466d", "#7f6a94", "#5cb28d", "#a0cc7e"),
title.size=1.5, max.words=500)

# http://www.color-hex.com/color-palette/27584
# http://www.color-hex.com/color-palette/27525
# http://www.color-hex.com/color-palette/26994
# http://www.color-hex.com/color-palette/26903
# http://www.color-hex.com/color-palette/26853
# http://www.color-hex.com/color-palette/26724