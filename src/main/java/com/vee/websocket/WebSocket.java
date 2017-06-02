/**
 * Created by Dearvee on 2017/5/31.
 */
package com.vee.websocket;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint("/WebSocket")
public class WebSocket {

    private Session session;//连接会话
    public static int OnlineCount=0;
    private static CopyOnWriteArraySet<WebSocket> webSocketSet = new CopyOnWriteArraySet<WebSocket>();//每个客户端对应的对象，单一客户端通信则用Map

    @OnOpen
    public void onOpen(Session session){
        this.session=session;
        webSocketSet.add(this);
        addOnlineCount();//增加在线人数
        System.out.println("新的加入！"+getOnlineCount());
    }
    @OnClose
    public void onClose(){
        webSocketSet.remove(this);
        subOnlineCount();//减少在线人数
        System.out.println("新的下线！"+getOnlineCount());
    }
    @OnError
    public void onError(Session session,Throwable error){
        System.out.println("出现错误！");
        error.printStackTrace();
    }
    @OnMessage
    public void onMessage(String message,Session session){
        //信息改变，向每一个终端发送信息
        System.out.println("发出的消息:"+message);
        for (WebSocket webSocket:webSocketSet) {
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
