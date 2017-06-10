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
    <style>
        html{
            width: 100%;
            height: 100%;
        }
        body{
            width:100%;
            height: 100%;
            color: #3366CC;
            overflow: hidden;
            user-select: none;
            background: url("back.png");
            margin:0;
        }
        h1{
            display: inline;
            background: #333333;
            line-height: 2em;
            padding: 10px 20px 10px 20px;
            border-radius: 0 0 5px 5px;
            box-shadow: 1px 1px 10px #333;
            animation: h1 1s;
            margin: 0 10px;
        }
        @keyframes h1 {
            0%{padding: 10px 20px 10px 20px;}
            50%{padding: 10px 50px 10px 50px;}
            100%{padding: 10px 20px 10px 20px;}
        }
        .board{
            width:1000px;
            margin: 10px 100px;
        }
        .canvas{
            width:1000px;
            height:650px;
            background: #eee;
            float: left;
            box-shadow: 2px 2px 10px #ddd;
            cursor: url("webs/pen.png"),auto;
        }
        .edit{
            height:650px;
            width: 340px;
            display: inline-block;
            position: absolute;
            user-select: none;
            padding: 0;
            margin: 0 10px;
            border: 2px #eeeeee solid;
            list-style: none;
            box-shadow: 0 0 10px #ddd;
        }
        .edit li{
            padding: 5px;
        }
        .chat{
            width: inherit;
            position: absolute;
            bottom: 0;
        }
        .chatInfo{
            width: 320px;
            height: 280px;
            background: #f8f8f8;
            line-height: 1.8em;
            text-blink: 1em;
            padding: 10px;
        }
        .chatEdit{
            width: inherit;
            padding: 0;
        }
        .chatEdit input:first-child{
            width: 253px;
            height:38px;
            color: #3366CC;
            font-family: Lato,\"PingFang SC\",\"Microsoft YaHei\",sans-serif;
            border-radius: 2px;
            text-indent: 0.3em;
            border: solid 1px #3366CC;
        }
        .chatEdit input:last-child{
            width: 80px;
            height:40px;
            background: #333;
            border: none;
            font-family: Lato,"PingFang SC","Microsoft YaHei",sans-serif;
            transition: all 0.2s;
            border-radius: 2px;
            cursor: pointer;
            color: #3366CC;
            box-shadow: 0 0 2px #333;
        }
        .chatEdit input:last-child:hover{
            box-shadow: 0 0 10px #333;
        }
        #userID{
            background: #333333;
            border-radius: 2px;
            box-shadow: 0 0 5px #333;
            margin: 5px 10px;
            padding: 4px;
        }
    </style>
    <script src="webs/jquery-3.2.1.min.js"></script>
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
        var canDraw = false;
        var drawColor="#3366CC";
        var drawWidth="5";
        var coordinate="";//coordinate-坐标

        function initDraw() {//初始化画笔
            setDrawStyle();
            setDrawType("free");
        }
        function draw(x0, y0, x1, y1) {//画直线
            coordinate=
                "draw:"+drawColor+"+"+drawWidth+"+("+parseInt(x0)+","+
                parseInt(y0)+")"+"("+parseInt(x1)+","+parseInt(y1)+")";
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

        function setDrawStyle() {
            var dColor = document.getElementById('drawColor');//画笔颜色
            dColor.oninput = function () {
                drawColor = dColor.value;
            }

            var dView = document.getElementById('viewDWidth');//宽度显示
            var dWidth = document.getElementById('drawWidth');//画笔宽度
            dWidth.oninput = function () {
                drawWidth = dWidth.value;
                dView.innerText = dWidth.value;
            }
        }
        function setDrawType(type) {
            var canvas = document.getElementById("canvas");
            if (type === "free") {//freeDraw
                $("#canvas").bind("mousedown", function (ed) {
                    var beginX = ed.clientX;
                    var beginY = ed.clientY;
                    canDraw = true;
                    $("#canvas").bind("mousemove", function (em) {
                        if (canDraw) {
                            draw(beginX, beginY, em.clientX, em.clientY);
                            send(coordinate);
                            beginX = em.clientX;
                            beginY = em.clientY;
                        }
                        else {
                            beginX = em.clientX;
                            beginY = em.clientY;
                        }
                    });
                });
                $(document.body).bind("mouseup", function () {
                    canDraw = false;
                });
            }
            if (type === "line") {//lineDraw
                var first = true;
                var beginX, beginY, endX, endY;
                $("#canvas").bind("click", function (ec) {
                    if (first) {
                        beginX = ec.clientX;
                        beginY = ec.clientY;
                        endX = ec.clientX;

                        endY = ec.clientY;
                        first = false;
                    }
                    else {
                        endX = ec.clientX;
                        endY = ec.clientY;
                        first = true;
                    }
                    draw(beginX, beginY, endX, endY);
                    send(coordinate);
                });
            }
        }
        function selDrawType() {
            var events=event.srcElement.id;
            alert(events);
            $("#canvas").unbind();
            setDrawType(events);
        }
        function toCanvasCo(x0,y0,x1,y1) {//相对画板坐标
            var x=document.getElementById("canvas").offsetLeft-7;
            var y=document.getElementById("canvas").offsetTop-7;
            return [x0-x, y0-y, x1-x, y1-y];
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

