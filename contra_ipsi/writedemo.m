




fns = fieldnames(s);

for i=1:length(fns)
    if fns{i}~=''
        newfield = fns{i};
        newvalue = getfield(s,fns{i});
        fprintf(fid,'[%s]tab%s\n',newfield,newvalue)
    end
end
