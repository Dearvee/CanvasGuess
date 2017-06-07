package com.vee.answer;

import com.vee.websocket.WebSocket;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by Dearvee on 2017/6/6.
 */
public class setAnswer extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //super.doGet(req, resp);
        doPost(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //super.doPost(req, resp);
        String answer = req.getParameter("answer");
        answer=new String(answer.getBytes("ISO-8859-1"),"utf-8");
        String userID = req.getParameter("userID");
        if (req.getParameter("roomID") != null) {
            int roomID = Integer.parseInt(req.getParameter("roomID"));
            if (WebSocket.getAnswer(roomID) == null) {
                WebSocket.setAnswer(roomID, answer);
                System.out.println("set answer " + answer + " success");
                req.getRequestDispatcher("webs/canvas.jsp?roomID"+req.getParameter("roomID")+"&userID="+userID).forward(req,resp);
            } else
                System.out.println("set Failed~");
        }
        else
            System.out.println("roomID null");
    }
}
