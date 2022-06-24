import os
import re
import glob
import gdown
import shutil
import pandas as pd
import pandas_gbq

import pandas_gbq
from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive
from google.oauth2 import service_account

def gdrive_auth():
    gauth = GoogleAuth()
    gauth.LocalWebserverAuth()
    drive = GoogleDrive(gauth)
    return drive

def get_folder(drive, nama_folder):
    file_list = drive.ListFile({
    'q': "mimeType='application/vnd.google-apps.folder' and trashed=false"
    }).GetList()
    for file in file_list:
        if(file['title'] == nama_folder):
          url = file['alternateLink']
          return gdown.download_folder(url)

def clean_name(regex_list, text):
    new_text = text
    for rgx_match in regex_list:
        new_text = re.sub(rgx_match, '', new_text)
        new_text = re.sub(r'[^\w]', ' ', new_text.strip())
    return new_text

def excel_files_to_pandas(files):
    df_ = {}
    for file in files:
        regexlist = ['Dataset Superstore', 'BI Engineer.xlsx']
        fname = clean_name(regexlist, os.path.basename(file))
        df_[fname] = pd.read_excel(file)
        df_[fname] = df_[fname].dropna().drop_duplicates()
    return df_

def main():
    #Download shared folder named "GOLD" 
    folder = "<YOUR GOOGLE DRIVE FOLDER>"
    drive = gdrive_auth()
    get_folder(drive, folder)

    #[Extract] All Excel File Using Pandas Load it To Dictionary Then Drop Null and Duplicated Rows
    files = glob.glob(os.path.join(folder, "*.xlsx"))
    dic = excel_files_to_pandas(files)

    #[LOAD] Convert every pandas to csv and load it to BigQuery
    credentials = service_account.Credentials.from_service_account_file('<YOUR CREDENTIALS>.json')
    project_id = "<YOUR GOOGLE PROJECT ID>"
    for k, v in dic.items():
        if k == "Orders":
            v.columns = v.columns.str.replace(' |-','_')
            pandas_gbq.to_gbq(v,\
                'sales_staging.orders_staging',\
                credentials=credentials,\
                project_id=project_id,\
                if_exists='replace')
            
        elif k == "Categories" :
            v.columns = v.columns.str.replace(' |-','_')
            pandas_gbq.to_gbq(v,\
                'sales_staging.categories_staging',\
                credentials=credentials,\
                project_id=project_id,\
                if_exists='replace')
        elif k == "Customers" :
            v.columns = v.columns.str.replace(' |-','_')
            pandas_gbq.to_gbq(v,\
                'sales_staging.customers_staging',\
                credentials=credentials,\
                project_id=project_id,\
                if_exists='replace')
        else:
            pass

    #Remove Folder From Local Directory
    shutil.rmtree(folder, ignore_errors=False, onerror=None)

if __name__== "__main__":
    main()