function log = preMergeAuto
%PREMERGEAUTO Auto analyze ev2 file to pre-merge.
%   log     : log.

%--------------------------------------------------------------------------

bugtext = '';

outputpath = '';

[filename,filepath,findex]=uigetfile('*.ev2','选择ev2文件');

[fpath, fname, fext] = fileparts(fullfile(filepath,filename));
log.filefilterindex=findex;
log.filepath=fpath;
log.filename=[fname,fext];
log.outputpath=outputpath;

fprintf(['[preMerge]: Successfully found file [%s]. Fine. Wait Please...','\n'],[fname,fext]);

newfilename = fname;

% open file
[fid,falseMsg]=fopen(fullfile(filepath,filename),'r');
if fid==-1
    fprintf(['[preMerge] ERROR: [%s]','\n'],falseMsg);
    log.error=1;
    log.errormsg=falseMsg;
    return;
end

fprintf(['[preMerge]: Now Processing, Wait Please...','\n']);

%--------------------------------------------------------------------------

fprintf(['[preMerge]: Now Processing "rawTable", Wait Please...','\n']);

rawTableCols = {'id','eventcode','col3','col4','col5','time'};
rawTable = table({},{},{},{},{},{},'VariableNames',rawTableCols);

%--------------------------------------------------------------------------

regOfEV2 = '^ *(?<column1>[\d]+) *(?<column2>[\d]+) *(?<column3>[\d]+) *(?<column4>[\d]+) *(?<column5>[\d\.]+) *(?<column6>[\d]+)$';

while true
%for i=1:20
    tline=fgetl(fid);
    if ~ischar(tline)
        break
    else
        lineregexp = regexp(tline, regOfEV2, 'names');
        %d1 = str2double(strtrim(lineregexp.column1));
        d1 = (strtrim(lineregexp.column1));
        d2 = (strtrim(lineregexp.column2));
        d3 = (strtrim(lineregexp.column3));
        d4 = (strtrim(lineregexp.column4));
        d5 = (strtrim(lineregexp.column5));
        d6 = (strtrim(lineregexp.column6));
        linecell = {d1,d2,d3,d4,d5,d6};
        lineTable = cell2table(linecell);
        lineTable.Properties.VariableNames = rawTableCols;
        
        tmp = rawTable;
        rawTable = [tmp;lineTable];
    end
end

log.tables.rawTable = rawTable;
writetable(rawTable,fullfile(outputpath,[newfilename,'_raw.csv']));

%--------------------------------------------------------------------------

fprintf(['[preMerge]: Now Processing "preGroupedTable", Wait Please...','\n']);

preGroupedTableCols = {'id','eventcode','time','type','meaning','group','checkas','ingroup','unusual','need'};
preGroupedTable = table({},{},{},{},{},{},{},{},{},{},'VariableNames',preGroupedTableCols);

%--------------------------------------------------------------------------

typeMap    = containers.Map;
checkMap   = containers.Map;
meaningMap = containers.Map;

checkMax   = 2;
checkOrder = 1:checkMax;

checkMap('stimulate') = 1;
checkMap('response')  = 2;

typeMap('3') = 'stimulate';
typeMap('5') = 'stimulate';
typeMap('7') = 'stimulate';

typeMap('201') = 'response';
typeMap('202') = 'response';

typeMap('199') = 'other';
typeMap('200') = 'other';
typeMap('203') = 'other';


meaningMap('3') = 'low competance face';
meaningMap('5') = 'medium competance face';
meaningMap('7') = 'high competance face';

meaningMap('201') = 'high competance key';
meaningMap('202') = 'low competance key';

meaningMap('199') = 'other';
meaningMap('200') = 'other';
meaningMap('203') = 'other';

%--------------------------------------------------------------------------

gN = 0;
checkN = 1;

rspMissN = 0;
rspOverN = 0;

