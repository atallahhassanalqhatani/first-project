select*from CovidVaccinations
order by 3,4
--select*from CovidVaccinations
select*from Coviddeaths
where continent is not null
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population  from Coviddeaths
order by 1,2

-- total cases vs total deaths
select location,date,total_cases, total_deaths,(total_deaths/total_cases) *100 as death_persentege
from coviddeaths
where location like'saudi%'
order by total_deaths desc


--total cases vs population
select location,date,total_cases, population,(total_cases/population) *100 as total_cases_to_population_persentege
from coviddeaths
where location like'saudi%'
order by population desc

-- most total_cases_to_population_persentege countery rate
select location, population,max(total_cases) as max_countery,max ((total_cases/population)) *100 as total_cases_to_population_persentege
from coviddeaths
--where location like'saudi%'
where continent is not null
group by location, population
order by total_cases_to_population_persentege desc

-- most total_deahhs_to_population_persentege countery rate
select location, max(total_deaths) as max_total_deaths from coviddeaths
--where location like'saudi%'
where continent is not null
group by location
order by max_total_deaths  desc
---total deaths by continet
select location, max(total_deaths) as max_total_deaths from coviddeaths
--where location like'saudi%'
where continent is null
group by location
order by max_total_deaths  desc

--- most deaths an aisa
select continent,location,max(total_deaths) as asia_total_deaths from CovidDeaths
where continent='asia'
group by continent , location
order by asia_total_deaths desc

--  ksa number
select date,sum(new_cases) as sum_new_cases,sum(new_deaths) as sum_total_deaths,sum(new_deaths)/sum(new_cases)*100 as death_persentege
--total_cases, total_deaths,(total_deaths/total_cases) *100 as death_persentege
from coviddeaths
where location like'saudi%'
and continent is not null
group by date 
order by 1,2

-- all cases and deaths
select sum(new_cases) as all_cases,sum(new_deaths) as all_deaths,sum(new_deaths)/sum(new_cases)*100 as death_persentege
--total_cases, total_deaths,(total_deaths/total_cases) *100 as death_persentege
from coviddeaths
where location like'saudi%'
and continent is not null
order by 1,2

--total test persentege at KSA
select sum(total_tests)/sum(population)*100 'total test persentege'
from CovidVaccinations cv join CovidDeaths cd on cv.location=cd.location 
and cv.date=cd.date
where cv.location like 'saudi%'


--- population vs Vaccinations
select cd.continent,cd.location,cd.date,cv.new_vaccinations,
sum(cv.new_vaccinations) over (partition by cd.location order by cd.location ,cd.date )
as total_vaccinations_2
from CovidVaccinations cv join CovidDeaths cd on cv.location=cd.location 
and cv.date=cd.date
where cd.continent is not null
order by 2,3


--cte

with popvsvac(continent,location,date,population,new_vaccinations,total_vaccinations_2)
as
(
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cv.new_vaccinations) over (partition by cd.location order by cd.location ,cd.date )
as total_vaccinations_2--, --(total_vaccinations_2/population)*100
from CovidVaccinations cv join CovidDeaths cd on cv.location=cd.location 
and cv.date=cd.date
where cd.continent is not null
--order by 2,3
)
select*,(total_vaccinations_2/population)*100from popvsvac
--view
create view percent_popvsvac as
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(cv.new_vaccinations) over (partition by cd.location order by cd.location ,cd.date )
as total_vaccinations_2--, --(total_vaccinations_2/population)*100
from CovidVaccinations cv join CovidDeaths cd on cv.location=cd.location 
and cv.date=cd.date
where cd.continent is not null
--order by 2,3