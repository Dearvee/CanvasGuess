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
    <style>
        html{
            width: 100%;
            height: 100%;
        }
        body{
            width:100%;
            height: 100%;
            overflow: hidden;
            color: #666666;
            text-shadow: 0 0 10px #ddd;
            background: url("back.png");
        }
        body>h1{
            display: block;
            width: 600px;
            height: 50px;
            margin: 0 auto;
            text-align: center;
            user-select: none;
            color:#3366CC;
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
        .edit{
            height:650px;
            width: 320px;
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
            width: inherit;
            height: 280px;
            background: #f8f8f8;
        }
        .chatEdit{
            width: inherit;
            height: 50px;
            padding: 0;
        }
        .chatEdit input:first-child{
            font-size: 1em;
        }
        #userID{
            color: #3366CC;
        }
    </style>
    <script src="jquery-3.2.1.min.js"></script>
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
                message="[<span id='userID'>"+user+"</span>] : "+message.substring(7+user.length)+"<p/>";
                $("#chatInfo").html($("#chatInfo").html() + message);
            }
            if(type==="guess"){
                message="[猜画] [<span id='userID'>"+user+"</span>] : <span style='background: #ffffff;padding:5px;border-radius: 5px;'>"+message.substring(8+user.length)+"</span><p/>";
                if(answer==="Flower")
                    alert("Flower +3");
                else
                    alert("Wrong")
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
<h1>Room: <%=roomID%> Owner: <%
    if(roomID!=null&&!roomID.equals(""))
    out.println(WebSocket.roomAdmin.get(Integer.parseInt(roomID)));%></h1>
<div class="board">
    <canvas id="canvas" class="canvas" width="1000" height="650"></canvas>
    <ul class="edit">
        <div class="chat">
            <h3><%=user%> Show time~</h3>
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


