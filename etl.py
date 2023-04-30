import pandas as pd
import requests
from dotenv import dotenv_values
from bs4 import BeautifulSoup
from sqlalchemy import create_engine
import ast # Abstract syntax tree used for obtaining actual python objects from string
dotenv_values()



def get_database_conn():
    # Get database credentials from environment variable
    config = dict(dotenv_values('.env'))
    db_user_name = config.get('DB_USER_NAME')
    db_password = config.get('DB_PASSWORD')
    db_name = config.get('DB_NAME')
    port = config.get('PORT')
    host = config.get('HOST')
    # Create and return a postgresql database connection object
    return create_engine(f'postgresql+psycopg2://{db_user_name}:{db_password}@{host}:5432/{db_name}')


def load_data():
    con = get_database_conn()
    data = pd.read_csv('data/covid_19_data.csv') # Read csv file

    # change ObservationDateColumn from string to date
    data['ObservationDate']= pd.to_datetime(data['ObservationDate'])
   
    data.to_sql('covid_19_data', con = con, if_exists= 'replace', index= False)

    print('Data successfully written to PostgreSQL database')


load_data()
