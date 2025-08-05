library(ggplot2)
library(dplyr)
library(tidyr)
library(MASS)
library(data.table)
library(afex)

data <- fread("/Users/hung-ihsiao/Downloads/DOD_P4_H22.csv", sep = ",")

data

data_long <- data %>%
  pivot_longer(cols = c(Pre_left, Post_left, Pre_right, Post_right), 
               names_to = c("Time", "Side"), 
               names_sep = "_", 
               values_to = "Value")

data_long$Time <- factor(data_long$Time, levels = c("Pre", "Post"))

mean_data_correct <- data_long %>%
  group_by(Group, Time, Side) %>%
  summarise(Mean_Value = mean(Value, na.rm = TRUE))

ggplot(mean_data_correct, aes(x = Time, y = Mean_Value, color = Group, group = interaction(Group, Side))) +
  geom_point(size = 3) +
  geom_line(size = 1.2) +
  facet_wrap(~ Side, scales = "free_y") +
  labs(title = "Pre vs Post Exposure Mean for Left and Right Measurements",
       x = "Time (Pre vs Post)", 
       y = "Mean Value") +
  theme_minimal() +
  theme(legend.title = element_blank())

data_left <- data_long %>% filter(Side == "left")

data_left$Group <- factor(data_left$Group)
data_left$Time <- factor(data_left$Time, levels = c("Pre", "Post"))

model <- aov(Value ~ Group * Time, data = data_left)

anova_table <- summary(model)[[1]]
print(anova_table)

ss_total <- sum(anova_table[["Sum Sq"]])
ss_interaction <- anova_table["Group:Time", "Sum Sq"]
eta_squared_interaction <- ss_interaction / ss_total
eta_squared_interaction

simulate_sample_size_with_covs <- function(n, effect_size, num_covariates = 3, alpha = 0.05, num_sim = 1000) {
  success_count <- 0
  for (i in 1:num_sim) {
    covariates <- mvrnorm(n = n, mu = rep(0, num_covariates), Sigma = diag(num_covariates))
    beta_covs <- rep(0.32, num_covariates)
    beta_interaction <- effect_size
    intercept <- 0
    X <- cbind(1, covariates)
    errors <- rnorm(n, mean = 0, sd = 1)
    outcome <- X %*% c(intercept, beta_covs) + beta_interaction + errors
    model <- lm(outcome ~ covariates)
    p_value <- summary(model)$coefficients[4, 4]
    if (p_value < alpha) {
      success_count <- success_count + 1
    }
  }
  estimated_power <- success_count / num_sim
  return(estimated_power)
}

n_initial <- 70
effect_size <- 0.05450809
alpha <- 0.05
desired_power <- 0.80

while (TRUE) {
  power_estimation <- simulate_sample_size_with_covs(n = n_initial, effect_size = effect_size)
  cat("Sample Size:", n_initial, " | Estimated Power:", power_estimation, "\n")
  if (power_estimation >= desired_power) {
    cat("Achieved desired power with sample size:", n_initial, "\n")
    break
  }
  n_initial <- n_initial + 2
}




data_left$ID <- rep(1:22, each = 2) 

model_afex <- aov_car(Value ~ Group * Time + Error(ID/Time), data = data_left, type = 3)


anova_summary <- summary(model_afex)
anova_summary


ss_time <- 0.05361  
ss_group_time <- 0.05134  
ss_error <- 0.17967  


partial_eta_squared_group_time <- ss_group_time / (ss_group_time + ss_error)
partial_eta_squared_group_time