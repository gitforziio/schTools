function [people, log] = electrodes( es )
[people, log] = getwhatweneed_batch( es );

dirpath=log{2}.dirpath;
dirname=log{2}.dirname;

subTable = struct2table(people);

[file,path]=uiputfile(fullfile(dirpath,[dirname,'.csv']),'保存数据');
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


% 选择存放【某个脑电成分的某一个水平的全部dat文件】的文件夹

dirfullpath=uigetdir;

if isequal(dirfullpath,0)
    log.bugtext = 'canceled';
    return
end

[dirpath, dirname] = fileparts(dirfullpath);
log.dirpath=dirpath;% 文件夹所在的路径
log.dirname=dirname;% 文件夹的名字，也就是【水平】的名字

%fprintf(['[preMean]: Successfully found dir [%s]. Fine. Wait Please...','\n'],dirname);



%% 获得水平文件夹下的全部dat文件的列表
[datfiles,datN] = FileFromFolder(dirfullpath,[],'dat');
datlist = {datfiles.name};
log.datlist = datlist;
log.datN = datN;

%% 依次打开dat文件并进行处理


subjects = {};


for i=1:datN
    dat = datlist{i};
    
    thisdatinfo = getinfofromfilename( dat );
    
    subject.subid = thisdatinfo.subid;
    
    datpath = fullfile(dirfullpath,dat);
    
    % ---MAIN-BEGAN--------------------------------------------------------
    
    % 每个dat文件其实对应一个被试
    
    % 导入数据
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

