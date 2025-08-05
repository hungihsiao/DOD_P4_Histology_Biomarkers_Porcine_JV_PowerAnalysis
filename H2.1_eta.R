library(dplyr)

data <- data.frame(
  Group = c("Noncollar", "Noncollar", "Noncollar", "Noncollar", "Noncollar", "Noncollar", 
            "Noncollar", "Noncollar", "Noncollar", "Noncollar", 
            "collar", "collar", "collar", "collar", "collar", "collar", 
            "collar", "collar", "collar", "collar", "collar"),
  FA_Pre = c(0.62438, 0.634884, 0.625828, 0.668577, 0.672169, 0.568289, 
             0.655434, 0.577244, 0.657304, 0.668433, 
             0.666438, 0.609098, 0.797478, 0.633361, 0.641137, 0.585547, 
             0.724058, 0.653797, 0.614673, 0.717971, 0.627917),
  FA_pst = c(0.712852, 0.635183, 0.677045, 0.717732, 0.668394, 0.624356, 
             0.643289, 0.582477, 0.643364, 0.710236, 
             0.67602, 0.658146, 0.784302, 0.655841, 0.613979, 0.597683, 
             0.693532, 0.653565, 0.61929, 0.65554, 0.601279),
  MD_Pre = c(0.000623, 0.00067, 0.000609, 0.00061, 0.000558, 0.000694, 
             0.000637, 0.00071, 0.000582, 0.000633, 
             0.000618, 0.000647, 0.000462, 0.000566, 0.000526, 0.000634, 
             0.000598, 0.000635, 0.000591, 0.000568, 0.000633),
  MD_pst = c(0.00051, 0.000676, 0.000561, 0.00055, 0.000594, 0.000608, 
             0.000623, 0.000679, 0.000589, 0.000595, 
             0.000629, 0.000653, 0.000502, 0.000523, 0.000591, 0.000617, 
             0.00062, 0.000655, 0.000609, 0.000636, 0.000633),
  AD_Pre = c(0.001136, 0.001245, 0.001106, 0.001166, 0.001083, 0.001194, 
             0.001193, 0.001233, 0.001083, 0.001198, 
             0.001196, 0.001166, 0.000978, 0.001032, 0.000965, 0.001119, 
             0.001209, 0.001168, 0.001078, 0.001128, 0.001174),
  AD_pst = c(0.001014, 0.001264, 0.001056, 0.001082, 0.001132, 0.00109, 
             0.001169, 0.00118, 0.001099, 0.001185, 
             0.001214, 0.001221, 0.001056, 0.000958, 0.001068, 0.001107, 
             0.001226, 0.001228, 0.001107, 0.001196, 0.001115),
  fiso_Pre = c(0.14962, 0.075244, 0.08551, 0.029719, 0.033043, 0.074514, 
               0.062832, 0.067073, 0.105868, 0.103368, 
               0.075968, 0.113971, 0.106086, 0.18967, 0.041295, 0.170465, 
               0.125389, 0.138103, 0.07778, 0.192278, 0.117676),
  fiso_pst = c(0.11731, 0.208591, 0.072887, 0.148686, 0.11311, 0.139143, 
               0.095012, 0.107201, 0.131869, 0.0906, 
               0.086806, 0.058067, 0.037287, 0.166282, 0.071074, 0.176616, 
               0.088554, 0.11531, 0.05844, 0.054186, 0.136656),
  ficvf_Pre = c(0.621502, 0.526618, 0.62247, 0.56557, 0.692352, 0.524418, 
                0.576095, 0.471343, 0.675605, 0.598878, 
                0.592215, 0.6068, 0.902696, 0.762667, 0.804932, 0.586087, 
                0.694149, 0.690264, 0.614645, 0.835713, 0.589576),
  ficvf_pst = c(0.792561, 0.633121, 0.731297, 0.788519, 0.833421, 0.711171, 
                0.59957, 0.522188, 0.671108, 0.678257, 
                0.600977, 0.607898, 0.815936, 0.858892, 0.66555, 0.616766, 
                0.628497, 0.624238, 0.607499, 0.583657, 0.567706),
  odi_Pre = c(0.124131, 0.103356, 0.138493, 0.101503, 0.136942, 0.12666, 
              0.114919, 0.110935, 0.134179, 0.109781, 
              0.110211, 0.117925, 0.115146, 0.148637, 0.16905, 0.131525, 
              0.1036, 0.123724, 0.141967, 0.123432, 0.113731),
  odi_pst = c(0.12545, 0.104738, 0.137182, 0.127318, 0.129286, 0.148183, 
              0.126269, 0.11718, 0.13464, 0.114713, 
              0.103179, 0.115318, 0.092974, 0.167368, 0.144769, 0.133535, 
              0.099773, 0.109789, 0.135833, 0.107571, 0.127958)
)

