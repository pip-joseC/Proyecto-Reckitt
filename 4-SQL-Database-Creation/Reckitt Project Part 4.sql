/******************************** TABLE CREATION ********************************/

-- Creating the category table
CREATE TABLE category (
    [IdCategory] TINYINT, --IdCategory are integers from 1 to 5, a TINYINT is sufficient
    [Category] VARCHAR(100) --This stores the meaning of each Id as text strings
)

-- Creating the calendar table
CREATE TABLE calendar (
    [Week] VARCHAR(10), --Short identifiers for each week 
    [Year] INT, --Corresponding year, as an integer 
    [Month] TINYINT, --Corresponding month, identified by its month number from 1 to 12
    [WeekNumber] TINYINT, --Week number of that year, ranges from 1 to 52
    [Date] DATE --Full date of the first day of the corresponding week
)

-- Creating the segments table
CREATE TABLE segments (
    [Category] TINYINT, --Integer identifier for the category
    [Attr1] VARCHAR(30), --First attribute, stored as text
    [Attr2] VARCHAR(30), --Second attribute, stored as text
    [Attr3] VARCHAR(30), --Third attribute, stored as text
    [Format] VARCHAR(30), --Format/presentation name, stored as text
    [Segment] VARCHAR(30) --Corresponding segment name, stored as text
)

-- Creating the products table
CREATE TABLE products (
    [Manufacturer] VARCHAR(100), --Manufacturer name, stored as text
    [Brand] VARCHAR(100), --Brand name, stored as text
    [Item] VARCHAR(100), --Alphanumeric product identifier
    [ItemDescription] VARCHAR(255), --Product description, stored as a long text
    [Category] TINYINT, --Integer identifier for the category
    [Format] VARCHAR(30), --Format/presentation name, stored as text
    [Attr1] VARCHAR(30), --First attribute, stored as text
    [Attr2] VARCHAR(30), --Second attribute, stored as text
    [Attr3] VARCHAR(30), --Third attribute, stored as text
)

-- Creating the sales table
CREATE TABLE sales (
    [Week] VARCHAR(10), --Short identifiers for each sales week
    [ItemCode] VARCHAR(100), --Alphanumeric identifier of the sold product
    [TotalUnitSales] DECIMAL(8,3), --Decimal quantity measuring unit sales for that week
    [TotalValueSales] DECIMAL(8,3), --Decimal quantity measuring monetary sales for that week
    [TotalUnitAvgWeeklySales] DECIMAL(8,3), --Quantity measuring the product's average historical performance
    [Region] VARCHAR(100) --Region where the sale was made, stored as text
)

/******************************** IMPORTING THE DATA ********************************/

-- Import the CSV file
BULK INSERT category
--File path: this must be changed if reproducibility is required
FROM 'C:\Users\sorak\Proyecto Reckitt\DIM_CATEGORY.csv'
WITH (
    FORMAT='CSV', -- Specifying that the format is CSV
    FIRSTROW = 2  -- Skip the header, it will start on the second row
);

SELECT * 
FROM category

-- Import the CSV file, now for sales
BULK INSERT sales
--File path: this must be changed if reproducibility is required
FROM 'C:\Users\sorak\Proyecto Reckitt\FACT_SALES.csv'
WITH (
    FORMAT='CSV', -- Specifying that the format is CSV
    FIRSTROW = 2  -- Skip the header, it will start on the second row
);

SELECT * 
FROM sales

-- THE REMAINING TABLES WERE IMPORTED USING THE SSMS TOOL FOR IMPORTING EXCEL FILES

--Correction to avoid errors in the Data Import Wizard (will require converting the format afterward)
ALTER TABLE calendar
ALTER COLUMN [Date] VARCHAR(10);
--Afterward, the calendar table needs to be imported again and it should work

--Viewing the data already inserted into the calendar table
SELECT * 
FROM calendar

--PENDING: Convert the "Date" field from VARCHAR to DATE
--Adding a new column with data type DATE
ALTER TABLE calendar ADD ValidDate DATE;
--Updating the records of this field with the VARCHAR records converted to DATE
UPDATE calendar
SET ValidDate = CONVERT(DATE,[Date],103); --Format 103 is the DD/MM/YYYY date format
--Deleting the field with the dates in VARCHAR
ALTER TABLE calendar DROP COLUMN [Date];
--Renaming the new column to the previous one: 'Date'
EXEC sp_rename 'calendar.ValidDate', 'Date', 'COLUMN';

