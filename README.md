# Retail Sales Analysis & Demand Forecasting – Reckitt (Vanish & Lysol)

## Project Overview
This is the final project of the EBAC **"Profesión Científico de Datos"** program, developed in collaboration with **Reckitt** using real-world data from the **Fabric Treatment and Laundry Bleach** category in Mexico. The analysis is framed around the brands **Vanish** and **Lysol**, both part of **Reckitt**, and is built from the role of a Data Scientist.

The project is an **end-to-end Data Science workflow** that prepares and cleans the data, explores it, segments it, queries it relationally, communicates it through an interactive dashboard, and finally forecasts future demand. The goal is to understand market behavior, brand performance, regional and temporal patterns, and to support strategic decisions around positioning, pricing, and marketing.

The project covers:
- Data cleaning and transformation
- Data integration from multiple sources
- Exploratory data analysis (EDA)
- Customer/product segmentation via clustering (K-Means)
- Relational data analysis with SQL
- Interactive dashboarding (Power BI)
- Sales forecasting with time series models (ARIMA)

---

## Business Context
Reckitt is a global leader in health, hygiene, and nutrition products (Vanish, Lysol, etc.). In the Mexican market, the **Fabric Treatment and Laundry Bleach** category is strategically important and highly competitive.

This project supports business questions such as:
- Brand performance across segments and regions
- Identification of key competitors
- Sales trends over time
- Detection of growth opportunities to sustain leadership and profitability
- Anticipation of future demand for planning

---

## Data Science Workflow
1. Data ingestion from multiple tables and file formats
2. Data cleaning and validation
3. Data transformation and feature preparation
4. Exploratory data analysis (EDA)
5. Segmentation with K-Means clustering
6. Relational analysis with SQL
7. Interactive visualization in Power BI
8. Demand forecasting with ARIMA
9. Conclusions and business recommendations

---

## Tools and Technologies
- **Python** – Pandas, NumPy, Matplotlib, Seaborn, Scikit-learn, Statsmodels
- **SQL** – SQL Server Management Studio (table creation, relational modeling, views with joins, CTEs, window functions)
- **Power BI** – interactive multi-page dashboard for stakeholders
- **Jupyter Notebook**
- **CSV and Excel** data handling

---

## Dataset
The source database consists of **5 tables** holding weekly sales of cleaning products across multiple regions of Mexico. Key columns include `WEEK`, `ITEM_DESCRIPTION`, `TOTAL_UNIT_SALES`, `TOTAL_VALUE_SALES`, `TOTAL_UNIT_AVG_WEEKLY_SALES` (historical baseline), `REGION`, `BRAND`, `FORMAT`, and `SEGMENT`. The data spans **January 2022 to mid-July 2023**.

---

## Pipeline Detail

### 1. Data Cleaning and Transformation (Python)
**Path:** `1-Limpieza-y-Transformación-de-Datos/`
**Notebook:** `EBAC Proyecto Parte 1 - Limpieza de Datos.ipynb`
- Loading data from CSV and Excel into multiple DataFrames
- Handling missing value and removing duplicates
- Standardizing categorical labels and converting weekly identifiers to datetime
- Merging dimension and fact tables into a consolidated analytical dataset

### 2. Exploratory Data Analysis (EDA)
**Path:** `2-Visualización-y-Analisis-Exploratorio-de-Datos/`
**Notebook:** `Proyecto con Empresa Aliada Parte 2 - Visualización de datos.ipynb`
- Scatter plots validating the relationship between unit, value, and historical sales
- Boxplots and bar charts by segment, region, and brand
- Time series line plots with confidence intervals by segment, region, and brand
- Outlier detection and brand-vs-brand comparison (Vanish vs. Lysol)

### 3. Segmentation with Clustering (K-Means)
**Path:** `3-Aprendizaje-no-supervizado-KMeans/`
**Notebook:** `EBAC Proyecto Parte 3 - Clustering con K-Means.ipynb`
- Feature selection (unit sales, historical sales, date-as-integer; Region and Format as balanced categoricals, with formats merged into a `SOLIDO` category in order to avoid overcomplexity in the model)
- Optimal `k` chosen via the elbow method and silhouette score (**k = 8**)
- Interpretation of 8 clusters and lift/over-representation analysis by brand, region, format, and segment

### 4. Relational Analysis (SQL)
**Path:** `4-Creacion-de-base-de-datos-SQL/`
**Report:** `Reporte Proyecto con empresa aliada - Parte 4 SQL.pdf`
- Creation of 5 relational tables and a consolidated view via inner joins
- Sales statistics by format, region, segment, and brand
- Brand rankings, top products per brand, and quarterly trend analysis using CTEs and window functions

### 5. Power BI Dashboard
**Path:** `5-Dashboard-interactivo-con-Power-BI/`
**Report:** `Reporte Proyecto con empresa aliada - Parte 5 Power BI.pdf`
Five interactive pages with slicers, bookmarks, drill-downs, and tooltips:
- Sales Summary
- Sales by Region
- Sales by Brand
- Top 3 Products by Brand
- Clustering Results

### 6. Sales Forecasting (ARIMA)
**Path:** `6-Pronóstico-de-Ventas-con-ARIMA/`
**Notebook:** `EBAC Proyecto Parte 6 - Pronóstico de ventas de Vanish & Lysol.ipynb`
- Stationarity check (first differencing, `d = 1`) and PACF analysis
- Hyperparameter search by AIC → best model **ARIMA(4, 1, 3)**
- 2-month forecast for Vanish + Lysol with 90% confidence intervals
- Validation: **RMSE ≈ 97.7**, **MAPE ≈ 10.5%**

---

## Key Results & Recommendations

### Findings
- **Market leaders:** The **BLEACH** and **BAR** segments dominate consistently in volume and over time; ~95% of sales concentrate in **Liquid** and **Gel** formats. **SCANNING MEXICO** is the leading region, followed by **AREA 5**.
- **Brand leadership:** **CLORALEX** leads the market (95.7% of the high-performance cluster), followed by BLANCATEL, CLOROX, and CLARASOL. The star product is high-volume liquid bleach.
- **Vanish:** Present but not a leader. Grows steadily (+22% from 2022 to 2023), driven mainly by the **BAR** segment (unlike the liquid-driven market). Ranks 3rd in the top 5 by average value sales.
- **Lysol:** Underperforming and declining (−27% from 2022 to 2023). Confined to the **SANITIZER** segment, where it is the #1 brand — but that segment is only ~0.18% of total volume.
- **Cross-cutting patterns:** Best-selling segments (Bar, Bleach) are the lowest-priced per unit. **Q4-2022** shows a general sales decline across regions, with bleach products most sensitive.

### Recommendations
- **General:** Protect Q4 with targeted promotions; prioritize resources in Scanning Mexico and AREA 5.
- **Vanish:** Lean into the Gel format (its relative strength) and the BAR segment as a growth engine; concentrate investment in Scanning Mexico and reinforce AREAS 4, 2, and 1; close the price/value gap vs. Cloralex and Blancatel.
- **Lysol:** Defend its sanitizer leadership, evaluate format diversification beyond liquid, and reverse the post-2022 decline with directed campaigns.

---

## Project Status
**Complete** (all planned stages implemented):
- Data cleaning and transformation
- Exploratory data analysis and visualization
- K-Means clustering
- SQL relational analysis
- Power BI dashboard
- ARIMA sales forecasting
- Conclusions and recommendations
