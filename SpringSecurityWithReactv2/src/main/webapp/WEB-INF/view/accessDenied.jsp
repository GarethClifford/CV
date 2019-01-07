<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Access Denied</title>
<style>
body {
  margin: 0;
  font-family: Arial, Helvetica, sans-serif;
}

.topnav {
  overflow: hidden;
  background-color: #333;
}

.topnav a {
  float: left;
  color: #EA6F6F;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
  font-size: 17px;
}

.topnav a:hover {
  background-color: #ddd;
  color: black;
}

.topnav a.active {
  background-color: #8D1A67;
  color: white;
}
</style>
</head>
<body>

<div class="topnav">
  <a class="active" href="<c:url value="/homepage.html" />">Home</a>
  <a href="<c:url value="/admin/adminpage.html" />">Admin </a>
  <a href="<c:url value="/perform_logout" />">Logout</a>
</div>

<div style="padding-left:16px">
  <h2> </h2>
  <p> You do not have this permission </p>
</div>
</body>


</html>
