function datheadtext = datheaddefult

datmeta.VISCPT = 'Version 3.00';
datmeta.id = '-----';
datmeta.operator = '-----';
datmeta.doctor = '-----';
datmeta.referral = '-----';
datmeta.institution = '-----';
datmeta.subject = '-----';
datmeta.age = '0';
datmeta.sex = '0';
datmeta.hand = '0';
datmeta.medications = '-----';
datmeta.class = '-----';
datmeta.state = '-----';
datmeta.label = '-----';
datmeta.date = '08/24/93';
datmeta.time = '17:00:54';
datmeta.eduction = '-----';
datmeta.occupation = '-----';

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
