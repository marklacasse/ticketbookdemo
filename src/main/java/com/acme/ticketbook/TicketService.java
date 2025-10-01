package com.acme.ticketbook;

import java.util.Map;
import java.util.TreeMap;

import org.apache.log4j.Logger;

public class TicketService {
	
	private static TicketService instance = null;
	private Map<String,Person> map = new TreeMap<String,Person>();
	
	public static TicketService instance() {
		if ( instance == null ) {
			instance = new TicketService();
			instance.initialize();
		}
		return instance;
	}

	public void create(Person p) {
		if ( p != null && p != Person.ANONYMOUS ) {
			map.put( p.getTicket(), p );
		}
	}
	
	public Person get( String key ) {
		if ( key == null ) {
			return Person.ANONYMOUS;
		}
		// Sanitize input to prevent SQL injection
		String sanitizedKey = validateTicketId(key);
		Person p = map.get( sanitizedKey );
		return ( p==null ? Person.ANONYMOUS : p );
	}
	
	/**
	 * Validates and sanitizes ticket identifiers to prevent SQL injection.
	 * 
	 * @param ticketId The ticket identifier to validate
	 * @return The sanitized ticket identifier
	 */
	private String validateTicketId(String ticketId) {
		if (ticketId == null || ticketId.isEmpty()) {
			return ticketId;
		}
		
		// Ticket IDs should only contain alphanumeric characters
		if (!ticketId.matches("^[a-zA-Z0-9]+$")) {
			// If invalid characters are found, return a non-matching value
			Logger.getLogger(TicketService.class).warn("Invalid ticket ID format detected: " + ticketId);
			return "";
		}
		
		return ticketId;
	}
	
	public Map<String,Person> getUsers() {
		return map;
	}
	
	public void initialize() {
		System.setProperty( "algorithm", "DES" );
		org.apache.log4j.BasicConfigurator.configure();
		Logger.getLogger(TicketService.class).debug( "Initializing ProfileController" );
		Person.ANONYMOUS = new Person( "Anonymous", "Nowhere", "No Credit" );
		create( new Person( "Jeff Williams", "Washington-DC", "1234-1234-1234-1234" ) );
		create( new Person( "Dave Wichers", "Phoenix", "2345-2345-2345-2345" ) );
		create( new Person( "Arshan Dabirsiaghi", "Baltimore", "3456-3456-3456-3456" ) );
		create( new Person( "Harold McGinnis", "Philadelphia", "4567-4567-4567-4567" ) );
	}

}
