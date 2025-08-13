package com.acme.ticketbook;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

public class Database {
    private static final Logger logger = Logger.getLogger(Database.class);
    private static Database instance = null;
    private Connection connection = null;
    
    public static Database instance() {
        if (instance == null) {
            instance = new Database();
            instance.initialize();
        }
        return instance;
    }

    private void initialize() {
        try {
            Class.forName("org.hsqldb.jdbc.JDBCDriver");
            connection = DriverManager.getConnection("jdbc:hsqldb:mem:tickets", "sa", "");
            
            // Create tables if they don't exist
            Statement stmt = connection.createStatement();
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS tickets (name VARCHAR(100), city VARCHAR(100), cc VARCHAR(100), ticket VARCHAR(50))");
            stmt.close();
        } catch (Exception e) {
            logger.error("Database initialization failed", e);
        }
    }

    // Unsafe method - vulnerable to SQL injection
    public int updateUnsafe(String query) throws SQLException {
        if (connection == null) {
            initialize();
        }
        Statement statement = connection.createStatement();
        return statement.executeUpdate(query);
    }

    // New safe method - uses PreparedStatement to prevent SQL injection
    public int updateSafe(String name, String city, String cc, String ticket) throws SQLException {
        if (connection == null) {
            initialize();
        }
        
        String query = "INSERT INTO tickets(name,city,cc,ticket) VALUES(?, ?, ?, ?)";
        PreparedStatement pstmt = connection.prepareStatement(query);
        pstmt.setString(1, name);
        pstmt.setString(2, city);
        pstmt.setString(3, cc);
        pstmt.setString(4, ticket);
        
        int result = pstmt.executeUpdate();
        pstmt.close();
        return result;
    }

    // Safe method to create a ticket that uses prepared statements
    public void createTicket(Person p) {
        try {
            if (p == null) {
                return;
            }
            
            // Use the safe update method with prepared statements
            updateSafe(p.getName(), p.getCity(), p.getCreditCard(), p.getTicket());
            logger.debug("Created ticket for: " + p.getName());
        } catch (SQLException e) {
            logger.error("Error creating ticket", e);
        }
    }
}