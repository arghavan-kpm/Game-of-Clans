<%--
  Created by IntelliJ IDEA.
  User: kosar
  Date: 2/21/18
  Time: 9:59 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>CLAN WAR</title>

</head>
<body>

<% if (request.getAttribute("msg") != null) {%>
<h1 style="color:red "><%= request.getAttribute("msg") %></h1><% }%>


<table style="width:100%">
    <tr>
        <th>Login</th>
        <th>Signup</th>
    </tr>
    <tr>
        <td>
            <form action="clogin" method=GET style="background-color:#A0A0FF">
                username :<input type="text" name="user"/> <br/>
                password :<input type="password" name="pass"/><br/>
                <input type="submit" value="login"/>
            </form>
        </td>

        <td>
            <form action="csignup" method=GET style="background-color:#A0A0FF">
                username :<input type="text" name="user"/> <br/>
                password :<input type="password" name="pass"/><br/>

                <input type="submit" value="signup"/>
            </form>
        </td>
    </tr>
</table>
</body>
</html>
