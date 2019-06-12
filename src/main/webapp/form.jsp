<%--
  Created by IntelliJ IDEA.
  User: kosar
  Date: 2/21/18
  Time: 10:03 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import ="java.util.* , domain.*"%>

<html>
<head>
    <title>Form</title>
</head>
<body>

    <% if (request.getAttribute("msg") != null) {%>
            <h1><%= request.getAttribute("msg") %></h1><% }%>

    <% Individual individual= (Individual)request.getAttribute("user"); %>

    <table style="width:100%">
        <tr>
            <th>اعتبار شما : <%= Tools.getPersian(Integer.toString(individual.getCredit())) %> تومان</th>
            <th>نام کاربری :  <%= individual.getName()%></th>
        </tr>
        <tr>
            <td>
                <form action="csearch" method=GET style="background-color:#A0A0FF">
                    <input type="hidden" name="user" value="<%=individual.getUsername()%>"/>
                    حداقل متراژ:<input type="text" name="minArea"/> <br/>
                    نوع ملک: <input type="text" name="buildingType"/><br/>
                    نوع قرارداد(خرید/اجاره): <input type="text" name="dealType"/><br/>
                    حداکثر قیمت: <input type="text" name="maxPrice"/><br/>

                    <input type="submit" value="جست و جو"/>
                </form>
            </td>
        </tr>

        <tr>
            <td>
                <form action="crecord" method=GET style="background-color:#FFFFA0">
                    <input type="hidden" name="user" value="<%=individual.getUsername()%>"/>
                    نوع ساختمان(ویلایی/آپارتمان):
                    <select name="buildingType">
                        <option value="آپارتمان">آپارتمان</option>
                        <option value="ویلایی">ویلایی</option>

                    </select> <br/>
                        متراژ: <input type="text" name="area"/><br/>

                        نوع قرارداد(خرید/اجاره):
                    <select name="dealType">
                        <option value="خرید">خرید</option>
                        <option value="اجاره">اجاره</option>

                    </select><br/>
                        قیمت فروش/اجاره: <input type="text" name="price"/><br/>
                        آدرس:<input type="text" name="address"/><br/>
                        شماره تلفن:<input type="text" name="phone"/><br/>
                        توضیحات:<input type="text" name="description"/><br/>

                        <input type="submit" value="اضافه کردن خانه ی جدید"/>
                </form>
            </td>
        </tr>

        <tr>
            <td>
                <form action="ccharge" method=GET style="background-color: dimgrey"> <br/>
                    <input type="hidden" name="user" value="<%=individual.getUsername()%>"/>
                    اعتبار: <input type="text" name="credit"/><br/>
                    <input type="submit" value="افزایش اعتبار"/>
                </form>
            </td>
        </tr>

    </table>



</body>
</html>
