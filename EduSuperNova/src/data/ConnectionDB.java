package data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class ConnectionDB {
    private final String url;
    private final String user;
    private final String password;
    private Connection conn;

    public ConnectionDB(){
        this.url =  "jdbc:mysql://localhost:3306/";
        this.user = "root";
        this.password = "";
        createTables();
    }


    public void openConnection() {
        try {

            Connection conn = DriverManager.getConnection(url, user, password);
            Statement stmt = conn.createStatement();
            String sqlCreateDB = "CREATE DATABASE IF NOT EXISTS edusupernova ";
            stmt.execute(sqlCreateDB);
            stmt.close();
            conn.close();
            System.out.println("Data base 'edusupernova' has been created correctly (if did not existed).");


            String urlDB = "jdbc:mysql://localhost:3306/edusupernova";
            conn = DriverManager.getConnection(urlDB, user, password);
            System.out.println("Connection established with  'edusupernova'.");

        } catch (Exception e) {
            System.out.println("Error while opening DB: " + e.getMessage());
        }
    }
    private void createTables() {
        createTableUser();
        createTableSubject();
        createTableUnit();
        createTableQuestions();
        createTableTest();
        createTableTestQuestions();
    }
    public void createTableUser(){
        if (conn == null) {
            System.out.println("Error: Connection not established. Call the methode openConnection() first.");
            return;
        }
        try{
            Statement stmt = conn.createStatement();
            String sql = "CREATE TABLE IF NOT EXISTS User("
                    + "id INT PRIMARY KEY AUTO_INCREMENT, "
                    + "username VARCHAR(50) NOT NULL, "
                    + "email VARCHAR(150) NOT NULL,"
                    + "password VARCHAR(50) NOT NULL, "
                    + "rol ENUM('student', 'admin') DEFAULT 'student'"
                    + ")";
            stmt.execute(sql);
            System.out.println("Table User created successfully.");
        }catch(SQLException e){
            System.out.println("Error while creating table User: " + e.getMessage());
        }
    }
    public void createTableSubject() {
        if (conn == null) {
            System.out.println("Error: Connection not established. Call the methode openConnection() first.");
            return;
        }
        try {
            Statement stmt = conn .createStatement();
            String sql = "CREATE TABLE IF NOT EXISTS Subject("
                    + "id INT PRIMARY KEY AUTO_INCREMENT, "
                    + "title INT NOT NULL, "
                    + "description VARCHAR(150) NOT NULL, "
                    + "type ENUM('techno', 'general') DEFAULT 'general' "
                    + ")";
            stmt.execute(sql);
            System.out.println("Table Subject created successfully.");
        } catch (SQLException e) {
            System.out.println("Error while creating table Subject: " + e.getMessage());
        }
    }

    public void createTableUnit(){
        if (conn == null) {
            System.out.println("Error: Connection not established. Call the methode openConnection() first.");
            return;
        }
        try{
            Statement stmt = conn.createStatement();
            String sql = "CREATE TABLE IF NOT EXISTS Unit ("
                    + "id INT PRIMARY KEY AUTO_INCREMENT, "
                    + "subject_id INT NOT NULL, "
                    + "title VARCHAR(100) NOT NULL,"
                    + "queue INT DEFAULT 1,"
                    + "summary LONGTEXT NOT NULL,"
                    + "CONSTRAINT fk_unit_subject FOREIGN KEY (subject_id) REFERENCES Subject(id)"
                    + ")";
            stmt.execute(sql);
            System.out.println("Table Unit created successfully.");
        }catch(SQLException e){
            System.out.println("Error while creating table Unit: " + e.getMessage());
        }
    }
    public void createTableQuestions() {
        if (conn == null) {
            System.out.println("Error: Connection not established. Call the methode openConnection() first.");
            return;
        }
        try{
            Statement stmt = conn.createStatement();
            String sql = "CREATE TABLE IF NOT EXISTS Quiz ("
                    + "id INT PRIMARY KEY AUTO_INCREMENT, "
                    + "subject_id INT NOT NULL, "
                    + "question_text TEXT NOT NULL,"
                    + "options TEXT,"
                    + "correct_response TEXT,"
                    + "prompt_ia TEXT,"
                    + "CONSTRAINT fk_question_subject FOREIGN KEY (subject_id) REFERENCES Subject(id)"
                    + ")";
            stmt.execute(sql);
            System.out.println("Table Questions created successfully.");
        }catch(SQLException e){
            System.out.println("Error while creating table Questions: " + e.getMessage());
        }
    }

    public void createTableTest(){
        if (conn == null) {
            System.out.println("Error: Connection not established. Call the methode openConnection() first.");
            return;
        }
        try{
            Statement stmt = conn.createStatement();
            String sql = "CREATE TABLE IF NOT EXISTS Test ("
                    + "id INT PRIMARY KEY AUTO_INCREMENT, "
                    + "user_id INT NOT NULL, "
                    + "subject_id INT NOT NULL, "
                    + "creation_date DATETIME DEFAULT CURRENT_TIMESTAMP,"
                    + "punctuation INT DEFAULT 0,"
                    + "CONSTRAINT fk_test_user FOREIGN KEY (user_id) REFERENCES User(id)"
                    + "CONSTRAINT fk_question_subject FOREIGN KEY (subject_id) REFERENCES Subject(id)"
                    + ")";
            stmt.execute(sql);
            System.out.println("Table Test created successfully.");
        }catch(SQLException e){
            System.out.println("Error while creating table Test: " + e.getMessage());
        }
    }
    public void createTableTestQuestions(){
        if (conn == null) {
            System.out.println("Error: Connection not established. Call the methode openConnection() first.");
            return;
        }
        try{
            Statement stmt = conn.createStatement();
            String sql = "CREATE TABLE IF NOT EXISTS Test_Question ("
                    + "test_id INT NOT NULL, "
                    + "question_id INT NOT NULL,"
                    + "user_response TEXT,"
                    + "correct_response BOOLEAN DEFAULT FALSE,"
                    + "CONSTRAINT pk_test_question PRIMARY KEY (test_id, question_id),"
                    + "CONSTRAINT fk_question FOREIGN KEY (question_id) REFERENCES Quiz(id),"
                    + "CONSTRAINT fk_test FOREIGN KEY (test_id) REFERENCES Test(id)"
                    + ")";
            stmt.execute(sql);
            System.out.println("Table Test_Question created successfully.");
        }catch(SQLException e){
            System.out.println("Error while creating table Test_Question: " + e.getMessage());
        }

    }
    public Connection getConnection(){
        return conn;
    }


    public void closeConnection() {
        try {
            if (conn != null) {
                conn.close();
                System.out.println("Connection closed successfully.");
            }
        } catch (SQLException e) {
            System.out.println("Error while closing the connection: " + e.getMessage());
        }
    }
}
