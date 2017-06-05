<%@ page import="com.vee.websocket.WebSocket" %><%--
  Created by IntelliJ IDEA.
  User: Dearvee
  Date: 2017/6/6
  Time: 0:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Set Answer</title>
    <script>
        window.onload=function () {
            document.getElementById("answerSet").
            addEventListener("click",function () {
                <%
                String roomID=request.getParameter("roomID");
                if(WebSocket.getAnswer(Integer.parseInt(roomID))==null){
                    WebSocket.setAnswer(Integer.parseInt(roomID),"123");
                    System.out.println("set answer 123 success");
                    }
                %>

            });
        }
    </script>
</head>
<body>
<input id="answerIn" type="text" placeholder="Answer"/>
<input id="answerSet" type="submit"/>
</body>
</html>
