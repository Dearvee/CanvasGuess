<%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/6/2
  Time: 20:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login CanvasGuess</title>
    <style>/*登录*/
    body{
        background: url("back.png");
    }
    #login{
        width: 450px;
        height: 220px;
        position: absolute;
        top: 150px;
        left: 30%;
        background: #aaaaaa;
        border-radius: 5px;
        font-family: Lato,"PingFang SC","Microsoft YaHei",sans-serif;
        color: #ffffff;
        text-shadow: 2px 2px 4px #666666;
        box-shadow: 2px 2px 4px #666666;
        text-align: center;
        transition: all 0.3s;
        user-select: none;
    }
    #login:hover{
        background: #999999;
    }

    .in{
        width: 220px;
        height:38px;
        font-size: 1em;
        color: #666666;
        position: absolute;
        right: 120px;
        top: 80px;
        font-family: Lato,\"PingFang SC\",\"Microsoft YaHei\",sans-serif;
        text-shadow: 2px 2px 4px #666666;
        box-shadow: 2px 2px 4px #666666;
        border: none;
        border-radius: 2px;
        text-indent: 0.3em;
    }
    .label{
        position: absolute;
        top: 95px;
        right: 350px;
        font-size: 18px;
    }
    #sub{
        width: 50px;
        height:38px;
        position: absolute;
        right: 50px;
        top:132px;
        background: #FFFFFF;
        border: none;
        color: #666666;
        font-size: 18px;
        font-family: Lato,"PingFang SC","Microsoft YaHei",sans-serif;
        transition: all 0.2s;
        text-shadow: 2px 2px 4px #666666;
        box-shadow: 2px 2px 4px #666666;
        border-radius: 2px;
        cursor: pointer;
    }
    #sub:hover{
        background: #999999;
        color: #FFFFFF;
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
        <h2>Login CanvasGuess</h2>
        <form action="/Login">
            <label class="label" for="in_user">Name:</label>
            <input class="in" id="in_user" placeholder="用户名" name="user" type="text" />
            <label class="label" style="top: 145px;" for="in_password">Password:</label>
            <input class="in" id="in_password" placeholder="密码" style="top: 130px;" name="password" type="password"/>
            <input id="sub" type="submit" value="login"/>
            <div class="tip"><%=request.getAttribute("returnLogin")%></div>
        </form>
    </div>
</div>
</body>
</html>
