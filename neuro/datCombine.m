function datc = datCombine( data, datb )

disp('Function [datCombine()] is running, Please Wait...');

% data
datc.adStruct     = [];
datc.sdStruct     = [];

for i=1:size(data.adStruct,2)
    
    newadStruct   = structOverride(data.adStruct(i), datb.adStruct(i));
    newsdStruct   = structOverride(data.sdStruct(i), datb.sdStruct(i));
    
    datc.adStruct = [datc.adStruct,newadStruct];
    datc.sdStruct = [datc.sdStruct,newsdStruct];
    
end

% labels
datc.labelsA      = data.labels;
datc.labelsB      = datb.labels;

datc.labels       = fieldnames(datc.adStruct)';

% subject
datc.subjectA     = data.subject;
datc.subjectB     = datb.subject;

datc.subject.Date       = datestr(now,'mm/dd/yyyy');
datc.subject.Time       = datestr(now,'HH:MM:SS');
datc.subject.Channels   = num2str(length(datc.labels));
datc.subject.Rate       = data.subject.Rate;
datc.subject.Type       = data.subject.Type;
datc.subject.Points     = data.subject.Points;
datc.subject.Xmin       = data.subject.Xmin;
datc.subject.Sweeps     = data.subject.Sweeps;
acpta=str2double(data.subject.Accepted);
acptb=str2double(datb.subject.Accepted);
rjcta=str2double(data.subject.Rejected);
rjctb=str2double(datb.subject.Rejected);
datc.subject.Accepted   = num2str(mean([acpta,acptb]));
datc.subject.Rejected   = num2str(mean([rjcta,rjctb]));
datc.subject.Domain     = data.subject.Domain;
datc.subject.Rows       = data.subject.Rows;

% info
datc.infoA        = data.info;
datc.infoB        = datb.info;

% file
datc.fileA        = data.filename;
datc.fileB        = datb.filename;

% done
disp('Function [datCombine()] done.');
end

