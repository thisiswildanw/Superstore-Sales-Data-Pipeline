MERGE `wildan-portofolio.sales_warehouse.product_dim` p_dim
USING (
SELECT 
    Product_ID,
    Product_Name,
    Category,
    Sub_Category
FROM `wildan-portofolio.sales_staging.categories_staging`
GROUP BY 1,2,3,4
) cs
ON p_dim.Product_ID = cs.Product_ID
WHEN NOT MATCHED THEN 
INSERT VALUES (
    cs.Product_ID,
    cs.Category,
    cs.Sub_Category,
    cs.Product_Name,
    CURRENT_DATE(),
    NULL,
    TRUE
)
WHEN MATCHED AND (
p_dim.Category <> cs.Category
OR p_dim.Sub_Category <> cs.Sub_Category
OR p_dim.Product_Name <> cs.Product_Name
)
THEN UPDATE SET 
End_Date = CURRENT_DATE, Flag = False;

#Inflow sales_staging.customers_staging to sales_warehouse.cutomers_dim using SCD Type 2
MERGE `wildan-portofolio.sales_warehouse.customer_dim` c_main
USING `wildan-portofolio.sales_staging.customers_staging` ts
ON c_main.Customer_ID = ts.Customer_ID
WHEN NOT MATCHED THEN 
INSERT VALUES (
    ts.Customer_ID,
    ts.Customer_Name,
    ts.Segment,
    CURRENT_DATE(),
    NULL,
    TRUE
)
WHEN MATCHED AND (
c_main.Customer_ID <> ts.Customer_ID
OR c_main.Customer_Name <> ts.Customer_Name
OR c_main.Segment <> ts.Segment
)
THEN UPDATE SET 
End_Date = CURRENT_DATE(), Flag = False;

#Inflow sales_staging.order_staging to sales_warehouse.sales_fact
MERGE `wildan-portofolio.sales_warehouse.sales_fact` s_main
USING `wildan-portofolio.sales_staging.orders_staging` os
ON 
s_main.Order_ID = os.Order_ID 
AND s_main.Order_Date = DATE(os.Order_Date)
AND s_main.Product_ID = os.Product_ID
AND s_main.Customer_ID = os.Customer_ID
AND s_main.City = os.City
AND s_main.Quantity = CAST(ROUND(os.Quantity) AS INT64)
AND s_main.Discount = os.Discount
AND s_main.Profit = os.Profit
AND s_main.Sales = os.Sales
WHEN NOT MATCHED THEN 
INSERT VALUES (
    os.Order_ID,
    DATE(os.Order_Date),
    os.Product_ID,
    os.Customer_ID,
    os.City,
    CAST(ROUND(os.Quantity) AS INT64),
    os.Discount,
    os.Profit,
    os.Sales
);

#Inflow sales_staging.order_staging to sales_warehouse.ship_dim
MERGE `wildan-portofolio.sales_warehouse.ship_dim` sh_main
USING (
SELECT
    Order_ID,
    Ship_Date,
    Ship_Mode 
FROM
`wildan-portofolio.sales_staging.orders_staging`
GROUP BY
    Order_ID,
    Ship_Date,
    Ship_Mode) os
ON 
sh_main.Order_ID = os.Order_ID 
AND sh_main.Ship_Date = DATE(os.Ship_Date)
AND sh_main.Ship_Mode = os.Ship_Mode
WHEN NOT MATCHED THEN 
INSERT VALUES (
    os.Order_ID,
    DATE(os.Ship_Date),
    os.Ship_Mode
);

#Inflow sales_staging.order_staging to sales_warehouse.city_dim
MERGE `wildan-portofolio.sales_warehouse.city_dim` sh_main
USING (
SELECT
    City,
    Postal_Code,
    State,
    Region,
    Country 
FROM
`wildan-portofolio.sales_staging.orders_staging`
GROUP BY
    Postal_Code,
    City,
    State,
    Region,
    Country) os
ON 
    sh_main.City = os.City 
    AND sh_main.Postal_Code = CAST(ROUND(os.Postal_Code) AS INT64)
    AND sh_main.State = os.State
    AND sh_main.Region = os.Region
    AND sh_main.Country = os.Country 
WHEN NOT MATCHED THEN 
INSERT VALUES (
    City,
    CAST(ROUND(os.Postal_Code) AS INT64),
    State,
    Region,
    Country
);