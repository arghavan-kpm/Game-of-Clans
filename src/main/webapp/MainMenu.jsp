<%--
  Created by IntelliJ IDEA.
  User: kosar
  Date: 18/12/19
  Time: 14:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import ="java.util.* , domain.*"%>
<%@ page import="static java.lang.Math.abs" %>

<html>
<head>
    <title>Main Menu</title>
</head>
<body>

    <table style="width:100%" border="2">
        <tr>
            <th>Username</th>
            <th>Clan ID</th>
            <th>Clan Experience</th>
            <th>Number of Won</th>
            <th>Number of Lost</th>
            <th>Clan Gold</th>
            <th>Clan Lumber</th>
            <th>Clan Food</th>
            <th>Clan Army</th>
            <th>Clan Chant</th>
            <th>Clan Level</th>
        </tr>

            <%
                int myExpr = 0;
                ArrayList< ArrayList<Integer> > res = Connect2DB.getClansInfo();
                for(int i=0;i < res.size();i++){
                    if(Integer.parseInt((String)request.getAttribute("clanId")) == res.get(i).get(0)){
                        myExpr = res.get(i).get(1);

            %>

            <tr>
                <td>
                    <%= request.getAttribute("user") %>
                </td>
                <%
                    for(int j=0;j < res.get(i).size();j++){
                %>
                <td>
                        <%= res.get(i).get(j)%>

                </td>
                <%
                    }
                %>
                <td>
                    <%= Connect2DB.getClanChant(Integer.parseInt((String)request.getAttribute("clanId")))%>
                </td>
                <td>
                    <%= Connect2DB.getClanLevel(Integer.parseInt((String)request.getAttribute("clanId")))%>
                </td>
            </tr>

            <%
                    }
                }
            %>
    </table>
    <br />
    <% if ( Connect2DB.isAdmin((String)request.getAttribute("user"))) { %>
        <form action="cupdateChant" method=GET >
            <input type="hidden" name="user" value="<%=(String)request.getAttribute("user")%>"/>
            <input type="hidden" name="clanId" value="<%=(String)request.getAttribute("clanId")%>"/>
            <input type="text" name="newChant" placeholder="New Chant here ... " />
            <input type="submit" value="update"/>
        </form>
        <br />
    <% } %>


    <h1> Attack History </h1>
    <table border="1">
        <tr>
            <th> Fight ID </th>
            <th> Winner ID </th>
            <th> Loser ID </th>
            <th> Date of Fight </th>
        </tr>
        <%   ArrayList<ArrayList<String> > attacks = Connect2DB.getAttacks((String)request.getAttribute("clanId"));%>
        <% for( int i =0; i<attacks.size(); i++){%>
            <tr>
                <%for(int j=0;j < attacks.get(i).size();j++){%>
                <td> <%=attacks.get(i).get(j)%></td>
                <%}%>
            </tr>
        <%}%>
    </table>


    <h1> Leaderboard </h1>
    <table border="1">
        <tr>
            <th> Clan ID </th>
            <th> Experience </th>
            <th> Number of won </th>
            <th> Number of lost </th>
        </tr>
        <% res = Connect2DB.sort(res); %>
        <%for(int i=0;i < res.size();i++){%>
            <tr>
                <%for(int j=0;j < 4;j++){%>
                    <td>
                        <%= res.get(i).get(j)%>
                    </td>
                <%}%>
                <% if( abs(res.get(i).get(1) / 100 - myExpr/100) <= 1 && res.get(i).get(0) != Integer.parseInt((String)request.getAttribute("clanId"))) { %>
                    <td>
                        <a href="/cattack?user=<%=(String)request.getAttribute("user")%>&clanId=<%=(String)request.getAttribute("clanId")%>&attacked=<%=res.get(i).get(0)%>"> Attack </a>
                    </td>
                <%}%>
            </tr>
        <%}%>
    </table>
    <br/>
    <%  String[] jobs = {"Miner","Sawyer","Farmer","Trainer"};
        int jobId = Connect2DB.getJob((String)request.getAttribute("user"));
    %>
    <form action="cupdateJob" method=GET>
        <input type="hidden" name="user" value="<%=(String)request.getAttribute("user")%>"/>
        <input type="hidden" name="clanId" value="<%=(String)request.getAttribute("clanId")%>"/>
        job :
        <select name="newJob">
            <% for(int i=0;i < 4;i++){%>
                <option value="<%=i + 1%>" <%if(i + 1== jobId) { %>  selected <%}%> > <%=jobs[i]%></option>
            <%}%>
        </select>
        <input type="submit" value = "update job" />
        <br/>
    </form>
    <br />
    <h1> Clan Members </h1>
    <%  boolean isAdmin = Connect2DB.isAdmin((String)request.getAttribute("user"));
        ArrayList<String> clanUsers = Connect2DB.getClanUsers(Integer.parseInt((String)request.getAttribute("clanId")));
    %>
    <table border="1">
        <tr>
            <th> Role </th>
            <th> User </th>
        </tr>
        <%for(int i=0;i < clanUsers.size();i++){ %>
            <tr>
                <td>
                    <%  int role = Connect2DB.getRole(clanUsers.get(i)); %>
                    <%  if(role == 1){%>
                        User
                    <%}%>
                    <%if(role == 2){%>
                        Assistant
                    <%}%>
                    <%if(role == 3){%>
                        Admin
                    <%}%>
                </td>
                <td>
                    <%=clanUsers.get(i)%>
                </td>
                <%if(isAdmin && !clanUsers.get(i).equals((String)request.getAttribute("user"))){%>
                <td>
                    <a href="caddRemove?user=<%=(String)request.getAttribute("user")%>&clanId=<%=(String)request.getAttribute("clanId")%>&applied=<%=clanUsers.get(i)%>&action=remove">remove user</a>
                </td>
                <td>
                    <a href="caddRemove?user=<%=(String)request.getAttribute("user")%>&clanId=<%=(String)request.getAttribute("clanId")%>&applied=<%=clanUsers.get(i)%>&action=alter&convert=<%=3 - role%>">Alter role</a>
                </td>
                <%}%>
            </tr>
        <%}%>
        <% if(isAdmin){ %>
            <tr>
                <td>
                    <form action="caddRemove" method=GET>
                        <input type="hidden" name="user" value="<%=(String)request.getAttribute("user")%>"/>
                        <input type="hidden" name="clanId" value="<%=(String)request.getAttribute("clanId")%>"/>
                        <input type="hidden" name="action" value="add"/>
                        <input type="text" name="applied" placeholder="New Username" />
                        <input type="submit" name="add user"/>
                    </form>
                </td>
                <% if(request.getAttribute("ARmsg") != null){ %>
                    <td style="color:red">
                        <%=(String)request.getAttribute("ARmsg")%>
                    </td>
                <%}%>
            </tr>
        <%}%>
    </table>
    <br />
    <%   if(Connect2DB.getRole((String)request.getAttribute("user")) > 1) { %>
    <%   ArrayList<ArrayList<String> > buildings = Connect2DB.getClanBuildings((String)request.getAttribute("clanId"));%>

        <h2> Buildings </h2>
        <br />
        <table border="1">
            <tr>
                <th>Type</th>
                <th>Start date</th>
                <th>Progress</th>
                <th>Action</th>
            </tr>
            <% int activeBuildingId = 0; %>
            <%for(int i=0;i < buildings.size();i++){%>
            <% if(buildings.get(i).get(4).equals("Deactivate"))
                activeBuildingId = Integer.parseInt(buildings.get(i).get(0));
            }%>
            <%for(int i=0;i < buildings.size();i++){%>
                <tr>
                    <%for(int j=1;j < buildings.get(i).size() - 1;j++){%>
                        <td> <%=buildings.get(i).get(j)%></td>
                    <%}%>
                    <td>
                        <a href="cactivity?user=<%=(String)request.getAttribute("user")%>&clanId=<%=(String)request.getAttribute("clanId")%>&activeId=<%=activeBuildingId%>&buildingId=<%=buildings.get(i).get(0)%>">
                            <%=buildings.get(i).get(4)%>
                        </a>
                    </td>

                </tr>
            <%}%>
            <tr>
                <td>
                    <form action="caddBuild" method=GET>
                        <input type="hidden" name="user" value="<%=(String)request.getAttribute("user")%>"/>
                        <input type="hidden" name="clanId" value="<%=(String)request.getAttribute("clanId")%>"/>
                        <select name="type">
                            <option value="FARM"> FARM </option>
                            <option value="BARRACK"> BARRACK </option>
                        </select>
                        <input type="submit" name="add building"/>
                    </form>
                </td>
            </tr>
        </table>
    <%}%>


</body>
</html>
