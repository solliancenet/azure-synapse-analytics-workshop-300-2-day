# Challenge 3 - Optimize existing query performance and create new queries

## Introduction

Wide World Importers (WWI) is in the process of building a new, modern analytics solution. Their existing analytics solution was created using an older, on-premises version of SQL Server and was based only on the relational engine. WWI's top management expects the new solution to support the strategic move towards near-real-time data analysis.

The core objective of Challenge 3 is create secure, performant queries and build compelling visualizations over those queries.

## Completing the challenge

Work as a team to complete this challenge. Please pay attention to the challenge's background story, as it contains insights into the customer's pain points and what they want to solve. Successful teams collaborate on understanding the challenge, then divide and conquer to work in parallel as much as possible.

You have the freedom to choose the solution your team believes will best fit WWI's needs. However, you must be able to explain the thought process behind the decisions to your coach.

> **IMPORTANT TECHNICAL NOTE**
>
> Your workplace for the challenges is the `wwi_poc` schema in your SQL pool.
>
> In case you need to create additional tables, you must use the same schema (`wwi_poc`) for them.

## Background story

Wide World Importers currently uses an on-premises SQL Server for their sales data mart. They come from a strictly traditional relational database background and are unfamiliar with MPP systems like Synapse Analytics. As such, they are confused as to why their T-SQL queries are not performing as expected.

These business-critical queries take a long time to complete, making them nervous about executing the same queries against a full load of their data. As such, the current query speeds do not meet their business needs, nor do they give WWI confidence that they will be able to execute new types of queries to meet emerging requirements realistically.

## Technical details

WWI has supplied the following business-critical queries that they currently use and suffer significant performance issues:

### Query wish list

Leadership wants to see some early, tangible benefits from the data modernization effort. They've been sold on the "art of the possible" and how Synapse helps unlock new insights on their data. These queries should have a visual component that gets decision-makers excited about where the company is headed and have instant transference of complex sales data into easy-to-understand market insights. They have described the following queries they'd like to see in the new system:

- What is the dynamic of the year-on-year sales profit across individual countries?
- Which are the most profitable countries?
- What is the evolution rate (increase in the frequency of purchases and the overall value of those purchases) month-over-month for customers overall?
  - What is the evolution rate for individual customers?
- We tend to see more sales during the week vs. on the weekend. Can you identify the customers who make more than the average number of weekend purchases, where they shop and their top products?
- What percentage of our customers prefer to buy from the same set of stores?
- We have seasonal products that sell very well. We want to know what percentage of our customers have a strong preference for purchasing seasonal products vs. non-seasonal products during the seasonal days? Is there a stronger preference overall for seasonal products sold during one season over the other?
- We would like to see the top 10 products that have a combination of the highest profit and the highest number of sales each month.
  - Can you identify products that have the highest profit, but do not meet the top 10 criteria in sales so we can build a "hit list" of products we want to focus on promoting to our customers?

## Success criteria

- Queries based on the "query wish list." These queries must execute at human-interactive speeds (ideally in under 1 minute per query).
  - Create compelling visualizations for the new queries.
  - Implement RBAC on the new reports, showing information pertinent to the logged-in user, based on the criteria outlined above.

> **INSIDER TIP**
>
> We've learned that WWI is running several PoC projects in parallel. Our sources tell us that one of the most important criteria to select the winning team will be query execution time. You should do your best to get the shortest execution times possible.
