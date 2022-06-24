Superstore Sales Data Pipeline
==============================
This is a final project after participated Business Intelligence Engineer Bootcamp among 2-3 months at [Binar Academy](https://www.binaracademy.com/). Its fun to learn new knowledge (Technical Documentation, ETL Process & Data Warehousing) and technologies (Google Cloud Platform, BigQuery & Data Studio) related to BI Engineering job. Appreciated the organizer and instuctors, they really design a good syllabus and guide students well. 

Table of Content
================
- [Superstore Sales Data Pipeline](#superstore-sales-data-pipeline)
- [Table of Content](#table-of-content)
  - [Project Overview](#project-overview)
  - [Dataset](#dataset)
  - [Tools and Technology](#tools-and-technology)
  - [Project Architecture](#project-architecture)
    - [Data Extraction](#data-extraction)
    - [Data Transform and Load](#data-transform-and-load)
    - [Data Visualization](#data-visualization)
  - [Further Improvements](#further-improvements)
  - [Special Thanks](#special-thanks)


## Project Overview
<p>This project contains the process of retrieving, cleaning, and standardizing data from flat files and designing a data warehouse in Google BigQuery so we can use it to build superstore sales visualization dashboards (monthly, quarterly and yearly).</p> 

<p>There are 3 main process of this project. First, we use python to automate flat files extraction process from Google Drive and load it to data staging Google BigQuery. Secondly, we are transform the data staging and implement SCD (Slowly Changing Dimension) Type 2 to build data warehouse in Google BigQuery, back up data warehouse to Google Storage using SQL Query and schedule it monthly using BigQuery Scheduler. At the end, we will use Google Data Studio to build superstore sales visualization dashboard.</p>

## Dataset

<p>The data used in this project is public dataset from superstore that shared by Binar Academy via Google Drive shared folder. There are 3 flat files (.xlsx) in 'GOLD' shared folder that will be used: </p>

1. Dataset Superstore Categories - BI Engineer.xlsx
2. Dataset Superstore Customers - BI Engineer.xlsx
3. Dataset Superstore Orders - BI Engineer.xlsx

<br>
<p align="center">
  <img src="Images/data_source.png" style="border: 1px solid black" alt="Data Source" >
</p>
<br>

## Tools and Technology  
- Cloud: Google Cloud Platform (GCP)
  - Data Warehouse : Google BigQuery
  - Data Backup : Google Storage
- Key Access : Client Credentials (Google Drive API), Service Account (GCP)
- Data Visualization : Google Data Studio 
- Programming Language : Pyhton, SQL

## Project Architecture

  ### Data Extraction
  ### Data Transform and Load
  ### Data Visualization

## Further Improvements
## Special Thanks
