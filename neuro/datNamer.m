function datname = datNamer(dat,suffix)

if nargin<1 || isempty(dat)
    error('A dat obj needed!');
end

if nargin<2 || isempty(suffix) || suffix~=0
    suffix=1;
end


if isfield(dat,'info')
    info=dat.info;
elseif isfield(dat,'infoA')
    info=dat.infoA;
elseif isfield(dat,'infoB')
    info=dat.infoB;
else
    datname='noname';
    return
end

datname='';
if isfield(info,'subid')
    if ~isempty(info.subid)
        datname=[datname,info.subid,'-avg'];
    else
        datname=[datname,'avg'];
    end
else
    datname=[datname,'avg'];
end


spans={};
if isfield(info,'validity')
    spans=[spans,info.validity];
end
if isfield(info,'FastOrSlow')
    spans=[spans,info.FastOrSlow];
end
if isfield(info,'ContraOrIpsi')
    spans=[spans,info.ContraOrIpsi];
end

disp(spans);

span='';
for i=1:length(spans)
    if i==1
        span=[span,spans{i}];
    elseif ~isempty(spans{i})
        span=[span,'_',spans{i}];
    end
end

if ~isempty(span)
    datname=[datname,'(',span,')'];
else
    datname=[datname,'(unknownCondition)'];
end

if suffix==1
    datname=[datname,'.dat'];
end

end