SELECT * 
FROM calendar

--Viewing the data already inserted into the segments table
SELECT * 
FROM segments

--Viewing the data already inserted into the products table
SELECT * 
FROM products


/******************************** DATA CLEANING ********************************/

--Are there null values in the tables' columns? (We already know there are none in category)

--Checking null values in segments
SELECT 
    SUM(CASE WHEN [Category] IS NULL THEN 1 ELSE 0 END) AS CategoryNulls,
    SUM(CASE WHEN [Attr1] IS NULL THEN 1 ELSE 0 END) AS Attr1Nulls,
    SUM(CASE WHEN [Attr2] IS NULL THEN 1 ELSE 0 END) AS Attr2Nulls,
    SUM(CASE WHEN [Attr3] IS NULL THEN 1 ELSE 0 END) AS Attr3Nulls,
    SUM(CASE WHEN [Format] IS NULL THEN 1 ELSE 0 END) AS FormatNulls,
    SUM(CASE WHEN [Segment] IS NULL THEN 1 ELSE 0 END) AS SegmentNulls
FROM segments;

--Checking null values in calendar
SELECT 
    SUM(CASE WHEN [Week] IS NULL THEN 1 ELSE 0 END) AS WeekNulls,
    SUM(CASE WHEN [Year] IS NULL THEN 1 ELSE 0 END) AS YearNulls,
    SUM(CASE WHEN [Month] IS NULL THEN 1 ELSE 0 END) AS MonthNulls,
    SUM(CASE WHEN [WeekNumber] IS NULL THEN 1 ELSE 0 END) AS WeekNumberNulls,
    SUM(CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END) AS DateNulls
FROM calendar;

--Checking null values in products
SELECT 
    SUM(CASE WHEN [Manufacturer] IS NULL THEN 1 ELSE 0 END) AS ManufacturerNulls,
    SUM(CASE WHEN [Brand] IS NULL THEN 1 ELSE 0 END) AS BrandNulls,
    SUM(CASE WHEN [Item] IS NULL THEN 1 ELSE 0 END) AS ItemNulls,
    SUM(CASE WHEN [ItemDescription] IS NULL THEN 1 ELSE 0 END) AS ItemDescriptionNulls,
    SUM(CASE WHEN [Category] IS NULL THEN 1 ELSE 0 END) AS CategoryNulls,
    SUM(CASE WHEN [Format] IS NULL THEN 1 ELSE 0 END) AS FormatNulls,
    SUM(CASE WHEN [Attr1] IS NULL THEN 1 ELSE 0 END) AS Attr1Nulls,
    SUM(CASE WHEN [Attr2] IS NULL THEN 1 ELSE 0 END) AS Attr2Nulls,
    SUM(CASE WHEN [Attr3] IS NULL THEN 1 ELSE 0 END) AS Attr3Nulls
FROM products;

--Checking null values in sales
SELECT 
    SUM(CASE WHEN [Week] IS NULL THEN 1 ELSE 0 END) AS WeekNulls,
    SUM(CASE WHEN [ItemCode] IS NULL THEN 1 ELSE 0 END) AS ItemCodeNulls,
    SUM(CASE WHEN [TotalUnitSales] IS NULL THEN 1 ELSE 0 END) AS ItemNulls,
    SUM(CASE WHEN [TotalValueSales] IS NULL THEN 1 ELSE 0 END) AS TotalUnitSalesNulls,
    SUM(CASE WHEN [TotalUnitAvgWeeklySales] IS NULL THEN 1 ELSE 0 END) AS TotalUnitAvgWeeklySalesNulls,
    SUM(CASE WHEN [Region] IS NULL THEN 1 ELSE 0 END) AS RegionNulls
FROM sales;


--Handling the null values
UPDATE segments --There is only one null value in segments, in the Attr3 column
SET [Attr3] = ISNULL([Attr3], 'NO DEFINIDO');

UPDATE products --There are only 12 null values in the products table: 6 in Attr1 and 6 in Attr3
SET [Attr1] = ISNULL([Attr1], 'NO DEFINIDO'),
    [Attr3] = ISNULL([Attr3], 'NO DEFINIDO');


