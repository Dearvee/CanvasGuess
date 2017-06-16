<%@ page import="com.vee.websocket.WebSocket" %>
<%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/5/31
  Time: 10:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object user=session.getAttribute("user");
    String roomID=request.getParameter("roomID");
    String userID=request.getParameter("userID");

    if(roomID==null)
        out.print("<script>window.location.href=\"room.jsp\";</script>");
    else {
        String reg = "[0-9]*";
        boolean isNum = roomID.matches(reg);
        if (!isNum)//room参数是否为数字
            out.print("<script>window.location.href=\"room.jsp\";</script>");
        else if (roomID.equals("") || WebSocket.map.get(Integer.parseInt(roomID)) == null)//判断房间是否存在
            out.print("<script>window.location.href=\"room.jsp\";</script>");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Guess Page</title>
    <link rel="stylesheet" type="text/css" href="style/guess.css">
    <script src="js/jquery-3.2.1.min.js"></script>
    <script src="js/guess.js"></script>
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
        }

        //连接成功建立的回调方法
        websocket.onopen = function(event){
            //alert("Start CanvasGuess");
        }

        //接收到消息的回调方法
        websocket.onmessage = function(event){
            messageFilter(event.data);
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
        function messageFilter(message) {//websocket
            var term=message.split(":");
            var type=term[0];
            var user=term[1].split(">>")[0];
            var answer=term[term.length-1];
            if(type==="draw")
                drawInfo(message);
            if(type==="chat") {
                message="<span id='userID'>"+user+"</span> : "+message.substring(7+user.length)+"<p/>";
                $("#chatInfo").html($("#chatInfo").html() + message);
            }
            if(type==="guess"){
                message="[猜画] <span id='userID'>"+user+"</span> : <span style='background: #ffffff;padding:5px;border-radius: 5px;'>"+message.substring(8+user.length)+"</span><p/>";
                if(answer==="Flower")
                    alert("Flower +3");
                else if (answer==="Wrong")
                    alert("Wrong")
                else if (answer==="Again")
                    alert("Again");
                $("#chatInfo").html($("#chatInfo").html() + message);
            }
            $("#chatInfo").scrollTop($("#chatInfo")[0].scrollHeight);//滑动滚动条到最底部
        }
    </script>
    <script>
        window.onload=function() {
            <%
            if(user!=null)
                out.print("addChatEvent();");
            %>
        }
    </script>
    <script>
        function addChatEvent() {
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
    <h1>Room: <%=roomID%></h1><h1> Owner: <%
    if(roomID!=null&&!roomID.equals(""))
    out.println(WebSocket.roomAdmin.get(Integer.parseInt(roomID)));%></h1>
</center>
<div class="board">
    <canvas id="canvas" class="canvas" width="1000" height="650"></canvas>
    <ul class="edit">
        <div class="chat">
            <h3><%=user%></h3>
            <div id="chatInfo" class="chatInfo" style="overflow-y: scroll;"></div>
            <div class="chatEdit">
                <input id="inChat" type="text" name="chatInfo" placeholder="Say/Guess"/>
                <input id="chatSend" type="submit" value="Say"/>
                <input id="guessSend" type="submit" value="Guess"/>
            </div>
        </div>
    </ul>
</div>
<ul style="position: fixed;left: 0;top: 100px;">
    <li><a href="login.jsp">Login</a></li>
</ul>
</body>
</html>


