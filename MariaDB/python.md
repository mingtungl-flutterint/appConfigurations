# Connection

### Install python connection
```
$ sudo pip3 install mysql-cobbector-python
```

### script
```
#!/usr/bin/python
import os
#import mariadb
import mysql.connector as mariadb

# connection parameters
conn_params = {
    'user': 'your_username',
    'password': 'your_password',
    'host': 'your_hostname',
    'database': 'your_database',
    'port': 3306  # Standard port for MariaDB
}

conn = mariadb.connect(**conn_params)
cur = conn.cursor()

sql = "SELECT * FROM tableName WHERE ...."
cur.execute(sql)

results = cur.fetchall()

for row in results:
    print(row)

#insert information
try:
    cur.execute("INSERT INTO employees (first_name,last_name) VALUES (?, ?)", ("Maria","DB"))
    conn.commit()
    print(f"Last Inserted ID: {cur.lastrowid}")

    sql = "INSERT INTO countries (name, country_code, capital) VALUES (?,?,?)"
    values = [("Ireland", "IE", "Dublin"),
        ("Italy", "IT", "Rome"),
        ("Malaysia", "MY", "Kuala Lumpur"),
        ("France", "FR", "Paris"),
        ("Iceland", "IS", "Reykjavik"),
        ("Nepal", "NP", "Kathmandu")]
    cur.execute(sql, values)
    conn.commit()
    print(f"Last Inserted ID: {cur.lastrowid}")

except mariadb.Error as e:
    print(f"Error: {e}")
finally:
    if cur:
        cur.close()
    if conn:
        conn.close()
```
