function drawStar( windowPtr,n,cx,cy,r1,r2,a,fill,color,other )
% drawStar 绘制星形。
%
%   windowPtr : 窗口指针。 
%   n         : 星形尖角的数量。
%   cx,cy     : 星形中心点的坐标。
%   r1        : 星形的长半径。
%   [r2]      : 星形的短半径。'auto'表示自动计算；'none'表示没有短半径，即正多边形；默认为'auto'。
%   [a]       : 初始旋转角度。弧度计。默认为0。
%   [fill]    : 是否填充。0或1。默认为0。
%   [color]   : 颜色。
%   [other]   : 如果不填充，则表示线条宽度，默认为1；如果填充，则无效（1表示凸，0表示凹，默认为1）。
%

%% defult args
if nargin<6 || isempty(r2)
    r2=[];
end
if nargin<7 || isempty(a)
    a=[];
end
if nargin<8 || isempty(fill)
    fill=0;
end
if nargin<9 || isempty(color)
    color=[];
end
if nargin<10 || isempty(other)
    other=1;
end

%% main
pointList=makeStarPoints( n,cx,cy,r1,r2,a );

if fill==0
    method='FramePoly';
else
    method='FillPoly';
    other=0;
end

Screen(method,windowPtr,color,pointList,other);

end

function [ pointList ] = makeStarPoints( n,cx,cy,r1,r2,a )
%makeStarPoints 生成星形的顶点坐标。
%   n      : 星形的尖角数。
%   cx,cy  : 星形的中点坐标。
%   r1     : 星形的长半径。
%   [r2]   : 星形的短半径，'auto'自动；'none'没有；`length of the shot radius`具体数值。
%   [a]    : 初始的倾斜角度。

%% defult args
if nargin<5 || isempty(r2)
    r2='auto';
end
if nargin<6 || isempty(a)
    a=0;
end
if ischar(r2) && strcmp(r2,'auto')
    x=r1*cos(pi/n);
    if n>4
        computedR2=x-x*tan(pi/n)^2;
        r2=computedR2;
    else
        r2=x;
    end
end
if ischar(r2) && strcmp(r2,'none')
    computedR2=r1*cos(pi/n);
    r2=computedR2;
end

%% main
pointList=zeros(2*n,2);
beginX=cx;
beginY=cy-r1;
[firstX,firstY]=rotatePbyC( beginX,beginY,cx,cy,a,r1 );
pointList(1,1)=firstX;
pointList(1,2)=firstY;
for i=2:2*n
    lastX=pointList((i-1),1);
    lastY=pointList((i-1),2);
    if mod(i,2)
        l=r1;
    else
        l=r2;
    end
    [thisX,thisY]=rotatePbyC( lastX,lastY,cx,cy,(pi/n),l );
    pointList(i,1)=thisX;
    pointList(i,2)=thisY;
end

%%

end

function [ qx,qy,oldlength ] = rotatePbyC( px,py,cx,cy,a,l )
%rotatePbyC 二维平面坐标旋转
%   px,py  : 原始点的坐标。
%   cx,cy  : 旋转中心的坐标。
%   [a]    : 旋转角度，弧度制，默认为0。
%   [l]    : 旋转后的半径，默认为原始长度。

if nargin<5 || isempty(a)
    a=0;
end
ox=px-cx;
oy=py-cy;
b=getARCfromXY( ox,oy );
g=a+b;
oldlength=(ox^2+oy^2)^(1/2);
if nargin<6 || isempty(l)
    l=oldlength;
end
qx=l*cos(g)+cx;
qy=l*sin(g)+cy;

end

function [ arc ] = getARCfromXY( x,y )

basic=atan(y/x);

if x>=0
    arc=basic;
elseif y>=0
    arc=basic+pi;
else
    arc=basic-pi;
end

end

