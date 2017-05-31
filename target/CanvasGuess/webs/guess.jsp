<%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/5/31
  Time: 10:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
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
        }
        .board{
            width:800px;
        }
        .canvas{
            width:800px;
            height:650px;
            background: #eee;
            float: left;
            box-shadow: 2px 2px 10px #ddd;
        }
    </style>
    <script src="jquery-3.2.1.min.js"></script>
    <script>
        var drawColor="#000";
        var drawWidth="10";
        window.onload=function() {
            drawInfo("#000+20+(10,10)(100,100)")
        }

        var coordinate="";//coordinate-坐标

        function draw(x0, y0, x1, y1) {//画直线
            coordinate+=drawColor+"+"+drawWidth+"+("+parseInt(x0)+","+parseInt(y0)+")"+"("+parseInt(x1)+","+parseInt(y1)+")*";
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
    </script>
</head>
<body>
<div class="board">
    <canvas id="canvas" class="canvas" width="800" height="650"></canvas>
</div>
</body>
</html>


