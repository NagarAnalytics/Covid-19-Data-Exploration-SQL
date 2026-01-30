# Covid-19-Data-Exploration-SQL
Data exploration of global Covid-19 immunization and mortality rates using SQL Server.

# Covid-19 Global Data Exploration

## 📌 Project Overview
This project involves a deep dive into global Covid-19 data, focusing on death transitions and vaccination progress. The goal was to extract meaningful insights regarding mortality rates and the pace of immunization across different continents and income groups.

## 🛠 Tools & Technologies
- **Language:** SQL (T-SQL / MS SQL Server)
- **Advanced SQL Techniques:** Joins, CTEs, Temp Tables, Window Functions, Aggregate Functions, Creating Views.

## 📊 Key Insights & Queries
1. **Mortality Probability:** Analyzed the likelihood of dying if you contract Covid-19 in specific countries over time.
2. **Infection vs. Population:** Calculated the percentage of the population infected per country to identify high-risk zones.
3. **Global Numbers:** Aggregated total cases and deaths globally to provide a high-level summary of the pandemic's impact.
4. **Vaccination Progress:** Performed a **Rolling Count** of vaccinations using Partition By to track how many people were vaccinated day-by-day.
5. **Population vs. Vaccination:** Utilized a **CTE** and a **Temp Table** to perform calculations on partitioned data to find the percentage of a country's population that has received at least one vaccine.

## 📂 File Structure
- `Covid_Exploration_Queries.sql`: Full SQL script containing all analysis queries.
- `CovidDeaths.csv`: Dataset containing death statistics (optional/sample).
- `CovidVaccinations.csv`: Dataset containing vaccination statistics (optional/sample).

## 🚀 How to Run
1. Import the `CovidDeaths` and `CovidVaccinations` Excel/CSV files into your SQL database.
2. Ensure the data types (especially dates and numeric values) are correctly cast.
3. Execute the queries in `Covid_Exploration_Queries.sql`.
