# CanvasGuess
it is a canvas in html5。

# Environment

* Ubuntu16.04/win7

* Tomcat7.0

* jdk1.8

* IDEA

# Instruction

#### Database:

* creat database and table:


		CREATE TABLE canvas.logininfo (
			user varchar(100) NOT NULL,
			password varchar(100) NOT NULL,
			email varchar(100) NOT NULL,
			flower BIGINT DEFAULT 0 NULL
		)
		ENGINE=InnoDB
		DEFAULT CHARSET=utf8
		COLLATE=utf8_general_ci ;


* seting database info:


		driver=com.mysql.jdbc.Driver
		url=jdbc:mysql://localhost/canvas
		user=root
		password=dearvee1996



-----------------------------



# Process

### 初步思路
###### 关于画板的思路，我想应该很大程度上来自于原来做的一个控件流畅拖动效果中，对鼠标事件mouseover,mousedown,mousemove,mouseup,mouseout的剖析.让鼠标在画板上画出线条，无非就是在mousedown的前提下，触发mousemove事件时，用html5画笔画出自mousedown坐标至事件mousemove坐标的线条(以直代曲)，当然后期线条的颜色，也是可以通过input color供选择的。


### 1.碰壁
###### 经过测试初步思路，大的方向是正确的，但，并不是简单的由mousedown向mousemove划线。试验之后，它的效果是这样的：
![image](https://github.com/Dearvee/CanvasGuess/raw/master/explainImag/1.gif)
###### 显然，这已经不是一个画板。


### 2.尝试实时更新begin坐标
###### 尝试在每次mousemove触发时，更新画笔的初始点，而不像初步思路中，初始点始终为mousedown坐标。得到下面的效果：
![image](https://github.com/Dearvee/CanvasGuess/raw/master/explainImag/2.gif)
###### 虽然还不是很友好，但相较上一个版本更像是理想中的画板了。
### 3.修复2中第二笔，开始画时，自动连接第一笔的末端
###### 即：
![image](https://github.com/Dearvee/CanvasGuess/raw/master/explainImag/3.gif)
###### 显然，这是因为在不允许划线的时候仍要更新begin坐标，又是begin坐标搞的鬼。更新之后。即得到粗糙画板，由于展示的图片可能较多，这里就不再展示正确逻辑的gif。

### 4.添加websocket交互后，实现CanvasGuess雏形
具体实现过程见(http://www.dearvee.com)Essay-学习效率这么低?
![image](https://github.com/Dearvee/CanvasGuess/raw/master/explainImag/4.gif)
### 5.servlet实现登录注册，另外通过过滤websocket信息，添加聊天窗口
![image](https://github.com/Dearvee/CanvasGuess/raw/master/explainImag/5.gif)
### 6.从CopyOnWriteArraySet<WebSocket>到HashMap<Integer,CopyOnWriteArraySet<WebSocket>> 
###### 此类型的改变 ，增加了多放房间操作功能，每个房间对应一个CopyOnWriteArraySet<WebSocket>
### 7.兼容Linux,Win部署,添加lib库
###### 判断操作系统，找到数据库配置文件路径。从而兼容Linux.添加lib文件夹，导入链接mysql的jar包，简化部署。
