package com.vee.sql;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.*;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Properties;

/**
 * Created by Dearvee on 2017/6/2.
 */
public class MySql{
    public String driver;
    public String url;
    public String userSql;
    public String passwordSql;

    public MySql(){
        String path = MySql.class.getResource("/").getPath();//获取数据库配置文件路径
        String websiteURL = (path.replace("/build/classes", "").replace("%20"," ").replace("classes/", "") + "database.properties").replaceFirst("/", "");
        Properties prop=new Properties();
        if(System.getProperty("os.name").equals("linux")||System.getProperty("os.name").equals("Linux"))
            websiteURL="/"+websiteURL;
        System.out.println(websiteURL);
        try {
            InputStream inStream= new FileInputStream(new File(websiteURL));
            prop.load(inStream);

            System.out.println(prop.getProperty("password"));
        }
        catch (Exception e){
            System.out.println(e.toString());
        }
        this.driver=prop.getProperty("driver");
        this.url=prop.getProperty("url");
        this.userSql=prop.getProperty("user");
        this.passwordSql=prop.getProperty("password");
    }

    public HashMap<String,String> selectSql(String user){
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
    public void insertSql(String user,String password,String email){
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

    public void updataSql(String user){
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

    public LinkedHashMap<String,Integer> rankDesc(){
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
