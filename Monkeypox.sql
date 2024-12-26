Show databases;
create database project_dbms;
use project_dbms;

#create tables
create table Total_Cases_Monkeypox(
iso_code VARCHAR(30) NOT NULL,
date VARCHAR(20)NOT NULL,
total_cases_per_million INT(2)NOT NULL,
location VARCHAR(20) NOT NULL,
total_cases INT(5) NOT NULL,
primary key(iso_code)
);

2) 
create table Total_Deaths_Monkeypox1(
total_deaths INT(5) NOT NULL,
location VARCHAR(30) NOT NULL,
iso_code VARCHAR(30) NOT NULL,
date VARCHAR(20)NOT NULL,
total_deaths_per_million INT(2) NOT NULL,
primary key(total_deaths),
foreign key (iso_code) references Total_Cases_Monkeypox(iso_code)
);

3) 
create table new_cases_monkeypox(
new_cases INT(8) NOT NULL,
new_cases_smoothed INT(3) NOT NULL,
new_cases_per_million INT(5)NOT NULL,
new_cases_smoothed_per_million INT(5) NOT NULL,
iso_code VARCHAR(30) NOT NULL,
location VARCHAR(30) NOT NULL,
date VARCHAR(20) NOT NULL,
primary key(new_cases),
foreign key(iso_code) references Total_Cases_Monkeypox(iso_code)
);




4) 
create table new_deaths_monkeypox2(
new_deaths INT(8) NOT NULL,
new_deaths_per_million INT(5) NOT NULL,
new_deaths_smoothed INT(5) NOT NULL,
new_deaths_smoothed_per_million INT(5) NOT NULL,
location VARCHAR(30) NOT NULL,
iso_code VARCHAR(30) NOT NULL,
total_deaths INT(5) NOT NULL,
date VARCHAR(20) NOT NULL,
Primary key(new_deaths),
foreign key(iso_code) references Total_Cases_Monkeypox(iso_code),
foreign key(total_deaths) references Total_Deaths_Monkeypox1(total_deaths)
);





Queries:

Total Global Cases

Select sum(max_cases) as global_cases
From (
Select location, max(total_cases) as max_cases
From Total_Cases_Monkeypox
Group by 1
)

 Total Global Deaths

Select sum(max_deaths) as global_deaths
From (
Select location, max(total_deaths) as max_deaths
From Total_Deaths_Monkeypox1
Group by 1
)


Deaths by Cases
With cases_by_country as (
Select location, max(total_cases) as max_cases
From Total_Cases_Monkeypox
Group by 1
)

, deaths_by_country as (
Select location, max(total_deaths) as max_deaths
From Total_Deaths_Monkeypox1
Group by 1
)


Select c.location, c.max_cases, d.max_deaths, ROUND(d.max_deaths/c.max_cases,2) as deaths_by_cases_ratio
From cases_by_country c
Inner join deaths_by_country d
	On c.location = d.location

– Alternate that includes Decimal data type

Select c.location, c.max_cases, d.max_deaths, ROUND(CAST (d.max_deaths as DECIMAL(7,2))/ CAST(c.max_cases as DECIMAL(7,2)) , 2) as deaths_by_cases_ratio
From cases_by_country c
Inner join deaths_by_country d
	On c.location = d.location
