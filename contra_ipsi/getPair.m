function  [ pname ] = getPair(cname, tla, tlb)
%getPair Get the paired channel name of `cname`.
%  Usage: pname = getPair(cname, tla, tlb)
%   [ cname ] : A channel name.
%   [   tla ] : Suffix of 1st strust when find same field. Defult:'_a'.
%   [   tlb ] : Suffix of 2nd strust when find same field. Defult:'_b'.
%   [ pname ] : The paired name of cname.
%
%  See Also: structCombine

%% init
% -------------------------------------------------------------------------

if nargin<1 || isempty(cname)
    error('Uncompleted input!');
end

if nargin<2 || isempty(tla)
    tla='_a';
end
if nargin<3 || isempty(tlb)
    tlb='_b';
end

pname=cname;

    function ss = op(s)
        ss=s(end:-1:1);
    end


%% if cname has a suffix
% -------------------------------------------------------------------------

tlaop=op(tla);
tlbop=op(tlb);
cnameop=op(cname);

hastla=1;
hastlb=1;

for i=1:length(tla)
    if ~(tlaop(i)==cnameop(i));
        hastla=0;
        break
    end
end

if hastla && length(tla)~=length(cname)
    pnameop=[tlbop,cnameop((length(tla)+1):end)];
    pname=(pnameop);
    return
end

for i=1:length(tlb)
    if ~(tlbop(i)==cnameop(i));
        hastlb=0;
        break
    end
end

if hastlb && length(tlb)~=length(cname)
    pnameop=[tlaop,cnameop((length(tlb)+1):end)];
    pname=(pnameop);
    return
end


%% if cname is a normal channel name ended with number
% -------------------------------------------------------------------------

regOfChannel =  '(?<part>[a-zA-Z]+)(?<num>\d+)';
ch=regexp(cname, regOfChannel, 'names');

if isfield(ch,'part') && isfield(ch,'num')
    n=str2double(ch.num);
    if mod(n,2)
        pname=[ch.part,num2str(n+1)];
        return
    else
        pname=[ch.part,num2str(n-1)];
        return
    end
end




end
