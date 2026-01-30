/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT * FROM PortfolioProject..CovidDeaths$
ORDER BY 3,4

SELECT * FROM PortfolioProject..CovidVaccinations$
ORDER BY 3,4

---Total Cases vs Total Deaths.
---Likelihood of death if you contract Covid in your country.

SELECT 
    location,
    date, 
    total_Cases,
    new_cases,
    total_deaths, 
    (total_deaths/total_cases)*100 as death_percentage
FROM PortfolioProject..CovidDeaths$
WHERE location like '%states%'
ORDER BY 1,2


-----Total Cases VS Population.
-----Show what percentage of the population got COVID-19.

SELECT 
  location, 
  date,
  population, 
  total_Cases, 
  (total_cases/population)*100 as PopulationInfectedPercent
FROM PortfolioProject..CovidDeaths$
WHERE location LIKE '%states%'
ORDER BY 1,2


----Countries with the highest infection rate compared to Population.

SELECT 
  Location, 
  Population, 
  MAX(total_Cases) as HighestInfectionCount, 
  MAX((total_cases/population))*100 as PopulationInfectedPercent
FROM PortfolioProject..CovidDeaths$
--where location like '%states%'
GROUP BY location, population
ORDER BY PopulationInfectedPercent desc


----Countries with Highest Death Count per Population.

SELECT 
  Location, 
  MAX(CAST(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
GROUP BY Location
ORDER BY TotalDeathCount desc


----Countries with Highest Death Count Per Population.

SELECT 
  Location, 
  MAX(CAST(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc

---Let's Break Things Down by Continent
----Continents with the highest death count per population

SELECT 
  continent, 
  MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM portfolioProject..coviddeaths$
WHERE continent is not null 
GROUP BY continent
ORDER BY TotalDeathcount desc

---GLOBAL NUMBERS

SELECT   
  SUM(new_cases) as total_cases, 
  SUM(cast(new_deaths as int)) as total_deaths, 
  SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
FROM Portfolioproject..coviddeaths$
WHERE continent is not null
--group by date
ORDER BY 1,2


----JOINING BOTH THE TABLES
----Total Population VS Vaccination

SELECT 
  cd.continent,
  cd.location,
  cd.date,
  cd.population, 
  cv.new_vaccinations, 
  SUM(CONVERT(INT, cv.new_vaccinations)) OVER (Partition by cd.location Order by cd.location, cd.Date) as RollingPeopleVaaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ cd
INNER JOIN PortfolioProject..CovidVaccinations$ cv ON cd.location = cv.location and cd.date = cv.date
WHERE cd.continent is not null 
ORDER BY 2,3


----Using CTE(Common Table Expression)

with PopvsVac (continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as
(
SELECT 
    cd.continent,
    cd.location,
    cd.date,
    cd.population,
    cv.new_vaccinations, 
    SUM(CONVERT(INT, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.Date) as RollingPeopleVaaccinated
--, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ cd
INNER JOIN PortfolioProject..CovidVaccinations$ cv ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL 
--order by 2,3
)

SELECT * FROM PopvsVac


--Temp Table

DROP Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
 
INSERT INTO #PercentPopulationVaccinated
SELECT 
  cd.continent, 
  cd.location, 
  cd.date,
  cd.population, 
  cv.new_vaccinations,
  SUM(CONVERT(int,cv.new_vaccinations)) OVER(Partition by cd.location order by cd.location, cd.Date) as RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ cd
INNER JOIN PortfolioProject..CovidVaccinations$ cv ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL 
--order by 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


-----Creating a view to store data for later visualizations

DROP View PercentPopulationVaccinated
CREATE View PercentPopulationVaccinated as
SELECT 
  cd.continent, 
  cd.location, 
  cd.date, 
  cd.population, 
  cv.new_vaccinations,
  SUM(CONVERT(int,cv.new_vaccinations)) OVER(Partition by cd.location order by cd.location, cd.Date) as RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ cd
INNER JOIN PortfolioProject..CovidVaccinations$ cv on cd.location = cv.location and cd.date = cv.date
WHERE cd.continent IS NOT NULL 
--order by 2,3

SELECT * FROM PercentPopulationVaccinated



