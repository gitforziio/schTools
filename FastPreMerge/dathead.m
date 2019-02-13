function datheadtext = dathead( datmeta )

if nargin<1 || isempty(datmeta)
    datmeta.programmer = 'ChunHui_Sun';
end

if ~isfield(datmeta,'VISCPT')
    datmeta.VISCPT = 'Version 3.00';
end
if ~isfield(datmeta,'id')
    datmeta.id = '-----';
end
if ~isfield(datmeta,'operator')
    datmeta.operator = '-----';
end
if ~isfield(datmeta,'doctor')
    datmeta.doctor = '-----';
end
if ~isfield(datmeta,'referral')
    datmeta.referral = '-----';
end
if ~isfield(datmeta,'institution')
    datmeta.institution = '-----';
end
if ~isfield(datmeta,'subject')
    datmeta.subject = '-----';
end
if ~isfield(datmeta,'name')
    datmeta.name = 'OutMan';
end
if ~isfield(datmeta,'age')
    datmeta.age = '0';
end
if ~isfield(datmeta,'sex')
    datmeta.sex = '0';
end
if ~isfield(datmeta,'hand')
    datmeta.hand = '0';
end
if ~isfield(datmeta,'medications')
    datmeta.medications = '-----';
end
if ~isfield(datmeta,'class')
    datmeta.class = '-----';
end
if ~isfield(datmeta,'state')
    datmeta.state = '-----';
end
if ~isfield(datmeta,'label')
    datmeta.label = '-----';
end
if ~isfield(datmeta,'date')
    datmeta.date = datestr(now,'mm/dd/yy');
end
if ~isfield(datmeta,'time')
    datmeta.time = datestr(now,'HH:MM:SS');
end
if ~isfield(datmeta,'eduction')
    datmeta.eduction = '-----';
end
if ~isfield(datmeta,'occupation')
    datmeta.occupation = '-----';
end
if ~isfield(datmeta,'programmer')
    datmeta.programmer = 'ChunHui_Sun';
end

datheadtext = '';

fns=fieldnames(datmeta);

for i=1:length(fns)
    fni=fns{i};
    sti=datmeta.(fni);
    while length(fni)<12
        tmp=fni;
        fni=[tmp,'.'];
    end
    thislinetext = sprintf('%s= %s\t\t\t\t\n',fni,sti);
    tmp=datheadtext;
    datheadtext = [tmp,thislinetext];
end
tablehead = sprintf('Trial   Resp    Type    Correct     Latency\t\t\t\t\n');
tablesplit = sprintf('-----   ----    ----    -------   -----------\t\t\t\t\n');
datheadtext = [datheadtext,tablehead,tablesplit];

end
