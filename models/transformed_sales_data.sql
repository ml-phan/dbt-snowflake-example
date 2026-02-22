{{ config(alias='transformed_sales_data', materialized='table')}}

WITH transformed_sales_data AS(
    SELECT
        order_id,
        order_date,
        YEAR(TRY_TO_DATE(order_date)) AS order_year,
        MONTH(TRY_TO_DATE(order_date)) AS order_month,
        DAY(TRY_TO_DATE(order_date)) AS order_day,
        customer_id,
        product_id,
        product_name,
        quantity,
        price,
        (quantity * price) AS total_amount
    FROM {{ ref('raw_sales_data') }}
)
SELECT * FROM transformed_sales_data