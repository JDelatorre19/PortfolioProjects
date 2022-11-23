-- Data cleaning and exploration of global CO2 Data by country ranging from 1960 to 2011

-- Pull Up data
Select *
FROM PortfolioProject_DB.dbo.CO2_RAW

--------------------
-- Determine number of rows with countries where NULL values exist if any
Select *
FROM PortfolioProject_DB.dbo.CO2_RAW
WHERE [Country Name]is not null

Select *
FROM PortfolioProject_DB.dbo.CO2_RAW
WHERE [2011] is not null
--CO2 emission post 2011 are not available in this dataset and all rows containing NULL Country Name are completely null rows

-- Remove NULL rows


--Sort/remove rows that have country name but NULL emissions
Select
FROM PortfolioProject_DB.dbo.CO2_RAW
WHERE 


DROP TABLE if exists
CREATE TABLE 