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
    <style>
    body{
        background: url("back.png");
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
        width: 450px;
        height: 220px;
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
        color: #3366CC;
        position: absolute;
        right: 120px;
        top: 120px;
        font-family: Lato,\"PingFang SC\",\"Microsoft YaHei\",sans-serif;
        border-radius: 2px;
        text-indent: 0.3em;
        border: solid 1px #3366CC;
    }
    .label{
        position: absolute;
        top: 128px;
        right: 350px;
        font-size: 18px;
    }
    .sub{
        width: 80px;
        height:38px;
        position: absolute;
        left: 350px;
        top:121px;
        background: #333;
        border: solid 1px #3366CC;
        font-family: Lato,"PingFang SC","Microsoft YaHei",sans-serif;
        transition: all 0.2s;
        border-radius: 2px;
        cursor: pointer;
        line-height: 38px;
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
