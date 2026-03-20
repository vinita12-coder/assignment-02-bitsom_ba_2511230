## Anomaly Analysis 
### Update Anomaly
**Columns**: sales_rep_id, sales_rep_name, sales_rep_email, office_address
**Rows**: e.g., Row 3 (ORD1114), Row 39 (ORD1180), and many rows for sales_rep_id = SR01
The sales rep address is repeated in each order row.
SR01 appears in 80+ orders, so address changes must update all those rows.
When only some rows were updated, the data became inconsistent:

“Mumbai HQ, Nariman Point, Mumbai - 400021”
“Mumbai HQ, Nariman Pt, Mumbai - 400021”
This is exactly an update anomaly.


### Delete Anomaly
**Columns**: product_id, product_name, category, unit_price
**Row** : Row 13 (ORD1185)
 Product P008 (Webcam, Electronics, ₹2100) appears in only one order row.
 If ORD1185 is deleted (canceled/archived), that product detail disappears too.
 No separate products table means product data is tied to orders, causing delete anomaly.


### Insert Anomaly
**Columns** : sales_rep_id, sales_rep_name, sales_rep_email, office_address
Current reps:
SR01 (Deepak Joshi)
SR02 (Anita Desai)
SR03 (Ravi Kumar). 
 Adding new rep SR04 (Priya Kapoor) would require a fake order row if data stays in one flat table.
 Sales rep info must be in an independent sales_reps table to avoid this insert anomaly.

## Normalization Justification
Flat orders_flat.csv may look simple but introduces real data risks.
 Redundancy means update errors and inconsistent values (e.g., mismatched office addresses).
 Delete of one order can erase important "master" data (product is lost).
 New master entities (sales reps) can’t be inserted cleanly without fake transactions.
### Normalization:
Separates data into related tables (e.g., orders, products, sales_reps),guarantees consistency,prevents redundant updates,avoids accidental data loss,Tradeoff: more joins, but data integrity is worth it.
