<%@ page import="com.vee.websocket.WebSocket" %><%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/6/3
  Time: 20:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    //Object loginUser=request.getAttribute("loginUser");
    Object user=session.getAttribute("user");
    //if(user==null)//两个都为null说明用户未登录跳转到登录页面
        //out.print("<script>window.location.href=\"login.jsp\";</script>");
%>
<html>
<head>
    <base href="<%=basePath%>"/>
    <title>Room</title>
    <style>
        body{
            background:url("webs/back.png");
            color: #3366CC;
            margin: 0 0;
        }
        h1{
            display: inline;
            background: #333333;
            line-height: 2em;
            padding: 10px 20px 10px 20px;
            margin: 0 0;
            border-radius: 0 0 5px 5px;
            box-shadow: 1px 1px 10px #333;
            animation: h1 1s;
        }
        @keyframes h1 {
            0%{padding: 10px 20px 10px 20px;}
            50%{padding: 10px 50px 10px 50px;}
            100%{padding: 10px 20px 10px 20px;}
        }
        .room{
            width: 280px;
            height: 80px;
            background: #ffffff;
            margin: 20px 20px;
            border-radius: 10px;
            cursor: pointer;
            user-select: none;
            box-shadow: 0 0 4px #3366CC;
            font-family: Lato,"PingFang SC","Microsoft YaHei",sans-serif;
            transition: all 0.3s;
        }
        a{
            color: #3366CC;
            transition: all 0.3s;
        }
        a:hover{
            color: #333;
        }
        .room:hover{
            background: #f8f8f8;
            transform: scale(1.01);
        }
        #roomID{
            line-height: 2em;
            border-radius: 10px 10px 0 0;
            background: #333;
            border: solid 1px #3366CC;
            font-family: Lato,"PingFang SC","Microsoft YaHei",sans-serif;
            transition: all 0.2s;
            cursor: pointer;
            color: #3366CC;
            box-shadow: 0 0 2px #333;
        }
        #roomID:hover{
            box-shadow: 0 0 10px #333;
        }
        ul li{
            float: left;
        }
        ul li a{
            display: inline-block;
            width: 100px;
            height: 60px;
            color: #3366CC;
            text-decoration: none;
        }
        ul li a:hover {
            text-decoration: underline;
            color: #3366CC;
        }
        h3 span{
            padding: 10px;
        }
        input:first-child{
            width: 100px;
            height:38px;
            color: #3366CC;
            font-family: Lato,\"PingFang SC\",\"Microsoft YaHei\",sans-serif;
            border-radius: 2px;
            text-indent: 0.3em;
            border: solid 1px #3366CC;
        }
        input:last-child{
            height:38px;
            background: #333;
            border: none;
            font-family: Lato,"PingFang SC","Microsoft YaHei",sans-serif;
            transition: all 0.2s;
            border-radius: 2px;
            cursor: pointer;
            color: #3366CC;
            box-shadow: 0 0 2px #333;
        }
        input:last-child:hover{
            box-shadow: 0 0 10px #333;
        }
    </style>
</head>
<body>
<center>
    <h1>CanvasGuess Room</h1>
    <div>
        <h3>
            <span>All room: <%=WebSocket.map.size()%></span>
            <span>All online: <%=WebSocket.OnlineCount%></span>
            <span><a href="webs/login.jsp">Login</a></span>
            <span><a href="webs/rank.jsp">Rank</a></span>
        </h3>
        <form action="webs/guess.jsp">
            <input type="text" name="roomID" placeholder="roomID"/>
            <input type="submit" value="Come into"/>
        </form>
    </div>
<ul style="list-style: none;">
    <li>
        <%String createUrl="webs/canvas.jsp?roomID="+(WebSocket.map.size()+1)+"&userID="+user;%>
        <a class="room" href="<%=createUrl%>" style="line-height: 80px;font-size: 1.3em;">+Create room</a>
    </li>
    <%
    for(int room:WebSocket.map.keySet()){//output all room
        out.println("<li><a href=\""+"webs/guess.jsp?roomID="+(room)+"&userID="+WebSocket.roomAdmin.get(room)+"\" class=\"room\">" +
                "<div id='roomID'>Room: "+(room)+"&nbsp;&nbsp;&nbsp;&nbsp; " +
                "Owner: "+WebSocket.roomAdmin.get(room)+"</div>" +
                "<div style='line-height:2.8em;'>Online: "+WebSocket.map.get(room).size()+"</div></a></li>");
    }
    %>
    <!--<iframe width="300" height="300" src="webs/guess.jsp?roomID=1&userID=123456"></iframe>-->
</ul>
</center>
</body>
</html>
