/**
 * Created by vee on 17-6-16.
 */
var drawColor="#fff";
var drawWidth="10";

function draw(x0, y0, x1, y1) {//画直线
    var co=toCanvasCo(x0,y0,x1,y1);
    x0=co[0];y0=co[1];x1=co[2];y1=co[3];
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

function drawInfo(info) {
    var strokes=info.split("*");//每一笔
    for(var i=0;i<strokes.length;i++){
        var operate=strokes[i].split("+");//每一笔的属性,包括color，width，coordinate
        drawColor=operate[0].substring(5);
        drawWidth=operate[1];
        var co=coToArray(operate[2]);
        draw(co[0],co[1],co[2],co[3]);
    }
}
function coToArray(coordinate) {
    var coors=coordinate.match(/\(\d+,\d+\)/g);
    var co0,co1;
    co0=[coors[0].split(",")[0].substr(1),
        coors[0].split(",")[1].
        substr(0,coors[0].split(",")[1].length-1)];
    co1=[coors[1].split(",")[0].substr(1),
        coors[1].split(",")[1].
        substr(0,coors[1].split(",")[1].length-1)];
    return [co0[0],co0[1],co1[0],co1[1]];
}
function toCanvasCo(x0,y0,x1,y1) {//相对画板坐标
    var x=document.getElementById("canvas").offsetLeft-7;
    var y=document.getElementById("canvas").offsetTop-7;
    return [x0-x, y0-y, x1-x, y1-y];
}