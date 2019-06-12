<%--
  Created by IntelliJ IDEA.
  User: kosar
  Date: 2/22/18
  Time: 1:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import ="java.util.* , domain.*"%>

<html>
<head>
    <title>Choose your clan</title>
</head>
<body>
    <h5> User : <%= request.getAttribute("user")%> </h5><br />
    <h1>List of clans</h1>

    <table style="width:100%" border="2">
        <tr>
            <th> Clan ID</th>
            <th>Clan Experience</th>
            <th>Number of Won</th>
            <th>Number of Lost</th>
            <th>Clan Gold</th>
            <th>Clan Lumber</th>
            <th>Clan Food</th>
            <th>Clan Army</th>
        </tr>

        <%
            ArrayList< ArrayList<Integer> > res = Connect2DB.getClansInfo();
            for(int i=0;i < res.size();i++){
        %>

            <tr>
                <%
                for(int j=0;j < res.get(i).size();j++){
                %>
                <td>
                    <a href="cchoose?user=<%= request.getAttribute("user") %>&clanId=<%= res.get(i).get(0)%>">
                        <%= res.get(i).get(j)%>
                    </a>
                </td>
                <%
                }
                %>
            </tr>

        <%
            }
        %>
        <tr>
            <td>
                <a href="caddClan?user=<%=request.getAttribute("user") %>">
                    New Clan
                </a>
            </td>
        </tr>

    </table>
</body>
</html>
