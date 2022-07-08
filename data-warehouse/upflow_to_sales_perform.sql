DROP TABLE IF EXISTS `wildan-portofolio.sales_dashboard.yearly_sales_performance`;
CREATE TABLE `wildan-portofolio.sales_dashboard.yearly_sales_performance` AS  
WITH first_last_order AS ( 
  SELECT
  Customer_ID,
  Order_ID,
  Order_Date,
  City,
  CASE 
    WHEN ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY  Order_Date) = 1 THEN 1
    ELSE 0
  END AS Is_First_Order,
  CASE 
    WHEN ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Order_Date DESC) = 1 THEN 1
    ELSE 0
  END AS Is_Last_Order,
  Qty,
  ROUND(Cost,1) Gross_Cost,
  ROUND(Gross_Sales-Cost,1) Mark_Up,
  ROUND(Discount,1) Discount_Cost,
  ROUND(Sales,1) Sales,  
  CASE
    WHEN Profit > 0 THEN 0
    ELSE ROUND(Profit,1)
  END AS Loss,
  CASE 
    WHEN Profit >= 0 THEN ROUND(Profit,1)
    ELSE 0
  END AS Profit,
  FROM(
    SELECT
      Customer_ID,
      Order_ID,
      Order_Date,
      City,
      SUM(Quantity) Qty,
      SUM(Sales+(Discount*Sales)) Gross_Sales,
      SUM(Discount*Sales*-1) Discount,
      SUM(Sales) Sales,
      SUM(Sales-Profit) Cost,
      SUM(Profit) Profit,
    FROM
      `wildan-portofolio.sales_warehouse.sales_fact`
    GROUP BY Customer_ID, Order_ID, Order_Date, City)
)
SELECT
  fl.* EXCEPT (City),
  cdim.* EXCEPT (Customer_ID, Started_Date, End_Date,Flag),
  ct.* EXCEPT (City, Postal_Code, State, Country)
FROM first_last_order fl
  INNER JOIN `wildan-portofolio.sales_warehouse.customer_dim` cdim
  ON fl.Customer_ID = cdim.Customer_ID 
    INNER JOIN `wildan-portofolio.sales_warehouse.city_dim` ct
    ON ct.City =fl.City
ORDER BY fl.Customer_ID, Order_Date DESC;