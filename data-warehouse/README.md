# Data Warehouse

  ## Design Data Model
   
  We use [sqldbm](https://app.sqldbm.com) to design star-schema data model. 

  <p align="center">
      <img src="images/data_warehouse_design.png" style="border: 1px solid black" alt="Data Staging Design" >
  </p>

  ## Create empty table based on data model.
  Tutorial (product_dim) : 

  <p align="center">
      <img src="images/Create_Table_Part1.png" style="border: 1px solid black" alt="Data Staging Design" >
  </p>
  <p align="center">
      <img src="images/Create_Table_Part2.png" style="border: 1px solid black" alt="Data Staging Design" >
  </p>

  <br>


  Empty Sales Fact Table :
  <p align="center">
      <img src="images/empty_sales_fact.png" style="border: 1px solid black" alt="Data Staging Design" >
  </p>
  <br>

  Empty Product Dimension Table:
  <p align="center">
      <img src="images/empty_product_dim.png" style="border: 1px solid black" alt="Data Staging Design" >
  </p>
  <br>

  Empty Customer Dimension Table :
  <p align="center">
      <img src="images/empty_customer_dim.png" style="border: 1px solid black" alt="Data Staging Design" >
  </p>
  <br>
  
  Empty Ship Dim Table :
  <p align="center">
      <img src="images/empty_ship_dim.png" style="border: 1px solid black" alt="Data Staging Design" >
  </p>
  <br>

  Empty City Dim Table :
  <p align="center">
      <img src="images/empty_city_dim.png" style="border: 1px solid black" alt="Data Staging Design" >
  </p>
  <br>
   

  ## [Create Inflow query to move and transform data from sales staging to sales warehouse](upflow-query)
  
  Create scheduled queries by first day of month at 01.05 am that contain several process:  
  - Transform order_staging to sales_fact, ship_dim and city_dim
  - Transform categories_staging to product_dim using SCD Type-2
  - Transform customer_staging to customer_dim using SCD Type-2

  Click here to [More Details](inflow-query) 

## Create Downflow query to backup sales warehouse to Google Storage.

## Create Upflow query for sales performance dashboard.

## Create Upflow query for RFM dashboard.


