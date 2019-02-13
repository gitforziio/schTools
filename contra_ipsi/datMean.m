function [datc,choice] = datMean( data, datb, choice )
%datMean Compute mean from 2 dats to 1 dat.
%  Usage: datc = datMean( data, datb, choice )
%   [   data ] : 1st dat.
%   [   datb ] : 2nd dat.
%   [ choice ] : ('l'or`1`)or('r'or`0`). Defult:'r'.
%   [   datc ] : output dat.
%
%  See Also: datCombine

%% init
% -------------------------------------------------------------------------

if nargin<2 || isempty(data) || isempty(datb)
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

%% main
% -------------------------------------------------------------------------

disp('Function [datMean()] is running, Please Wait...');

% data
datc.adStruct     = [];
datc.sdStruct     = [];

for i=1:size(data.adStruct,2)
    
    newadStruct   = structForMean(data.adStruct(i), datb.adStruct(i), choice);
    newsdStruct   = structForMean(data.sdStruct(i), datb.sdStruct(i), choice);
    
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

datc.subject.Date            = datestr(now,'mm/dd/yyyy');
datc.subject.Time            = datestr(now,'HH:MM:SS');
datc.subject.Channels        = num2str(length(datc.labels));
datc.subject.Rate            = data.subject.Rate;
datc.subject.Type            = data.subject.Type;
datc.subject.Points          = data.subject.Points;
datc.subject.Xmin            = data.subject.Xmin;
datc.subject.Sweeps          = data.subject.Sweeps;
acpta=str2double(data.subject.Accepted);
acptb=str2double(datb.subject.Accepted);
rjcta=str2double(data.subject.Rejected);
rjctb=str2double(datb.subject.Rejected);
datc.subject.Accepted        = num2str(mean([acpta,acptb]));
datc.subject.Rejected        = num2str(mean([rjcta,rjctb]));
datc.subject.Domain          = data.subject.Domain;
datc.subject.Rows            = data.subject.Rows;

% info
datc.infoA        = data.info;
datc.infoB        = datb.info;

% file
datc.fileA        = data.filename;
datc.fileB        = datb.filename;

% done
disp('Function [datMean()] done.');
end
