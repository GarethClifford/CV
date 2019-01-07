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
  <a href="<c:url value="/perform_logout" />">Logout</a>
</div>
<security:authorize access="hasRole('ROLE_ADMIN')">
<h1>Welcome </h1><h1 id='loggedInUserName'><security:authentication property="principal.username" /></h1>
</security:authorize>
<br/>
    <script>
    var string = '';
    var array = eval(getAllAccounts('http://35.246.41.89:8081/user/getall'));
    var userNameLoggedIn = document.getElementById('loggedInUserName').innerHTML;
    var idLoggedIn='';
    var amISuper='';
    var xhr = new XMLHttpRequest();
    window.onload = gettingLoggedInAdminID;

    function register() {
      if(amISuper) {
        createAdmin();
      }else{
        window.alert("YOU HAVE NO POWER HERE")
      }
    }

    function createAdmin() {
      var url = "http://35.246.41.89:8084/admin/create/" + idLoggedIn;
      xhr.open("POST", url, true);
      xhr.setRequestHeader("Content-Type", "application/json");
      var dataToSend = gatheringInfo();
      xhr.send(dataToSend);
    }

    function gatheringInfo() {
      var username = document.getElementById('username').value;
      var password = document.getElementById('password').value;
      var firstName = document.getElementById('firstname').value;
      var lastName = document.getElementById('lastname').value;
      var email = document.getElementById('email').value;
      var isSuper = document.getElementById('isAdmin').checked;
      var data = JSON.stringify({
        "username":username,
        "password":password,
        "firstName":firstName,
        "lastName":lastName,
        "email":email,
        "superAdmin":isSuper
      });
      return data
    }

    function requestGetOrDelete(getOrDelete ,url) {
      var xhr = new XMLHttpRequest();
      xhr.open(getOrDelete, url, false);
      xhr.send(null);
// just testing this works
      return xhr.response;
    }

    function getAllCV(id) {
      var cvUrl = 'http://35.246.41.89:8082/cvgenerator/getbyuser/' + id;
      var cvArray = eval(requestGetOrDelete("GET", cvUrl));
      return cvArray;
    }

    function showUserData() {
      string='';
      for(i = 0; i < array.length; i++){
          userID = array[i].user_id;
          var row = array[i];
          creatingData(userID);
      }
      document.getElementById('userTable').innerHTML = '<tr><th>#</th><th>Username</th><th>First name</th><th>Last name</th><th>Email</th><th>CV 1</th><th>CV 2</th><th>CV 3</th><th>Flag user</th><th>Tag user</th><th>Delete</th></tr>' + string;
      document.getElementById('flagButton').innerHTML = "<button class='btn btn-danger' onclick='flagSelectedUsers()'> Flag these users</button>"
      document.getElementById('tagButton').innerHTML = "<button class='btn btn-danger' onclick='tagSelectedUsers()'> Tag selected users</button>"
    }

    function creatingData(userID) {
      var numberOfCvs = getAllCV(userID).length;

      cvTitle1 = '';
      cvID1 = '';
      cvTitle2 = '';
      cvID2 = '';
      cvTitle3 = '';
      cvID3 = '';
      if( numberOfCvs === 3 ) {
        cvTitle1 =  getAllCV(userID)[0].fileName;
        cvID1 = getAllCV(userID)[0].cv_id;
        cvTitle2 = getAllCV(userID)[1].fileName;
        cvID2 = getAllCV(userID)[1].cv_id;
        cvTitle3 = getAllCV(userID)[2].fileName;
        cvID3 = getAllCV(userID)[2].cv_id;
        createUserRow()
      } else if( numberOfCvs === 2 ) {
        cvTitle1 = getAllCV(userID)[0].fileName;
        cvID1 = getAllCV(userID)[0].cv_id;
        cvTitle2 = getAllCV(userID)[1].fileName;
        cvID2 = getAllCV(userID)[1].cv_id;
        createUserRow();
      } else if ( numberOfCvs === 1 ) {
        cvTitle1 = getAllCV(userID)[0].fileName;
        cvID1 = getAllCV(userID)[0].cv_id;
        createUserRow();
      } else {
        createUserRow();
      }
    }

    function createUserRow() {
      if(array[i].flagged) {
        creatingString1();
      } else {
        creatingString2();
      }
    }

    function creatingString1() {
      var arrayOfCvs = eval(getAllCV(userID));
      if( arrayOfCvs.length === 3 ) {
        string += "<tr class='danger'><td>" + array[i].user_id + "</td><td>" + array[i].username + "</td><td>" + array[i].firstName + "</td><td>" + array[i].lastName + "</td><td>" + array[i].email + '</td><td><a onclick=downloadCV(' + arrayOfCvs[0].cv_id + ')>' + cvTitle1 + '</a></td><td><a onclick=downloadCV(' + arrayOfCvs[1].cv_id + ')>' + cvTitle2 + '</a></td><td><a onclick="downloadCV(' + arrayOfCvs[2].cv_id + ')">' + cvTitle3 + '</a></td><td> <input type="checkbox" id=isUserFlagged' + i + '> Flag </td><td> <input type="checkbox" id=isUserTagged' + i + '> Tag user </td><td> <input type="button" class="btn btn-danger" value="Delete" onclick=\'deleteUser('+array[i].user_id+')\'/>' + "</td></tr>";
      } else if( arrayOfCvs.length === 2 ) {
        string += "<tr class='danger'><td>" + array[i].user_id + "</td><td>" + array[i].username + "</td><td>" + array[i].firstName + "</td><td>" + array[i].lastName + "</td><td>" + array[i].email + '</td><td><a onclick=downloadCV(' + arrayOfCvs[0].cv_id + ')>' + cvTitle1 + '</a></td><td><a onclick=downloadCV(' + arrayOfCvs[1].cv_id + ')>' + cvTitle2 + '</a></td><td></td><td> <input type="checkbox" id=isUserFlagged' + i + '> Flag </td><td> <input type="checkbox" id=isUserTagged' + i + '> Tag user </td><td> <input type="button" class="btn btn-danger" value="Delete" onclick=\'deleteUser('+array[i].user_id+')\'/>' + "</td></tr>";
      } else if( arrayOfCvs.length === 1 ) {
        string += "<tr class='danger'><td>" + array[i].user_id + "</td><td>" + array[i].username + "</td><td>" + array[i].firstName + "</td><td>" + array[i].lastName + "</td><td>" + array[i].email + '</td><td><a onclick=downloadCV(' + arrayOfCvs[0].cv_id + ')>' + cvTitle1 + '</a></td><td></td><td></td><td> <input type="checkbox" id=isUserFlagged' + i + '> Flag </td><td> <input type="checkbox" id=isUserTagged' + i + '> Tag user </td><td> <input type="button" class="btn btn-danger" value="Delete" onclick=\'deleteUser('+array[i].user_id+')\'/>' + "</td></tr>";
      } else {
        string += "<t class='danger'r><td>" + array[i].user_id + "</td><td>" + array[i].username + "</td><td>" + array[i].firstName + "</td><td>" + array[i].lastName + "</td><td>" + array[i].email + '</td><td></td><td>/td><td></td><td> <input type="checkbox" id=isUserFlagged' + i + '> Flag </td><td> <input type="checkbox" id=isUserTagged' + i + '> Tag user </td><td> <input type="button" class="btn btn-danger" value="Delete" onclick=\'deleteUser('+array[i].user_id+')\'/>' + "</td></tr>";
      }
      return string;
    }

    function creatingString2() {
      var arrayOfCvs = eval(getAllCV(userID));
      if( arrayOfCvs.length === 3 ) {
        string += "<tr><td>" + array[i].user_id + "</td><td>" + array[i].username + "</td><td>" + array[i].firstName + "</td><td>" + array[i].lastName + "</td><td>" + array[i].email + '</td><td><a onclick=downloadCV(' + arrayOfCvs[0].cv_id + ')>' + cvTitle1 + '</a></td><td><a onclick=downloadCV(' + arrayOfCvs[1].cv_id + ')>' + cvTitle2 + '</a></td><td><a onclick="downloadCV(' + arrayOfCvs[2].cv_id + ')">' + cvTitle3 + '</a></td><td> <input type="checkbox" id=isUserFlagged' + i + '> Flag </td><td> <input type="checkbox" id=isUserTagged' + i + '> Tag user </td><td> <input type="button" class="btn btn-danger" value="Delete" onclick=\'deleteUser('+array[i].user_id+')\'/>' + "</td></tr>";
      } else if( arrayOfCvs.length === 2 ) {
        string += "<tr><td>" + array[i].user_id + "</td><td>" + array[i].username + "</td><td>" + array[i].firstName + "</td><td>" + array[i].lastName + "</td><td>" + array[i].email + '</td><td><a onclick=downloadCV(' + arrayOfCvs[0].cv_id + ')>' + cvTitle1 + '</a></td><td><a onclick=downloadCV(' + arrayOfCvs[1].cv_id + ')>' + cvTitle2 + '</a></td><td></td><td> <input type="checkbox" id=isUserFlagged' + i + '> Flag </td><td> <input type="checkbox" id=isUserTagged' + i + '> Tag user </td><td> <input type="button" class="btn btn-danger" value="Delete" onclick=\'deleteUser('+array[i].user_id+')\'/>' + "</td></tr>";
      } else if( arrayOfCvs.length === 1 ) {
        string += "<tr><td>" + array[i].user_id + "</td><td>" + array[i].username + "</td><td>" + array[i].firstName + "</td><td>" + array[i].lastName + "</td><td>" + array[i].email + '</td><td><a onclick=downloadCV(' + arrayOfCvs[0].cv_id + ')>' + cvTitle1 + '</a></td><td></td><td></td><td> <input type="checkbox" id=isUserFlagged' + i + '> Flag </td><td> <input type="checkbox" id=isUserTagged' + i + '> Tag user </td><td> <input type="button" class="btn btn-danger" value="Delete" onclick=\'deleteUser('+array[i].user_id+')\'/>' + "</td></tr>";
      } else {
        string += "<tr><td>" + array[i].user_id + "</td><td>" + array[i].username + "</td><td>" + array[i].firstName + "</td><td>" + array[i].lastName + "</td><td>" + array[i].email + '</td><td></td><td></td><td></td><td> <input type="checkbox" id=isUserFlagged' + i + '> Flag </td><td> <input type="checkbox" id=isUserTagged' + i + '> Tag user </td><td> <input type="button" class="btn btn-danger" value="Delete" onclick=\'deleteUser('+array[i].user_id+')\'/>' + "</td></tr>";
      }
      return string;
    }

    function flagSelectedUsers() {
      string=''
      for ( i = 0; i < array.length; i ++ ) {
        if(document.getElementById('isUserFlagged' + i).checked) {
          updateUserToFlagged(array[i].user_id);
        }
      }
    }

    function tagSelectedUsers() {
      string = '';
      for ( i = 0; i < array.length; i ++ ) {
        if(document.getElementById('isUserTagged' + i).checked) {
          updateUserToTagged(array[i].user_id);
        }
      }
    }

    function updateUserToTagged(userID) {
      var cvUrl = 'http://35.246.41.89:8081/user/taguser/' + userID + '/' + idLoggedIn;
      requestGetOrDelete("GET", cvUrl);
      window.alert("User has been tagged, you will recieve an email whenever they make any change")
    }

    function updateUserToFlagged(userID) {
      var yesOrNo = isThisUserFlagged();
      var flaggedData = getFlaggedData(yesOrNo);
      var url = 'http://35.246.41.89:8081/user/update/' + userID;
      xhr.open("PUT", url, true);
      xhr.setRequestHeader("Content-Type", "application/json");
      xhr.send(flaggedData);
      window.location.reload();
    }

    function isThisUserFlagged() {
      var trueOrFalse = true;
      if(array[i].flagged === true && document.getElementById('isUserFlagged' + i).checked === true) {
        trueOrFalse = false;
      }
      return trueOrFalse;
    }

    function getFlaggedData(yesOrNo) {
      var newFlaggedData = JSON.stringify({
        'user_id':userID,
        'username':array[i].username,
        'password':array[i].password,
        'firstName':array[i].firstName,
        'lastName':array[i].lastName,
        'email':array[i].email,
        'flagged':yesOrNo
      });
      return newFlaggedData;
    }

    function showAdminData() {
      forLoop(array);
    }

    function forLoop(JSONobj) {
      var arrayAdmin = eval(getAllAccounts('http://35.246.41.89:8084/admin/getall'));
      var string = '';
      for(i = 0; i < arrayAdmin.length; i++){
        var row = arrayAdmin[i];
        string += "<tr><td>" + arrayAdmin[i].admin_id + "</td><td>" + arrayAdmin[i].username + "</td><td>" + arrayAdmin[i].firstName + "</td><td>" + arrayAdmin[i].lastName + "</td><td>" + arrayAdmin[i].email + '</td><td>' + arrayAdmin[i].superAdmin + '</td><td> <input type="button" class="btn btn-danger" value="Delete" onclick=\'deleteAdmin('+arrayAdmin[i].admin_id+')\'/>' + "</td></tr>";
      }
      document.getElementById('userTable').innerHTML = '<tr><th>#</th><th>Username</th><th>First name</th><th>Last name</th><th>Email</th><th>Superadmin</th><th>Delete</th></tr>' + string;
    }

    function downloadCV(id) {
      console.log(id + " test");
      var downloadUrl = 'http://35.246.41.89:8082/cvgenerator/get/' + id;
      window.location.assign(downloadUrl);
      // console.log(id);
    }

    function getAllAccounts(url) {
      return requestGetOrDelete("GET", url);
    }

    function getAllAccounts(url) {
      return requestGetOrDelete("GET", url);
    }

    function deleteUser(accnumber) {
      if(amISuper) {
        removeUser(accnumber);
      }else{
        window.alert("YOU HAVE NO POWER HERE")
      }
    }

    function deleteAdmin(accnumber) {
      if(amISuper) {
        removeAdmin(accnumber);
      }else{
        window.alert("YOU HAVE NO POWER HERE")
      }
    }

    function removeUser(accnumber) {
      var url = 'http://35.246.41.89:8081/user/delete/' + accnumber;
      requestGetOrDelete("DELETE",url);
      window.location.reload();
    }

    function removeAdmin(accnumber) {
      var url = 'http://35.246.41.89:8084/admin/delete/' + accnumber;
      requestGetOrDelete("DELETE",url);
      window.location.reload();
    }
      function gettingLoggedInAdminID() {
        var listOfAdmins = eval(getAllAccounts('http://35.246.41.89:8084/admin/getall'))
        var numberOfAdmins = array.length;
        for(var i = 0; i < numberOfAdmins; i++) {
          if(listOfAdmins[i].username === userNameLoggedIn ){
            idLoggedIn = listOfAdmins[i].admin_id;
            amISuper = listOfAdmins[i].superAdmin;
          }
        }
        return idLoggedIn;
    }

  </script>
       <button type='button' class="btn btn-primary" onClick="showUserData()"> Show all users </button>
       <button type='button' class="btn btn-primary" onClick="showAdminData()"> Show all admins </button>
       <br/><br/>
       <table style="width:65%" id="userTable" class="table">
       </table>
       <div id='flagButton'></div>
       <br/>
       <div id='tagButton'></div>
       <br/>
       <div class="form-popup" id="userForm">
           <form onsubmit="return false;" method="post" class="form-container">
           <label for="username">Username:</label>
           <input type="text" class="form-control" id="username" name="username" style="width: 150px;">
           <label for="pwd">Password:</label>
           <input type="password" class="form-control" id="password" name="password" style="width: 150px;">
           <label for="text">First name:</label>
           <input type="text" class="form-control" id="firstname" name="firstname" style="width: 150px;">
           <label for="text">Last name:</label>
           <input type="text" class="form-control" id="lastname" name="lastname" style="width: 150px;">
           <label for="text">Email:</label>
           <input type="text" class="form-control" id="email" name="email" style="width: 150px;">
           </br>
           </br>
           <div className="radio">
             <label>
               <input id="isAdmin" type="radio" value="Admin"/>
               Admin
             </label>
             <label>
               <input id="isTrainer"type="radio" value="Trainer"checked={true}/>
               Trainer
             </label>
             <br/><br/>
         <div>
         <button type="submit" class="btn btn-success"  onclick="register()">Create</button>

         </form>
    <br/><br/>

</body>
</html>
