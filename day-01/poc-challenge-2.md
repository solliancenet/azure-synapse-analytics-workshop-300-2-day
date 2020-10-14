# Challenge 2 - Optimize data load

## Introduction

Wide World Importers (WWI) is in the process of building a new, modern analytics solution. Their existing analytics solution was created using an older, on-premises version of SQL Server and was based only on the relational engine. WWI's top management expects the new solution to support the strategic move towards near-real-time data analysis.

The core objective of Challenge 2 is to optimize the raw data import into Azure Synapse Analytics, ensuring the process is repeatable and WWI's RTO requirements are properly met.

## Completing the challenge

Work as a team to complete this challenge. Please pay attention to the challenge's background story, as it contains insights into the customer's pain points and what they want to solve. Successful teams collaborate on understanding the challenge, then divide and conquer to work in parallel as much as possible.

You have the freedom to choose the solution your team believes will best fit WWI's needs. However, you must be able to explain the thought process behind the decisions to your coach.

> **IMPORTANT TECHNICAL NOTE**
>
> Your workplace for the challenges is the `wwi_poc` schema in your SQL pool.
>
> In case you need to create additional tables, you must use the same schema (`wwi_poc`) for them.

### Background story

Importing all of the existing data is only part of the data load story. Wide World Importers has a recovery time objective (RTO) of 60 minutes for a full rebuild of the warehouse. If, during testing and experimentation, for example, data gets corrupted in the SQL pool, they want the ability to rebuild the warehouse for a new iteration of testing altogether. The data engineers lack confidence in the warehouse and have grown accustomed to iterating over snapshots of their data throughout the process. This RTO gives them the confidence to proceed with further testing and configuration of the system.

In addition to the RTO requirements, top management is demanding more and more of a departure from the traditional "analyze today, yesterday's data." The goal is to significantly reduce the gap between the moment data is generated, and the moment it ends up in dashboards.

Data post-May 2017 is now coming in as a continuous stream of Parquet files. Propose and implement a data lake architecture where top management can get data with various compromises between delivery speed and accuracy/completeness. Provide a bronze level where freshly collected sales data is analyzed using Synapse SQL Serverless and exposed to dashboards. Provide a silver level where data quality has been increased via data engineering. Finally, provide the gold level where top-quality data has been persisted in a Synapse SQL Pool.

> **TIPS**
>
> 1. Think about ways your pipeline can parallelize data ingestion.
> 2. Consider the impact of indexes on performance when importing data into tables. How can you optimize the process to account for this?

### Success criteria

- You have created a data loading pipeline that provides a repeatable import process and meets the RTO requirements of a 60-minute full rebuild of the warehouse.
- You have proven this process by wiping out the database (excluding pre-existing data) and conducting a full import with predictable results and processing time.
- You store all raw data in a bronze folder, cleaned up data in a silver folder, and all fully-transformed data stores in the SQL pool.
- The data loading resource takes priority over all other resources connected to the SQL pool.

> **IMPORTANT TECHNICAL NOTE**
>
> Observe the important detail in the second success criteria: you should NOT take into account the pre-existing data when estimating and demonstrating the required RTO.
