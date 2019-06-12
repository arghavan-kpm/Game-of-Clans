<%--
  Created by IntelliJ IDEA.
  User: kosar
  Date: 2/21/18
  Time: 5:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import ="java.util.* , domain.*"%>

<html>
<head>
    <title>search</title>
</head>
<body>

    <% if (request.getAttribute("mesg") != null) {%>
    <h1><%= request.getAttribute("mesg") %></h1><% }%>

    <% Individual individual= (Individual)request.getAttribute("user"); %>
    <% ArrayList<House> houses = (ArrayList<House>)request.getAttribute("houses"); %>


    <table style="width:100%" border="2">
        <tr>
            <th>اعتبار شما : <%= Tools.getPersian(Integer.toString(individual.getCredit())) %> تومان</th>
            <th>نام کاربری :  <%= individual.getName()%></th>
        </tr>
        <%
            if(houses != null)
                for(House h : houses){
                %>
            <tr>
                <td>

                    <%if(h.getDeal() == 0){%>
                    <p>
                        قیمت:<%=h.getSellP()%><br />
                        نوع:فروشی
                    </p>
                    <%}
                    else{
                    %>
                    <p>
                        قیمت پایه:<%=h.getBaseP()%>
                        <br />
                        قیمت اجاره:<%=h.getRentP()%>
                        <br />
                        نوع :‌رهن و اجاره
                    </p>
                    <%}%>
                    <p>
                        متراژ:<%=h.getArea()%>
                        <a href="<%=h.getImageURL()%>" target="_blank">لینک عکس</a>
                    </p>
                    <a href="cmoreInfo?house_id=<%=h.getId()%>&user=<%=individual.getUsername()%>">اطلاعات بیشتر</a>


                </td>
            </tr>

           <% }
           %>

    </table>

</body>
</html>