for i=1:length(rawTable.id(:))
    if ~isKey(typeMap,rawTable.eventcode{i})
        typeMap(rawTable.eventcode{i})='undefined';
    end
    if ~isKey(meaningMap,rawTable.eventcode{i})
        meaningMap(rawTable.eventcode{i})='undefined';
    end
    linetype    = typeMap(rawTable.eventcode{i});
    linemeaning = meaningMap(rawTable.eventcode{i});
    
    nowCheck = checkOrder(checkN);
    
    if ~isKey(checkMap,linetype)
        checkMap(linetype)=0;
    end
    
    linecheck = checkMap(linetype);
    nextbase = linecheck;
    
    if linecheck==1
        gN = gN+1;
    end
    
    linegroup   = gN;
    
    if linecheck==0
        % 不是刺激也不是反应，跳过
        % fprintf(['             第 %d 行: 无用','\n'], i);
        unusual = 0;
        needthis = 0;
        linegroup = 0;
    elseif linecheck==nowCheck && linecheck==1
        % 是正在检查的，是刺激
        unusual = 0;
        needthis = 1;
    elseif linecheck==nowCheck && linecheck~=1
        % 是正在检查的，不是刺激（是反应）
        unusual = 0;
        needthis = 1;
    elseif linecheck~=nowCheck && linecheck==1
        % 不是正在检查的，且是刺激，说明上一组少了一个反应
        % 以后需要给上一组增加一个相应的空反应
        linebugtext = sprintf(['第 %d 行: 上一组少了一个反应  ;','\n'], i);
        fprintf(['             ','%s'], linebugtext);
        tmptext = bugtext;
        bugtext = [tmptext,linebugtext];
        unusual = 0;
        needthis = 1;
        rspMissN = rspMissN+1;
        preGroupedTable.unusual(i-1)={2};
    elseif linecheck~=nowCheck && linecheck~=1
        % 不是正在检查的，且不是该组第一个的刺激
        % 说明是多余的反应
        % 以后需要把这个删掉
        linebugtext = sprintf(['第 %d 行: 这组做了多余的反应  ;','\n'], i);
        fprintf(['             ','%s'], linebugtext);
        tmptext = bugtext;
        bugtext = [tmptext,linebugtext];
        unusual = 1;
        needthis = 0;
        rspOverN = rspOverN+1;
        if linecheck~=checkOrder(end)
            nextbase = nowCheck;
        end
    end
    
    % next checkN
    checkN = nextbase+1;
    if checkN > length(checkOrder)
        checkN = 1;
    end
    
    lineid      = str2double(rawTable.id(i));
    linecode    = rawTable.eventcode(i);
    linetime    = {str2double(rawTable.time{i})};
    linegroup   = num2str(linegroup);
    linecheckas = nowCheck;
    lineingroup = linecheck;
    lineunusual = unusual;
    lineneed    = needthis;
    linecell    = {lineid,linecode,linetime,linetype,linemeaning,linegroup,linecheckas,lineingroup,lineunusual,lineneed};
    lineTable   = cell2table(linecell);
    lineTable.Properties.VariableNames = preGroupedTableCols;
    
    tmp = preGroupedTable;
    preGroupedTable = [tmp;lineTable];
end

log.tables.preGroupedTable = preGroupedTable;
writetable(preGroupedTable,fullfile(outputpath,[newfilename,'_preGrouped.csv']));

fprintf(['','\n']);

zongjitext0 = sprintf(['总计：','\n']);
zongjitext1 = sprintf(['试次数量    == %d  ;','\n'],gN);
zongjitext2 = sprintf(['漏反应数    == %d  ;','\n'],rspMissN);
zongjitext3 = sprintf(['多反应数    == %d  ;','\n'],rspOverN);

fprintf(['[preMerge]: ','%s'],zongjitext0);
fprintf(['                  ','%s'],zongjitext1);
fprintf(['                  ','%s'],zongjitext2);
fprintf(['                  ','%s'],zongjitext3);
fprintf(['','\n']);

tmptext = bugtext;
bugtext = [tmptext,zongjitext0,zongjitext1,zongjitext2,zongjitext3,'\n'];

log.trialN   = gN;
log.rspMissN = rspMissN;
log.rspOverN = rspOverN;


%--------------------------------------------------------------------------

fprintf(['[preMerge]: Now Processing "bhvTable", Wait Please...','\n']);

bhvTableCols = {'groupid','stimu','stimu_time','resp','resp_time','rt'};
bhvTable = table({},{},{},{},{},{},'VariableNames',bhvTableCols);

