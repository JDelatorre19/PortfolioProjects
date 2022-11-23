/*

Cleaning Data in SQL Queries 

*/

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject_DB.dbo.NashvilleHousingData

Update NashvilleHousingData
SET SaleDate = CONVERT(Date, SaleDate)
-- This may not work so use code snippet below

ALTER TABLE NashvilleHousingData
Add SaleDateConverted Date;

Update NashvilleHousingData
SET SaleDateConverted = CONVERT(Date, SaleDate)

-------------------------------------------------------------

--Populate Property Address Data

Select *
From PortfolioProject_DB.dbo.NashvilleHousingData
--WHERE PropertyAddress is null
Order By ParcelID

Select a.parcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject_DB.dbo.NashvilleHousingData a
JOIN PortfolioProject_DB.dbo.NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--  Run update below and then rerun above query, no values should return as 'NULL' values are populated now
Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject_DB.dbo.NashvilleHousingData a
JOIN PortfolioProject_DB.dbo.NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]


-- Breaking out Address into individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject_DB.dbo.NashvilleHousingData
--WHERE PropertyAddress is null
--Order By ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From PortfolioProject_DB.dbo.NashvilleHousingData

ALTER TABLE PortfolioProject_DB.dbo.NashvilleHousingData
Add PropertySplitAddress  Nvarchar(255);

Update PortfolioProject_DB.dbo.NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE PortfolioProject_DB.dbo.NashvilleHousingData
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject_DB.dbo.NashvilleHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
FROM PortfolioProject_DB.dbo.NashvilleHousingData


--Breakout Owner Address with individual Columns (Address, City and State)
Select OwnerAddress
FROM PortfolioProject_DB.dbo.NashvilleHousingData

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
From  PortfolioProject_DB.dbo.NashvilleHousingData

-- Adding Column names to Parsed OwnerAddress
ALTER TABLE PortfolioProject_DB.dbo.NashvilleHousingData
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject_DB.dbo.NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE PortfolioProject_DB.dbo.NashvilleHousingData
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject_DB.dbo.NashvilleHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE PortfolioProject_DB.dbo.NashvilleHousingData
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject_DB.dbo.NashvilleHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)


-- Consolidate SoldasVacant from Y, N, Yes, and No to ONLY Yes and No
Select Distinct(SoldasVacant), Count(SoldasVacant)
From  PortfolioProject_DB.dbo.NashvilleHousingData
Group by SoldAsVacant
Order by 2

Select SoldasVacant
, CASE When SoldasVacant = 'Y' THEN 'YES'
		When SoldasVacant = 'N' THEN 'NO'
		ELSE SoldasVacant
		END
From  PortfolioProject_DB.dbo.NashvilleHousingData

Update PortfolioProject_DB.dbo.NashvilleHousingData
SET SoldasVacant = CASE When SoldasVacant = 'Y' THEN 'YES'
		When SoldasVacant = 'N' THEN 'NO'
		ELSE SoldasVacant
		END

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID, 
							PropertyAddress,
							SalePrice,
							SaleDate,
							LegalReference
							ORDER BY
								UniqueID
								) row_num

From  PortfolioProject_DB.dbo.NashvilleHousingData
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--Order By PropertyAddress


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID, 
							PropertyAddress,
							SalePrice,
							SaleDate,
							LegalReference
							ORDER BY
								UniqueID
								) row_num

From  PortfolioProject_DB.dbo.NashvilleHousingData
--order by ParcelID
)
SELECT *
From RowNumCTE
Where row_num > 1

Select*
From  PortfolioProject_DB.dbo.NashvilleHousingData

---------------------------------------------
-- Remove Unused Columns (PERFORM ONLY ON VIEWS, DO NOT REMOVE UNUSED COLUMNS ON RAW DATA UNLESS CLEARED TO)

Select*
From  PortfolioProject_DB.dbo.NashvilleHousingData

ALTER TABLE PortfolioProject_DB.dbo.NashvilleHousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject_DB.dbo.NashvilleHousingData
DROP COLUMN SaleDate