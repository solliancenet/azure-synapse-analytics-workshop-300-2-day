# Challenge 4 - Using Apache Spark in Synapse

## Introduction

Wide World Importers (WWI) is in the process of building a new, modern analytics solution. Their existing analytics solution was created using an older, on-premises version of SQL Server and was based only on the relational engine. WWI's top management expects the new solution to support the strategic move towards near-real-time data analysis.

The core objective of Challenge 4 is to demonstrate how Synapse Spark and Spark ML can be used to train Machine Learning models using data available in the Data Lake.

## Completing the challenges

Work as a team to complete the challenges listed below. Please pay attention to each challenge's background story, as they contain insights into the customer's pain points and what they want to solve. Successful teams collaborate on understanding each challenge, then divide and conquer to work in parallel as much as possible.

You have the freedom to choose the solution your team believes will best fit WWI's needs. However, you must be able to explain the thought process behind the decisions to your coach.

> **IMPORTANT TECHNICAL NOTE**
>
> Your workplace for the challenges is the `wwi_poc` schema in your SQL pool.
>
> In case you need to create additional tables, you must use the same schema (`wwi_poc`) for them.

## Background story

Wide World Importers is looking to improve its business processes using Data Engineering and Machine Learning at scale. They expect Synapse Analytics to support their initiative by allowing their Spark developers to work seamlessly with data, regardless of whether in the Data Lake or dedicated SQL Pools. 

WWI expects the new analytics solution to be a source of valuable data for various Machine Learning processes. The Chief Data Scientist of WWI wants to be sure that Synapse Analytics can deliver on these expectations. One of the current initiatives of WWI is to start providing personalized recommendations to its customers. As part of the PoC, they expect to see a demo implementation of a recommender engine built with Spark on top of sales data already imported in dedicated SQL pools.

While laying out plans for using a combination of SQL pool and Data Lake data, WWI's Data Engineering team has raised concerns about Spark's performance when working with the Data Lake. They would like to understand which are the options they could use to alleviate that concern.

### Technical details

One of the simple approaches to demonstrate a recommender engine is to use the Alternating Least Squares (ALS) algorithm available in PySpark (which uses a matrix factorisation technique).

For data lake indexing, you can use the open source Hyperspace engine (https://cloudblogs.microsoft.com/opensource/2020/06/30/hyperspace-indexing-subsystem-apache-spark-now-open-source/).

### Success criteria

- Implement and demonstrate a simple recommender engine using Spark.
- Demonstrate how indexing can help improving the way you work with the Data Lake in Spark.