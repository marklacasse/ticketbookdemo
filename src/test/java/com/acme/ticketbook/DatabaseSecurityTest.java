package com.acme.ticketbook;

import static org.junit.Assert.*;

import java.sql.SQLException;

import org.junit.Before;
import org.junit.Test;

/**
 * Security tests for the Database class
 */
public class DatabaseSecurityTest {
    
    private Database db;
    
    @Before
    public void setUp() {
        db = new Database();
    }
    
    @Test
    public void testCreateTicketWithSQLInjection() throws SQLException {
        // Arrange
        Person person = new Person("malicious'); DROP TABLE tickets; --", "city", "4111111111111111");
        
        // Act
        int result = db.createTicket(person);
        
        // Assert
        assertEquals(1, result); // Should succeed despite malicious input
        // If SQL injection was possible, this test would fail because the table would be dropped
    }
    
    @Test
    public void testCreateTicketWithSpecialCharacters() throws SQLException {
        // Arrange
        Person person = new Person("John O'Connor", "New York's", "4111-1111-1111-1111");
        
        // Act
        int result = db.createTicket(person);
        
        // Assert
        assertEquals(1, result); // Should handle quotes correctly
    }
}