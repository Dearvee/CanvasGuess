/**
 * Created by Dearvee on 2017/5/31.
 */
package com.vee.websocket;


import com.vee.sql.MySql;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.HashMap;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint("/WebSocket/{roomID}/{userID}")
public class WebSocket {
    private Session session;//连接会话
    public static int OnlineCount=0;
    public static int roomID=0;
    //private static CopyOnWriteArraySet<WebSocket> webSocketSet = new CopyOnWriteArraySet<WebSocket>();//每个客户端对应的对象，单一客户端通信则用Map

    public static HashMap<Integer,CopyOnWriteArraySet<WebSocket>>  map= new HashMap<Integer, CopyOnWriteArraySet<WebSocket>>();//每个room对应一个客户端集合
    public static HashMap<Integer,String> roomAdmin = new HashMap<Integer,String>();//每个room对应一个房主
    public static HashMap<Integer,String> Answer = new HashMap<Integer,String>();//每个room对应的answer
    public static HashMap<String,Integer> Again = new HashMap<String, Integer>();//每个人的回答次数限制
    @OnOpen
    public void onOpen(@PathParam("roomID") int roomID,@PathParam("userID") String userID,Session session){
        this.session=session;
        addMap(roomID,userID);
        addOnlineCount();//增加在线人数
        //System.out.println(roomID+"新的加入！"+getOnlineCount());
    }
    @OnClose
    public void onClose(@PathParam("roomID") int roomID){
        removeMap(roomID);
        //subOnlineCount();//减少在线人数
        //System.out.println("新的下线！"+getOnlineCount());
    }
    @OnError
    public void onError(Session session,Throwable error){
        //System.out.println("出现错误！");
        error.printStackTrace();
    }
    @OnMessage
    public void onMessage(@PathParam("roomID") int roomID,String message,Session session){
        //信息改变，向每一个终端发送信息
        String result=Flower(message,roomID);
        for (WebSocket webSocket:map.get(roomID)) {
            try {
                webSocket.sendMessage(message+result);
            }
            catch (IOException e){
                e.printStackTrace();
            }
        }
        System.out.println("发出的消息:"+message+result);
    }

    private void sendMessage(String message) throws IOException{
        this.session.getBasicRemote().sendText(message);
    }
    private void addOnlineCount(){
        OnlineCount++;
    }
    private void subOnlineCount(){
        OnlineCount--;
    }
    private int getOnlineCount(){
        return OnlineCount;
    }

    public void addMap(@PathParam("roomID") int roomID,@PathParam("userID") String userID) {
        if(WebSocket.map.get(roomID)==null) {
            roomAdmin.put(roomID,userID);//创建房间的用户为房主
            this.roomID=roomID;
            System.out.println(" 第一次进入房间 "+roomID);
            CopyOnWriteArraySet<WebSocket> current = new CopyOnWriteArraySet<WebSocket>();
            current.add(this);
            WebSocket.map.put(roomID, current);
        }
        else {
            System.out.print(" 非第一次次进入房间 "+roomID);
            WebSocket.map.get(roomID).add(this);
            System.out.println(" 房间目前在线人数 "+WebSocket.map.get(roomID).size());
        }
    }

    private void removeMap(@PathParam("roomID") int roomID) {
        System.out.print(" 离开房间 "+roomID);
        WebSocket.map.get(roomID).remove(this);
        if(WebSocket.map.get(roomID).size()==0) {//空的房间清除房间
            WebSocket.map.remove(roomID);
            WebSocket.roomAdmin.remove(roomID);
            WebSocket.setAnswer(roomID,null);
        }
        subOnlineCount();
        //System.out.println(" 房间目前在线人数 "+WebSocket.map.get(roomID).size());
    }

    public static void setAnswer(@PathParam("roomID") int roomID,String answer) {//设置房间答案
        Answer.put(roomID,answer);
    }

    public static String getAnswer(@PathParam("roomID") int roomID) {//获得房间答案
        return Answer.get(roomID);
    }

    public static Integer getAgain(String userID) {
        return Again.get(userID);
    }

    public static void setAgain(String userID,int value) {
        Again.put(userID,value);
    }

    public String Flower(String message,@PathParam("roomID") int roomID){
        String result="";
        if (message.split(":")[0].equals("guess")){
            String user=getUser(message);
            changeAgain(user);
            if(getAgain(user)<=0)
                result=":Again";
            else {
                if (message.split(">>")[1].equals(getAnswer(roomID))) {//判断是否回答正确
                    System.out.println(message.split(":")[1].split(">>")[0] + " accepted");
                    System.out.println("Flower +3");
                    MySql mySql=new MySql();
                    mySql.updataSql(message.split(":")[1].split(">>")[0]);
                    result = ":Flower";
                    setAgain(user,0);
                } else {
                    result = ":Wrong";
                }
            }
        }
        return result;
    }

    public static String getUser(String message){
        return message.split(":")[1].split(">>")[0];
    }

    public static void changeAgain(String user){
        if(getAgain(user)==null) {
            setAgain(user, 3);
            System.out.println(user+" init "+3);
        }
        else{
            setAgain(user,getAgain(user)-1);
            System.out.println(user+" again "+getAgain(user));
        }
    }
}
