<%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/6/2
  Time: 20:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    %>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Login CanvasGuess</title>
    <link rel="stylesheet" type="text/css" href="webs/style/login.css">
</head>
<body>
<div>
    <div id="login"><!--登录-->
        <h2>Login CanvasGuess</h2>
        <form action="/login">
            <label class="label" for="in_user">Name:</label>
            <input class="in" id="in_user" placeholder="username" name="user" type="text" />
            <label class="label" style="top: 138px;" for="in_password">Password:</label>
            <input class="in" id="in_password" placeholder="password" style="top: 130px;" name="password" type="password"/>
            <a href="webs/register.jsp" class="sub" style="position: absolute;top: 80px;text-decoration: none;">register</a>
            <input class="sub" type="submit" value="login"/>
            <div class="tip">PS: <%=request.getAttribute("returnLogin")%></div>
        </form>
    </div>
</div>
</body>
</html>