--Are there duplicates in the tables?
--The data will be grouped considering all columns, and rows appearing more than once will be shown
SELECT *, COUNT(*) AS VecesDuplicado
FROM calendar
GROUP BY [Week], [Year], [Month], [WeekNumber], [Date] 
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) AS VecesDuplicado
FROM segments
GROUP BY [Category], [Attr1], [Attr2], [Attr3], [Format], [Segment]
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) AS VecesDuplicado
FROM products
GROUP BY [Manufacturer], [Brand], [Item], [ItemDescription], [Category], [Format], [Attr1], [Attr2], [Attr3]
HAVING COUNT(*) > 1;

SELECT *, COUNT(*) AS VecesDuplicado
FROM sales
GROUP BY [Week], [ItemCode], [TotalUnitSales], [TotalValueSales], [TotalUnitAvgWeeklySales], [Region]
HAVING COUNT(*) > 1;

--Only one duplicate record was found, in the segments table
WITH cte_dups AS ( --Creating a CTE, since we need to filter on the column generated with ROW_NUMBER()
SELECT *, ROW_NUMBER() OVER( --Partitioning over all columns of the segments table
          PARTITION BY [Category], [Attr1], [Attr2], [Attr3], [Format], [Segment] 
          ORDER BY [Segment]) AS IdDuplicado
FROM segments
)
DELETE FROM cte_dups
WHERE IdDuplicado > 1; --Deleting the ones with IdDuplicado > 1, which correspond to duplicates


/************** Defining keys (PRIMARY KEY and FOREIGN KEY) ****************/
--Before assigning the "Primary Keys", we need to make sure there are no null or duplicate values.
--(in all tables except category, since we already confirmed there are no duplicate values)

--Checking for duplicates only in the fields that should be primary keys for the tables:
--calendar (Week field)
SELECT [Week], COUNT(*) AS Frecuency
FROM calendar
GROUP BY [Week]
HAVING COUNT(*) > 1;
--segments (Category, Attr1, Attr2, Attr3, Format fields)
SELECT [Category], [Attr1], [Attr2], [Attr3], [Format], COUNT(*) AS Frecuency
FROM segments
GROUP BY [Category], [Attr1], [Attr2], [Attr3], [Format]
HAVING COUNT(*) > 1;
--products (Item field)
SELECT [Item], COUNT(*) AS Frecuency
FROM products
GROUP BY [Item]
HAVING COUNT(*) > 1;

--Is there any product in the "sales" table with ItemCode = 'N/A'?
SELECT [ItemCode]
FROM sales
WHERE [ItemCode] = 'N/A'

--Since there is no product with ItemCode 'N/A', it's best to delete them, as they won't be useful for Joins
DELETE FROM products
WHERE [Item] = 'N/A';


--Once this has been checked, we can assign the Primary and Foreign Keys to each table:

--category only has the Primary Key of IdCategory
ALTER TABLE category
ALTER COLUMN [IdCategory] TINYINT NOT NULL; --First we need to redefine it so it doesn't accept null values
ALTER TABLE category
ADD CONSTRAINT PK_IdCategory PRIMARY KEY CLUSTERED ([IdCategory]); --Assigning the Primary Key

--calendar only has the Primary Key of Week
ALTER TABLE calendar
ALTER COLUMN [Week] VARCHAR(10) NOT NULL; --First we need to redefine it so it doesn't accept null values
ALTER TABLE calendar
ADD CONSTRAINT PK_Week PRIMARY KEY CLUSTERED ([Week]); --Assigning the Primary Key 

--segments has a Composite Primary Key made up of: [Category],[Attr1],[Attr2],[Attr3],[Format]
ALTER TABLE segments
ALTER COLUMN [Category] TINYINT NOT NULL; 
ALTER TABLE segments
ALTER COLUMN [Attr1] VARCHAR(30) NOT NULL;
ALTER TABLE segments
ALTER COLUMN [Attr2] VARCHAR(30) NOT NULL;
ALTER TABLE segments
ALTER COLUMN [Attr3] VARCHAR(30) NOT NULL;
ALTER TABLE segments
ALTER COLUMN [Format] VARCHAR(30) NOT NULL;
ALTER TABLE segments
ADD CONSTRAINT PK_segment PRIMARY KEY ([Category],[Attr1],[Attr2],[Attr3],[Format]); --Assigning the Primary Key 

