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
        .room:hover{
            background: #f8f8f8;
            transform: scale(1.01);
        }
        #roomID{
            line-height: 2em;
            background: #3366CC;
            border-radius: 10px 10px 0 0;
            color: #ffffff;
            text-shadow: #ddd 0 0 1px;
        }
        ul li{
            float: left;
        }
        ul li a{
            display: inline-block;
            width: 100px;
            height: 60px;
            text-decoration: none;
        }
        ul li a:hover {
            text-decoration: underline;
        }
        h3 span{
            padding: 10px;
        }
        input:first-child{
            width: 100px;
            font-size: 1.2em;
        }
        input:last-child{
            font-size: 1.1em;
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
        </h3>
        <form action="webs/guess.jsp">
            <input type="text" name="roomID"/>
            <input type="submit" value="进入房间"/>
        </form>
    </div>
<ul style="list-style: none;">
    <li>
        <%String createUrl="webs/canvas.jsp?roomID="+(WebSocket.map.size()+1)+"&userID="+user;%>
        <a class="room" href="<%=createUrl%>" style="line-height: 80px;font-size: 1.3em;">+创建房间</a>
    </li>
    <%
    for(int room=0;room<WebSocket.map.size();room++){//输出房间总数
        out.println("<li><a href=\""+"webs/guess.jsp?roomID="+(room+1)+"&userID="+WebSocket.roomAdmin.get(room+1)+"\" class=\"room\">" +
                "<div id='roomID'>Room: "+(room+1)+"&nbsp;&nbsp;&nbsp;&nbsp; " +
                "Owner: "+WebSocket.roomAdmin.get(room+1)+"</div>" +
                "在线人数: "+WebSocket.map.get(room+1).size()+"</a></li>");
    }
    %>
</ul>
</center>
</body>
</html>
