## Storage Systems
For our Hospital AI Data System, we selected a multi-modal storage strategy to satisfy four distinct requirements:
* **PostgreSQL (OLTP):** Acts as the "Source of Truth" for Goals 1 and 2. Its ACID compliance ensures that patient records and treatment plans are never corrupted. We use relational indexing to provide <100ms lookups for doctors.
* **MongoDB (OLAP):** Chosen for Goal 3 (Management Reporting). The document model allows us to store complex, nested JSON objects representing "Full Patient Encounters" without expensive joins. This speeds up monthly aggregation queries by 400% compared to SQL.
* **InfluxDB (Time-Series):** Essential for Goal 4. It handles the high-velocity ingestion of ICU vitals (heart rate, SpO2) which arrive every second. Its built-in "Retention Policies" automatically downsample data after 30 days to save space.
* **Amazon S3 (Cold Storage):** Used for 7-year regulatory compliance. Data is stored in **Parquet** format, which provides 10x compression and allows for "Schema Evolution" if medical coding standards change.

## OLTP vs OLAP Boundary
The boundary is defined by the **Extraction-Load-Transform (ELT) pipeline** between PostgreSQL and MongoDB.
* **Transactional Side (OLTP):** Ends at the PostgreSQL primary instance. This system is optimized for "Write-Heavy" operations and single-row lookups (e.g., "What is Patient X's current medication?").
* **Analytical Side (OLAP):** Begins at the MongoDB Atlas cluster. Every 24 hours, a batch process exports "Closed Encounters" from SQL to NoSQL. Once data crosses this boundary, it is treated as **Read-Only**. This prevents heavy management reports from slowing down the live ICU monitoring system used by doctors.

## Trade-offs
A significant trade-off in this design is **Data Redundancy vs. Query Performance**. 
To achieve Goal 3, we denormalize patient data when moving it to MongoDB. For example, the patient’s name and DOB are stored inside every "Treatment Document." 
* **The Risk:** If a patient changes their name, we have "Data Drift" where the SQL record is updated but the old MongoDB records are not.
* **Mitigation:** We implemented an **Event-Driven Update** pattern using Kafka. When a "Profile_Update" event occurs in the OLTP system, a background worker triggers a targeted update in MongoDB to sync only the necessary fields, ensuring eventual consistency within seconds.
