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
    <link rel="stylesheet" href="webs/style/room.css">
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
