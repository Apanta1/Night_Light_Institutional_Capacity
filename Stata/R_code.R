
setwd("/Users/apanta1/Desktop/Summer Research 2024/Night_Light_Institutional_Capacity/Stata")

# Load necessary libraries
library(tidyverse)
library(readr)
library(dplyr)
library(tidyr)
library(broom)
library(ggplot2)
library(data.table)

#load the dataset
data <- read_csv("Local_Gov_Dataset_of_Nepal.csv")

# Drop municipalities without data
data <- data %>% filter(lisa_20_21 != "N/A", lisa_21_22 != "N/A")

# Convert to numeric
data <- data %>%
  mutate(lisa_20_21 = as.numeric(lisa_20_21),
         lisa_21_22 = as.numeric(lisa_21_22))

# Calculate new variables
data <- data %>%
  mutate(baseline_nl = rowMeans(select(., sum_2014:sum_2017), na.rm = TRUE),
         ln_baseline_nl_km = log(baseline_nl / area_kmsq),
         rel_chgnl = log(sum_2021) - log(sum_2017),
         ln_popn = log(popn_2021),
         high_school_percent = ((popn_highschool + popn_graduate + popn_post_graduate) / popn_2021) * 100,
         urban_num = ifelse(UNIT_TYPE != "Gaunpalika", 1, 0),
         gov_coalitiion = ifelse(`Political Affiliation` %in% c("CPN-MC", "CPN-UML", "FSFN", "NSP"), 1, 0),
         female = ifelse(Sex == "Female", 1, 0),
         lisa_avg = rowMeans(select(., lisa_20_21, lisa_21_22), na.rm = TRUE))

setnames(data, "Age at Election", "ageatelection")

print(names(data))

lm(rel_chgnl ~ ln_baseline_nl_km, data = data)

#running initial regression
model1 <- lm(rel_chgnl ~ ln_baseline_nl_km, data = data)
model2 <- lm(rel_chgnl ~ ln_baseline_nl_km + lisa_avg, data = data)
model3 <- lm(rel_chgnl ~ ln_baseline_nl_km + lisa_avg + high_school_percent, data = data)
model4 <- lm(rel_chgnl ~ ln_baseline_nl_km + lisa_avg + high_school_percent + ageatelection, data = data)
model5 <- lm(rel_chgnl ~ ln_baseline_nl_km + lisa_avg + high_school_percent + ageatelection + gov_coalitiion, data = data)
model6 <- lm(rel_chgnl ~ ln_baseline_nl_km + lisa_avg + high_school_percent + ageatelection + gov_coalitiion + female, data = data)
model7 <- lm(rel_chgnl ~ ln_baseline_nl_km + lisa_avg + high_school_percent + ageatelection + gov_coalitiion + female + ln_popn, data = data)
model8 <- lm(rel_chgnl ~ ln_baseline_nl_km + cop_cor_ + high_school_percent + ageatelection + gov_coalitiion + female + ln_popn + urban_num, data = data)


print(summary(model8))

model11 <- lm (cop_cor_20_21 ~ ageatelection, data = data)
print(summary(model11))

# Load the stargazer library
library(stargazer)

# Save the regression results to a .doc file
stargazer(model1, model2, model3, model4, model5, model6, model7, type = "html", out = "R_regression_result.doc")


ggplot(data, aes(cop_cor_20_21, rel_chgnl)) + 
  geom_point(aes(color = gov_coalitiion)) + 
  geom_smooth() + 
  labs( x = "cooperation and coordination score",
        y = "relative change in nightlight")+
  theme_minimal()

ggplot(data, aes(ageatelection, cop_cor_21_22)) + geom_point() + 
  geom_smooth() + theme_minimal()



ggplot(data, aes(x = lisa_avg, y = rel_chgnl)) + 
  geom_point (size = high_school_percent) + 
  geom_smooth(method = "lm", se = F) +
  theme_minimal()

print(names(data))
