# DOD_P4_Histology_Biomarkers_Porcine_JV_PowerAnalysis

## Overview

This repository contains power analysis simulations for **Hypothesis 1.1** under Project 4 (P4) of a Department of Defense (DoD)-funded study examining the effectiveness of **jugular vein (JV) compression** in mitigating blast-induced brain injury in a porcine model. Specifically, the analysis focuses on **tissue-level histological biomarkers**—Iba1 and AT8 thresholds—as surrogate outcomes for indirect injury measures like blood biomarkers and white matter integrity.

## Repository Structure

```
DOD_P4_Histology_Biomarkers_Porcine_JV_PowerAnalysis/
├── P4_H1.1_20percent.R
├── P4_H1.1_15percent.R
├── P4_H2.1_ETA.R
├── P4_H2.2_behavioral_analysis.R
├── DOD_P4_H22.csv
└── README.md

```

## Hypothesis 1.1

> JV compression will reduce pre- to post-blast histological signs of brain injury (axonal damage and glial response) in pigs, relative to the non-collar group.

---

## Methodology

### 1. Biomarkers and Measurements

The following histological thresholds were used:
- **Iba1**: ibal1, ibal2, ibal3
- **AT8**: at81, at82, at83

Each metric includes post-blast mean and standard error (SE) values for the **Collar** and **Non-Collar** groups, based on published data. Group sample sizes:
- Collar: `n = 8`
- Non-Collar: `n = 6`

### 2. Pre-blast Simulation

As the original study lacked pre-blast measurements, baseline values were simulated based on existing blast literature (e.g., Shridharani et al., 2012), indicating baseline responses are typically 10–20% of post-blast values.

Two scenarios were tested:
- **20% Scaling**: Pre-blast values set to 20% of post-blast means
- **15% Scaling**: Pre-blast values set to 15% of post-blast means

### 3. Covariate Simulation

- **Sex** was included as a covariate by simulating equal sample sizes within each group, with minor mean and variance shifts to reflect sex-related biological variability.
- Covariate-adjusted analysis was performed using ANCOVA.

### 4. Effect Size Calculation

- **Interaction effects** were computed as the difference in pre-post changes between the Collar and Non-Collar groups, standardized by a pooled SD.
- **Cohen’s f²** was calculated and used as input for power analysis.
- Power analysis was conducted using `pwr.f2.test()` in R for:
  - α = 0.05
  - Power = 0.80
  - 2 numerator degrees of freedom (Group × Time interaction)

---

## File Descriptions

| File | Description |
|------|-------------|
| `P4_H1.1_20percent.R` | Simulation and power analysis assuming pre-blast values = 20% of post-blast |
| `P4_H1.1_15percent.R` | Simulation and power analysis assuming pre-blast values = 15% of post-blast |

---

## Results Summary

### Key Outputs per Biomarker:
For each measurement (e.g., `ibal1`, `at83`, etc.), the scripts output:
- Interaction effect size (Cohen’s d)
- Cohen’s f²
- Estimated total sample size (Collar + Non-Collar) to detect interaction at 80% power

### Interpretation
- Higher effect sizes (e.g., from ibal3 or at83) require **smaller sample sizes**.
- Conservative planning based on larger required samples (e.g., ibal1) can inform group sizes accounting for dropout or poor data quality.

## Hypothesis 2.1 – DTI Metrics Power Analysis (FA, MD, AD, fiso, ficvf, odi)

### Objective

Hypothesis 2.1 assesses whether **JV occlusion** mitigates pre- to post-blast white matter integrity changes in pigs, using **diffusion tensor imaging (DTI)** and **NODDI**-based scalar metrics.

> JV compression will mitigate pre- to post-blast changes in white matter metrics (FA, MD, AD, fiso, ficvf, and odi) relative to the non-collar group.

---

### Methodology

#### 1. Input Data

- **Participants**:
  - Collar Group: *n = 11 pigs*
  - Noncollar Group: *n = 10 pigs*
- **Metrics analyzed**:
  - Fractional Anisotropy (**FA**)
  - Mean Diffusivity (**MD**)
  - Axial Diffusivity (**AD**)
  - Free Water Fraction (**fiso**)
  - Intracellular Volume Fraction (**ficvf**)
  - Orientation Dispersion Index (**odi**)

