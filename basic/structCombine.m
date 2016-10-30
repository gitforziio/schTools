function c = structCombine(a, b)
%structCombine combine struct a & b.
%   ...

aa=a;

% fnsa = fieldnames(a);
% la   = length(fnsa);

fnsb = fieldnames(b);
lb   = length(fnsb);

disp(fnsb);
disp(lb);


for i=1:lb
    fn=fnsb{i};            %disp('[fn]');disp(fn);
    v=getfield(b,fn);      %disp('[ v]');disp(v);
    aa=setfield(aa,fn,v);
end

c=aa;


end
