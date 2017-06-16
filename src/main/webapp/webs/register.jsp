<%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/6/2
  Time: 21:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
    <base href="<%=basePath%>"/>
    <title>Register CanvasGuess</title>
    <link rel="stylesheet" type="text/css" href="webs/style/register.css">
</head>
<body>
<div>
    <div id="login"><!--登录-->
        <h2>Register CanvasGuess</h2>
        <form action="/register">
            <label class="label" for="in_user">Name:</label>
            <input class="in" id="in_user" placeholder="username" name="user" type="text"/>
            <label class="label" style="top: 138px;" for="in_password">Password:</label>
            <input class="in" id="in_password" placeholder="password" style="top: 130px;" name="password" type="password"/>
            <label class="label" style="top: 188px;" for="in_repassword">RePassword:</label>
            <input class="in" id="in_repassword" placeholder="repassword" style="top: 180px;" name="repassword" type="password"/>
            <label class="label" style="top: 238px;" for="in_email">Email:</label>
            <input class="in" id="in_email" placeholder="email" style="top: 230px;" name="email" type="text"/>
            <input class="sub" type="submit" value="submit"/>
            <div class="tip">PS: <%=request.getAttribute("returnRegister")%></div>
        </form>
    </div>
</div>
</body>
</html>

