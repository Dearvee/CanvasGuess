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
    <link rel="stylesheet" type="text/css" href="webs/style/index.css">
    <script src="webs/js/jquery-3.2.1.min.js"></script>
    <script src="webs/js/index.js"></script>
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

