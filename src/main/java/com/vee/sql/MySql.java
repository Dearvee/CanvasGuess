package com.vee.sql;

import java.sql.*;
import java.util.HashMap;
import java.util.LinkedHashMap;

/**
 * Created by Dearvee on 2017/6/2.
 */
public class MySql {
    public static final String driver="com.mysql.jdbc.Driver";//驱动
    public static final String url="jdbc:mysql://localhost/canvas";
    public static final String userSql="root";
    public static final String passwordSql="dearvee1996";
    public static HashMap<String,String> selectSql(String user){
        HashMap<String,String> map=new HashMap<String, String>();
        try{
            Class.forName(driver);
            Connection conn = DriverManager.getConnection(url, userSql, passwordSql);//连接数据库
            if(!conn.isClosed())
                System.out.println("Succeeded connecting to the Database!");
            Statement statement=conn.createStatement();//以执行sql语句
            String sql="SELECT * FROM `logininfo` WHERE user='"+user+"'";
            ResultSet resultSet=statement.executeQuery(sql);
            while(resultSet.next()) {
                        map.put("password",resultSet.getString("password"));
                        map.put("email",resultSet.getString("email"));
                        map.put("flower",resultSet.getString("flower"));
                return map;
            }
        }
        catch (Exception e){
            System.out.println("查询数据失败:"+e.toString());
        }
        return map;
    }
    public static void insertSql(String user,String password,String email){
        try{
            Class.forName(driver);
            Connection conn = DriverManager.getConnection(url, userSql, passwordSql);//连接数据库
            if(!conn.isClosed())
                System.out.println("Succeeded connecting to the Database!");
            Statement statement=conn.createStatement();//以执行sql语句
            String sql="INSERT INTO `logininfo`(`user`, `password`, `email`, `flower`) " +
                    "VALUES ('"+user+"','"+password+"','"+email+"','0')";
            statement.executeUpdate(sql);
            System.out.println("数据库插入数据成功");
        }
        catch (Exception e){
            System.out.println("数据库插入数据失败"+e.toString());
        }
    }

    public static void updataSql(String user){
        try{
            Class.forName(driver);
            Connection conn = DriverManager.getConnection(url, userSql, passwordSql);//连接数据库
            if(!conn.isClosed())
                System.out.println("Succeeded connecting to the Database!");
            Statement statement=conn.createStatement();//以执行sql语句
            String sql="UPDATE `logininfo` " +
                    "SET flower=flower+3 WHERE user='"+user+"'";
            statement.executeUpdate(sql);
            System.out.println("数据库修改数据成功");
        }
        catch (Exception e){
            System.out.println("数据库修改数据失败"+e.toString());
        }
    }

    public static LinkedHashMap<String,Integer> rankDesc(){
        LinkedHashMap<String,Integer> map=new LinkedHashMap<String, Integer>();
        try{
            Class.forName(driver);
            Connection conn = DriverManager.getConnection(url, userSql, passwordSql);//连接数据库
            if(!conn.isClosed())
                System.out.println("Succeeded connecting to the Database!");
            Statement statement=conn.createStatement();//以执行sql语句
            String sql="SELECT `user`,`flower`" +
                    "FROM `logininfo` " +
                    "ORDER BY `flower` DESC";
            ResultSet resultSet=statement.executeQuery(sql);
            while(resultSet.next()) {
                map.put(resultSet.getString("user"),resultSet.getInt("flower"));
                System.out.println(resultSet.getString("user")+" "+resultSet.getInt("flower"));
            }
            return map;
        }
        catch (Exception e){
            System.out.println("数据rank失败"+e.toString());
        }
        return map;
    }
}
