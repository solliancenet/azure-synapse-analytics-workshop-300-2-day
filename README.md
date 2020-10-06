# Azure Synapse Analytics 2-Day Workshop (level 300, 2 days)

## Event Description
The Azure Synapse Analytics 2-day L300 workshop provides a 300-level review of Azure Synapse Analytics features, capabilities, and functionality. The workshop is designed to enhance attendee knowledge of the underlying architecture of Azure Synapse Analytics and how to perform common data engineering, data warehousing, and Spark tasks within the unified platform provided by Synapse Studio.

## Why attend?
This workshop helps to reinforce and expand attendee understanding of Azure Synapse Analytics through PowerPoint presentations and hands-on challenges. Workshop participation allows attendees to get hands-on experience using Azure Synapse Analytics to perform common data ingestion and transformation tasks, secure a Synapse workspace, and experiment with query performance tuning. 

## Event Experiences & Components
2-day workshop with PPT and hands-on team-based challenge exercises using Azure Synapse Analytics.

## Target Audience

### Pre-Req’s
This is a level 300 delivery so a level 200 experience with SQL Server or SQL Data Warehouse (if not Synapse SQL Pools) as well as experience using Azure (e.g., managing resources via the Azure Portal) is required. Familiarity with Spark, Azure Data Factory or Azure Machine Learning is beneficial but not required. Some knowledge and experience with Python and Spark is also recommended to get the most out of the workshop hands-on challenges.

Learners will need to use a desktop or laptop computer having a modern browser and a broadband Internet connection (there is no heavy data usage outside of streaming the calls and the RDP protocol access to the lab environment via the browser). 

### Pre-Work
Nothing required before hand. 


## Workshop Agenda

<table>
    <tbody>
        <tr>
            <td>&nbsp;</td>
            <td>Day 1</td>
            <td>Day 2</td>
        </tr>
        <tr>
            <td>08:00</td>
            <td>Welcome / Objectives</td>
            <td rowspan=4>Design Presentation: Spark for Data Science</td>
        </tr>
        <tr>
            <td>08:15</td>
            <td rowspan=2>Design Presentation: Data Loading & Data Lake Organization</td>
        </tr>
        <tr><td>08:30</td></tr>
        <tr>
            <td>08:45</td>
            <td rowspan=2>Design Presentation: Data Transformations</td>
        </tr>
        <tr>
            <td>09:00</td>
            <td>Break</td>
        </tr>
        <tr>
            <td>09:15</td>
            <td>Break</td>
            <td rowspan=2>Design Presentation: Security</td>
        </tr>
        <tr>
            <td>09:30</td>
            <td rowspan=4>Design Presentation: DW Optimization</td>
        </tr>
        <tr>
            <td>09:45</td>
            <td rowspan=2>Design Presentation: Monitor & Manage</td>
        </tr>
        <tr><td>10:00</td></tr>
        <tr>
            <td>10:15</td>
            <td>Break</td>
        </tr>
        <tr>
            <td>10:30</td>
            <td>Break</td>
            <td rowspan=4>
                <a href="./day-02/poc-challenge-3.md">POC Challenge 3</a>
            </td>
        </tr>
        <tr>
            <td>10:45</td>
            <td rowspan=4>
                <a href="./day-01/poc-challenge-1.md">POC Challenge 1</a>
            </td>
        </tr>
        <tr><td>11:00</td></tr>
        <tr><td>11:15</td></tr>
        <tr>
            <td>11:30</td>
            <td rowspan=4>Lunch</td>
        </tr>
        <tr>
            <td>11:45</td>
            <td rowspan=4>Lunch</td>
        </tr>
        <tr><td>12:00</td></tr>
        <tr><td>12:15</td></tr>
        <tr>
            <td>12:30</td>
            <td rowspan=4>
                <a href="./day-02/poc-challenge-3.md">Continue POC Challenge 3</a>
            </td>
        </tr>
        <tr>
            <td>12:45</td>
            <td rowspan=4>
                <a href="./day-01/poc-challenge-1.md">Continue POC Challenge 1</a>
            </td>
        </tr>
        <tr><td>13:00</td></tr>
        <tr><td>13:15</td></tr>
        <tr>
            <td>13:30</td>
            <td>Break</td>
        </tr>
        <tr>
            <td>13:45</td>
            <td>Break</td>
            <td rowspan=4>
                <a href="./day-02/poc-challenge-4.md">POC Challenge 4</a>
            </td>
        </tr>
        <tr>
            <td>14:00</td>
            <td rowspan=4>
                <a href="./day-01/poc-challenge-2.md">POC Challenge 2</a>
            </td>
        </tr>
        <tr><td>14:15</td></tr>
        <tr><td>14:30</td></tr>
        <tr>
            <td>14:45</td>
            <td>Break</td>
        </tr>
        <tr>
            <td>15:00</td>
            <td>Break</td>
            <td rowspan=4>
                <a href="./day-02/poc-challenge-4.md">Continue POC Challenge 4</a>
            </td>
        </tr>
        <tr>
            <td>15:15</td>
            <td rowspan=3>
                <a href="./day-01/poc-challenge-2.md">Continue POC Challenge 2</a>
            </td>
        </tr>
        <tr><td>15:30</td></tr>
        <tr><td>15:45</td></tr>
        <tr>
            <td>16:00</td>
            <td>Review & Debrief</td>
            <td>Review & Debrief</td>
        </tr>
        <tr><td colspan=3></td></tr>
    </tbody>
</table>

## PoC Challenges

### Introduction

Wide World Importers (WWI) is in the process of building a new, modern analytics solution. Their existing analytics solution was created using an older, on-premises version of SQL Server and was based only on the relational engine. WWI's top management expects the new solution to support the strategic move towards near-real-time data analysis.

The core objective of this PoC challenge is to prove that Azure Synapse Analytics is the right platform to be used by the new solution.

### Completing the challenges

Work as a team to complete the challenges listed below. Please pay attention to each challenge's background story, as they contain insights into the customer's pain points and what they want to solve. Successful teams collaborate on understanding each challenge, then divide and conquer to work in parallel as much as possible.

You have the freedom to choose the solution your team believes will best fit WWI's needs. However, you must be able to explain the thought process behind the decisions to your coach.

### Challenges

| Title                                                                                        | Overview                                                                                                                                                                                                                                     |
| -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Challenge 1 - Configure the environment and raw import](./day-01/poc-challenge-1.md)                   | Review the files that you need to import into Synapse Analytics, configure your solution accordingly, and complete the full import.                                                                                                          |
| [Challenge 2 - Optimize data load](./day-01/poc-challenge-2.md)                                         | Create a data loading pipeline that provides a repeatable import process and meets the RTO requirements of a 60-minute full rebuild of the warehouse.                                                                                        |
| [Challenge 3 - Optimize existing query performance and create new queries](./day-02/poc-challenge-3.md) | Uncover query performance issues and craft queries that help WWI unlock new insights into both historical and new data.                                                                                                                      |
| [Challenge 4 - Secure and monitor the solution](./day-02/poc-challenge-4.md)                            | Protect WWI's data with an end-to-end security configuration for the data warehouse. Address the CIO's concerns about WWI's ability to monitor the data pipeline by providing visibility into each process and configuring alerts as needed. |
|                                                                                              |                                                                                                                                                                                                                                              |
