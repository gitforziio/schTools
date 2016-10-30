function c = structOverride(a, b)
%structOverride combine struct a & b.
%   b would override a's old values if they have same fields.

% fnsa = fieldnames(a);
% la   = length(fnsa);

fnsb = fieldnames(b);
lb   = length(fnsb);

% disp(fnsb);
% disp(lb);


for i=1:lb
    fn=fnsb{i};            % disp('[fn]');disp(fn);
    v=getfield(b,fn);      % disp('[ v]');disp(v);
    a=setfield(a,fn,v);
end

c=a;


end
