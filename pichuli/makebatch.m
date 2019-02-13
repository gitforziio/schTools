function log = makebatch
%MAKETCL Make TCL file.
%   log     : log.

%--------------------------------------------------------------------------

% 设置参数

originpath_defult  = 'E:\ERP';
targetpath_defult  = 'E:\ERP2';
idrange_defult  = '[1:3,5:9,11:16,18:20,22:28,30,32:34,36,39,40,42:44,46:50]';
winstart_defult = '-200';
winend_defult   = '1000';

PPP.fields = {'originpath','targetpath','idrangestr','winstart','winend'};
PPP.defans = {originpath_defult,targetpath_defult,idrange_defult,winstart_defult,winend_defult};
PPP.prompt = {'初始目录','目标目录','被试编号数组','时间窗开始于','时间窗结束于'};

pppinfo = inputdlg(PPP.prompt, '定制批处理-YML专用', 1,PPP.defans);

disp(pppinfo);

if isempty(pppinfo)
    return
end

% 获得参数

originpath     = pppinfo{1};
targetpath     = pppinfo{2};
idrangestr     = pppinfo{3};
winstart       = pppinfo{4};
winend         = pppinfo{5};

idrange        = eval(idrangestr);

log.winstart   = winstart;
log.winend     = winend;
log.originpath = originpath;
log.targetpath = targetpath;
log.idrange    = idrange;

%--------------------------------------------------------------------------

% 选择存放路径

dfttclfilename    = [idrangestr,'_TCL.tcl'];

[tclname,tclpath] = uiputfile(fullfile(originpath,dfttclfilename),'选择保存位置');

log.tclpath       = tclpath;
log.tclname       = tclname;

tclLocation       = fullfile(tclpath,tclname);

try
    [fid,falseMsg]=fopen(tclLocation,'w');
    if fid==-1
        fprintf('[makebatch]: !!!WARNING!!!  [ %s ]\n',falseMsg);
        return
    end
    fprintf(['[makebatch]: _preMerge.dat File now created and opened...','\n']);
catch exc
    log.exc=exc;
    return
end

for i=idrange
    istr = num2str(i);
    if length(istr) == 1
        istr = strcat('0',istr);
    end
    writeTCL(fid,originpath,targetpath,istr,winstart,winend)
end

try
    st = fclose(fid);
    if ~(st==0)
        fprintf(['[makebatch] !!!WARNING!!!: Something went wrong while closing file!','\n']);
        fprintf(['[makebatch]: Try closing all files...','\n']);
        log.error=1;
        log.errormsg='Something wrong while closing file.';
        st = fclose('all');
    end
    fprintf(['[makebatch]: File now (should be) closed...[st=%d]','\n'],st);
catch exc
%     log.exc=exc;
%     return
    rethrow(exc)
end

log.done = 1;

end


function writeTCL(f,op,p,id,winstart,winend)

fprintf(f,['OPENFILE {%s\\%s\\%s-l.cnt}','\r\n'],op,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 3,4,5,6,7,8,13,14,15,16,17,18','\r\n']);
fprintf(f,['EPOCH_EX PORT_INTERNAL \"\" N %s %s N Y Y N N SORT44 {%s\\%s\\%s-e.eeg}','\r\n'],winstart,winend,p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-e.eeg}','\r\n'],p,id,id);
fprintf(f,['BASECOR_EX PRESTIMINTERVAL x x { ALL } {%s\\%s\\%s-b.eeg} ','\r\n'],p,id,id);
fprintf(f,['OPENFILE {%s\\%s\\%s-b.eeg}','\r\n'],p,id,id);
fprintf(f,['ARTREJ_EX REJCRITERIA Y x x Y -80 80 Y Y { ALL } ','\r\n']);
fprintf(f,['SAVEAS {%s\\%s\\%s-ar.eeg}','\r\n'],p,id,id);
fprintf(f,['OPENFILE {%s\\%s\\%s-ar.eeg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s-b.eeg}','\r\n'],id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 3','\r\n']);
fprintf(f,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(f,['SORT44 -CorrectCriteria CORRECT','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(3_201).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(3_201).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(3_201).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 3','\r\n']);
fprintf(f,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(f,['SORT44 -CorrectCriteria INCORRECT','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(3_202).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(3_202).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(3_202).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 3','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(3).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(3).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(3).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 5','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(5).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(5).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(5).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 7','\r\n']);
fprintf(f,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(f,['SORT44 -CorrectCriteria CORRECT','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(7_201).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(7_201).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(7_201).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 7','\r\n']);
fprintf(f,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(f,['SORT44 -CorrectCriteria INCORRECT','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(7_202).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(7_202).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(7_202).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 7','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(7).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(7).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(7).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 4','\r\n']);
fprintf(f,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(f,['SORT44 -CorrectCriteria CORRECT','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(4_201).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(4_201).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(4_201).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 4','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(4).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(4).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(4).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 4','\r\n']);
fprintf(f,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(f,['SORT44 -CorrectCriteria INCORRECT','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(4_202).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(4_202).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(4_202).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 6','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(6).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(6).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(6).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 8','\r\n']);
fprintf(f,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(f,['SORT44 -CorrectCriteria CORRECT','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(8_201).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(8_201).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(8_201).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 8','\r\n']);
fprintf(f,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(f,['SORT44 -CorrectCriteria INCORRECT','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(8_202).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(8_202).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(8_202).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 8','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(8).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(8).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(8).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 13','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(13).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(13).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(13).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 14','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(14).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(14).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(14).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 15','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(15).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(15).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(15).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 16','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(16).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(16).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(16).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 17','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(17).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(17).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(17).avg}','\r\n'],p,id,id);
fprintf(f,['CREATESORT SORT44','\r\n']);
fprintf(f,['SORT44 -TypeEnabled T','\r\n']);
fprintf(f,['SORT44 -TypeCriteria 18','\r\n']);
fprintf(f,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(18).avg}','\r\n'],p,id,id);
fprintf(f,['DELETESORT SORT44','\r\n']);
fprintf(f,['OPENFILE {%s\\%s\\%s-avg(18).avg}','\r\n'],p,id,id);
fprintf(f,['CLOSEFILE {%s\\%s\\%s-avg(18).avg}','\r\n'],p,id,id);

fprintf(f,['CLOSEFILE {%s-l.cnt}','\r\n'],id);
fprintf(f,['CLOSEFILE {%s-e.eeg}','\r\n'],id);
fprintf(f,['CLOSEFILE {%s-ar.eeg}','\r\n'],id);

fprintf(f,'\r\n');

end

