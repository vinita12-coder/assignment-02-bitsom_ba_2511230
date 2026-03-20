## Database Recommendation 

For a healthcare patient management solution, the primary database should be MySQL.

Healthcare records are highly confidential and involve linked entities (patients, doctors, appointments, prescriptions, billing).
These entities have strict, normalized relationships best served by a relational database.
MySQL supports ACID (Atomicity, Consistency, Isolation, Durability), which ensures reliable transaction behavior.
Example: if saving a prescription fails halfway, MySQL prevents storing partial/out-of-sync data.
MongoDB, by contrast, follows BASE (Basically Available, Soft state, Eventually consistent).

This model increases scalability and availability but can allow temporary data discrepancies, which is undesirable for critical patient data.
Because patient record consistency is essential, relational DB (MySQL) is the right choice for the core system.

CAP theorem: prioritizing consistency over availability is the correct tradeoff for medical data integrity.
For a supplemental fraud detection feature:
Fraud detection often uses high-volume semi-structured/unstructured data (behavior logs, transactions, events).
This use case benefits from flexible schema and horizontal scaling.
MongoDB is better suited here.

Hence:
Core patient management → MySQL (strong consistency and data correctness)
Fraud detection analytics → MongoDB (flexible schema, scalable)
