function  [ pname ] = getPair(cname, tla, tlb)
%structCombine combine struct a & b.
%  Usage: pname = getPair(cname, tla, tlb)
%   [ cname ] : A channel name.
%   [   tla ] : Suffix of 1st strust when find same field. Defult:'_a'.
%   [   tlb ] : Suffix of 2nd strust when find same field. Defult:'_b'.
%   [ pname ] : The paired name of cname.

if nargin<1 || isempty(cname)
    error('Uncompleted input!');
end

if nargin<2 || isempty(tla)
    tla='_a';
end
if nargin<3 || isempty(tlb)
    tlb='_b';
end









end
