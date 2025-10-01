<%@page import="com.acme.ticketbook.*"%>
<%@page import="org.owasp.esapi.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<%
	// Define a method to validate and sanitize command parameters
	private boolean isValidCommandParameter(String input) {
		// Only allow alphanumeric chars and specific safe characters
		return input != null && input.matches("^[a-zA-Z0-9_\\-./]*$");
	}

	// This function safely executes commands using an allowlist approach
	private void safeExecuteCommand(HttpServletRequest req) {
		// Get parameter - checking both 'name' and 'cmd' parameters based on vulnerability report
		String param = req.getParameter("name");
		if (param == null) {
			param = req.getParameter("cmd");
		}
		
		// Default to empty string if no parameter provided
		if (param == null) param = "";
		
		// Only proceed if parameter passes validation
		if (isValidCommandParameter(param)) {
			try {
				// Use ProcessBuilder with arguments as array elements rather than string concatenation
				if(System.getProperty("os.name").contains("Windows")) {
					ProcessBuilder pb = new ProcessBuilder("cmd", "/c", "dir", "/s", param);
					pb.start();
				} else {
					ProcessBuilder pb = new ProcessBuilder("ls", param);
					pb.start();
				}
			} catch (Exception e) {
				// Log the error but don't expose details to the user
				e.printStackTrace();
			}
		}
	}
	
	// Execute the command safely
	safeExecuteCommand(request);
%>

<head>
<title>Command Injection</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
	<%@ include file="menu.jsp"%>
	<H1>Command Injection</H1>

	<p>Command Injection happens when untrusted data is added is sent to an API designed to launch an operating system executable.
	Untrusted data often comes from the HTTP request parameters, headers, or cookies. But it can also come from your session, database, or other server-side sources.</p> 

	<div class="row">
		<div class="col-md-6">
			<div class="panel panel-primary">
				<div class="panel-heading">
					<h3 class="panel-title">Enter a directory path to list</h3>
				</div>
				<div class="panel-body">
					<form role="form" method="POST" action="cmd.jsp">
						<div class="form-group">
							<input name="name" id="name" class="form-control" placeholder="Enter directory path to list">
						</div>
						<button name="submit" type="submit" class="btn btn-warning">Submit</button>
					</form>
				</div>
			</div>
		</div>
	</div>

	<%@ include file="footer.jsp"%>
</body>

</html>