--Data Exploration with SQL


select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4
--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4


--select starting data
select location, date, total_cases, new_cases, total_deaths, Population 
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Selecting total cases vs total deaths in India.
-- Cnverting 'total deaths to decimal because the original row is of type :nvarchar

select location, date, total_cases, total_deaths, Population, convert(float,
	convert(decimal(18,2),total_deaths) / convert(decimal(18,2),total_cases))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location= 'India'
order by 1,2


-- Selecting Total cases vs Population
-- Shows percentage of total indian population that contracted covid

select location, date, total_cases, total_deaths, Population, convert(float,
	convert(decimal(18,2),total_cases) / Population)*100 as ContractedPercentage
from PortfolioProject..CovidDeaths
where location = 'India'
order by 1,2

-- countries with highest infection rate
-- Cnverting 'total cases' to decimal and then to float because the original row is of type nvarchar, and the max function only returns int/float

select location, Population, max(total_cases) as HighestCaseCount, 
	Max(convert(float, convert(decimal(18,2),total_cases) / Population)*100 )as ContractedPercentage
from PortfolioProject..CovidDeaths
group by Location , Population
order by 1, 2

-- Creating a View :HighestInfectionRate

create view HighestInfectionRate as
select location, Population, max(total_cases) as HighestCaseCount, 
	Max(convert(float, convert(decimal(18,2),total_cases) / Population)*100 )as ContractedPercentage
from PortfolioProject..CovidDeaths
--where location = 'India'
group by Location , Population
--order by 1, 2


-- Query: Show the maximum death counts in each country in descending order of total cases.

select location, max(cast(total_deaths as int)) as TotalDeathCount, max(cast(total_cases as int)) as TotalCaseCount
from PortfolioProject..CovidDeaths
--where location = 'India'
where continent is not null
group by location
order by totaldeathcount desc


-- View of the maximum death counts in each country in descending order of total cases.

create view HighestDeathsPerPopulation as
select location, max(cast(total_deaths as int)) as TotalDeathCount, max(cast(total_cases as int)) as TotalCaseCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location

-- Showing maximum death counts in each continent in descending order of total cases.

select continent, max(cast(total_deaths as int)) as TotalDeathCount, max(cast(total_cases as int)) as TotalCaseCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by totaldeathcount desc

--Global Numbers

select SUM(new_cases) as NewCaseCount, Sum(new_deaths) as newDeaths, 
	(Sum(new_deaths)/Sum(new_cases))*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location = 'India'
where continent is not null
--group by date
order by 1,2
--order by totaldeathcount desc


--Joining 2 seperate tables to show total new vaccinations and deaths per continent and country. 

select cd.continent, cd.location, cd.Population, CD.date , cv.new_vaccinations, sum(convert(float, cv.new_vaccinations)) over ( partition by cd.location order by cd.date ) as CulPeopleVacced
from PortfolioProject..CovidDeaths CD
join PortfolioProject..CovidVaccinations CV
on cd.location=cv.location
and cd.date= cv.date
where cd.continent is not null 
order by 1,2,3


