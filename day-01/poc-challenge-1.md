# Challenge 1 - Configure the environment and raw import

## Introduction

Wide World Importers (WWI) is in the process of building a new, modern analytics solution. Their existing analytics solution was created using an older, on-premises version of SQL Server and was based only on the relational engine. WWI's top management expects the new solution to support the strategic move towards near-real-time data analysis.

The core objective of Challenge 1 is to perform an import WWI's raw data into Azure Synapse Analytics.

## Completing the challenge

Work as a team to complete this challenge. Please pay attention to the challenge's background story, as it contains insights into the customer's pain points and what they want to solve. Successful teams collaborate on understanding the challenge, then divide and conquer to work in parallel as much as possible.

You have the freedom to choose the solution your team believes will best fit WWI's needs. However, you must be able to explain the thought process behind the decisions to your coach.

> **IMPORTANT TECHNICAL NOTE**
>
> Your workplace for the challenges is the `wwi_poc` schema in your SQL pool.
>
> In case you need to create additional tables, you must use the same schema (`wwi_poc`) for them.

## Background story

WWI began an internal initiative to modernize its outdated, on-premises data and analytics platform by migrating a year of historical data to Azure Synapse Analytics. The promise of a highly-scalable, thoroughly modern, unified data warehouse and analytics system capable of storing their old data and capturing and processing new data as it arrives sold them on Azure Synapse Analytics. They were also excited about the prospect of unlocking new insights by integrating non-relational data and being prepared to delve into machine learning when they are ready to tackle that challenge.

However, that promise never came. After importing each month's worth of sales data, the data engineering team would execute queries over the data set in the SQL pool. After a few iterations of this process, query execution became painfully slow. Each iteration of the data import took longer because they truncated the tables and re-imported all of the data up to the next month. Finally, the team gave up on the process and decided to seek outside help.

Wide World Importers wants your help proving that Synapse Analytics is the right platform for their needs. They have invested a fair amount of resources to this project already, and have gotten the go-ahead from leadership and the board to fully migrate to a new solution over the next eight to twelve months.

## Technical details

Sales data is currently being inserted into the SQL pool. About 57% of the data is already in the internal tables of the SQL Pool. The data roughly covers Jan 2014 to April 2017. The remainder of the data is in external CSV and Parquet files.

One of WWI's large LOB systems had a major outage during May 2017. Data was exported using an alternative approach and is available in CSV files. Starting in June 2017, data is available as Parquet files.

Also, customer data was only partially imported. Issues with the processing of customer information prevented a complete import of customer data.

## WWI resources

WWI loaded their data to the primary ADLS Gen2 account for the Synapse Analytics workspace.

You can find the CSV files for May 2017 in the following path: `wwi-02 / sale-poc`.

> **TIPS**
>
> 1. Do not make assumptions about the condition or quality of the data in the CSV files. Synapse Studio allows you to open files using either SQL or Spark in the Data hub to explore the first few files in the May 2017 dataset prior to importing it into tables. Do the data types found in the tables match what you are seeing in the files?
> 2. Look for issues that could impact your ability to cleanly import the files using a code-free approach (e.g., Are there values in fields that might cause issues? Are the files properly formatted as CSV files?)
> 3. Take a few minutes to understand the capabilities of Synapse Pipelines, Synapse SQL, and Spark for handling problematic files.
> 4. Don't be afraid to embrace the Spark side to address any problem files!

You can find the Parquet files in the following paths:

- `wwi-02 / sale-small / Year=2017 / Quarter=Q2 / Month=6`
- `wwi-02 / sale-small / Year=2017 / Quarter=Q3`
- `wwi-02 / sale-small / Year=2017 / Quarter=Q4`
- `wwi-02 / sale-small / Year=2018`
- `wwi-02 / sale-small / Year=2019`

> **IMPORTANT TECHNICAL NOTE**
>
> Do not use other files from the data lake to import sales data as they will invalidate the results of the PoC.

You can find the complete customer data in the following path: `wwi-02 / data-generators / generator-customer.csv`. The file should be approximately 140 MB in size.

> **TIPS**
>
> 1. Use Synapse Studio to explore the customer data file and validate the data in each field appears correct.
> 2. You will need the customer's country of residence later. How might you be able to isolate this value in the address field and add it to a country column?

## Success criteria

- **All data** is migrated to the SQL pool. At this point, you are performing a raw import, which means that your focus is not on the repeatability of the data load process.
- There are no time constraints on the data loading operation, but be mindful of leaving time for the remaining challenges.
  - Consider working with a subset of both the CSV and Parquet files as you iterate through your data loading process. Test your assumptions with smaller sample sizes before loading the entire data set.
