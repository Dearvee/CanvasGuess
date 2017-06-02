import java.sql.*;
import java.util.HashMap;

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
            String sql="SELECT * FROM `logininfo` WHERE USER='"+user+"'";
            ResultSet resultSet=statement.executeQuery(sql);
            while(resultSet.next()) {
                        map.put("password",resultSet.getString("password"));
                        map.put("email",resultSet.getString("email"));
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
            String sql="INSERT INTO `logininfo`(`user`, `password`, `email`) " +
                    "VALUES ('"+user+"','"+password+"','"+email+"')";
            statement.executeUpdate(sql);
            System.out.println("数据库插入数据成功");
        }
        catch (Exception e){
            System.out.println("数据库插入数据失败"+e.toString());
        }
    }
}
