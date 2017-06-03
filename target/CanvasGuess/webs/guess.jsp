<%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/5/31
  Time: 10:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object user=request.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Guess Page</title>
    <style>
        html{
            width: 100%;
            height: 100%;
        }
        body{
            width:100%;
            height: 100%;
            overflow: hidden;
            color: #3366CC;
            text-shadow: 0 0 10px #ddd;
        }
        body>h2{
            display: block;
            width: 600px;
            height: 50px;
            margin: 0 auto;
            font-weight: inherit;
            text-align: center;
            user-select: none;
        }
        .board{
            width:1000px;
            margin: 0 100px;
        }
        .canvas{
            width:1000px;
            height:650px;
            background: #eee;
            float: left;
            box-shadow: 2px 2px 10px #ddd;
        }
        .chat{
            width: 400px;
            height: 400px;
            background: #dddddd;
            position: fixed;
            bottom: 30px;
            right: 10px;
        }
        .chatInfo{
            width: inherit;
            height: 280px;
            background: #cccccc;
        }
        .chatEdit{
            width: inherit;
            height: 50px;
            position: absolute;
            bottom: 0;
        }
        .chatEdit input:first-child{
            height: 25px;
            width: 250px;
            color: #3366CC;
            margin: 5px 5px;
            font-size: 1em;
        }
    </style>
    <script src="jquery-3.2.1.min.js"></script>
    <script type="text/javascript">
        var websocket = null;

        //判断当前浏览器是否支持WebSocket
        if('WebSocket' in window){
            <%String room=request.getParameter("room");%>
            websocket = new WebSocket("ws://localhost:8080/WebSocket/"+"<%=room%>");//建立连接
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
        function messageFilter(message) {//websocket 信息过滤器
            var type=message.split(":")[0];
            var user=message.split(":")[1].split(">>")[0];
            if(type==="draw")
                drawInfo(message);
            if(type==="chat") {
                message=user+" say:<p/>"+message.substring(7+user.length)+"<p/>";
                $("#chatInfo").html($("#chatInfo").html() + message);
            }
            if(type==="guess"){
                message="<猜画> "+user+">><span style='background: #ffffff;padding:5px;border-radius: 5px;'>"+message.substring(8+user.length)+"</span><p/>";
                $("#chatInfo").html($("#chatInfo").html() + message);
            }
            $("#chatInfo").scrollTop($("#chatInfo")[0].scrollHeight);//滑动滚动条到最底部
        }
    </script>
    <script>
        var drawColor="#fff";
        var drawWidth="10";

        function draw(x0, y0, x1, y1) {//画直线
            var co=toCanvasCo(x0,y0,x1,y1);
            x0=co[0];y0=co[1];x1=co[2];y1=co[3];
            var canvas = document.getElementById("canvas");
            var ctx = canvas.getContext("2d");
            ctx.lineWidth = drawWidth;
            ctx.strokeStyle = drawColor;
            ctx.lineCap = "round";
            ctx.beginPath();
            ctx.moveTo(x0, y0);
            ctx.lineTo(x1, y1);
            ctx.stroke();
            ctx.closePath();
        }

        function drawInfo(info) {
            var strokes=info.split("*");//每一笔
            for(var i=0;i<strokes.length;i++){
                var operate=strokes[i].split("+");//每一笔的属性,包括color，width，coordinate
                drawColor=operate[0].substring(5);
                drawWidth=operate[1];
                var co=coToArray(operate[2]);
                draw(co[0],co[1],co[2],co[3]);
            }
        }
        function coToArray(coordinate) {
            var coors=coordinate.match(/\(\d+,\d+\)/g);
            var co0,co1;
            co0=[coors[0].split(",")[0].substr(1),
                coors[0].split(",")[1].
                substr(0,coors[0].split(",")[1].length-1)];
            co1=[coors[1].split(",")[0].substr(1),
                coors[1].split(",")[1].
                substr(0,coors[1].split(",")[1].length-1)];
            return [co0[0],co0[1],co1[0],co1[1]];
        }
        function toCanvasCo(x0,y0,x1,y1) {//100 50 相对画板坐标
            return [x0-100, y0-50, x1-100, y1-50];
        }
    </script>
    <script>
        window.onload=function() {
            <%
            //if(user!=null)
                //out.print("addChatEvent();");
            %>
            addChatEvent();
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
<h2>猜！猜！猜！</h2>
<div class="board">
    <canvas id="canvas" class="canvas" width="1000" height="650"></canvas>
</div>
<div class="chat">
    <h3><%
    if(user==null)
        out.print("你必须登录才可以参与互动~");
    else
        out.print("Welcome "+user);
    %></h3>
    <div id="chatInfo" class="chatInfo" style="overflow-y: scroll;"></div>
    <div class="chatEdit">
        <input id="inChat" type="text" name="chatInfo" placeholder="聊天/猜画"/>
        <input id="chatSend" type="submit" value="聊天"/>
        <input id="guessSend" type="submit" value="猜画"/>
    </div>
</div>
<ul style="position: fixed;left: 0;top: 100px;">
    <li><a href="login.jsp">Login</a></li>
</ul>
</body>
</html>


