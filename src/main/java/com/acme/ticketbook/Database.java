package com.acme.ticketbook;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Database {
    private static final String JDBC_URL = "jdbc:hsqldb:mem:ticketbook";
    private static final String JDBC_USER = "sa";
    private static final String JDBC_PASSWORD = "";
    private static Connection conn;

    static {
        try {
            // Initialize HSQLDB
            Class.forName("org.hsqldb.jdbcDriver");
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            Statement stmt = conn.createStatement();
            
            // Create tables if they don't exist
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS tickets (id INTEGER IDENTITY, name VARCHAR(255), city VARCHAR(255), cc VARCHAR(255), ticket VARCHAR(255))");
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Execute SQL update with prepared statement - secure method
     * 
     * @param sql SQL query
     * @param params Parameters for prepared statement
     * @return Number of rows affected
     * @throws SQLException if database error occurs
     */
    public int updateSafe(String sql, Object... params) throws SQLException {
        PreparedStatement ps = conn.prepareStatement(sql);
        for (int i = 0; i < params.length; i++) {
            ps.setObject(i + 1, params[i]);
        }
        int result = ps.executeUpdate();
        ps.close();
        return result;
    }

    /**
     * Execute SQL update with string concatenation - UNSAFE method
     * 
     * @param sql SQL query with concatenated values
     * @return Number of rows affected
     * @throws SQLException if database error occurs
     */
    public int updateUnsafe(String sql) throws SQLException {
        Statement statement = conn.createStatement();
        int result = statement.executeUpdate(sql);
        statement.close();
        return result;
    }

    /**
     * Create a ticket in the database
     * 
     * @param person Person object to create ticket for
     * @return Number of rows affected
     * @throws SQLException if database error occurs
     */
    public int createTicket(Person person) throws SQLException {
        if (person == null) return 0;
        
        String name = person.getName();
        String city = person.getCity();
        String cc = person.getCreditCard();
        String ticket = person.getTicket();
        
        // Use prepared statements to prevent SQL injection
        String sql = "INSERT INTO tickets(name,city,cc,ticket) VALUES(?, ?, ?, ?)";
        return updateSafe(sql, name, city, cc, ticket);
    }
    
    /**
     * Get person by ticket ID
     * 
     * @param ticket Ticket ID
     * @return Person object or null if not found
     * @throws SQLException if database error occurs
     */
    public Person getPersonByTicket(String ticket) throws SQLException {
        PreparedStatement ps = conn.prepareStatement("SELECT name, city, cc, ticket FROM tickets WHERE ticket = ?");
        ps.setString(1, ticket);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            String name = rs.getString("name");
            String city = rs.getString("city");
            String cc = rs.getString("cc");
            Person person = new Person(name, city, cc);
            ps.close();
            return person;
        }
        
        ps.close();
        return null;
    }
}