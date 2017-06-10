package com.vee.safe;

import com.vee.sql.MySql;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;

/**
 * Created by Dearvee on 2017/6/2.
 */

public class Login extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String user = req.getParameter("user");
        String password = req.getParameter("password");
        req.setAttribute("returnLogin","");
        HttpSession session=req.getSession();//返回与当前req关联的session
        if (isTrue(user,password)) {
            //req.setAttribute("loginUser",user);
            session.setAttribute("user",user);
            //if(WebSocket.OnlineCount==0) //空的房间，di
                req.getRequestDispatcher("webs/room.jsp").forward(req, resp);//转发user和password
            //else
                //req.getRequestDispatcher("webs/guess.jsp").forward(req,resp);
        }
        else {
            req.setAttribute("returnLogin", this.returnMessage);
            System.out.println("输入错误");
            req.getRequestDispatcher("webs/login.jsp").forward(req,resp);//输入密码错误，页面保持在登录页面
        }
    }
    private String returnMessage="";
    private boolean isTrue(String user,String password){
        MySql mySql=new MySql();
        //MySql mySql=new MySql("com.mysql.jdbc.Driver","jdbc:mysql://localhost/canvas","root","dearvee1996");
        HashMap<String,String> map= mySql.selectSql(user);//根据user查询的其他信息
        if(user.equals("")) {//用户名为空
            this.returnMessage="用户名为空！";
            return false;
        }
        if(map.size()==0) {//不存在的用户名
            this.returnMessage="不存在的用户名！";

            return false;
        }
        if(!map.get("password").equals(password)) {//密码错误
            this.returnMessage="密码错误！";
            return false;
        }
        return true;
    }
}

