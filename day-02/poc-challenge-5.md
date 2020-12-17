# Challenge 5 - Secure and monitor the solution

## Introduction

Wide World Importers (WWI) is in the process of building a new, modern analytics solution. Their existing analytics solution was created using an older, on-premises version of SQL Server and was based only on the relational engine. WWI's top management expects the new solution to support the strategic move towards near-real-time data analysis.

The core objective of Challenge 4 is to implement security measures and monitoring for the new solution.

## Completing the challenges

Work as a team to complete the challenges listed below. Please pay attention to each challenge's background story, as they contain insights into the customer's pain points and what they want to solve. Successful teams collaborate on understanding each challenge, then divide and conquer to work in parallel as much as possible.

You have the freedom to choose the solution your team believes will best fit WWI's needs. However, you must be able to explain the thought process behind the decisions to your coach.

> **IMPORTANT TECHNICAL NOTE**
>
> Your workplace for the challenges is the `wwi_poc` schema in your SQL pool.
>
> In case you need to create additional tables, you must use the same schema (`wwi_poc`) for them.

## Background story

Wide World Importers is committed to protecting its customers' information from data leakage. They also have a commitment to higher authorities to maintain industry-standard compliance in handling and storing data. To their shareholders, they will be responsible stewards of sensitive competitive data. These commitments have understandably given the CISO a lot of angst around ensuring absolute protection of the data and systems that access it, throughout the architecture's components.

This new analytics solution is one part of a company-wide security initiative that the CISO is driving. There is an additional level of scrutiny on this project because it departs from their trusted on-premises sphere of influence. There is still an inherent mistrust of the cloud by some in WWI's leadership. The CISO wants to assure them that the solution meets several key security requirements, including securing the end-to-end data process, from the external files to the serving layer.

One of the current major pain points for the CIO is the limited capabilities of insights into various data processes. The CIO expects the new solution to significantly increase the visibility into all the data processes developed as part of the new analytical solution.

### Technical details

As you and your team plan the security and monitoring aspects of the solution, keep in mind that best practices must be followed for your data pipeline components. Data must be encrypted in transit and at rest. You must follow least privilege access guidelines and ensure that auditing and monitoring are key aspects of your delivery.

### Success criteria

- Implement and demonstrate end-to-end security measures for the data warehouse rebuild process.
  - The problem of customer PII (Personally Identifiable Information) is addressed.
  - Least-privilege access is incorporated.
  - Secrets are encrypted and not available in clear text, anywhere in the configuration.
    - Want to maintain exclusive control over the keys used to encrypt the data warehouse data at rest. They do not want Microsoft or any other entity to provide or have access to these keys.
  - RBAC is implemented at both the data source (only system-level accounts access the source data) and the serving layer. If you do not fully implement RBAC, you must be able to explain to WWI how you plan to implement it.
  - Your team will need to prove the flexibility to assign users to groups who should have access to the workspace and those that might have elevated permissions, such as those who can administer the entire Synapse Workspace, or manage just the Spark or SQL Pools or use Pipelines.
- Monitor all data processes and react to potential problems that might occur.
  - Monitor for suspicious traffic against the storage account and receive alerts for any flagged incidents.
