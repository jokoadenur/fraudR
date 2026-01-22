![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
![CRAN Version](https://img.shields.io/badge/CRAN-7.3.2-brightgreen)
![Open Issues](https://img.shields.io/badge/open%20issues-0-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue)

<img width="500" height="500" alt="fraudR-removebg-preview" src="https://github.com/user-attachments/assets/3eca6d26-1ede-41f3-8ccf-f2c47c7075ec" />


# fraudR

`fraudR` is an R package for **forensic data analysis** designed to detect  
**potential data fraud, human manipulation, or human error** in numeric datasets.

The package applies _multiple statistical forensic signals approcah_, including digit
preference, entropy collapse, smoothness anomalies, and temporal pattern
regularity—to generate an interpretable **fraud risk score** for each numeric
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

**Interpretation Guide**:

<img width="988" height="242" alt="image" src="https://github.com/user-attachments/assets/f236a88a-eb21-45fb-b192-2a42e6fd02a0" />

hint: `fraudR` provides statistical signals, not legal proof. Results should be interpreted alongside domain knowledge.

**Author**

Joko Ade Nursiyono
Data Analyst (East Java, BPS-Statistics Indonesia)

**Citation**

If you use fraudR in research or official reports, please cite:
```
Nursiyono, J. A. (2026). fraudR: Statistical Forensic Detection of Data Fraud in R.
```
  
  Optional additional columns such as color, group, or category can be used to further customize the visualization.
