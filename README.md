![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
![CRAN Version](https://img.shields.io/badge/CRAN-7.3.2-brightgreen)
![Open Issues](https://img.shields.io/badge/open%20issues-0-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue)

<img width="500" height="500" alt="fraudR-removebg-preview" src="https://github.com/user-attachments/assets/3eca6d26-1ede-41f3-8ccf-f2c47c7075ec" />


# fraudR

`fraudR` is an R package for **forensic data analysis** designed to detect  
**potential data fraud, human manipulation, or human error** in numeric datasets.

## Dataset Requirements

A numeric variable will be analyzed by `fraud_score()` only if all conditions below are met: (1) Data type: numeric; (2) Minimum observations: ≥ 10 non-missing values; (3) Minimum unique values: ≥ 5 distinct values; (4) Structure: ordered data (time column optional; row order used if absent). 

## How to Check Your Data?

```R
x <- data$variable
is.numeric(x) &&
sum(!is.na(x)) >= 10 &&
length(unique(x[!is.na(x)])) >= 5
```
## Recommended Structure
```R
data.frame(
  time = 1:n,        # optional
  var1 = numeric(n),
  var2 = numeric(n)
)
```

Variables not meeting these criteria are automatically skipped to avoid unreliable fraud detection.
The package applies _multiple statistical forensic signals approcah_, including digit
preference, entropy collapse, smoothness anomalies, and temporal pattern
regularity, to generate an interpretable **fraud risk score** for each numeric
variable in a dataset.

`fraudR` is suitable for:
- Official statistics and administrative data
- Financial and economic indicators
- Monitoring data quality in surveys and reports
- Early-warning detection of suspicious patterns

---

## Installation

To install the development version of `fraudR` from GitHub, run:

```R
# Install from GitHub
devtools::install_github("jokoadenur/fraudR")
```

> **Note:** If prompted to update packages (options such as 1. All, 2. CRAN, etc.), simply press **ENTER** to skip. Wait until the message `DONE (fraudR)` appears.

After installation, activate the package with the following code:

```R
# Activate the package
library(fraudR)
```

## Usage
**Main Functions**
1. fraud_score()

Computes a fraud risk score for each numeric variable in a dataset using multiple forensic indicators.
```R
fraud_score(dataset)
```
_What it detects?_ (1) Digit preference bias; (2) Entropy collapse in differences and second differences; (3) Benford deviation on data changes; (4) Over-smoothness / rigidity; and (5) Excessively strong linear patterns (R²)

_And what it's Output?_ (1) A data frame containing:(a) fraud_score (0–1); (2) fraud_percent (0–100%); (3) risk_level (LOW / MEDIUM / HIGH)

Example:
```R
fraud_score(hasil_cek_sampah)
Variable 'Produksi1' shows a potential manipulation score of 19.3% - Risk level: LOW
Variable 'Produksi2' shows a potential manipulation score of 19.3% - Risk level: LOW
Variable 'Produksi3' shows a potential manipulation score of 19.1% - Risk level: LOW
Variable 'Produksi4' shows a potential manipulation score of 19.4% - Risk level: LOW
Variable 'Produksi5' shows a potential manipulation score of 18.6% - Risk level: LOW
Variable 'Produksi6' shows a potential manipulation score of 19.3% - Risk level: LOW
Variable 'Pendapatan1' shows a potential manipulation score of 25.5% - Risk level: LOW
Variable 'Pendapatan2' shows a potential manipulation score of 25% - Risk level: LOW
Variable 'Pendapatan3' shows a potential manipulation score of 25.5% - Risk level: LOW
Variable 'Pendapatan4' shows a potential manipulation score of 25.5% - Risk level: LOW
Variable 'Pendapatan5' shows a potential manipulation score of 25.1% - Risk level: LOW
Variable 'Pendapatan6' shows a potential manipulation score of 23.9% - Risk level: LOW
Variable 'Harga1' shows a potential manipulation score of 7.2% - Risk level: LOW
Variable 'Harga2' shows a potential manipulation score of 10.3% - Risk level: LOW
Variable 'Harga3' shows a potential manipulation score of 6% - Risk level: LOW
Variable 'Harga4' shows a potential manipulation score of 7.7% - Risk level: LOW
Variable 'Harga5' shows a potential manipulation score of 7.6% - Risk level: LOW
Variable 'Harga6' shows a potential manipulation score of 8.1% - Risk level: LOW
Variable 'harga_median' shows a potential manipulation score of 6.6% - Risk level: LOW
Variable 'Harga_adj1' shows a potential manipulation score of 6.7% - Risk level: LOW
Variable 'Harga_adj2' shows a potential manipulation score of 8.4% - Risk level: LOW
Variable 'Harga_adj3' shows a potential manipulation score of 5.6% - Risk level: LOW
Variable 'Harga_adj4' shows a potential manipulation score of 6.7% - Risk level: LOW
Variable 'Harga_adj5' shows a potential manipulation score of 6.7% - Risk level: LOW
Variable 'Harga_adj6' shows a potential manipulation score of 6.6% - Risk level: LOW
```

**Interpretation Guide**:

<img width="988" height="242" alt="image" src="https://github.com/user-attachments/assets/f236a88a-eb21-45fb-b192-2a42e6fd02a0" />

hint: `fraudR` provides statistical signals, not legal proof. Results should be interpreted alongside domain knowledge.

2. plot_fraud_signature()

Visualizes forensic signatures for a selected numeric variable.
```R
plot_fraud_signature(dataset, "variable")
```
_The plot includes_: (1) Time-series pattern with regression trend; (2) Last-digit distribution; (3) Distribution of first differences (Δ); and (4) Entropy collapse across data layers

_Example_
```R
plot_fraud_signature(dataset, "Produksi1")
```
_The result_
<img width="1070" height="766" alt="image" src="https://github.com/user-attachments/assets/b009bd4b-f804-4c90-9ab3-adfe4c0ebc88" />

**Author**

Joko Ade Nursiyono

Data Analyst (East Java, BPS-Statistics Indonesia)

**Citation**

If you use fraudR in research or official reports, please cite:
```
Nursiyono, J. A. (2026). fraudR: Statistical Forensic Detection of Data Fraud in R.
```
  
  Optional additional columns such as color, group, or category can be used to further customize the visualization.
