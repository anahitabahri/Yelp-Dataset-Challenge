library(tidyr)
library(dplyr)
library(readr)
library(arm)
library(lme4)
library(merTools)
library(aod)
library(ggplot2)
library(Rcpp)

data <- read_csv('../../yelp_data.csv')
data <- data.frame(data)

colnames(data)

########################## RANDOM EFFECTS W NEW DATA ##########################
model1 <- lmer(ReviewStars ~ experience + price + 
                 (1 | state) + (1 | business_id), data = data)

AIC(model1)
plotFEsim(FEsim(model1)) # model 1 skewed towards negative ratings
plotREsim(REsim(model1))

model2 <- lmer(ReviewStars ~ friendly + delicious + 
                 (1 | state) + (1 | business_id), data = data)

AIC(model1,model2) 
plotFEsim(FEsim(model2)) # model 2 obviously skewed towards positive ratings
plotREsim(REsim(model2))

model3 <- lmer(ReviewStars ~ sauce + fries + medium +
                 (1 | state) + (1 | business_id), data = data)

AIC(model1,model2,model3) # similar to model 1
plotFEsim(FEsim(model3)) # weird, fries and medium are skewed towards negative ratings
plotREsim(REsim(model3))

model4 <- lmer(ReviewStars ~ experience + price + service +
                 (1 | state) + (1 | business_id), data = data)

AIC(model1,model2,model3,model4) # doesn't seem like service adds much value
plotFEsim(FEsim(model4)) # again, skewed towards negative ratings
plotREsim(REsim(model4))

########################## RANDOM EFFECTS W OLD DATA ##########################

data2 <- read_csv('../../yelp-data/new_data/final_data/data_modeling.csv')
data2 <- data.frame(data2)

colnames(data2)

model5 <- lmer(ReviewStars ~ PriceRange + experience + price +
                 (1 | state) + (1 | business_id), data = data2)


AIC(model1,model4,model5) # PriceRange adds some value
plotFEsim(FEsim(model5)) # PriceRange is slightly more positively skewed
plotREsim(REsim(model5))

model6 <- lmer(ReviewStars ~ PriceRange + experience + price + wine + cheese + sauce +
                 (1 | state) + (1 | business_id), data = data2)

AIC(model5,model6) # addition of wine, cheese, and sauce barely makes a difference
plotFEsim(FEsim(model6)) # wine, cheese on the positive side, sauce near median
plotREsim(REsim(model6))

########################## LOGISTIC REGRESSION W NEW DATA ##########################

data = data %>% mutate(experience2 = ifelse(experience == 'True', 1, 0))

mylogit <- glm(experience2 ~ votes_useful + ReviewStars, 
               data = data, family = "binomial")

## summary
display(mylogit)

## 95% CI
confint(mylogit)

## odds ratios and 95% CI
exp(cbind(OR = coef(mylogit), confint(mylogit)))

library(popbio)
logi.hist.plot(data$votes_useful,data$experience2,boxp=FALSE,
               type="hist",col="gray")

logi.hist.plot(data$votes_funny,data$experience2,boxp=FALSE,
               type="hist",col="gray")

logi.hist.plot(data$votes_cool,data$experience2,boxp=FALSE,
               type="hist",col="gray")


data = data %>% mutate(num_words = nchar(data$text))


logi.hist.plot(data$num_words,data$experience2,boxp=FALSE,
               type="hist",col="gray")

logi.hist.plot(data$num_words,data$rating1,boxp=FALSE,
               type="hist",col="gray")

logi.hist.plot(data$num_words,data$rating5,boxp=FALSE,
               type="hist",col="gray")


## view data frame
# http://www.ats.ucla.edu/stat/r/dae/logit.htm