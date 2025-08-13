<%@page import="java.nio.file.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="com.acme.ticketbook.*"%>
<%@page import="org.owasp.esapi.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<title>File Reader</title>
<link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
    <%@ include file="../menu.jsp" %>
    <H1>File Reader</H1>

    <div class="row">
        <div class="col-md-6">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Select a file to view</h3>
                </div>
                <div class="panel-body">
                    <form role="form" method="POST" action="path.jsp">
                        <div class="form-group">
                            <select name="file" id="file" class="form-control">
                                <option value="constitution.txt">US Constitution</option>
                                <option value="declaration.txt">Declaration of Independence</option>
                                <option value="gettysburg.txt">Gettysburg Address</option>
                            </select>
                        </div>
                        <button name="submit" type="submit" class="btn btn-warning">Go!</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%
    // Get the requested file parameter
    String requestedFile = request.getParameter("file");
    
    // Create a set of allowed files - whitelist approach
    Set<String> allowedFiles = new HashSet<>(Arrays.asList(
        "constitution.txt", "declaration.txt", "gettysburg.txt"
    ));
    
    if (requestedFile != null && !requestedFile.isEmpty()) {
        // Validate that the requested file is in our whitelist
        if (allowedFiles.contains(requestedFile)) {
            try {
                // Use a predefined base directory for all files
                String baseDir = "/home/runner/work/ticketbookdemo/ticketbookdemo/src/main/resources/textfiles";
                
                // Build the complete file path safely by resolving against base directory
                Path filePath = Paths.get(baseDir, requestedFile);
                
                // Additional safety check - verify the resolved path is still within base directory
                if (filePath.toAbsolutePath().startsWith(Paths.get(baseDir).toAbsolutePath())) {
                    // Read file content safely
                    byte[] fileBytes = Files.readAllBytes(filePath);
                    String content = new String(fileBytes);
    %>
                    <div class="row">
                        <div class="col-md-10">
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <h3 class="panel-title">Content of <%=requestedFile%></h3>
                                </div>
                                <div class="panel-body">
                                    <pre><%=content%></pre>
                                </div>
                            </div>
                        </div>
                    </div>
    <%
                } else {
                    // Path traversal attempt detected
                    out.println("<div class='alert alert-danger'>Invalid file access attempt detected.</div>");
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error reading file: " + e.getMessage() + "</div>");
            }
        } else {
            // Requested file not in whitelist
            out.println("<div class='alert alert-danger'>The requested file is not allowed.</div>");
        }
    }
    %>

    <%@ include file="../footer.jsp" %>
</body>

</html>