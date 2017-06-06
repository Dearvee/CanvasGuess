<%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/6/6
  Time: 0:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Set setAnswer</title>
</head>
<body>

<form action="/setAnswer">
    <input name="roomID" type="text" value="<%=request.getParameter("roomID")%>" hidden>
    <input name="userID" type="text" value="<%=request.getParameter("userID")%>" hidden>
    <input name="answer" type="text" placeholder="setAnswer"/>
    <input type="submit"/>
</form>
</body>
</html>
