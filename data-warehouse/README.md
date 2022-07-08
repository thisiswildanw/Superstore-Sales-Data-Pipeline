### Data Warehouse

  **1. Create Empty Fact and Dimension Table Based on Data Warehouse Modeling**
   
  Main process: 
   - Design a star schema data model for data warehouse using [sqldbm](https://app.sqldbm.com). 
   - Create sales_warehouse dataset in BigQuery.
   - Create empty fact and dimension table based designed data model.
    
  Star Schema Model:  

  <p align="center">
      <img src="images/data_warehouse_design.png" style="border: 1px solid black" alt="Data Staging Design" >
  </p>
     
  <p align="center">
      <img src="images/dataset_warehouse.png" style="border: 1px solid black" alt="Data Staging Design" >
  </p>

  Empty Sales Fact For Example:
  <p align="center">
      <img src="images/empty_sales_fact.png" style="border: 1px solid black" alt="Data Staging Design" >
  </p>
  <br>
   

**2. Create Data Staging to Data Warehouse Data Flow Query**
  
  This query contain several process:  
  - Inflow process from order_staging to sales_fact, ship_dim and city_dim
  - Inflow process from categories_staging to product_dim using SCD Type-2
  - Inflow process from customer_staging to customer_dim using SCD Type-2
  
  
The Query Result For Sales Fact 
<p align="center">
      <img src="images/not_empty_sales_fact.png" style="border: 1px solid black" alt="Data Staging Design" >
  </p>
<br>

**3. Create Aggregation Table For Dashboard By Querying Data Warehouse**


**4. Automated Each Query Execution By First Day of The Month at 02.00 AM**
