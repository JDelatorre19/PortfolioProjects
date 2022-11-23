Select *
From PortfolioProject_DB..Covid_Deaths
Where continent is not null
order by 3,4

--Select *
--From PortfolioProject_DB..Covid_Vaccinations
--order by 3,4

-- Select Data that we are going to be using


Select Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject_DB..Covid_Deaths
order by 1,2

-- Looking at Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject_DB..Covid_Deaths
Where location like '%states%'
order by 1,2

-- Looking at Total Cases vs Population
--% of population that got Covid

Select Location, date, population, total_cases, (total_deaths/population)*100 a PercentagePopInfected
FROM PortfolioProject_DB..Covid_Deaths
Where location like '%states%'
order by 1,2

--Looking at Countries with highest infection rates
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopInfected
FROM PortfolioProject_DB..Covid_Deaths
-- Where location like '%states%'
Where continent is not null
Group by Location, population
order by PercentagePopInfected desc

-- Observing countries with Highest Death Count per population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject_DB..Covid_Deaths
-- Where location like '%states%'
Where continent is not null
Group by Location
Order by TotalDeathCount desc

--BREAK DOWN BY CONTINENT
-- Continents with highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject_DB..Covid_Deaths
-- Where location like '%states%'
Where continent is not null 
Group by continent
Order by TotalDeathCount desc


-- Global Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
FROM PortfolioProject_DB..Covid_Deaths
Where continent is not null
--Group by date
order by 1,2

-- Looking at Total Population vs Vaccinations
-- new_vaccinations is new vaccinations per DAY

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PortfolioProject_DB..Covid_Deaths dea
Join PortfolioProject_DB..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PortfolioProject_DB..Covid_Deaths dea
Join PortfolioProject_DB..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- TEMP TABLE


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric, 
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PortfolioProject_DB..Covid_Deaths dea
Join PortfolioProject_DB..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for future visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PortfolioProject_DB..Covid_Deaths dea
Join PortfolioProject_DB..Covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select*
From PercentPopulationVaccinated