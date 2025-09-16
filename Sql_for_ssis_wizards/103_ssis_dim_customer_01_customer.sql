
use AdventureWorks2022;

SELECT CustomerID AS customer_id, PersonID
FROM Sales.Customer
WHERE PersonID IS NOT NULL
UNION ALL
SELECT NULL, NULL

use Sales_DataMart_2022;
ALTER TABLE dim_customer
ALTER COLUMN marital_status CHAR(1);
select * from dim_customer


use AdventureWorksDW2022
select * from DimCustomer


--birth_date
--marital status
--gender 
-- yearly_income
-- education

select CustomerKey ,Gender as gender, MaritalStatus as marital_status, BirthDate as birth_date, YearlyIncome as yearly_income, EnglishEducation as education
from DimCustomer






