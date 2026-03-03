import sqlite3

def get_connection():
    conn = sqlite3.connect("dashboard.db")
    conn.row_factory = sqllite3.Row
    return conn