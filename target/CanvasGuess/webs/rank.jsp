<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="com.vee.sql.MySql" %><%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/6/7
  Time: 2:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    MySql mySql=new MySql();
    LinkedHashMap<String,Integer> rank = mySql.rankDesc();
%>
<html>
<head>
    <title>Flower Rank</title>
    <link rel="stylesheet" type="text/css" href="style/rank.css">
</head>
<body>
<center>
    <h1>Flower Rank</h1>
</center>
<center>
    <table border="0.8">
        <tr>
            <td>No.</td>
            <td>User</td>
            <td>Flowers</td>
        </tr>
    <%
        int n=1;
        for(String user:rank.keySet()){%>
        <tr>
            <td><%out.print(n++);%></td>
            <td><%out.print(user);%></td>
            <td><%out.print(rank.get(user));%></td>
        </tr>
    <%}%>
    </table>
</center>
</body>
</html>
