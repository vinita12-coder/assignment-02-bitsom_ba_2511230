# Architecture Recommendation 
A rapidly expanding food delivery startup capturing GPS traces, reviews, payments, and menu images should use a Data Lakehouse.

**A classic Data Warehouse is optimized for structured, fixed-schema data, whereas this startup ingests mixed formats (text reviews, GPS events, image files) that don’t fit rigid tables well.**

**A pure Data Lake can store everything but lacks strong query performance, governance, and analytics features.**


## A Data Lakehouse gives the best of both worlds.
## Mixed data formats

Payment records are structured.

Reviews are unstructured text.

GPS logs are semi-structured.

Menu images are unstructured binary.

Lakehouse can keep all types in one platform without enforcing a strict schema up front.

### Mixed workload support

GPS stream is high-volume, real-time.

BI/reporting on orders/payments is batch/analytical.

Lakehouse supports both streaming and batch pipelines effectively.

### Scalability and cost

Data growth will be large.

Lakehouse uses scalable cloud storage (decoupled compute/storage), more cost-efficient than traditional warehouses that scale tightly.


### Conclusion: 

Data Lakehouse is the most appropriate scalable architecture for diverse data types and expected growth.