summary_stats <- data %>%
  group_by(Group) %>%
  summarise(
    FA_Pre_mean = mean(FA_Pre), FA_Pre_sd = sd(FA_Pre),
    FA_pst_mean = mean(FA_pst), FA_pst_sd = sd(FA_pst),
    MD_Pre_mean = mean(MD_Pre), MD_Pre_sd = sd(MD_Pre),
    MD_pst_mean = mean(MD_pst), MD_pst_sd = sd(MD_pst),
    AD_Pre_mean = mean(AD_Pre), AD_Pre_sd = sd(AD_Pre),
    AD_pst_mean = mean(AD_pst), AD_pst_sd = sd(AD_pst),
    fiso_Pre_mean = mean(fiso_Pre), fiso_Pre_sd = sd(fiso_Pre),
    fiso_pst_mean = mean(fiso_pst), fiso_pst_sd = sd(fiso_pst),
    ficvf_Pre_mean = mean(ficvf_Pre), ficvf_Pre_sd = sd(ficvf_Pre),
    ficvf_pst_mean = mean(ficvf_pst), ficvf_pst_sd = sd(ficvf_pst),
    odi_Pre_mean = mean(odi_Pre), odi_Pre_sd = sd(odi_Pre),
    odi_pst_mean = mean(odi_pst), odi_pst_sd = sd(odi_pst)
  )

pooled_sd <- function(sd1, sd2, n1, n2) {
  return(sqrt(((n1 - 1) * sd1^2 + (n2 - 1) * sd2^2) / (n1 + n2 - 2)))
}

n1 <- 10  
n2 <- 11  

effect_sizes <- data.frame(Measure = character(), Interaction_Effect_Size = numeric(), stringsAsFactors = FALSE)

variables <- c("FA", "MD", "AD", "fiso", "ficvf", "odi")

for (var in variables) {
  pre_noncollar_mean <- summary_stats[[paste0(var, "_Pre_mean")]][summary_stats$Group == "Noncollar"]
  post_noncollar_mean <- summary_stats[[paste0(var, "_pst_mean")]][summary_stats$Group == "Noncollar"]
  pre_collar_mean <- summary_stats[[paste0(var, "_Pre_mean")]][summary_stats$Group == "collar"]
  post_collar_mean <- summary_stats[[paste0(var, "_pst_mean")]][summary_stats$Group == "collar"]
  
  pre_noncollar_sd <- summary_stats[[paste0(var, "_Pre_sd")]][summary_stats$Group == "Noncollar"]
  post_noncollar_sd <- summary_stats[[paste0(var, "_pst_sd")]][summary_stats$Group == "Noncollar"]
  pre_collar_sd <- summary_stats[[paste0(var, "_Pre_sd")]][summary_stats$Group == "collar"]
  post_collar_sd <- summary_stats[[paste0(var, "_pst_sd")]][summary_stats$Group == "collar"]
  
  delta_noncollar <- post_noncollar_mean - pre_noncollar_mean
  delta_collar <- post_collar_mean - pre_collar_mean
  
  sd_pooled <- pooled_sd(pre_noncollar_sd, pre_collar_sd, n1, n2)
  
  interaction_d <- (delta_noncollar - delta_collar) / sd_pooled
  
  effect_sizes <- rbind(effect_sizes, data.frame(Measure = var, Interaction_Effect_Size = interaction_d))
}

print(effect_sizes)


cohen_d_to_eta_squared <- function(d) {
  eta_squared <- d^2 / (d^2 + 4)
  return(eta_squared)
}

round(cohen_d_to_eta_squared(-0.9829437), 3)
round(cohen_d_to_eta_squared(-0.8374358), 3)
round(cohen_d_to_eta_squared(1.6686192), 3)
round(cohen_d_to_eta_squared(1.6294144), 3)