/*
Covid 19 Southeast Asia Data Exploration

Skill used: Aggregate function, Window function, CTE, Create View.

*/

-- Data checking
SELECT * FROM covid_for_portfolio.Covid_data_exploration;
 
 
 
 -- Total Cases vs. Total death
 -- Show likelihood of dying if infected 

 SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
 FROM covid_for_portfolio.Covid_data_exploration
 ORDER BY location, date;
 
 
 
 -- Total Cases vs. Population
 -- Shows what percentage of population got Covid
 
 SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectedPercentage
 FROM covid_for_portfolio.Covid_data_exploration
 ORDER BY location, date;
 
 
 
 -- Total death vs. hospital patients
 
 SELECT location, date, total_deaths, hosp_patients , (total_deaths/hosp_patients)*100 AS CannotCuredPercentage
 FROM covid_for_portfolio.Covid_data_exploration
 ORDER BY location, date;
 
 
 
  -- Looking at total Population vs. Vaccinations 
 
 SELECT  location, date, population, new_vaccinations,
 (SUM(new_vaccinations) over (partition by location order by date))/population*100 as VaccinatedPercentage
 FROM covid_for_portfolio.Covid_data_exploration
 ORDER BY location, date;
 
 
 
 -- Looking at Countries with highest infection rate compared to Population
 
 SELECT iso_code, location, (MAX(total_cases)/MAX(population))*100 AS HighestInfectionRate
 FROM covid_for_portfolio.Covid_data_exploration
 GROUP BY iso_code, location
 ORDER BY HighestInfectionRate desc;
 
 /* Brunei has the highest infection rate which is about 80% population infected */
 
 
 
 -- Looking at Countries with the earliest cases infected
 
 SELECT location, MIN(date) as EarliestCase
 FROM covid_for_portfolio.Covid_data_exploration
 WHERE new_cases >0
 GROUP BY location
 ORDER BY EarliestCase asc;
 
 /* Thailand has the earliest case in Southeast Asia, 19/01/2020 */
 
 
 
 -- Showing Countries with highest death count per Population
 
 SELECT location, (MAX(total_deaths)/MAX(population))*100 AS HighestDeathCount
 FROM covid_for_portfolio.Covid_data_exploration
 GROUP BY location
 ORDER BY HighestDeathCount desc;
 
 /* Malaysia has the highest death percentage by population, but it is very low, about 0,1% */
 
 
 
  -- Looking at total Population vs. Vaccinations (Using CTE Function)
 
 WITH VaccinationPercentage AS
 (
 SELECT  location, date, population, new_vaccinations,
 SUM(new_vaccinations) over (partition by location order by date) as RollingCountVaccinated
 FROM covid_for_portfolio.Covid_data_exploration
 ORDER BY location, date
 )
 SELECT location, date, population, new_vaccinations, (RollingCountVaccinated/population*100) AS VaccinatedPercentage
 FROM VaccinationPercentage
 ORDER BY location, date;

 
 
 -- Creating view to store data for later visualizations 
 
 Create View VaccinatedPercentage as
 SELECT  location, date, population, new_vaccinations,
 (SUM(new_vaccinations) over (partition by location order by date))/population*100 as VaccinatedPercentage
 FROM covid_for_portfolio.Covid_data_exploration
 ORDER BY location, date;
 
 
 
 
 
 
 
 