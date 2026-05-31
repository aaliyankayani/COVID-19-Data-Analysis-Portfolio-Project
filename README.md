# COVID-19 Global Insights: Data Pipeline & Analytics Dashboard

## Overview

**COVID-19 Global Insights** is an end-to-end data engineering and analytics project that transforms raw World Health Organization (WHO) COVID-19 data into actionable insights through data preprocessing, SQL-based analysis, and interactive business intelligence reporting.

The project demonstrates a complete analytics workflow, covering data cleaning, database design, exploratory data analysis (EDA), and dashboard development. Using SQL Server and Tableau, it delivers key epidemiological metrics, global trend analysis, and executive-level visualizations.

---

## Project Objectives

* Build a structured data pipeline for COVID-19 data processing.
* Clean and transform raw WHO datasets for analysis readiness.
* Perform advanced SQL analysis to uncover global health trends.
* Create reusable database views for business intelligence integration.
* Develop an interactive Tableau dashboard for data-driven decision-making.

---

## Technology Stack

| Category            | Tools & Technologies                |
| ------------------- | ----------------------------------- |
| Data Source         | World Health Organization (WHO)     |
| Data Cleaning       | Google Sheets, Microsoft Excel      |
| Database            | Microsoft SQL Server                |
| Querying & Analysis | SQL Server Management Studio (SSMS) |
| Data Visualization  | Tableau                             |
| Version Control     | Git & GitHub                        |

---

## Data Pipeline Architecture

```text
WHO COVID-19 Dataset
          │
          ▼
 Data Cleaning & Transformation
     (Google Sheets)
          │
          ▼
    SQL Server Database
          │
          ▼
      SQL Analysis
      & Database Views
          │
          ▼
   Tableau Dashboard
          │
          ▼
 Business Intelligence Insights
```

---

## Data Preparation & ETL

### Data Source

The dataset was obtained from publicly available COVID-19 reports published by the **World Health Organization (WHO)**.

### Data Cleaning Process

#### Feature Selection

Removed unnecessary fields and retained only the most relevant analytical attributes, including:

* Location
* Date
* Population
* Total Cases
* Total Deaths
* Vaccination Metrics

#### Data Cleansing

* Replaced missing numeric values with `0`.
* Removed duplicate records.
* Validated row consistency and data integrity.

#### Data Standardization

* Standardized date formats (`MM/DD/YYYY`).
* Ensured consistent column naming conventions.
* Prepared datasets for SQL ingestion.

---

## SQL Analysis

The cleaned datasets were imported into **Microsoft SQL Server**, where multiple analytical queries were executed to generate meaningful insights.

### 1. Infection Prevalence Analysis

**Total Cases vs Population**

Measures the percentage of a country's population infected over time.

**Key Metric**

```sql
(Total_Cases / Population) * 100
```

---

### 2. Peak Infection Rate Analysis

Identifies countries with the highest recorded infection rates relative to population size.

**Purpose**

* Compare pandemic severity across countries.
* Highlight infection hotspots.

---

### 3. Mortality Analysis

Ranks countries based on total COVID-19 deaths.

**Purpose**

* Evaluate overall pandemic impact.
* Identify regions with the highest mortality burden.

---

### 4. Continental Analysis

Aggregates COVID-19 metrics at the continent level.

**Insights**

* Total deaths by continent.
* Comparative regional impact.

---

### 5. Global Daily Trends

Tracks worldwide daily cases and deaths over time.

**Purpose**

* Understand pandemic progression.
* Analyze major infection waves.

---

### 6. Global Fatality Rate Analysis

Calculates the daily global death percentage.

**Key Metric**

```sql
(Total_Deaths / Total_Cases) * 100
```

**Purpose**

* Measure fatality trends.
* Evaluate changes in mortality over time.

---

## Database Views

To improve maintainability and streamline Tableau integration, permanent SQL views were created using:

```sql
CREATE VIEW
```

### Benefits

* Simplified reporting queries.
* Faster dashboard development.
* Reusable data models.
* Improved BI workflow efficiency.

---

## Tableau Dashboard

The SQL views were connected directly to Tableau to create an interactive analytics dashboard.

### Dashboard Features

* Executive KPI summary
* Global infection trends
* Mortality analysis
* Geographic distribution insights
* Country comparison rankings
* Interactive filtering and exploration

### Key Benefits

* Real-time exploration of COVID-19 trends
* Executive-level reporting
* Visual comparison across countries and continents
* Data-driven decision support

---

## Repository Structure

```text
COVID-19-Global-Insights/
│
├── data/
│   └── cleaned datasets and references
│
├── sql/
│   ├── data_analysis.sql
│
├── visualizations/
│   ├── dashboard_screenshots/
│   └── covid_dashboard.twbx
│
└── README.md
```

---

## Getting Started

### Prerequisites

* Microsoft SQL Server
* SQL Server Management Studio (SSMS)
* Tableau Desktop or Tableau Public
* Google Sheets or Microsoft Excel

---

### Installation & Setup

#### 1. Clone the Repository

```bash
git clone https://github.com/aaliyankayani/COVID-19-Data-Analysis-Portfolio-Project.git
cd COVID-19-Data-Analysis-Portfolio-Project
```

#### 2. Import the Dataset

Load the cleaned COVID-19 datasets into SQL Server.

#### 3. Execute SQL Scripts

Run the scripts located in the `sql/` directory:

```sql
data_analysis.sql
```

This will generate all analytical queries and reporting views.

#### 4. Open Tableau Dashboard

Open the Tableau workbook located in:

```text
visualizations/covid_dashboard.twbx
```

Reconnect the data source if necessary and refresh the extracts.

---

## Key Insights Generated

* Countries with the highest infection rates relative to population.
* Countries with the highest total death counts.
* Continental-level mortality comparisons.
* Daily global infection and death trends.
* Global fatality rate progression throughout the pandemic.
* Vaccination-related performance indicators.

---

## Skills Demonstrated

* Data Cleaning & Transformation
* ETL Pipeline Design
* SQL Query Optimization
* Database View Creation
* Exploratory Data Analysis (EDA)
* Business Intelligence Reporting
* Data Visualization
* Dashboard Development
* Data Storytelling

---

## Acknowledgments

* **World Health Organization (WHO)** for providing publicly available COVID-19 datasets.
* **Microsoft SQL Server** for data storage and analytics.
* **Tableau** for interactive data visualization and dashboard development.

---

**Author:** Aaliyan Kayani
**Project Type:** Data Engineering • Data Analytics • Business Intelligence
**Tools:** SQL Server, SSMS, Tableau, Google Sheets, GitHub
