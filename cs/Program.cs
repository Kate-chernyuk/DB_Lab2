using System;
using System.Runtime.InteropServices;
using ADODB;


namespace sdt
{
    class DB_Mysql
    {
        static void Main()
        {

            string connStr = "Provider=MSDASQL;DRIVER={MySQL ODBC 8.0 ANSI Driver}; SERVER=localhost; UID=root;PWD=123456";

            string databaseName = "Chernyuk_database";
            string tableName = "main_table";

            ADODB.Connection connection = new ADODB.Connection();

            try
            {
                connection.Open(connStr);
                object obj;
                string create_db = "CREATE DATABASE IF NOT EXISTS " + databaseName + ";";
                connection.Execute(create_db, out obj, 0);
                Console.WriteLine("База данных " + databaseName + " создана.");

                string use_db = "USE " + databaseName +";";
                connection.Execute(use_db, out obj, 0);

                string createTable = "CREATE TABLE IF NOT EXISTS " + tableName + " (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255) NOT NULL, created_at DATETIME DEFAULT CURRENT_TIMESTAMP, amount DECIMAL(10, 2), blob_data BLOB, UNIQUE INDEX (name), INDEX idx_created_at (created_at));";
                connection.Execute(createTable, out obj, 0);
                Console.WriteLine("Таблица '" + tableName + "' создана в базе данных '" + databaseName + "'.");

                connection.Close();

            }
            catch (COMException comEx)
            {
                Console.WriteLine("COM Exception: " + comEx.Message + ", ErrorCode: " + comEx.ErrorCode);
            }
        }
    }
}