Each pig has paired **pre** and **post** blast values for all six metrics.

#### 2. Analysis Approach

- **Group × Time interaction effect size** was computed using the change from pre to post for each group, standardized by the pooled standard deviation across groups.
- **Cohen’s d** for interaction was computed per metric:

  \[
  d = \frac{(\text{ΔNoncollar} - \text{ΔCollar})}{\text{Pooled SD}}
  \]

- **Eta squared (η²)** values were derived from interaction d values using:

  \[
  \eta^2 = \frac{d^2}{d^2 + 4}
  \]

#### 3. Covariates

While not explicitly modeled in this script, the full experimental design considers three covariates in ANCOVA models. These covariates (e.g., age, weight, scanner type) are assumed to be normally distributed and incorporated during power estimation.

---

### Outputs

The following table summarizes the **interaction effect sizes** (Cohen’s d) and **converted η²** values for each DTI/NODDI metric:

| Metric | Cohen's d | η² (rounded) |
|--------|-----------|--------------|
| FA     | -0.983    | 0.195        |
| MD     | -0.837    | 0.149        |
| AD     |  1.669    | 0.410        |
| fiso   |  1.629    | 0.399        |
| ficvf  | *(not shown in this excerpt)* | *(computed in full script)* |
| odi    | *(not shown in this excerpt)* | *(computed in full script)* |

> Note: Negative d values represent reductions in the collar group relative to the noncollar group.

---

### Purpose

These η² values are used to inform sample size estimation and statistical power calculations for the study’s imaging-related Aim 2. Power analysis with covariate adjustment is conducted separately (see `P4_H2.1_power_analysis.R` for full implementation).

## Hypothesis 2.2 – Behavioral Performance and Interaction Effects

### Objective

Hypothesis 2.2 evaluates whether **JV compression** reduces **pre- to post-blast changes in motor performance** (e.g., left/right limb function) in a porcine model. Performance was quantified through sensor-based kinematic data collected from both the left and right limbs.

> JV compression will mitigate motor performance declines after blast exposure compared to the non-collar group.

---

### Methodology

#### 1. Input Data

- Source: `DOD_P4_H22.csv`
- Data structure:
  - Group (Collar / Non-Collar)
  - Repeated measures for:
    - Pre_left, Post_left
    - Pre_right, Post_right
- Total subjects: `n = 22`

#### 2. Preprocessing

- Data was reshaped into long format with `Time` (Pre, Post) and `Side` (left, right) as factors.
- Summary plots were created to visualize **mean values** over time, by group and side.
- Initial interaction effect analysis was performed on the **left side** only using a 2×2 ANOVA:
  - **Group (Collar vs Non-Collar)** × **Time (Pre vs Post)**

#### 3. Effect Size Estimation

- The interaction sum of squares (SS) and total SS were used to compute:
  - **η² for Group × Time** interaction
- Partial eta-squared was also computed via Type III repeated-measures ANOVA (`afex::aov_car`).

##### Example Outputs:
- Total SS: 0.28462
- Interaction SS: 0.05134
- **η² (Group × Time)** ≈ 0.181
- **Partial η²** ≈ 0.222

#### 4. Power Simulation with Covariates

To account for potential covariates (e.g., sex, scanner, weight), a **simulation-based power analysis** was conducted assuming:
- Effect size: 0.0545 (from η²)
- 3 covariates simulated from a multivariate normal distribution
- Covariate effect size: β = 0.32
- Outcome modeled via linear regression
- 1000 iterations per sample size

The sample size was iteratively increased until power ≥ 80% at α = 0.05.

##### Result:
- **Estimated sample size needed**: `n = 90` (based on simulation achieving ≥ 0.80 power)

---

### Outputs

- `P4_H2.2_behavioral_analysis.R`: Full data processing, visualization, ANOVA, effect size computation, and simulation-based power estimation with covariates.
- Interaction plots of pre vs post changes by group and side
- Final summary of both η² and partial η²

---

### Interpretation

This analysis supports study planning for detecting motor performance improvements attributable to JV compression. Power simulations with covariates provide a more robust sample size recommendation, accounting for confounding effects.


