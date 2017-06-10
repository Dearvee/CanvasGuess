package com.vee.safe;

import com.vee.sql.MySql;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by Dearvee on 2017/6/2.
 */
public class Register extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //super.doGet(req, resp);
        doPost(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //super.doPost(req, resp);
        String user=req.getParameter("user");
        String password=req.getParameter("password");
        String repassword=req.getParameter("repassword");
        String email=req.getParameter("email");
        req.setAttribute("returnRegister","");
        if(isSafe(user,password,repassword,email)) {
            MySql mySql=new MySql();
            //MySql mySql=new MySql("com.mysql.jdbc.Driver","jdbc:mysql://localhost/canvas","root","dearvee1996");
            mySql.insertSql(user,password,email);
            System.out.println("注册成功");
            req.getRequestDispatcher("webs/login.jsp").forward(req, resp);//转发user和passwor
        }
        else {
            req.setAttribute("returnRegister",this.returnMessage);
            System.out.println("输入错误");
            req.getRequestDispatcher("webs/register.jsp").forward(req, resp);//输入密码错误，页面保持在登录页面
        }
    }
    private String returnMessage="";
    private boolean isSafe(String user,String password,String repassword,String email){
        if (user.equals("")) { //用户名为空
            this.returnMessage="用户名为空！";
            return false;
        }
        if (password.equals("")) {//密码为空
            this.returnMessage="密码为空！";
            return false;
        }
        if (!password.equals(repassword)) {//两次密码不一致
            this.returnMessage="两次输入密码不一致！";
            return false;
        }
        if (!email.matches("(.*)@.(.*).(.*)")) {//不符合email格式
            this.returnMessage="Email格式不正确！";
            return false;
        }
        MySql mySql=new MySql();
        //MySql mySql=new MySql("com.mysql.jdbc.Driver","jdbc:mysql://localhost/canvas","root","dearvee1996");
        if(mySql.selectSql(user).size()!=0) {//已存在的用户
            this.returnMessage="已存在的用户名！";
            return false;
        }
        return true;
    }
}
