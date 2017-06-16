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
    <title>Set Answer</title>
    <link rel="stylesheet" type="text/css" href="style/answer.css">
</head>
<body>
    <div id="login">
        <h2>Set Answer</h2>
        <h3>Room:<%=request.getParameter("roomID")%> Owner:<%=request.getParameter("userID")%></h3>
        <form action="/answer">
            <input name="roomID" type="text" value="<%=request.getParameter("roomID")%>" hidden>
            <input name="userID" type="text" value="<%=request.getParameter("userID")%>" hidden>
            <label class="label">Answer:</label>
            <input class="in" name="answer" type="text" placeholder="setAnswer"/>
            <input class="sub" type="submit" value="Set"/>
        </form>
        <div class="tip">You set the answer for guess!</div>
    </div>
</body>
</html>
