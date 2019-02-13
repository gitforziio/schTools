function c = structForMean(a, b, choice)
%structForMean combine struct a & b using mean of them.
%  Usage: c = structForMean(a, b [,choice])
%   [      a ] : 1st strust.
%   [      b ] : 2nd strust.
%   [ choice ] : ('l'or`1`)or('r'or`0`). Defult:'r'.
%   [      c ] : The combined struct.

%% init
% -------------------------------------------------------------------------

if nargin<2 || isempty(a) || isempty(b)
    error('Uncompleted input!');
end
if nargin<3 || isempty(choice)
    choice='r';
end

if ischar(choice)
    if strcmp(choice(1),'l') || strcmp(choice(1),'L')
        choice='l';
    elseif ~isnan(str2double(choice))
        choice=str2double(choice);
    else
        choice='r';
    end
end

if isfloat(choice)
    if mod(choice,2)
        choice='l';
    else
        choice='r';
    end
end

%% init vairbles & check
% -------------------------------------------------------------------------

c    = [];
fns  = [];
fnsa = fieldnames(a);
fnsb = fieldnames(b);
l    = length(fnsa);
lb   = length(fnsb);

% check
if l~=lb
    error('Inputted dat `a` and `b` have unequal channels!');
end

if isequal(fnsa,fnsb)
    equalchannels=1;
else
    equalchannels=0;
end

regOfChannel =  '(?<part>[a-zA-Z]+)(?<num>\d+)';


for i=1:l
    cha=regexp(fnsa{i}, regOfChannel, 'names');
    if isfield(cha,'part') && isfield(cha,'num')
        n=str2double(cha.num);
        if mod(n,2)
            drcta='l';
        else
            drcta='r';
        end
        break
    end
end
for i=1:l
    chb=regexp(fnsb{i}, regOfChannel, 'names');
    if isfield(chb,'part') && isfield(chb,'num')
        n=str2double(chb.num);
        if mod(n,2)
            drctb='l';
        else
            drctb='r';
        end
        break
    end
end


if strcmp(choice,drcta)
        fns = fnsa;
        alignb=0;
        aligna=1;
elseif strcmp(choice,drctb)
        fns = fnsb;
        alignb=1;
        aligna=0;
elseif equalchannels
    for i=1:l
        tmp=[fns,getPair(fnsa{i})];
        fns=tmp;
    end
    alignb=1;
    aligna=1;
else
    error('Inputted dat `a` and `b` can not be paired!');
end




%% main
% -------------------------------------------------------------------------

for i=1:lb
    if equalchannels
        fni=fnsa{i};
        v=mean([a.(fni),b.(fni)]);
    else
        if aligna
            fni=fnsa{i};
            v=mean([a.(fni),b.(getPair(fni))]);
        elseif alignb
            fni=fnsb{i};
            v=mean([a.(getPair(fni)),b.(fni)]);
        end
    end
    c.(fns{i})=v;
end


%% end
end
