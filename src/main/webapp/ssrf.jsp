<%@page import="org.owasp.esapi.*"%>
<%@page import="com.acme.ticketbook.*"%>
<%@page import="java.net.*"%>
<%@page import="java.nio.charset.*"%>
<%@page import="org.apache.commons.io.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<title>Server Side Request Forgery (SSRF)</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
	<%@ include file="menu.jsp"%>
	<H1>Server Side Request Forgery (SSRF)</H1>

	<P>Any time an application uses untrusted data to open a URL, an attacker can make it issue forged requests that originate from the targeted server. This can be used to steal data, invoke functions, or as an intranet portscanner.</P>
	<% 
		// Separate method for URL validation
		String validateAndSanitizeURL(String inputURL) {
			if (inputURL == null || inputURL.isEmpty()) {
				// Default to a safe URL
				return "https://www.example.com";
			}
			
			try {
				URL urlObj = new URL(inputURL);
				String protocol = urlObj.getProtocol();
				
				// Only allow HTTP and HTTPS protocols
				if (!"http".equalsIgnoreCase(protocol) && !"https".equalsIgnoreCase(protocol)) {
					return "https://www.example.com";
				}
				
				// Additional validation could be added here
				// such as hostname validation against a whitelist
				
				return inputURL;
			} catch (MalformedURLException e) {
				return "https://www.example.com";
			}
		}
		
		String url = request.getParameter("url");
		String safeUrl = validateAndSanitizeURL(url);
		String pageContent = "";
		try {
			pageContent = IOUtils.toString(new URL(safeUrl), StandardCharsets.UTF_8);
		} catch (Exception e) {
			pageContent = "Error retrieving content: " + e.getMessage();
		}
	%>

	<BR>

	<div class="row">
		<div class="col-md-6">
			<div class="panel panel-primary">
				<div class="panel-heading">
					<h3 class="panel-title">Enter URL</h3>
				</div>
				<div class="panel-body">
					<form role="form" method="POST">
						<div class="form-group">
							<input id="url" name="url" value="<%=safeUrl %>"
								class="form-control" placeholder='Enter URL'>
						</div>
						<button name="submit" type="submit" class="btn btn-warning">Submit</button>
					</form>
				</div>
			</div>
		</div>
	</div>

        <div class="row">
                <div class="col-md-6">
                        <div class="panel panel-primary">
                                <div class="panel-heading">
                                        <h3 class="panel-title">URL Content</h3>
                                </div>
                                <div class="panel-body">
					<%=pageContent %>
                                </div>
                        </div>
                </div>
        </div>


	<%@ include file="footer.jsp"%>
</body>

</html>
