<%@ page import="com.vee.websocket.WebSocket" %><%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/6/1
  Time: 16:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    //Object loginUser=request.getAttribute("loginUser");
    Object user=session.getAttribute("user");

    String roomID=request.getParameter("roomID");
    String userID=request.getParameter("userID");
    if(user==null||userID==null||roomID==null) {//null说明用户未登录跳转到登录页面 或 登陆的用户不是房主
        out.print("<script>window.location.href=\"login.jsp\";</script>");
    }
    if(user!=null&&!user.equals(userID))//登陆的用户不是房主
        out.print("<script>window.location.href=\"room.jsp\";</script>");
    if(roomID==null||WebSocket.roomAdmin.get(Integer.parseInt(roomID))!=null &&!WebSocket.roomAdmin.get(Integer.parseInt(roomID)).equals(userID))//判断是否为房主
        out.print("<script>window.location.href=\"room.jsp\";</script>");

    for(int key:WebSocket.roomAdmin.keySet())
        if(roomID==null||WebSocket.roomAdmin.get(key).equals(user))//该房主已经创建一个房间，一用户最多一房间。
            out.print("<script>window.location.href=\"room.jsp\";</script>");
    if(roomID!=null&&WebSocket.Answer.get(Integer.parseInt(roomID))==null) {
        out.print("<script>window.location.href=\"answer.jsp?roomID="+roomID+"&userID="+userID+"\";</script>");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="utf-8"/>
    <title>Canvas Edit</title>
    <link rel="stylesheet" type="text/css" href="webs/style/canvas.css">
    <script src="webs/js/jquery-3.2.1.min.js"></script>
    <script src="webs/js/canvas.js"></script>
    <script type="text/javascript">
        var websocket = null;

        //判断当前浏览器是否支持WebSocket
        if('WebSocket' in window){
            websocket = new WebSocket("ws://localhost:8080/WebSocket/"+"<%=roomID%>/"+"<%=userID%>");//建立连接
        }
        else{
            alert('Not support WebSocket')
        }

        //连接发生错误的回调方法
        websocket.onerror = function(){
            alert("服务器可能开了小差");
        };

        //连接成功建立的回调方法
        websocket.onopen = function(event){
            //alert("Start CanvasGuess");
        }

        //接收到消息的回调方法
        websocket.onmessage = function(event){
            if (event.data.split(":")[0]!=="draw")
                messageFilter(event.data)
        }

        //连接关闭的回调方法
        websocket.onclose = function(){
            //alert("close CanvasGuess");
        }

        //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
        window.onbeforeunload = function() {
            websocket.close();
        }

        //关闭连接
        function closeWebSocket(){
            websocket.close();
        }

        //发送消息
        function send(info){
            websocket.send(info);
        }

        function messageFilter(message) {//websocket 信息过滤器
            var type=message.split(":")[0];
            var user=message.split(":")[1].split(">>")[0];
            if(type==="draw")
                drawInfo(message);
            if(type==="chat") {
                message="<span id='userID'>"+user+"</span> : "+message.substring(7+user.length)+"<p/>";
                $("#chatInfo").html($("#chatInfo").html() + message);
            }
            if(type==="guess"){
                message="[猜画] <span id='userID'>"+user+"</span> : <span style='background: #ffffff;padding:5px;border-radius: 5px;'>"+message.substring(8+user.length)+"</span><p/>";
                $("#chatInfo").html($("#chatInfo").html() + message);
            }
            $("#chatInfo").scrollTop($("#chatInfo")[0].scrollHeight);
        }
    </script>
    <script>
        window.onload=function() {
            initDraw();
            $("#chatSend").bind("click",function () {
                send("chat:"+"<%=user%>>>"+$("#inChat").val());
                $("#inChat").val("");
            });
            $("#guessSend").bind("click",function () {
                send("guess:"+"<%=user%>>>"+$("#inChat").val());
                $("#inChat").val("");
            });
            $("#inChat").bind("keypress",function (event) {
                if(event.keyCode===13) {
                    send("chat:"+"<%=user%>>>" + $("#inChat").val());
                    $("#inChat").val("");
                }
            });
        }
    </script>
</head>
<body>
<center>
    <h1>Room: <%=roomID%></h1><h1> Owner: <%=userID%></h1>
</center>
<div class="board">
    <canvas id="canvas" class="canvas" width="1000" height="650"></canvas>
    <ul class="edit">
        <li>
            <ul style="list-style: none;padding: 0;" onclick="selDrawType();">
                <li>Shape</li>
                <p>
                <li id="free" style="display: inline;background: #eee;cursor: pointer;">Free</li>
                <li id="line" style="display: inline;background: #eee;cursor: pointer;">Line</li>
            </ul>
        </li>
        <li>
            <label>Width:</label>
            <input type="range" id="drawWidth" value="5" min="1" max="100"/>
            <span id="viewDWidth">5</span>
        </li>
        <li>
            <label>Color:</label>
            <input type="color" id="drawColor" value="#3366CC"/>
        </li>
            <div class="chat">
                <h3><%=user%></h3>
                <div id="chatInfo" class="chatInfo" style="overflow-y: scroll;"></div>
                <div class="chatEdit">
                    <input id="inChat" type="text" name="chatInfo" placeholder="Say"/>
                    <input id="chatSend" type="submit" value="Say"/>
                </div>
            </div>
    </ul>
</div>
</body>
</html>

