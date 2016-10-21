function [mystr] = my2str(foo)
% this function is nuder dev.


if isempty(foo)
    mystr='';
elseif ischar(foo)
    mystr=foo;
elseif isnumeric(foo)
    mystr=num2str(foo);
else
    mystr='';
end


end