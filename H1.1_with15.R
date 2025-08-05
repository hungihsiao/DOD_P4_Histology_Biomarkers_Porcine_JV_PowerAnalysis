library(tidyr)
library(dplyr)
library(ggplot2)
library(reshape2)
library(pwr)

data <- data.frame(
  Measurement = c("ibal1", "ibal2", "ibal3", "at81", "at82", "at83"),
  Injured_Collar_Mean = c(30.26563, 5.410924, 1.320725, 9.392619, 2.448499, 0.958879),
  Injured_Collar_SE = c(2.798241, 1.263142, 0.385982, 1.491297, 0.391716, 0.111136),
  Injured_Non_Collar_Mean = c(41.19826, 10.25221, 3.023864, 11.44914, 4.958143, 1.515841),
  Injured_Non_Collar_SE = c(2.974156, 2.259893, 0.924089, 2.428651, 1.628793, 0.320597)
)

set.seed(123)
scaling_factor <- 0.15

data$Pre_Injured_Collar <- rnorm(nrow(data), mean = scaling_factor * data$Injured_Collar_Mean, sd = 0.1 * data$Injured_Collar_SE)
data$Pre_Injured_Non_Collar <- rnorm(nrow(data), mean = scaling_factor * data$Injured_Non_Collar_Mean, sd = 0.1 * data$Injured_Non_Collar_SE)



plot_data <- data.frame(
  Measurement = rep(data$Measurement, 2),
  Group = rep(c("Collar", "Non-Collar"), each = nrow(data)),
  Pre = c(data$Pre_Injured_Collar, data$Pre_Injured_Non_Collar),
  Post = c(data$Injured_Collar_Mean, data$Injured_Non_Collar_Mean)
)

plot_data_melted <- melt(plot_data, id.vars = c("Measurement", "Group"), variable.name = "Time", value.name = "Value")

ggplot(plot_data_melted, aes(x = Time, y = Value, group = Group, color = Group)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  facet_wrap(~ Measurement, ncol = 3, scales = "free_y") +
  labs(title = "Pre vs Post Exposure for Each Measurement", x = "Time (Pre vs Post)", y = "Value", color = "Group") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

N_collar <- 8
N_noncollar <- 6

data$Injured_Collar_SD <- data$Injured_Collar_SE * sqrt(N_collar)
data$Injured_Non_Collar_SD <- data$Injured_Non_Collar_SE * sqrt(N_noncollar)


data$Pre_Injured_Collar_Mean <- scaling_factor * data$Injured_Collar_Mean
data$Pre_Injured_Non_Collar_Mean <- scaling_factor * data$Injured_Non_Collar_Mean
data$Pre_Injured_Collar_SD <- scaling_factor * data$Injured_Collar_SD
data$Pre_Injured_Non_Collar_SD <- scaling_factor * data$Injured_Non_Collar_SD

final_data <- data.frame(
  Name = c(
    paste("Pre", data$Measurement, sep = "_"), paste("Post", data$Measurement, sep = "_"),
    paste("Pre", data$Measurement, sep = "_"), paste("Post", data$Measurement, sep = "_")
  ),
  Status = c(rep("Noncollar", 6), rep("Noncollar", 6), rep("Collar", 6), rep("Collar", 6)),
  N = c(rep(N_noncollar, 12), rep(N_collar, 12)),
  Mean = c(data$Pre_Injured_Non_Collar_Mean, data$Injured_Non_Collar_Mean, data$Pre_Injured_Collar_Mean, data$Injured_Collar_Mean),
  SD = c(data$Pre_Injured_Non_Collar_SD, data$Injured_Non_Collar_SD, data$Pre_Injured_Collar_SD, data$Injured_Collar_SD)
)

final_data

split_sex <- function(row) {
  n1 <- floor(row$N / 2)
  n2 <- row$N - n1
  mean1 <- row$Mean - 0.1 * row$SD
  mean2 <- row$Mean + 0.1 * row$SD
  sd1 <- sqrt((row$SD^2) / 2)
  sd2 <- sqrt((row$SD^2) / 2)
  
  data.frame(
    Name = rep(row$Name, 2),
    Status = rep(row$Status, 2),
    Sex = c(0, 1),
    N = c(n1, n2),
    Mean = c(mean1, mean2),
    SD = c(sd1, sd2)
  )
}

gender_df <- bind_rows(lapply(1:nrow(final_data), function(i) split_sex(final_data[i, ])))
gender_df

metrics <- unique(sub("Pre_", "", sub("Post_", "", gender_df$Name)))
results <- list()

for (metric in metrics) {
  metric_data <- gender_df[gender_df$Name %in% c(paste0("Pre_", metric), paste0("Post_", metric)), ]
  
  metric_data_wide <- reshape(metric_data, 
                              idvar = c("Status", "Sex"),
                              timevar = "Name",
                              direction = "wide")
  
  pre_var <- paste0("Mean.Pre_", metric)
  post_var <- paste0("Mean.Post_", metric)
  
  mean_sham_pre <- mean(metric_data_wide[[pre_var]][metric_data_wide$Status == "Noncollar"], na.rm = TRUE)
  mean_sham_post <- mean(metric_data_wide[[post_var]][metric_data_wide$Status == "Noncollar"], na.rm = TRUE)
  mean_blast_pre <- mean(metric_data_wide[[pre_var]][metric_data_wide$Status == "Collar"], na.rm = TRUE)
  mean_blast_post <- mean(metric_data_wide[[post_var]][metric_data_wide$Status == "Collar"], na.rm = TRUE)
  
  sd_sham_pre <- mean(metric_data_wide[[paste0("SD.Pre_", metric)]][metric_data_wide$Status == "Noncollar"], na.rm = TRUE)
  sd_sham_post <- mean(metric_data_wide[[paste0("SD.Post_", metric)]][metric_data_wide$Status == "Noncollar"], na.rm = TRUE)
  sd_blast_pre <- mean(metric_data_wide[[paste0("SD.Pre_", metric)]][metric_data_wide$Status == "Collar"], na.rm = TRUE)
  sd_blast_post <- mean(metric_data_wide[[paste0("SD.Post_", metric)]][metric_data_wide$Status == "Collar"], na.rm = TRUE)
  
  pooled_sd <- sqrt((sd_sham_pre^2 + sd_sham_post^2 + sd_blast_pre^2 + sd_blast_post^2) / 1.75)
  
  interaction_effect <- ((mean_sham_post - mean_sham_pre) - (mean_blast_post - mean_blast_pre)) / pooled_sd
  
  f_squared <- (interaction_effect^2) / 4
  
  sample_size_estimation <- pwr.f2.test(u = 2, f2 = f_squared, sig.level = 0.05, power = 0.80)
  
  total_sample_size <- ceiling(sample_size_estimation$v + 1 + 2)
  
  results[[metric]] <- list(
    interaction_effect = interaction_effect,
    f_squared = f_squared,
    sample_size_estimation = sample_size_estimation,
    sample_size_per_group = total_sample_size
  )
}

for (metric in names(results)) {
  cat("\n---", metric, "---\n")
  cat("Interaction Effect (Cohen's d):", results[[metric]]$interaction_effect, "\n")
  cat("Cohen's f^2:", results[[metric]]$f_squared, "\n")
  print(results[[metric]]$sample_size_estimation)
  cat("Estimated total sample size (collar and non collar):", results[[metric]]$sample_size_per_group, "\n")
}

