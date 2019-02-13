function [ dat ] = datReader( filepath )
%DATREADER A function to read .dat file from neuroscan avg.
%   filepath: The path of dat file to read.
%
%   dat: the structure of the dat file.


%--------------------------------------------------------------------------

% clc;

%--------------------------------------------------------------------------

% Log or not
global RobotCanSay;
if isempty(RobotCanSay)
    RobotCanSay=0;
end

% Logger defination
robot = 'DAT-file-Reader';

% make this function able to say
    function say(varargin)
        if RobotCanSay && exist('robotSay','file')
            robotSay(robot,varargin{:});
        else
            fprintf(varargin{:});
            fprintf('\n');
        end
    end

say(' ');
say('%s is ready.',robot);

%--------------------------------------------------------------------------

% nargin test
if nargin<1 || isempty(filepath)
    say('Function datReader(''filepath'') unable to find a filepath.');
    dat.error=1;
    dat.errormsg='No input.';
    return;
end

% does file exist?
if exist(filepath,'file')==2
    [fpath, fname, fext] = fileparts(filepath);
    dat.filepath=fpath;
    dat.filename=[fname,fext];
    say('Successfully found file [%s]. Fine.',[fname,fext]);
else
    say('File [%s] not found.',filepath);
    dat.error=1;
    dat.errormsg='File not found.';
    return;
end

% open file
[fid,falseMsg]=fopen(filepath,'r');
if fid==-1
    say('Something wrong: [%s]',falseMsg);
    dat.error=1;
    dat.errormsg=falseMsg;
    return;
end

%--------------------------------------------------------------------------

% get name info
if exist('getNameInfo','file')
    dat.info=getNameInfo(filepath);
else
    di.errormsg='Can not get info from file name, because function getNameInfo() is not found.';
    say('%s',di.errormsg);
    dat.info=di;
end

%--------------------------------------------------------------------------

dat.ad=[];
dat.sd=[];
dat.subject=[];
dat.eline=[];

% start to read
say('  Start to read DAT file [%s]...',[fname,fext]);
say('    Reading data, please wait...');



% process line by line
lasttitle='none';

while true
%for i=1:100
    tline=fgetl(fid);
    if ~ischar(tline)
        break
    else
        [mline,eline]=processline(tline,lasttitle);
        
        if strcmp(eline.linetype,'data')&&strcmp(lasttitle,'Average Data')
            dat.ad=vertcat(dat.ad,mline);
        elseif strcmp(eline.linetype,'data')&&strcmp(lasttitle,'Standard Deviation Data')
            dat.sd=vertcat(dat.sd,mline);
        elseif strcmp(eline.linetype,'meta')
            dat.subject.(eline.content.metaname)=eline.content.metavalue;
        elseif strcmp(eline.linetype,'labels')
            dat.labels=eline.content;
        else
            dat.eline=[dat.eline,eline];
        end
        
        if strcmp(eline.linetype,'title')
            lasttitle=eline.content;
            say('    Now reading [%s]...',lasttitle)
        end
    end
end


% conbine data struct
say('  Almost done, combining data...')

rn=size(dat.ad,1);
cn=size(dat.labels,2);

adStruct=[];
sdStruct=[];

for i=1:rn
    adnewline={};
    sdnewline={};
    for j=1:cn
        prelabel=dat.labels{j};
        [~,count]=sscanf(dat.labels{j}(1),'%d');
        if count==1
            newprelabel  = ['channel_',prelabel];
            prelabel     = newprelabel;
        end
        tmp              = [adnewline,{prelabel,dat.ad(i,j)}];
        adnewline        = tmp;
        tmp              = [sdnewline,{prelabel,dat.sd(i,j)}];
        sdnewline        = tmp;
    end
    adnewlinestruct      = struct(adnewline{:});
    tmp                  = [adStruct,adnewlinestruct];
    adStruct             = tmp;
    sdnewlinestruct      = struct(sdnewline{:});
    tmp                  = [sdStruct,sdnewlinestruct];
    sdStruct             = tmp;
end

