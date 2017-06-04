
/**
 * Created by Dearvee on 2017/6/2.
 */
public class Test {
    public static void main(String [] args){
        String reg = "[0-9]+";
        boolean isNum ="12345f6".matches(reg);
        System.out.println(isNum);
    }
}
