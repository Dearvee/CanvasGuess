/**
 * Created by vee on 17-6-16.
 */
var canDraw = false;
var drawColor="#3366CC";
var drawWidth="5";
window.onload=function() {
    initDraw();
}
var coordinate="";//coordinate-坐标

function initDraw() {//初始化画笔
    setDrawStyle();
    setDrawType("free");
}
function draw(x0, y0, x1, y1) {//画直线
    var co=toCanvasCo(x0,y0,x1,y1);
    x0=co[0];y0=co[1];x1=co[2];y1=co[3];
    coordinate=drawColor+"+"+drawWidth+"+("+parseInt(x0)+","+parseInt(y0)+")"+"("+parseInt(x1)+","+parseInt(y1)+")";
    var canvas = document.getElementById("canvas");
    var ctx = canvas.getContext("2d");
    ctx.lineWidth = drawWidth;
    ctx.strokeStyle = drawColor;
    ctx.lineCap = "round";
    ctx.beginPath();
    ctx.moveTo(x0, y0);
    ctx.lineTo(x1, y1);
    ctx.stroke();
    ctx.closePath();
}

function setDrawStyle() {
    var dColor = document.getElementById('drawColor');//画笔颜色
    dColor.oninput = function () {
        drawColor = dColor.value;
    }

    var dView = document.getElementById('viewDWidth');//宽度显示
    var dWidth = document.getElementById('drawWidth');//画笔宽度
    dWidth.oninput = function () {
        drawWidth = dWidth.value;
        dView.innerText = dWidth.value;
    }
}
function setDrawType(type) {
    var canvas = document.getElementById("canvas");
    if (type === "free") {//freeDraw
        $("#canvas").bind("mousedown", function (ed) {
            var beginX = ed.clientX;
            var beginY = ed.clientY;
            canDraw = true;
            $("#canvas").bind("mousemove", function (em) {
                if (canDraw) {
                    draw(beginX, beginY, em.clientX, em.clientY);
                    beginX = em.clientX;
                    beginY = em.clientY;
                }
                else {
                    beginX = em.clientX;
                    beginY = em.clientY;
                }
            });
        });
        $(document.body).bind("mouseup", function () {
            canDraw = false;
        });
    }
    if (type === "line") {//lineDraw
        var first = true;
        var beginX, beginY, endX, endY;
        $("#canvas").bind("click", function (ec) {
            if (first) {
                beginX = ec.clientX;
                endX = ec.clientX;
                beginY = ec.clientY;

                endY = ec.clientY;
                first = false;
            }
            else {
                endX = ec.clientX;
                endY = ec.clientY;
                first = true;
            }
            draw(beginX, beginY, endX, endY);
        });
    }
}
function selDrawType() {
    var events=event.srcElement.id;
    alert(events);
    $("#canvas").unbind();
    setDrawType(events);
}
function toCanvasCo(x0,y0,x1,y1) {//相对画板坐标
    var x=document.getElementById("canvas").offsetLeft-7;
    var y=document.getElementById("canvas").offsetTop-7;
    return [x0-x, y0-y, x1-x, y1-y];
}