--products has the PK of Item, and two FKs: Category and the composite one from the segments table
ALTER TABLE products
ALTER COLUMN [Item] VARCHAR(100) NOT NULL; --First we need to redefine it so it doesn't accept null values
ALTER TABLE products
ADD CONSTRAINT PK_Item PRIMARY KEY CLUSTERED ([Item]); --Assigning the Primary Key 
ALTER TABLE products
ADD CONSTRAINT FK_Category FOREIGN KEY ([Category]) --Assigning the Foreign Key 
REFERENCES category([IdCategory]); --References the PK of calendar
ALTER TABLE products --Assigning the Composite Foreign Key
ADD CONSTRAINT FK_segments FOREIGN KEY ([Category],[Attr1],[Attr2],[Attr3],[Format])  
REFERENCES segments ([Category],[Attr1],[Attr2],[Attr3],[Format]); --References the PK of segments

--sales has 2 Foreign Keys: Week and ItemCode
ALTER TABLE sales
ADD CONSTRAINT FK_Week FOREIGN KEY ([Week]) --Assigning the Foreign Key 
REFERENCES calendar([Week]); --References the PK of calendar
ALTER TABLE sales
ADD CONSTRAINT FK_Item FOREIGN KEY ([ItemCode]) --Assigning the Foreign Key 
REFERENCES products([Item]); --References the PK of products


/******************************** TABLE JOINS ********************************/
--With the database now complete and prepared, we can perform some JOINS and generate views from them
CREATE VIEW [Productos Detallados] AS
SELECT p.[Item], p.[Manufacturer], p.[Brand], p.[ItemDescription], 
       c.[Category], s.[Format], s.[Segment], s.[Attr1], s.[Attr2], s.[Attr3] --Fields to display
FROM products AS p
    INNER JOIN category AS c ON c.[IdCategory] = p.[Category] --Performing an Inner Join using the category identifier (PK IdCategory)
    INNER JOIN segments AS s ON p.[Category] = s.[Category] AND p.[Attr1] = s.[Attr1] AND
                                p.[Attr2] = s.[Attr2] AND p.[Attr3] = s.[Attr3] AND
                                p.[Format] = s.[Format]; --Performing an Inner Join using the composite PK to obtain the products' segments
--Viewing the created view
SELECT *
FROM [Productos Detallados];

CREATE VIEW [Ventas con Fechas] AS
SELECT ca.[Date], sa.[ItemCode], sa.[TotalUnitSales], 
       sa.[TotalValueSales], sa.[TotalUnitAvgWeeklySales], sa.[Region] --Fields to display
FROM sales AS sa
    INNER JOIN calendar AS ca ON ca.[Week] = sa.[Week]; --Performing an Inner Join using the week identifier (PK Week)
--Viewing the created view
SELECT *
FROM [Ventas con Fechas];

--For the next Join, we will use the two views created previously and combine them into a single one
CREATE VIEW [Datos Completos] AS
SELECT vf.[Date], vf.[ItemCode], pd.[ItemDescription], vf.[TotalUnitSales], 
       vf.[TotalValueSales], vf.[TotalUnitAvgWeeklySales], vf.[Region],
       pd.[Manufacturer], pd.[Brand], pd.[Category], pd.[Format], 
       pd.[Segment], pd.[Attr1], pd.[Attr2], pd.[Attr3] --Fields to display
FROM [Productos Detallados] AS pd
    INNER JOIN [Ventas con Fechas] AS vf ON pd.[Item] = vf.[ItemCode]; --Performing an Inner Join using the product code (PK Item)
--Viewing the created view
SELECT *
FROM [Datos Completos];

/******************************** KEY INSIGHTS ********************************/
/*
Below, multiple queries will be presented against the newly created database, with the goal
of obtaining key sales insights. To do this, sales statistics will be calculated, defined as:

Sales statistics: The number of sales (record frequency), the average unit sales 
(TotalUnitSales) and the historical sales performance (TotalUnitAvgWeeklySales), 
as well as the average and total sum of total monetary sales (TotalValueSales)
*/

--Calculating sales statistics by segment (Segment)
SELECT [Segment], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM [Datos Completos]
GROUP BY [Segment]
ORDER BY AVG(TotalValueSales) DESC;

--Calculating sales statistics by format (Format)
SELECT [Format], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM [Datos Completos]
GROUP BY [Format]
ORDER BY AVG(TotalValueSales) DESC;

--Calculating sales statistics by region (Region)
SELECT [Region], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM [Datos Completos]
GROUP BY [Region]
ORDER BY AVG(TotalUnitSales) DESC;

--Calculating sales statistics by brand (Brand). Since there are many brands, only the Top 5 best will be shown.
SELECT TOP(5) [Brand], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM [Datos Completos]
GROUP BY [Brand]
ORDER BY AVG(TotalValueSales) DESC; 

