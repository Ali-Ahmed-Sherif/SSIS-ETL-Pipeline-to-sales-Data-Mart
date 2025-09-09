if db_id('Sales_DataMart_2022') is not null
 drop database Sales_DataMart_2022;

create database Sales_DataMart_2022

use Sales_DataMart_2022

if exists (
select *
from sys.foreign_keys
WHERE  NAME = 'fk_fact_sales_dim_product'
                  AND parent_object_id = Object_id('fact_sales'))
alter table dim_product
drop constraint fk_fact_sales_dim_product;

go

if exists (
select * 
from sys.objects
where Name = 'dim_product'

)
  DROP TABLE dim_product

go



create table dim_product(
     product_key         INT NOT NULL IDENTITY(1, 1),-- surrogate key
     product_id          INT NOT NULL,--alternate key, business key
     product_name        NVARCHAR(50),
     Product_description NVARCHAR(400),
     product_subcategory NVARCHAR(50),
     product_category    NVARCHAR(50),
     color               NVARCHAR(15),
     model_name          NVARCHAR(50),
     reorder_point       SMALLINT,
     standard_cost       MONEY,

     source_system_code  tinyint not null,  -- meta data

     --Slowly Changing Dimensions
     start_date  datetime not null default (getdate()),
     end_date            DATETIME,
     is_current          TINYINT NOT NULL DEFAULT (1),
     constraint pk_dim_product Primary key clustered (product_key)
)

SET IDENTITY_INSERT dim_product ON

INSERT INTO dim_product
            (product_key,
             product_id,
             product_name,
             Product_description,
             product_subcategory,
             product_category,
             color,
             model_name,
             reorder_point,
             standard_cost,
             source_system_code,
             start_date,
             end_date,
             is_current)
VALUES      (0,
             0,
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             0,
             0,
             0,
             '1900-01-01',
             NULL,
             1);

SET IDENTITY_INSERT dim_product OFF

if exists (
select *
from sys.tables
where Name = 'fact_sales'
)
alter table fact_sales
add constraint fk_fact_sales_dim_product foreign key (product_key)
references dim_product(product_key);



-- create indexes
IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'dim_product_product_id'
                  AND object_id = Object_id('dim_product'))
  DROP INDEX dim_product.dim_product_product_id;

CREATE INDEX dim_product_product_id
  ON dim_product(product_id);

IF EXISTS (SELECT *
           FROM   sys.indexes
           WHERE  NAME = 'dim_prodct_product_category'
                  AND object_id = Object_id('dim_product'))
  DROP INDEX dim_product.dim_prodct_product_category

CREATE INDEX dim_prodct_product_category
  ON dim_product(product_category); 