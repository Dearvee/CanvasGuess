<%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/5/15
  Time: 17:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>CanvasGuess</title>
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
            user-select: none;
            background: url("webs/back.png");
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
        }
        @keyframes h1 {
            0%{padding: 10px 20px 10px 20px;}
            50%{padding: 10px 50px 10px 50px;}
            100%{padding: 10px 20px 10px 20px;}
        }
        a{
            color: #3366CC;
            transition: all 0.3s;
        }
        a:hover{
            color: #333;
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
    </style>
    <script src="webs/jquery-3.2.1.min.js"></script>
    <script>
        var canDraw = false;
        var drawColor="#3366CC";
        var drawWidth="5";
        window.onload=function() {
            initDraw();
        }
        var coordinate="";//coordinate-坐标

        function initDraw() {//初始化画笔
            setDrawStyle();
            setDrawType("free");
        }
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
                        endX = ec.clientX;
                        beginY = ec.clientY;

                        endY = ec.clientY;
                        first = false;
                    }
                    else {
                        endX = ec.clientX;
                        endY = ec.clientY;
                        first = true;
                    }
                    draw(beginX, beginY, endX, endY);
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
</head>
<body>
<center>
<h1>Free Page</h1>
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
    </ul>
</div>
<ul style="position: fixed;left: 0;top: 100px;">
    <li><h3><a href="webs/room.jsp">Room</a></h3></li>
</ul>
</body>
</html>

