<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Error</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="panel panel-default" style="margin-top: 100px;">
                    <div class="panel-heading">
                        <h3 class="panel-title">Login Error</h3>
                    </div>
                    <div class="panel-body">
                        <div class="alert alert-danger">
                            Login failed. Invalid username or password.
                        </div>
                        <a href="login.jsp" class="btn btn-lg btn-primary btn-block">Try Again</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="js/jquery-2.0.3.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>