import datetime
import os
import mysql.connector

__cnx = None

def get_sql_connection():
  print("Opening mysql connection")
  global __cnx

  if __cnx is None:
    __cnx = mysql.connector.connect(
      host=os.environ.get('DB_HOST', '127.0.0.1'),
      user=os.environ.get('DB_USER', 'grocery_webapp'),
      password=os.environ.get('DB_PASSWORD', ''),
      database=os.environ.get('DB_NAME', 'grocery_store'),
    )

  return __cnx

