function [st,n] = ismonster(foo)
n=length(size(foo));
if n==2
    st=0;
elseif n<2
    st=1;
else
    st=2;
end
