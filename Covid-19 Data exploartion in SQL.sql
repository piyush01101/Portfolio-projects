use [portfolio projec1]

-- USING COVID DEATHS TABLE
select * from CovidDeaths
where continent is not null
order by 3,4

-- Selecting data that we are going to use

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
where continent is not null
order by location, date

-- Taking a look at the Total cases and Total cases vs Total deaths by calculating Death Percentage and rounding it off to 2 decimal places, in India
-- Death percentage shows the chances of a persons's death if the person contracts Covid at a point of time

select location, date, total_cases, new_cases, total_deaths, round((total_deaths/total_cases)*100, 2) as DeathPercentage
from CovidDeaths
where location= 'India'
order by location, date

-- Taking a look at the Total cases vs Population and calculating percentage aliasing it as Infection percentage
-- There was Infection percentage of 1.39% on 30th of April, 2021

select location, date, population,  total_cases, round((total_cases/population)*100, 2) as InfectionPercentage
from CovidDeaths
where location= 'India' 
order by location, date

-- Finding countries in the descending order of Infection rate as on 30th of April, 2021
-- Andorra has a min-dlowing infection rate of 17.13%

select location, population,  max(total_cases) as HighestInfectionCount, max(round((total_cases/population)*100, 2)) as InfectionPercentage
from CovidDeaths
group by location, population
order by InfectionPercentage desc

-- Showing countries with highest death count per population

select location, population,  max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by location, population
order by TotalDeathCount desc

-- Let's look at data Continent wise
-- Showing Continents with highest death count per population

select continent, max(cast(total_deaths as int)) as TotalDeathcount
from CovidDeaths
where continent is not null
group by continent
order by TotalDeathcount desc

-- Looking at Global numbers

select date, sum(cast(new_cases as int)) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, round((sum(cast(new_deaths as int))/ sum(new_cases))*100,2) as DeathPercentage
from CovidDeaths
where continent is not null
group by date
order by date


-- USING COVID VACCINATIONS TABLE

select * 
from CovidVaccinations
order by 3,4

-- JOINING THE TWO TABLES

select *
from CovidDeaths Dea
join CovidVaccinations Vac
on dea.location= vac.location
and dea.date= vac.date

-- Looking at the start date of vaccination and the progress of vaccination in India
select dea.location, dea.date, dea.population, vac.new_vaccinations
from CovidDeaths Dea
join CovidVaccinations Vac
on dea.location= vac.location
and dea.date= vac.date
where dea.location= 'India'
order by dea.location, dea.date

-- Looking at Vaccination count globally by doing a Rolling count

select dea.location,dea.continent, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as VaccinationCount
from CovidDeaths Dea 
join CovidVaccinations Vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
order by dea.location,dea.continent, dea.date

-- Use Common Table Expression(CTE) to calculate Percentage of people Vaccinated 

with PopVsVac( location, continent, date, population, new_vaccinations, VaccinationCount)
as
(

select dea.location,dea.continent, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as VaccinationCount
from CovidDeaths Dea 
join CovidVaccinations Vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null
)
select *, (VaccinationCount/population)*100 as VaccinationPercentage
from PopVsVac

-- Creating View to store data for using later on for Visualisation

create view PopVsVac as
select dea.location,dea.continent, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as VaccinationCount
from CovidDeaths Dea 
join CovidVaccinations Vac
on dea.location= vac.location
and dea.date= vac.date
where dea.continent is not null