dat.adStruct=adStruct;
dat.sdStruct=sdStruct;




%--------------------------------------------------------------------------

% close file
try
    st = fclose(fid);
    if ~(st==0)
        say('!!!WARNING!!!: Something went wrong while closing file!');
        say('Try closing all files...');
        dat.error=1;
        dat.errormsg='Something wrong while closing file.';
        st = fclose('all');
    end
    say('File now (should be) closed...[st=%d]',st);
catch exc
    rethrow(exc)
end


% finish
dat.error=0;
say('Done.');
say('%s''s work finished.',robot);
say(' ');

end

%--------------------------------------------------------------------------

function [mline,eline]=processline(line,lasttitle)

% disp(line);

regOfTitle       =  '^\[(?<titlename>[\w\d ]+)\][\t ]*$';
regOfMeta        =  '^\[(?<metaname>[\w\d ]+)\]\t(?<metavalue>[^\t\n\r]+)[\t ]*$';
regOfLabel       =  '\[(?<label>[\w\d ]+)\][\t ]+';
regOfData        =  '(?<data>-*\d+\.*\d+)';

% init
eline.linetype='none';
eline.content=[];
mline=[];


% title
title_cc         =  regexp(line, regOfTitle, 'tokens');

if ~isempty(title_cc)
    eline.linetype      =  'title';
    eline.content       =  title_cc{1}{1};
    mline               =  [];
    return
end


% meta
metas_struct     =  regexp(line, regOfMeta, 'names');

if ~isempty(metas_struct)
    eline.linetype      =  'meta';
    eline.content       =  metas_struct;
    mline               =  [];
    return
end


% labels or units
labels_cc        =  regexp(line, regOfLabel, 'tokens');
% units_cc         =  regexp(line, regOfUnit, 'tokens');

titleEL          =  'Electrode Labels';
titleEX          =  'Electrode XUnits';
titleEY          =  'Electrode YUnits';

if ~isempty(labels_cc)
    if isequal(lasttitle,titleEL)
        eline.linetype      =  'labels';
    elseif isequal(lasttitle,titleEX)
        eline.linetype      =  'xunits';
    elseif isequal(lasttitle,titleEY)
        eline.linetype      =  'yunits';
    else
        eline.linetype      =  'Unknown';
    end
    
    labels_c=repmat({'non'},1,length(labels_cc));
    labels=repmat({'non'},1,length(labels_cc));
    
    for i=1:length(labels_cc)
        labels_c(i)=labels_cc{i}(1);
        labeli=labels_c{i};
        labels{i}=strtrim(labeli);
    end
    
    eline.content       =  labels;
    mline               =  [];
    return
end


%data
datas_cc         =  regexp(line, regOfData, 'tokens');

if ~isempty(datas_cc)
    eline.linetype      =  'data';
    eline.content       =  [];
    
    datas_c=repmat({'non'},1,length(datas_cc));
    datas=zeros(1,length(datas_cc));
    
    for i=1:length(datas_cc)
        datas_c(i)=datas_cc{i}(1);
        datai=datas_c{i};
        datas(i)=str2double(strtrim(datai));
    end
    
    mline               =  datas;
    return
end

end

%--------------------------------------------------------------------------

% [mline,countline,errline,indexline]=sscanf(line,'%f');
% regOfTitle_Subject                 =  '^\[(?<titlename>Subject)\][\t ]*$';
% regOfTitle_ElectrodeLabels         =  '^\[(?<titlename>Electrode Labels)\][\t ]*$';
% regOfTitle_ElectrodeXUnits         =  '^\[(?<titlename>Electrode XUnits)\][\t ]*$';
% regOfTitle_ElectrodeYUnits         =  '^\[(?<titlename>Electrode YUnits)\][\t ]*$';
% regOfTitle_AverageData             =  '^\[(?<titlename>Average Data)\][\t ]*$';
% regOfTitle_StandardDeviationData   =  '^\[(?<titlename>Standard Deviation Data)\][\t ]*$';
% regOfUnit                          =  '\[(?<unit>[\w\d ]+)\][\t ]+';
