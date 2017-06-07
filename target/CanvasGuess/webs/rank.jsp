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
    LinkedHashMap<String,Integer> rank = MySql.rankDesc();
%>
<html>
<head>
    <title>Flower Rank</title>
    <style>
        body{
            background: url("back.png");
        }
        h1{
            display: block;
            width: 600px;
            height: 50px;
            margin: 0 auto;
            text-align: center;
            color:#3366CC;
        }
        table{
            width: 60%;
            text-align: center;
            line-height: 2em;
            margin: 50px auto;
            font-size: 1.1em;
        }
        table tr{
            transition: all 0.3s;
        }
        table tr:nth-child(2n){
            background: url("back.png") #dddddd;
            box-shadow: 0 0 3px #333;
        }
        table tr:hover{
            background: url("back.png") #aaaaaa;
            color: #FFFFFF;
        }
        table tr:first-child{
            color:#3366CC;
            font-size: 1.2em;
            font-weight: bold;
        }
    </style>
</head>
<body>
<h1>Flower Rank</h1>
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
