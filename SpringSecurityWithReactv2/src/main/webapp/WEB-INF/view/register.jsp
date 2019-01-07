<!DOCTYPE html>
<html>
  <head>
    <title>Register</title>
    <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.6/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.10.1/bootstrap-table.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.6/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.10.1/bootstrap-table.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
  </head>
<body>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<html>
<head></head>
<style>
body {
  margin: auto;
  font-family: Arial, Helvetica, sans-serif;
  background-size: cover;

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
</body>

</head>
 <body>

<nav class="navbar">
  <div class="topnav">
        <a class="active" href="<c:url value="/homepage.html" />">Home</a>
  </div>
</nav>

<p> Register yourself now!</p>

<script>
    register = function() {
         var xhr = new XMLHttpRequest();
         var url = "http://35.246.41.89:8081/user/create";
         xhr.open("POST", url, true);
         xhr.setRequestHeader("Content-Type", "application/json");
         xhr.onreadystatechange = function () {
         if (xhr.readyState === 4 && xhr.status === 200) {
           console.log(xhr.responseText);
         }
         };
         var username = document.getElementById('username').value;
         var password = document.getElementById('password').value;
         var firstName = document.getElementById('firstname').value;
         var lastName = document.getElementById('lastname').value;
         var email = document.getElementById('email').value;
         var data = JSON.stringify({
           "username":username,
           "password":password,
           "firstName": firstName,
           "lastName": lastName,
           "email": email,
           "enabled":true,
           "role":"ROLE_USER"
         });
         xhr.send(data);
         document.getElementById('username').value="";
         document.getElementById('password').value="";
         document.getElementById('firstname').value="";
         document.getElementById('lastname').value="";
         document.getElementById('email').value="";
         alert("User Successfully Created!");
         return false;

       }

  </script>

<%-- onsubmit="return false;" method="post" --%>

    <form >
      <div class="form-group">
        <label for="username">Username:</label>
        <input type="text" class="form-control" id="username" name="username" required style="width: 150px;">
      </div>
      <div class="form-group">
        <label for="pwd">Password:</label>
        <input type="password" class="form-control" id="password" name="password" required style="width: 150px;">
      </div>
      <div class="form-group">
        <label for="text">First name:</label>
        <input type="text" class="form-control" id="firstname" name="firstname" required style="width: 150px;">
      </div>
      <div class="form-group">
        <label for="text">Last name:</label>
        <input type="text" class="form-control" id="lastname" name="lastname" required style="width: 150px;">
      </div>
      <div class="form-group">
        <label for="text">Email:</label>
        <input type="email" class="form-control" id="email" name="email" required style="width: 150px;">
      </div>
</br>
<button name= "button" type="submit" class="btn btn-success" onclick="register()">Create</button>
</form>

</body>
</html>
