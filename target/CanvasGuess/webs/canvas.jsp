<%--
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
            overflow: hidden;
            color: #3366CC;
            text-shadow: 0 0 10px #ddd;
        }
        h2{
            display: block;
            width: 600px;
            height: 50px;
            margin: 0 auto;
            font-weight: inherit;
            text-align: center;
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
            cursor: url("webs/12.png"),auto;
        }
        .login{
            width: 400px;
            height: 200px;
            background: #ddd;
            position:absolute;
            left:35%;
            top: 35%;
            color: #ffffff;
            box-shadow:2px 2px 4px #333;
            text-shadow: 1px 1px 4px #ffffff;
            display: none;
        }
        .form{
            position:absolute;
            top: 30%;
            left: 10%;
            text-shadow: 1px 1px 4px #ffffff;
        }
        .label{
            display: inline-block;
            width: 80px;
            text-align: right;
        }
        .input{
            width: 150px;
        }
        .edit{
            height:650px;
            width: 220px;
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
    </style>
    <script src="webs/jquery-3.2.1.min.js"></script>
    <script type="text/javascript">
        var websocket = null;

        //判断当前浏览器是否支持WebSocket
        if('WebSocket' in window){
            websocket = new WebSocket("ws://localhost:8080/WebSocket");//建立连接
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
            alert("Start CanvasGuess");
        }

        //接收到消息的回调方法
        websocket.onmessage = function(event){
            drawInfo(event.data);
        }

        //连接关闭的回调方法
        websocket.onclose = function(){
            alert("close CanvasGuess");
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
        function send(){
            websocket.send(coordinate);
        }
    </script>
    <script>
        var canDraw = false;
        var drawColor="#000";
        var drawWidth="10";
        window.onload=function() {
            initDraw();
        }
        var coordinate="";//coordinate-坐标

        function initDraw() {//初始化画笔
            setDrawStyle();
            setDrawType("free");
        }
        function draw(x0, y0, x1, y1) {//画直线
            coordinate=drawColor+"+"+drawWidth+"+("+parseInt(x0)+","+parseInt(y0)+")"+"("+parseInt(x1)+","+parseInt(y1)+")";
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
                            send();
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
                    send();
                });
            }
        }

        function selDrawType() {
            var events=event.srcElement.id;
            alert(events);
            $("#canvas").unbind();
            setDrawType(events);
        }

        function drawInfo(info) {
            var strokes=info.split("*");//每一笔
            for(var i=0;i<strokes.length;i++){
                var operate=strokes[i].split("+");//每一笔的属性,包括color，width，coordinate
                drawColor=operate[0];
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
</head>
<body>
<!--
<div class="login">
    <form action="login.jsp" method="get" class="form">
        <label class="label">username:</label>
        <input class="input" type="text" name="user" placeholder="用户名"/>
        <p>
            <label class="label">password:</label>
            <input class="input" type="password" name="password" placeholder="密码"/>
            <input type="submit"/>
        <p>
    </form>
</div>--><!--login-->
<h2>你是画家，你说了算。</h2>
<div class="board">
    <canvas id="canvas" class="canvas" width="1000" height="650"></canvas>
    <ul class="edit">
        <li>
            <ul style="list-style: none;padding: 0;" onclick="selDrawType();">
                <li>形状</li>
                <p>
                <li id="free" style="display: inline;background: #eee;cursor: pointer;">Free</li>
                <li id="line" style="display: inline;background: #eee;cursor: pointer;">Line</li>
            </ul>
        </li>
        <li>
            <label>宽度:</label>
            <input type="range" id="drawWidth" value="10" min="1" max="100"/>
            <span id="viewDWidth">10</span>
        </li>
        <li>
            <label>颜色:</label>
            <input type="color" id="drawColor"/>
        </li>
    </ul>
</div>
</body>
</html>
