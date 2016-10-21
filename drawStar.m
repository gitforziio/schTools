function drawStar( windowPtr,n,cx,cy,r1,r2,a,fill,color,other )
% drawStar �������Ρ�
%
%   windowPtr : ����ָ�롣 
%   n         : ���μ�ǵ�������
%   cx,cy     : �������ĵ�����ꡣ
%   r1        : ���εĳ��뾶��
%   [r2]      : ���εĶ̰뾶��'auto'��ʾ�Զ����㣻'none'��ʾû�ж̰뾶����������Σ�Ĭ��Ϊ'auto'��
%   [a]       : ��ʼ��ת�Ƕȡ����ȼơ�Ĭ��Ϊ0��
%   [fill]    : �Ƿ���䡣0��1��Ĭ��Ϊ0��
%   [color]   : ��ɫ��
%   [other]   : �������䣬���ʾ������ȣ�Ĭ��Ϊ1�������䣬����Ч��1��ʾ͹��0��ʾ����Ĭ��Ϊ1����
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
%makeStarPoints �������εĶ������ꡣ
%   n      : ���εļ������
%   cx,cy  : ���ε��е����ꡣ
%   r1     : ���εĳ��뾶��
%   [r2]   : ���εĶ̰뾶��'auto'�Զ���'none'û�У�`length of the shot radius`������ֵ��
%   [a]    : ��ʼ����б�Ƕȡ�

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
%rotatePbyC ��άƽ��������ת
%   px,py  : ԭʼ������ꡣ
%   cx,cy  : ��ת���ĵ����ꡣ
%   [a]    : ��ת�Ƕȣ������ƣ�Ĭ��Ϊ0��
%   [l]    : ��ת��İ뾶��Ĭ��Ϊԭʼ���ȡ�

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