--Let's say we want to know where Lysol ranks among brands by average sales
WITH cte AS ( --If a CTE is not used, the ranking won't work correctly
SELECT [Brand], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales,
       RANK() OVER(ORDER BY AVG(TotalValueSales) DESC) AS RankAvgSales,
       RANK() OVER(ORDER BY SUM(TotalValueSales) DESC) AS RankSumSales
FROM [Datos Completos]
GROUP BY [Brand]
)
SELECT *
FROM cte
WHERE [Brand] = 'LYSOL';


--MULTIPLE GROUPINGS
--Calculating sales statistics by Region and Segment
SELECT TOP (10)
       [Region],
       [Segment], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM [Datos Completos]
GROUP BY [Region], [Segment]
ORDER BY AVG(TotalValueSales) DESC;

--Calculating sales statistics by Segment and Format
SELECT TOP (10)
       [Segment],
       [Format], 
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM [Datos Completos]
GROUP BY [Segment], [Format]
ORDER BY AVG(TotalValueSales) DESC;

--MORE ELABORATE QUERIES

/*
Showing the best-selling product of each brand, showing its sales statistics. To display only
important information, only products from the Vanish and Lysol brands (the brands of interest) and the
other Top 5 best-selling brands (BLANCATEL,CLORALEX,CLOROX,CLARASOL) will be selected
*/
WITH cte_items AS ( --CTE with the sales statistics for each product
    SELECT [Brand],
           [ItemDescription],
           [Segment], 
           AVG(TotalUnitSales) AS AvgUnitSales,
           AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
           AVG(TotalValueSales) AS AvgValueSales,
           SUM(TotalValueSales) AS SumValueSales
    FROM [Datos Completos]
    GROUP BY [Brand],[ItemDescription],[Segment]
),
cte_ranked AS ( --Creating another CTE in order to apply a RANK partitioned by brand, since this new column will be used afterward
    SELECT *,
           RANK() OVER(PARTITION BY [Brand] ORDER BY AvgValueSales DESC) AS RankBrand
    FROM cte_items
)
SELECT *
FROM cte_ranked --Only the best product per brand will be selected (RankBrand = 1), and only for the corresponding brands
WHERE RankBrand = 1 AND [Brand] IN ('VANISH','LYSOL','BLANCATEL','CLORALEX','CLOROX','CLARASOL')
ORDER BY AvgValueSales DESC;

/*
We are going to use the dates to create a category based on the quarter they correspond to
The standard corporate quarterly division is defined as:
- Q1: Jan-Mar
- Q2: Apr-Jun
- Q3: Jul-Sep
- Q4: Oct-Dec
*/

--First we need to know the range of available dates
SELECT MIN([Date]) AS FechaMin, MAX([Date]) AS FechaMax
FROM [Datos Completos]; --The dates will appear in YYYY-MM-DD format

/*
We can see that we have sales from January 9, 2022 to July 17, 2023, so we can
divide the sales from Q1 2022 to Q3 2023. Next, sales will be grouped by
quarter and their sales statistics will be shown
*/
WITH cte_trimesters AS (
SELECT *, 
       CASE
            WHEN [Date] BETWEEN '2022-01-01' AND '2022-03-31' THEN 'Q1-2022'
            WHEN [Date] BETWEEN '2022-04-01' AND '2022-06-30' THEN 'Q2-2022'
            WHEN [Date] BETWEEN '2022-07-01' AND '2022-09-30' THEN 'Q3-2022'
            WHEN [Date] BETWEEN '2022-10-01' AND '2022-12-31' THEN 'Q4-2022'
            WHEN [Date] BETWEEN '2023-01-01' AND '2023-03-31' THEN 'Q1-2023'
            WHEN [Date] BETWEEN '2023-04-01' AND '2023-06-30' THEN 'Q2-2023'
            ELSE 'Q3-2023' END AS Trimester
FROM [Datos Completos]
)
SELECT [Trimester],
       COUNT(*) AS Frecuencia, 
       AVG(TotalUnitSales) AS AvgUnitSales,
       AVG(TotalUnitAvgWeeklySales) AS AvgUnitWeeklySales,
       AVG(TotalValueSales) AS AvgValueSales,
       SUM(TotalValueSales) AS SumValueSales
FROM cte_trimesters
WHERE [Brand] IN ('VANISH','LYSOL')
GROUP BY Trimester
ORDER BY AVG(TotalValueSales) DESC;
