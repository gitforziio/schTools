function [c,o]=iSay(varargin)
% iSay()
% this function does not work

if ~(exist('robotSay.m','file')==2)
    fprintf 'robotSay.m not exist'
end

s=varargin;
l=length(s);

if l==0
    situation='empty';
elseif ischar(s{1})
    situation='saying';
elseif isnumeric(s{1})
    situation='fid';
else
    situation='error';
end

switch situation
    case 'error'
        error('Uncorrect input.');
    case 'empty'
        [c,o]=robotSay(mfilename);
    case 'saying'
        [c,o]=robotSay(mfilename, s{:});
    case 'fid'
        [c,o]=robotSay(s{1}, mfilename, s{2,end});
end