%--------------------------------------------------------------------------

for i=1:length(preGroupedTable.id(:))
    
    if preGroupedTable.ingroup{i}==1 && preGroupedTable.need{i}
        linegroupid    = preGroupedTable.group{i};
        linestimu      = preGroupedTable.eventcode{i};
        linestimu_time = preGroupedTable.time{i};
    end
    
    if preGroupedTable.ingroup{i}~=1 && preGroupedTable.need{i}
        linegroupid    = preGroupedTable.group{i};
        lineresp       = preGroupedTable.eventcode{i};
        lineresp_time  = preGroupedTable.time{i};
        linert         = lineresp_time-linestimu_time;
    end
    
    if preGroupedTable.unusual{i}==2
        lineresp       = '0';
        lineresp_time  = 0;
        linert         = 0;
    end
    
    if (preGroupedTable.unusual{i}==0 && preGroupedTable.ingroup{i}==checkOrder(end))||(preGroupedTable.unusual{i}==2)
        linecell    = {linegroupid,linestimu,linestimu_time,lineresp,lineresp_time,linert};
        lineTable   = cell2table(linecell);
        lineTable.Properties.VariableNames = bhvTableCols;

        tmp = bhvTable;
        bhvTable = [tmp;lineTable];
    end
end

log.tables.bhvTable = bhvTable;
writetable(bhvTable,fullfile(outputpath,[newfilename,'_bhv.csv']));


%--------------------------------------------------------------------------

fprintf(['[preMerge]: Now Processing "preMergeTable", Wait Please...','\n']);

preMergeTableCols = {'trial','respond','type','correct','latancy'};
preMergeTable = table({},{},{},{},{},'VariableNames',preMergeTableCols);

datheadtext = datheaddefult;

try
    [mgDATfid,falseMsg]=fopen(fullfile(outputpath,[newfilename,'_preMerge.dat']),'w');
    if mgDATfid==-1
        fprintf('!!!WARNING!!!: [ %s ]\n',falseMsg);
        return
    end
    fprintf(['[preMerge]: _preMerge.dat File now created and opened...','\n']);
catch exc
    log.exc=exc;
    return
end
fprintf(mgDATfid,datheadtext);

%--------------------------------------------------------------------------

for i=1:length(preGroupedTable.id(:))
    
    linetrial   = preGroupedTable.id{i};
    linetype    = preGroupedTable.eventcode{i};
    
    if ~isequal(typeMap(linetype),'stimulate')
        linecorrect = -1;
    else
        linegroup   = preGroupedTable.group{i};
        tmpTable    = bhvTable(strcmp(bhvTable.groupid,linegroup),:);
        respcode    = tmpTable.resp{1};
        
        if isequal(respcode,'201')
            linecorrect = 1;
        elseif isequal(respcode,'202')
            linecorrect = 0;
        else
            linecorrect = -1;
        end
        
    end
    
    newlinetext = sprintf(['%d\t1\t%s\t%d\t800','\n'],linetrial,linetype,linecorrect);
    fprintf(mgDATfid,newlinetext);
    
    linecell    = {linetrial,1,linetype,linecorrect,800};
    lineTable   = cell2table(linecell);
    lineTable.Properties.VariableNames = preMergeTableCols;
    
    tmp = preMergeTable;
    preMergeTable = [tmp;lineTable];
end

log.tables.preMergeTable = preMergeTable;
writetable(preMergeTable,fullfile(outputpath,[newfilename,'_preMerge.csv']));


%--------------------------------------------------------------------------





%--------------------------------------------------------------------------

% close file
try
    st = fclose(fid);
    if ~(st==0)
        fprintf(['[preMerge] !!!WARNING!!!: Something went wrong while closing file!','\n']);
        fprintf(['[preMerge]: Try closing all files...','\n']);
        log.error=1;
        log.errormsg='Something wrong while closing file.';
        st = fclose('all');
    end
    fprintf(['[preMerge]: File now (should be) closed...[st=%d]','\n'],st);
catch exc
    rethrow(exc)
end

% finish
log.error=0;
log.bugtext=bugtext;
fprintf(['[preMerge]: Done.','\n']);
fprintf('\n');

%--------------------------------------------------------------------------

end



