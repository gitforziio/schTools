function [ p ] = isnil( a )
%ISNIL empty or not exist.
%   judge if an obj have a value which is not empty.

p='something went wrong';

if nargin<1 || isempty(a)
    a=[];
end

l=length(a);

if isempty(a)
    p=true;
elseif iscell(a)
    for i=1:l
        if isempty(a{i})
            p=true;
        end
    end
elseif isstruct(a)
    fns = fieldnames(a);
    for j=1:length(fns)
        field = fns{j};
        value = getfield(a,field);
        if isempty(value)
            p=true;
        end
    end
else
    p=false;
end

disp('done');
end