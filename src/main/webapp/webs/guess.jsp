<%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/5/31
  Time: 10:45
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
        h2{
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
    </style>
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
        var drawColor="#000";
        var drawWidth="10";
        window.onload=function() {
            ;
        }

        var coordinate="";//coordinate-坐标

        function draw(x0, y0, x1, y1) {//画直线
            var co=toCanvasCo(x0,y0,x1,y1);
            x0=co[0];y0=co[1];x1=co[2];y1=co[3];
            coordinate=drawColor+"+"+drawWidth+"+("+parseInt(x0)+","+parseInt(y0)+")"+"("+parseInt(x1)+","+parseInt(y1)+")";
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
            return [x0-100, y0-42, x1-100, y1-42];
        }
    </script>
</head>
<body>
<h2>猜！猜！猜！</h2>
<div class="board">
    <canvas id="canvas" class="canvas" width="1000" height="650"></canvas>
</div>
</body>
</html>


