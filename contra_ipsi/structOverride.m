function c = structOverride(a, b)
%structOverride combine struct a & b, while b would override a's old values if they have same fields.
%  Usage: c = structOverride(a, b, tla, tlb)
%   [    a ] : 1st strust.
%   [    b ] : 2nd strust.
%   [    c ] : The combined struct.
%   !!ATTENTION!!: b would override a's old values if they have same fields.

fnsb = fieldnames(b);
lb   = length(fnsb);

for i=1:lb
    fn=fnsb{i};
    v=b.(fn);
    a.(fn)=v;
end

c=a;

end
