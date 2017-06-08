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
    <style>/*注册*/
    body{
        background: url("webs/back.png");
        color: #3366CC;
    }
    body h2{
        height: 50px;
        background: #333333;
        line-height: 50px;
        border-radius: 5px 5px 0 0;
        margin: 0 auto;
        box-shadow: 0 2px 10px #333;
        animation: h2 1s;
    }
    @keyframes h2 {
        0%{padding: 0;}
        50%{ padding: 10px 20px 10px 20px;}
        100%{padding: 0;}
    }
    #login{
        width: 480px;
        height: 320px;
        position: absolute;
        top: 150px;
        left: 30%;
        border-radius: 5px;
        font-family: Lato,"PingFang SC","Microsoft YaHei",sans-serif;
        text-align: center;
        transition: all 0.3s;
        box-shadow: 1px 1px 10px #333;
    }

    .in{
        width: 220px;
        height:38px;
        font-size: 1em;
        position: absolute;
        right: 120px;
        top: 80px;
        font-family: Lato,\"PingFang SC\",\"Microsoft YaHei\",sans-serif;
        border-radius: 2px;
        text-indent: 0.3em;
        color: #3366CC;
        border: solid 1px #3366CC;
    }

    .label{
        position: absolute;
        top: 88px;
        right: 350px;
        font-size: 18px;
    }
    .sub{
        height:38px;
        width: 80px;
        position: absolute;
        right: 30px;
        top:230px;
        background: #333;
        border: none;
        font-family: Lato,"PingFang SC","Microsoft YaHei",sans-serif;
        transition: all 0.2s;
        border-radius: 2px;
        cursor: pointer;
        color: #3366CC;
        box-shadow: 0 0 2px #333;
    }
    .sub:hover{
        box-shadow: 0 0 10px #333;
    }
        .tip{
            width: 480px;
            position: absolute;
            bottom: 10px;
            text-align: center;
        }
    </style>
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

