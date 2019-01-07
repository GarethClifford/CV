
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<html>
  <head>
  <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.6/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.10.1/bootstrap-table.min.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.6/js/bootstrap.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.10.1/bootstrap-table.min.js"></script>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
  </head>
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
  <a href="<c:url value="/perform_logout" />">Logout </a>
</div>
<body>
<div id='CVMessage'>
<security:authorize access="hasRole('ROLE_USER')">


<h1>Welcome</h1><h1 id='loggedInUserName'><security:authentication property="principal.username" /></h1>
  <script>

    window.onload = gettingLoggedInUserID;
    var userNameLoggedIn = document.getElementById('loggedInUserName').innerHTML;
    var idLoggedIn='';
    var array = eval(getAllAccounts('http://35.246.41.89:8081/user/getall'));
    var xhr = new XMLHttpRequest();
    var string = '';
    // var array = '';

        function requestGetOrDelete(getOrDelete ,url) {
          var xhr = new XMLHttpRequest();
          xhr.open(getOrDelete, url, false);
          xhr.send(null);
	// hello just testing
          return xhr.response;
        }
        function gettingLoggedInUserID() {
         var listOfUsers = eval(getAllAccounts('http://35.246.41.89:8081/user/getall'));
         var numberOfUsers = listOfUsers.length;
         for(i = 0; i < numberOfUsers; i++) {
           if(listOfUsers[i].username === userNameLoggedIn ){
             idLoggedIn = listOfUsers[i].user_id;
           }
         }
         return idLoggedIn;
        }
        function getAllAccounts(url) {
         return requestGetOrDelete("GET", url);
        }

        function deleteCV(accnumber) {
         var url = 'http://35.246.41.89:8082/cvgenerator/delete/' + accnumber;
         requestGetOrDelete("DELETE", url);
         window.location.reload();
        }

        function uploadCV() {
          // if(getAllCV(idLoggedIn). < )
         var CV = new FormData();
         CV.append("CV", document.getElementById("file1").files[0]);
         var url = "http://35.246.41.89:8082/cvgenerator/create/" + idLoggedIn;
         xhr.open("POST", url);
         xhr.send(CV);
         document.getElementById('CVMessage').innerHTML = "Your CV has been uploaded to your profile.";
        }

        function updateUser() {
         var url = "http://35.246.41.89:8081/user/update/" + idLoggedIn;
         xhr.open("PUT", url, true);
         xhr.setRequestHeader("Content-Type", "application/json");
         var newInfo = gatheringNewInfo()
         xhr.send(newInfo);
         window.location.reload();
        }

        function gatheringNewInfo() {
         var username = document.getElementById('usernameUpdate').value;
         var password = document.getElementById('passwordUpdate').value;
         var firstName = document.getElementById('firstnameUpdate').value;
         var lastName = document.getElementById('lastnameUpdate').value;
         var email = document.getElementById('emailUpdate').value;
         var data = JSON.stringify({
           "user_id":idLoggedIn,
           "username":username,
           "password":password,
           "firstName":firstName,
           "lastName":lastName,
           "email":email,
         });
         return data;
        }

        function downloadCV(id) {
          var downloadUrl = 'http://35.246.41.89:8082/cvgenerator/get/' + id;
          window.location.assign(downloadUrl);
        }

        function getAllCV(idLoggedIn) {
         var cvUrl = 'http://35.246.41.89:8082/cvgenerator/getbyuser/' + idLoggedIn;
         var cvArray = eval(requestGetOrDelete("GET", cvUrl));
         return cvArray;
        }

        function showCVData() {
         array = eval(getAllCV(idLoggedIn));
         string = '';
         for ( i = 0; i < array.length; i ++ ) {
           createData();
         }
         document.getElementById('cvTable').innerHTML = '<tr><th>CV Title</th><th>Delete CV</th></tr>' + string;
        }

        function createData() {
         string+= "<tr><td><a onclick=downloadCV(" + array[i].cv_id + ")>" + array[i].fileName + "</a></td><td><input type='button' class='btn btn-danger' value='Delete' onclick='deleteCV(" + array[i].cv_id + ")'/></td></tr>";
        }
         // function uploadPhoto() {
         //   var picture = new FormData();
         //   picture.append("picture", document.getElementById("file2").files[0]);
         //   var xhr = new XMLHttpRequest();
         //   xhr.open("POST", "http://35.246.41.89:8086/picture/create/" + idLoggedIn);
         //   xhr.send(picture);
         //   document.getElementById('PhotoMessage').innerHTML = "Your photo has been uploaded to your profile, the trainers can now tell you apart.";
         // }

  </script>


  Add CV
  <form enctype="multipart/form-data" method="post">
      <input id="file1" type="file" name='myFile' multiple/>
  </form>
    <button onclick="uploadCV()" class="btn btn-success"> Upload CV </button>
    <br/><br/>
  </div>
<%-- <div id='PhotoMessage'>
    Upload a photo to help the trainers identify you!
    <form enctype="multipart/form-data" method="post">
        <input id="file2" type="file" name='myFile' multiple/>
    </form>
      <button onclick="uploadPhoto()" class="normal-button"> Upload photo </button>
      <br/><br/>
</div> --%>

<div class="form-popup" id="userForm">
    <form onsubmit="return false;" method="post" class="form-container">
    <label for="username">Username:</label>
    <input type="text" class="form-control" id="usernameUpdate" name="username" style="width: 150px;">
    <label for="pwd">Password:</label>
    <input type="password" class="form-control" id="passwordUpdate" name="password" style="width: 150px;">
    <label for="text">First name:</label>
    <input type="text" class="form-control" id="firstnameUpdate" name="firstname" style="width: 150px;">
    <label for="text">Last name:</label>
    <input type="text" class="form-control" id="lastnameUpdate" name="lastname" style="width: 150px;">
    <label for="text">Email:</label>
    <input type="text" class="form-control" id="emailUpdate" name="email" style="width: 150px;">
    </br>
    </br>
  <button  class="btn btn-success"  onclick="updateUser()">Update</button>
  <button  class="btn btn-danger" onclick="closeForm()">Close</button>
  </form>
</div>
<br/><br/>
<button class='btn btn-info' id='getCvButton' onclick="showCVData()">Show my CVs</button>

<table style="width:65%" id="cvTable" class="table">
</table>

</security:authorize>

<security:authorize access="hasRole('ROLE_ADMIN')">
<h1>Welcome </h1><h1 id='loggedInUserName'><security:authentication property="principal.username" /></h1>
</security:authorize>
</body>
</html>
