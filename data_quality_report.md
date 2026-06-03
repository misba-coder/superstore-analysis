# Data Quality Assessment Report
## Dataset: Sample Superstore Sales Data
## Total Rows Before Cleaning: 10,194
## Total Rows After Cleaning: 10,192

---

## Checks Performed

### 1. Null Values
- **Result: PASSED**
- Zero null values found across all 21 columns
- No imputation or row removal required

### 2. Duplicate Rows
- **Result: ACTION TAKEN**
- Found 2 types of apparent duplicates:
  - Legitimate repeated purchases (same product, different quantities) — KEPT
  - True duplicate rows (all columns identical) — REMOVED
- Removed 2 true duplicate rows
- Final clean dataset: 10,192 rows

### 3. Invalid Sales Values
- **Result: PASSED**
- Zero rows with negative or zero sales values

### 4. Invalid Dates
- **Result: PASSED**
- Zero cases where ship date was before order date

### 5. Categorical Column Consistency
- **Result: PASSED**
- Ship Mode: 4 valid categories (First Class, Same Day, Second Class, Standard Class)
- No typos or inconsistencies found

### 6. Statistical Summary
| Metric | Min | Max | Average |
|--------|-----|-----|---------|
| Sales | $0.44 | $22,638.48 | $228.23 |
| Profit | -$6,599.98 | $8,399.98 | $28.67 |
| Discount | 0% | 80% | 16% |

### Key Observations
- Extremely thin profit margins — average profit only $28.67 on average sale of $228
- Maximum discount of 80% suggests aggressive discounting may be hurting profitability
- Single transaction loss of $6,599.98 warrants further investigation
- Data is otherwise clean and ready for analysis

---
## Conclusion
Dataset is clean and ready for analysis after removal of 2 duplicate rows.