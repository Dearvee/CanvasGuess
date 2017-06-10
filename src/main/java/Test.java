import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

/**
 * Created by Dearvee on 2017/6/2.
 */
public class Test{
    public static void main(String [] args){
        Properties prop=new Properties();
        try {
            InputStream inStream = new FileInputStream(new File("src/main/resources/database.properties"));
            prop.load(inStream);

            System.out.println(prop.getProperty("password"));
        }
        catch (Exception e){
            System.out.println(e.toString());
        }
    }
}
