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
            text-shadow: 0 0 10px #ddd;
            user-select: none;
            background: url("webs/back.png");
        }
        body>h1{
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
            cursor: url("webs/pen.png"),auto;
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
    <script>
        var canDraw = false;
        var drawColor="#3366CC";
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
        function toCanvasCo(x0,y0,x1,y1) {//100 50 相对画板坐标
            return [x0-100, y0-50, x1-100, y1-50];
        }
    </script>
</head>
<body>
<h1>Free Page</h1>
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
            <input type="range" id="drawWidth" value="10" min="1" max="100"/>
            <span id="viewDWidth">10</span>
        </li>
        <li>
            <label>Color:</label>
            <input type="color" id="drawColor" value="#3366CC"/>
        </li>
    </ul>
</div>
<ul style="position: fixed;left: 0;top: 100px;">
    <li><a href="webs/room.jsp">Room</a></li>
</ul>
</body>
</html>

