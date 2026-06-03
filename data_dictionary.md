# Data Dictionary
## Project: Retail Sales Performance Analysis
## Dataset: Sample Superstore Sales Data

---

| Column | Type | Description |
|--------|------|-------------|
| row_id | Number | Unique row identifier |
| order_id | Text | Unique order identifier — one order can have multiple products |
| order_date | Date | When customer placed the order |
| ship_date | Date | When order was shipped |
| ship_mode | Text | Shipping speed chosen by customer |
| customer_id | Text | Unique customer identifier |
| customer_name | Text | Customer full name |
| segment | Text | Customer type — Consumer, Corporate, Home Office |
| country | Text | Country of sale |
| city | Text | City of sale |
| state | Text | State of sale |
| postal_code | Text | Postal code |
| region | Text | US Region — East, West, Central, South |
| product_id | Text | Unique product identifier |
| category | Text | Product category — Furniture, Office Supplies, Technology |
| sub_category | Text | Product sub-category |
| product_name | Text | Full product name |
| sales | Decimal | Revenue from the sale in USD |
| quantity | Number | Number of units sold |
| discount | Decimal | Discount applied — 0 means no discount |
| profit | Decimal | Profit or loss — negative means loss |

---

## Notes
- Total Columns: 21
- Total Rows: 10,192 (after cleaning)
- Date Range: 2023 to 2026
- Geography: United States only
- Currency: USD