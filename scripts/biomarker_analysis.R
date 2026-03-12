# Breast Cancer Biomarker Analysis

library(tidyverse)
library(broom)

# Load data
breast_data <- read.csv("data/breast_cancer_dataset.csv")

# Convert diagnosis to binary
breast_data$diagnosis_binary <- ifelse(breast_data$diagnosis == "M", 1, 0)

# Logistic regression
model <- glm(diagnosis_binary ~ radius_mean + texture_mean + area_mean,
             data = breast_data,
             family = binomial)

summary(model)

# Odds ratios
exp(coef(model))

# Forest plot
tidy_model <- tidy(model, exponentiate = TRUE, conf.int = TRUE)

plot <- ggplot(tidy_model[-1,], aes(x = term, y = estimate)) +
  geom_point(size=3) +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width=0.2) +
  coord_flip() +
  labs(title = "Odds Ratios for Breast Cancer Biomarkers",
       x = "Biomarker",
       y = "Odds Ratio") +
  theme_minimal()

ggsave("figures/biomarker_forest_plot.png", plot, width=8, height=6)
