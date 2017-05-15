# canvas
it is a canvas in html5

### 初步思路
###### 关于画板的思路，我想应该很大程度上来自于原来做的一个控件流畅拖动效果中，对鼠标事件mouseover,mousedown,mousemove,mouseup,mouseout的剖析.让鼠标在画板上画出线条，无非就是在mousedown的前提下，触发mousemove事件时，用html5画笔画出自mousedown坐标至事件mousemove坐标的线条，当然后期线条的颜色，也是可以通过input color供选择的。

### 碰壁
###### 经过测试初步思路，大的方向是正确的，但，并不是简单的由mousedown向mousemove划线。试验之后，它的效果是这样的：

###### 显然，这已经不是一个画板。

