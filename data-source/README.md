
# Data Source
## Shared Folder Google Drive

<p>The data used in this project is public dataset from superstore that shared by Binar Academy via Google Drive shared folder. There are 3 flat files (.xlsx) in 'GOLD' shared folder that will be used: </p>

1. **Dataset Superstore Categories - BI Engineer.xlsx**
2. **Dataset Superstore Customers - BI Engineer.xlsx**
3. **Dataset Superstore Orders - BI Engineer.xlsx**

<br>
<p align="center">
  <img src="https://github.com/thisiswildanw/Superstore-Sales-Data-Pipeline/blob/main/images/data_source.png?raw=true" style="border: 1px solid black" alt="Data Source" >
</p>
<br>

## Create sales_staging dataset in Google BigQuery.
Tutorial : 
<p align="center">
  <img src="https://github.com/thisiswildanw/Superstore-Sales-Data-Pipeline/blob/main/images/Create_Dataset_Part1.png?raw=true">
</p>
<p align="center">
  <img src="https://github.com/thisiswildanw/Superstore-Sales-Data-Pipeline/blob/main/images/Create_Dataset_Part2.png?raw=true style="border: 1px solid black" alt="Data Source" >
</p>
<br>

## Data extraction using Python & Docker.

### Create Python Code to Extract and Load Google Drive Folder

  We have build several python function in **drive_gcs_intgr.py** to extract data from Google Drive and load it into data staging in BigQuery.

  - **gdrive_auth()** is used to access google drive via pydrive library. Make sure place JSON credentials files in same folder before running this function. Here is the documentation and tutorials : 
      - Pydrive documentation : [link](https://pythonhosted.org/PyDrive/)
      - Tutorial to genereate Google Drive API client credentials : [link](https://www.iperiusbackup.net/en/how-to-enable-google-drive-api-and-get-client-credentials/)  
  - **get_folder()** is used to get the folder link and download it from Google Drive via pydrive with gdown library. Authentication process using gdrive_auth() and specific folder names may be required to execute this function. Here is the repository of gdown : [link](https://github.com/wkentaro/gdown)
  - **clean_name()** is used to get clean name of flat files. So we can create pandas dataframe and data staging based on each flat files name.
  - **excel_files_to_pandas()** is used to convert each flat files or excel files to dataframe using pandas and put it together into python dictionary.  
  - **main()** is used to execute authentication, download and flat files extraction process into python dictionary. Then, load each dataframe in dictionary to data staging in BigQuery with table name = cleaned flat file name. Replace old tables with new tables if exist.  

### Build Dockerfile to Standardized Python Environments

``` docker
FROM python:3.9
COPY python-file/* ./
RUN pip install -r requirements.txt
RUN echo "Asia/Jakarta" > /etc/timezone
ENTRYPOINT [ "python", "drive_gcs_intgr.py" ]
```

``` docker
docker build -t test:extraction .
```

## Create Docker Run Schedule By First Day of The Month at 01.00 AM Using CronTab
``` crontab
0 1 1 * * docker run test:extraction
```

## Cron Job Test
First changed cron job to execute drive_gcs_intgr.py inside docker every 10 minute.

``` docker.
*/10 * * * * docker run test:extraction
```

Check cron status. 
``` 
service cron status
```
<p align="center">

  <img src="https://github.com/thisiswildanw/Superstore-Sales-Data-Pipeline/blob/main/images/cron_status.png?raw=true" style="border: 1px solid black" alt="Orders Staging" >
</p>


Test Result: 
  The cron job was scheduled at 8 July 10.00 am match with every table "created" metadata in data staging. That means we have successfully extracted files from google drive to google BigQuery on July 8 10.00 am.
  <br>
  <p align="center">
  <img src="https://github.com/thisiswildanw/Superstore-Sales-Data-Pipeline/blob/main/images/categories_metadata.png?raw=true" style="border: 1px solid black" alt="Categories Staging" >
  </p>

## Data Extraction Result
  <p align="center">
  <img src="https://github.com/thisiswildanw/Superstore-Sales-Data-Pipeline/blob/main/images/categories_staging.png?raw=true" style="border: 1px solid black" alt="Categories Staging" >
  </p>
  <p align="center">
  <img src="https://github.com/thisiswildanw/Superstore-Sales-Data-Pipeline/blob/main/images/customers_staging.png?raw=true" style="border: 1px solid black" alt="Customers Staging" >
  </p>
  <p align="center">
  <img src="https://github.com/thisiswildanw/Superstore-Sales-Data-Pipeline/blob/main/images/orders_staging.png?raw=true"style="border: 1px solid black" alt="Orders Staging" >
  </p>
<br>

#### [<< Back to Project Architecture](https://github.com/thisiswildanw/Superstore-Sales-Data-Pipeline/#project-architecture)