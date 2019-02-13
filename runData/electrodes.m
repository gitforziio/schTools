function [people, log] = electrodes( es )
[people, log] = getwhatweneed_batch( es );

dirpath=log{2}.dirpath;
dirname=log{2}.dirname;

subTable = struct2table(people);

[file,path]=uiputfile(fullfile(dirpath,[dirname,'.csv']),'��������');
if file~=0
    writetable(subTable,fullfile(path,file));
end

% log.subTable = subTable;

end

function [people, log] = getwhatweneed_batch( electrodes )

[subjects, log1] = datfolder2strct;

people=[];
log2={};

for i=1:length(subjects)
    [someone, logi] = getwhatweneed( subjects{i}, electrodes );
    tmplog = log2;
    log2 = [tmplog;logi];
    temp = people;
    people = [temp; someone];
    log.subjects = people;
end

log=[{log};{log1};{log2}];

end

function [someone, log] = getwhatweneed( subject, electrodes )

someone.subid = subject.subid;

arr=[];

for i=1:length(electrodes)
    v = subject.(['p_',upper(electrodes{i})]);
    someone.(['p_',upper(electrodes{i})]) = v;
    temp = arr;
    arr = [temp,v];
end

someone.sta_mean = mean(arr);

log.subject = someone;

end

function [subjects, log] = datfolder2strct

%--------------------------------------------------------------------------

bugtext = '';


% ѡ���š�ĳ���Ե�ɷֵ�ĳһ��ˮƽ��ȫ��dat�ļ������ļ���

dirfullpath=uigetdir;

if isequal(dirfullpath,0)
    log.bugtext = 'canceled';
    return
end

[dirpath, dirname] = fileparts(dirfullpath);
log.dirpath=dirpath;% �ļ������ڵ�·��
log.dirname=dirname;% �ļ��е����֣�Ҳ���ǡ�ˮƽ��������

%fprintf(['[preMean]: Successfully found dir [%s]. Fine. Wait Please...','\n'],dirname);



%% ���ˮƽ�ļ����µ�ȫ��dat�ļ����б�
[datfiles,datN] = FileFromFolder(dirfullpath,[],'dat');
datlist = {datfiles.name};
log.datlist = datlist;
log.datN = datN;

%% ���δ�dat�ļ������д���


subjects = {};


for i=1:datN
    dat = datlist{i};
    
    thisdatinfo = getinfofromfilename( dat );
    
    subject.subid = thisdatinfo.subid;
    
    datpath = fullfile(dirfullpath,dat);
    
    % ---MAIN-BEGAN--------------------------------------------------------
    
    % ÿ��dat�ļ���ʵ��Ӧһ������
    
    % ��������
    a = importdata(datpath);
    da = a.data;
    if i == 1
        datxt = a.textdata;
        erps = datxt(2:end,2);
    end
    for p = 1:length(erps)
        subject.(['p_',erps{p}])=da(p);
    end
    temp = subjects;
    subjects = [temp, subject];
    log.subjects = subjects;
    
    % ---MAIN-END----------------------------------------------------------
end

%%
log.bugtext = bugtext;
end

function info = getinfofromfilename( datname )

regOfDatFileName = '^(?<subid>\d+)\((?<level>[\d_]+)\)_(?<erp>[^\.]+)';

info = regexp(datname, regOfDatFileName, 'names');

end

