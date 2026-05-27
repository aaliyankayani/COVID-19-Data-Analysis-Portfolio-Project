/*
===============================================================================
SQL Portfolio Project: COVID-19 Data Analysis
Author: Aaliyan Kayani
Date: May 2026
Description: This script analyzes global COVID-19 data to extract diffrent insights 
          
===============================================================================
*/

-- -------------------------------------------------------------------------
-- ANALYSIS 1: Total Cases vs Population
-- Goal: Determine the percentage of the population that contracted COVID-19 
--       over time per location.
-- -------------------------------------------------------------------------

SELECT
    location,
    date,
    population,
    total_cases,
    -- Calculate infection percentage (cast to float to prevent integer division truncation)
    (CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100 AS PercentPopulationInfected
FROM 
    PortfolioProject.dbo.CovidDeaths
-- Order by country name and date to track chronological progression
ORDER BY 
    location, 
    date;


-- -------------------------------------------------------------------------
-- ANALYSIS 2: Countries with Highest Infection Rate Compared to Population
-- Goal: Identify which countries experienced the highest peak infection 
--       percentages relative to their population size.
-- -------------------------------------------------------------------------

SELECT
    location,
    population,
    -- Capture the peak number of cases recorded for each location
    MAX(total_cases) AS HighestInfectionCount,
    -- Calculate the highest single-day infection percentage recorded
    MAX((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT))) * 100 AS PercentPopulationInfected
FROM 
    PortfolioProject.dbo.CovidDeaths
-- Aggregate data by location and population to find peak metrics
GROUP BY 
    location, 
    population
-- Rank results from highest infection density to lowest
ORDER BY 
    PercentPopulationInfected DESC;
-- -------------------------------------------------------------------------
-- ANALYSIS 3: Countries with Highest Death Count
-- Goal: Determine which countries suffered the highest absolute death toll.
-- Note: 'WHERE continent IS NOT NULL' filters out aggregate regional records.
-- -------------------------------------------------------------------------

SELECT
    location,
    -- total_deaths is stored as nvarchar/text in raw data, so we cast to INT
    MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM 
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL  -- Excludes regional aggregates like 'World' or 'Europe'
GROUP BY 
    location
ORDER BY 
    TotalDeathCount DESC;

    -------------------------------------------------------------------------
-- ANALYSIS 4: Breakdown by Continent
-- Goal: Analyze total death numbers aggregated at the continent level.
-- -------------------------------------------------------------------------

SELECT
    continent,
    -- Calculate total death impact per continent
    MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM 
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL
GROUP BY 
    continent
ORDER BY 
    TotalDeathCount DESC;
    -------------------------------------------------------------------------
-- ANALYSIS 5: Global Daily Numbers Query
-- Goal: Track the chronological progression of daily cases and deaths worldwide.
-- -------------------------------------------------------------------------

SELECT
    date,
    -- Aggregate daily global metrics
    SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS INT)) AS TotalDeaths
FROM 
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL
GROUP BY 
    date
ORDER BY 
    date;


-- -------------------------------------------------------------------------
-- ANALYSIS 6: Global Death Percentage by Day
-- Goal: Calculate the daily rolling fatality rate of COVID-19 globally.
-- Note: Uses NULLIF to safely handle days with 0 new cases to prevent errors.
-- -------------------------------------------------------------------------

SELECT
    date,
    SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
    -- NULLIF prevents a 'Divide by Zero' error if a day reports 0 new cases
    (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(new_cases), 0)) * 100 AS DeathPercentage
FROM 
    PortfolioProject..CovidDeaths
WHERE 
    continent IS NOT NULL
GROUP BY 
    date
ORDER BY 
    date;

-- -------------------------------------------------------------------------
-- ANALYSIS 7: Rolling Vaccination Summary (Base Query)
-- Goal: Calculate a cumulative daily rolling total of vaccinations per country.
-- -------------------------------------------------------------------------

SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    -- Window Function: Computes a running sum of vaccinations partitioned by country
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (
        PARTITION BY dea.location
        ORDER BY dea.location, dea.date
    ) AS RollingPeopleVaccinated
FROM 
    PortfolioProject..CovidDeaths dea
JOIN 
    PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
ORDER BY 
    location, 
    date;


-- -------------------------------------------------------------------------
-- ANALYSIS 8: Using a CTE (Common Table Expression)
-- Goal: Overcome SQL limitations to instantly calculate the percentage of 
--       the population vaccinated using the newly created 'RollingPeopleVaccinated'.
-- -------------------------------------------------------------------------

WITH PopvsVac (
    continent,
    location,
    date,
    population,
    new_vaccinations,
    RollingPeopleVaccinated
) AS (
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        -- CONVERT to BIGINT prevents arithmetic overflow bugs on high global aggregates
        SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (
            PARTITION BY dea.location
            ORDER BY dea.location, dea.date
        ) AS RollingPeopleVaccinated
    FROM 
        PortfolioProject..CovidDeaths dea
    JOIN 
        PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL
)
-- Querying directly out of the temporary CTE memory space
SELECT 
    *,
    (CAST(RollingPeopleVaccinated AS FLOAT) / NULLIF(population, 0)) * 100 AS PercentVaccinated
FROM 
    PopvsVac;


-- -------------------------------------------------------------------------
-- ANALYSIS 9: Using a Temporary Table (#)
-- Goal: Cache analytical results into temporary physical storage for multi-step 
--       optimization and indexing.
-- -------------------------------------------------------------------------

-- Idempotency check: ensures the script runs smoothly even if executed multiple times
DROP TABLE IF EXISTS #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated
(
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATETIME,
    population NUMERIC,
    new_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

-- Populating the Temporary Table
INSERT INTO #PercentPopulationVaccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (
        PARTITION BY dea.location
        ORDER BY dea.location, dea.date
    ) AS RollingPeopleVaccinated
FROM 
    PortfolioProject..CovidDeaths dea
JOIN 
    PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;

-- Fetching data from the Temporary Table with calculation logic
SELECT 
    *,
    (CAST(RollingPeopleVaccinated AS FLOAT) / NULLIF(population, 0)) * 100 AS PercentVaccinated
FROM 
    #PercentPopulationVaccinated;


-- -------------------------------------------------------------------------
-- ANALYSIS 10: Creating Permanent Database Views
-- Goal: Save analytical structures as permanent database schemas for business 
--       intelligence consumption (e.g., Tableau, PowerBI, Excel Reporting).
-- Note: 'CREATE VIEW' must be the first statement in a query batch.
-- -------------------------------------------------------------------------

GO -- Separates the command batch in Microsoft SQL Server

CREATE OR ALTER VIEW PercentPopulationVaccinated AS
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (
        PARTITION BY dea.location
        ORDER BY dea.location, dea.date
    ) AS RollingPeopleVaccinated
FROM 
    PortfolioProject..CovidDeaths dea
JOIN 
    PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;
    
GO

SELECT * FROM PercentPopulationVaccinated;