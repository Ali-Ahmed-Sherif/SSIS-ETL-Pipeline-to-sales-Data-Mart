# Sales Data Mart 2022

## Objective
The goal of this project is to design and implement a **Sales Data Mart** using **AdventureWorks 2022 ODS** as the source system.  
The Data Mart follows a **star schema** to support **business intelligence** and **analytical reporting** on sales performance.

The project consists of two main phases:

1. **Data Mart Design** – Building fact and dimension tables, implementing primary and foreign keys, and optimizing with indexes.  
2. **ETL Development** – Using **SSIS** to extract, transform, and load data from the ODS into the Sales Data Mart.  

---

## Data Mart Design
<img width="1236" height="1237" alt="image" src="https://github.com/user-attachments/assets/f5d7e6c6-b944-4f12-84e4-5f03b124f79f" />


### Fact Table: `fact_sales`
The fact table captures **sales transaction details**.  

- **Primary Key:** Composite (`sales_order_id`, `line_number`)  
- **Foreign Keys:** References all four dimensions (`product_key`, `customer_key`, `territory_key`, `order_date_key`)  

**Key Measures:**  

order_quantity

unit_price

unit_cost

tax_amount

freight_amount

extended_sales

extended_cost

---

### Dimension Tables

**`dim_product`**  
- Attributes: `product_key`, `product_id`, `product_name`, `sub_category`, `category`, `color`, `model`, `discontinued_flag`  
- Supports **Slowly Changing Dimensions (SCD)** for product updates  

**`dim_customer`**  
- Attributes: `customer_key`, `customer_id`, `first_name`, `last_name`, `gender`, `birth_date`, `marital_status`, `education`, `income`, `phone`, `email`, `address`, `city`, `state`, `country`  

**`dim_territory`**  
- Attributes: `territory_key`, `territory_id`, `territory_name`, `region`, `country`, `group_name`  

**`dim_date`**  
- Attributes: `date_key`, `full_date`, `day`, `month`, `quarter`, `year`  

> Each dimension includes an **"Unknown" record** (`surrogate key = 0`) to handle missing data gracefully.  

---

### Indexing Strategy
To improve query performance and support **OLAP operations**:  

- **Fact Table:** Indexes on foreign keys (`product_key`, `customer_key`, `territory_key`, `order_date_key`)  
- **Dimension Tables:** Indexes on business keys (`product_id`, `customer_id`, `territory_id`)  
- **Additional Indexes:** Frequently filtered attributes such as `city` and `category`  

This ensures **efficient JOIN operations** and faster **slice-and-dice analysis** in the data mart.  

---

## ETL Development (SSIS)

The ETL was built using **SQL Server Integration Services (SSIS)** to load data from the AdventureWorks ODS into the Sales Data Mart.  

**Dimension ETL Packages:**  
- **Extract** data from source tables  
- **Clean and transform** data (default values, surrogate keys)  
- Handle **Slowly Changing Dimensions** (`dim_product` and `dim_customer`)  
- Insert **"Unknown" rows** for missing references  

**Fact Table ETL:**  
- Maintains **referential integrity** with all dimensions  
- Calculates **extended sales and cost**  
- Handles **NULL or invalid references** (mapped to "Unknown")  

**Packages Overview:**  
- **`Dim_Product` Package:**  <img width="960" height="608" alt="image" src="https://github.com/user-attachments/assets/25999ca6-842a-4726-9364-495fb030566b" />
- **`Dim_Date` Package:** <img width="485" height="440" alt="image" src="https://github.com/user-attachments/assets/672e1632-dbb9-41a3-9db9-4af401fdcf98" />
- **`Dim_Territory` Package:** <img width="539" height="373" alt="image" src="https://github.com/user-attachments/assets/48b1aaa5-7603-4799-9f62-87c2097066a1" />











