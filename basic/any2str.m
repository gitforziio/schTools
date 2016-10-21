function [mystr,th] = any2str(foo)
% need ismonster.m


th.oldclass = class(foo);

th.data1    = size(foo);
th.data2    = length(foo);
th.data3    = ismonster(foo);



if isempty(foo)
    mystr='';
elseif ischar(foo)
    mystr=foo;
elseif isnumeric(foo)
    mystr=num2str(foo);
else
    mystr='';
end
