function c = structCombine(a, b, tla, tlb)
%structCombine combine struct a & b.
%  Usage: c = structCombine(a, b, tla, tlb)
%   [    a ] : 1st strust.
%   [    b ] : 2nd strust.
%   [  tla ] : Suffix of 1st strust when find same field. Defult:'_a'.
%   [  tlb ] : Suffix of 2nd strust when find same field. Defult:'_b'.
%   [    c ] : The combined struct.

if nargin<2 || isempty(a) || isempty(b)
    error('Uncompleted input!');
end

if nargin<3 || isempty(tla)
    tla='_a';
end
if nargin<4 || isempty(tlb)
    tlb='_b';
end

aa=a;
fnsb = fieldnames(b);
lb   = length(fnsb);

for i=1:lb
    fn=fnsb{i};
    if ~isfield(aa,fn)
        aa.(fn)=b.(fn);
    else
        fna=[fn,tla];
        fnb=[fn,tlb];
        va=a.(fn);
        vb=b.(fn);
        aa.(fna)=va;
        aa.(fnb)=vb;
        aa=rmfield(aa,fn);
    end
end

c=aa;


end
