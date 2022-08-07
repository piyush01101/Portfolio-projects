use [portfolio project]

-- Viewing data 
select *
from [Nashville Housing]

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1.) Standardizing Date format

-- Showing original SaleDate table
select SaleDate
from [Nashville Housing]

-- Creating new table- SalesDate after cleaning SaleDate table
alter table [Nashville Housing]
add SalesDate Date;

update [Nashville Housing]
set SalesDate=  convert (date, SaleDate)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2.) Populating Property Address data to fill Null values

-- Viewing rows with Null value in Property address
select *
from [Nashville Housing]
where PropertyAddress is null

-- Finding a reference point to populate Property address
select *
from [Nashville Housing]
order by ParcelID
-- #Found that the rows with same Parcel ID has the same Property address as well

-- Performing a self-join and seeing rows with Null values in a and non-null values in b
select a.ParcelID, a.[UniqueID ], a.PropertyAddress, b.ParcelID, b.[UniqueID ], b.PropertyAddress
from [Nashville Housing] a
join [Nashville Housing] b
on a.ParcelID= b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Updating table with null values from the table with non-null values
update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
from [Nashville Housing] a
join [Nashville Housing] b
on a.ParcelID= b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
-- #Property address has been populated


-- Viewing Owner address
select PropertyAddress, OwnerAddress
from [Nashville Housing]
where OwnerAddress is null

-- # We can see that there are a few rows in Owner address with null values. Let's populate them using property address.

update [Nashville Housing]
set OwnerAddress = ISNULL(Owneraddress, PropertyAddress)
select PropertyAddress, OwnerAddress
from [Nashville Housing] 
where OwnerAddress is null
-- #Owner address has been populated

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--3.) Breaking down address into Address, City and State 
select PropertyAddress, OwnerAddress
from [Nashville Housing]

-- Observed that there are comma to separate address from the city. We can use it to separate address from the city
-- Property address has Address and city whereas Owner address which is same as Property address has State as well. First lets extract Address and City from property address and the n extract State from Owner address.

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
from [Nashville Housing]
-- #Address separated.

select SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as City
from [Nashville Housing]
-- #City separated.

alter table [Nashville Housing]
add Address nvarchar(255),
city nvarchar(255);

update [Nashville Housing]
set Address= SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

update [Nashville Housing]
set City= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))

-- #Going to use parsename instead of substring
select PARSENAME(replace(owneraddress, ',','.'),1) as State
from [Nashville Housing]

alter table [Nashville Housing]
add State nvarchar(255);

update [Nashville Housing]
set State= PARSENAME(replace(owneraddress, ',','.'),1)
-- #State separated but we can see that there are some fields wherein there was no State and City was taken in instead of State.

-- Let's correct State
alter table [Nashville Housing]
add StateCorrected nvarchar(255);

update [Nashville Housing]
set StateCorrected=
( case when State <> 'TN' then 'TN'
else State
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4.) In the 'SoldAsvacant' column, we see there are some values Y,N instead of Yes and No. Let's correct them.
select distinct(SoldAsVacant), count(SoldAsVacant)
from [Nashville Housing]
group by SoldAsVacant
order by 2 desc

update [Nashville Housing]
set SoldAsVacant= case when SoldAsVacant= 'Y' then 'Yes'
when SoldAsVacant= 'N' then 'No'
else SoldAsVacant
end
-- SoldAsVacant column has been updated. We can cross-check using the distinct statement above.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5.) Removing duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Nashville Housing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From [Nashville Housing]
-- #Duplicates removed.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 6.) Delete Unused Columns

Select *
From [Nashville Housing]


ALTER TABLE [Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate, State

/*
The Nashville Housing dataset was cleaned and all the unrequired data was trimmed down.
*/
