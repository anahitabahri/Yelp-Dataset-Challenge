library(tidyr)
library(dplyr)
library(readr)
library(arm)
library(lme4)

data <- read_csv('../../yelp-data/new_data/final_data/data_modeling.csv')
data <- data.frame(data)

colnames(data)

########################################### FIXED EFFECTS ###########################################

# predict ReviewStars using just word indicators
model1 <- lm(ReviewStars ~ experience + price + wine + cheese + sauce, data=data)
summary(model1)
display(model1) # super low R-Squared . . .

# predict ReviewStars using word indicators with city / state
# state R-Squared: 0.02, city R-Squared: 0.03
model2 <- lm(ReviewStars ~ experience + price + wine + cheese + sauce + city, data=data)
display(model2)

# predict ReviewStars using word indicators with city, and 5 interaction terms (city * word)
model3 <- lm(ReviewStars ~ experience + price + wine + cheese + sauce + city
             + (experience*city + price*city + wine*city + cheese*city + sauce*city), data=data)
display(model3)
# took too long to run...

# same model, but with state instead of city
model4 <- lm(ReviewStars ~ experience + price + wine + cheese + sauce + state
             + (experience*state + price*state + wine*state + cheese*state + sauce*state), data=data)
display(model4) # such low R-squared!!!!!!!!! 

# ok let's just look at a few word indicators: experience and price. 
# without city/state or interactions, R-squared of 0.01
model5 <- lm(ReviewStars ~ experience + price + city, data=data)
display(model5)
# bumps up to 0.03, maybe random effects?

########################################### RANDOM EFFECTS ###########################################

model1 <- lmer(ReviewStars ~ experience + price + experience*state + price*state 
               + (1 | state), data=data)

model2 <- lmer(ReviewStars ~ experience + price + experience*city + price*city 
               + (1 | city), data=data)
# fixed-effect model matrix is rank deficient so dropping 167 columns / coefficients
summary(model2)
AIC(model1,model2)
#         df      AIC
# model1  50 520612.1
# model2 435 519047.3

# look into adding BusinessStars
model3 <- lmer(ReviewStars ~ PriceRange + experience + price + experience*state + price*state
               + (1 | state), data = data)

# fixed-effect model matrix is rank deficient so dropping 4 columns / coefficients

summary(model3)
AIC(model1,model2,model3) 

#        df      AIC
# model1  50 520612.1
# model2 435 519047.3
# model3  50 517283.1

#  cool, let's keep PriceRange... what if we add interaction with that too? 

model4 <- lmer(ReviewStars ~ PriceRange + experience + price + PriceRange*state + PriceRange*state
               + (1 | state), data = data)
# fixed-effect model matrix is rank deficient so dropping 4 columns / coefficients

# random effect on pricerange instead
model5 <- lmer(ReviewStars ~ PriceRange + experience + price +
               + (1 +PriceRange|state)+(1|business_id), data = data)
AIC(model5) # AIC: 504354.3

library(merTools)
plotFEsim(FEsim(model5))

# state and pricerange effect, biz id random effect
# experience and price true , negative rating
# price range high is associated with positive rating
plotREsim(REsim(model5))
# not much state level effect
# not much pricerange effect
# biz id variability



model5 <- lmer(ReviewStars ~ PriceRange + experience + price +
                 + (1 | state)+(1|business_id), data = data)

AIC(model5) # slightly higher, would be better since we have fewer parameters (removing pricerange)
plotREsim(REsim(model5)) # removed pricerange so only biz id and state
# state level difference for large effect -- .1 get that much boost being in that state...
# biz effect is taking that away


model5 <- lmer(ReviewStars ~ PriceRange + experience + price + wine + cheese + sauce
                 + (1 | state)+(1|business_id), data = data)

plotFEsim(FEsim(model5)) # sauce wasn't good, sauce was delish
# if you wanna dig into it -- simulation
plotREsim(REsim(model5)) # doesn't change much



AIC(model3,model4,model5) 
#        df      AIC
# model3 50 517283.1
# model4 34 517241.2
# model5 34 516797.7

# grow model 5
model6 <- lmer(ReviewStars ~ PriceRange + experience + price + 
                 state*experience + state*price + PriceRange*state + PriceRange*state
               + (1 | PriceRange), data = data)

# dropping 9 cols

# add state
model7 <- lmer(ReviewStars ~ PriceRange + experience + price + state + 
                 state*experience + state*price + PriceRange*state + PriceRange*state
               + (1 | PriceRange), data = data)
# dropping 9 cols
AIC(model5,model6,model7)
#        df      AIC
# model5 34 516797.7
# model6 61 516796.6
# model7 61 516796.6
# model7 is hardly better...

# add 2 more interactions
model8 <- lmer(ReviewStars ~ PriceRange + experience + price + state + 
                 PriceRange*experience + PriceRange*state +
                 state*experience + state*price + PriceRange*state + PriceRange*state
               + (1 | PriceRange), data = data)
# again, dropping 9 cols
#      df      AIC
# model5 34 516797.7
# model7 61 516796.6
# model8 62 516698.1

AIC(model5,model7,model8)

# model8 is worse
# conclusion: model7 is best, but not by far... maybe model5 is good for now.
# what is model 5 again?

lmer(ReviewStars ~ PriceRange + experience + price + PriceRange*state + PriceRange*state
     + (1 | PriceRange), data = data)
# fixed-effect model matrix is rank deficient so dropping 4 columns / coefficients


# why don't we add state in front of this? doesn't work

# model9 <- lmer(ReviewStars ~ PriceRange + experience + price + PriceRange*state + PriceRange*state
#               + (state | PriceRange), data = data)
# dropping 4 cols

# switch the 2
# model10 <- lmer(ReviewStars ~ PriceRange + experience + price + PriceRange*state + PriceRange*state
#               + (PriceRange | state), data = data)
# dropping 4 cols
# AIC(model5,model9,model10)
