/**
 * Created by Dearvee on 2017/5/31.
 */
package com.vee.websocket;

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

@ServerEndpoint("/WebSocket/{roomID}")
public class WebSocket {
    private Session session;//连接会话
    public static int OnlineCount=0;
    private static CopyOnWriteArraySet<WebSocket> webSocketSet = new CopyOnWriteArraySet<WebSocket>();//每个客户端对应的对象，单一客户端通信则用Map

    private void addMap(@PathParam("roomID") int roomID) {
        if(WebSocket.map.get(roomID)==null) {
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
            System.out.println(" 房间目前在线人数 "+WebSocket.map.get(roomID).size());
    }

    private static HashMap<Integer,CopyOnWriteArraySet<WebSocket>>  map= new HashMap<Integer, CopyOnWriteArraySet<WebSocket>>();
    @OnOpen
    public void onOpen(@PathParam("roomID") int roomID,Session session){
        this.session=session;
        addMap(roomID);
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
        System.out.println("发出的消息:"+message);
        for (WebSocket webSocket:map.get(roomID)) {
            try {
                webSocket.sendMessage(message);//向每一个终端发送message
            }
            catch (IOException e){
                e.printStackTrace();
            }
        }
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
}
