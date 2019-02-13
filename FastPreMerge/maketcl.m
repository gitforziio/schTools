function log = maketcl
%MAKETCL Make TCL file.
%   log     : log.

%--------------------------------------------------------------------------

pathstr_defult = 'C:\Documents and Settings\labusers\桌面';
id_defult      = '00';
sbname_defult  = 'OutMan';

PPP.fields = {'pathstr','id','sbname'};
PPP.defans = {pathstr_defult,id_defult,sbname_defult};
PPP.prompt = {'文件路径','被试编号','姓名拼音'};
pppinfo = inputdlg(PPP.prompt,'必要信息',1,PPP.defans);

disp(pppinfo);

if isempty(pppinfo)
    return
end

path   = pppinfo{1};
id     = pppinfo{2};
sbname = pppinfo{3};

tclfilename = [id,'_TCL.tcl'];
filepathname = fullfile(path,id,tclfilename);


log.path = path;
log.id = id;
log.sbname = sbname;
log.tclfilename = tclfilename;
log.filepathname = filepathname;

try
    [fid,falseMsg]=fopen(tclfilename,'w');
    if fid==-1
        fprintf('[maketcl]: !!!WARNING!!!  [ %s ]\n',falseMsg);
        return
    end
    fprintf(['[maketcl]: _preMerge.dat File now created and opened...','\n']);
catch exc
    log.exc=exc;
    return
end


fprintf(fid,['OPENFILE {%s\\%s\\%s%s.cnt}','\r\n'],path,id,id,sbname);
fprintf(fid,['MERGEEVT {%s\\%s\\%sMerge.dat}','\r\n'],path,id,id);
fprintf(fid,['FILTER_EX LOWPASS ZEROPHASESHIFT x x 30 24 x x x N FIR { ALL } {%s\\%s\\%s-f.cnt}','\r\n'],path,id,id);
fprintf(fid,['OPENFILE {%s\\%s\\%s-f.cnt}','\r\n'],path,id,id);
fprintf(fid,['LDR {H:\\ERP1data\\ref-M2.ldr} {%s\\%s\\%s-l.cnt}','\r\n'],path,id,id);
fprintf(fid,['OPENFILE {%s\\%s\\%s-l.cnt}','\r\n'],path,id,id);
fprintf(fid,['CREATESORT SORT44','\r\n']);
fprintf(fid,['SORT44 -TypeEnabled T','\r\n']);
fprintf(fid,['SORT44 -TypeCriteria 3,5,7','\r\n']);
fprintf(fid,['EPOCH_EX PORT_INTERNAL "" N -200 800 N Y Y N N SORT44 {%s\\%s\\%s-e.eeg}','\r\n'],path,id,id);
fprintf(fid,['DELETESORT SORT44','\r\n']);


fprintf(fid,['OPENFILE {%s\\%s\\%s-e.eeg}','\r\n'],path,id,id);
fprintf(fid,['BASECOR_EX PRESTIMINTERVAL x x { ALL } {%s\\%s\\%s-b.eeg} ','\r\n'],path,id,id);


fprintf(fid,['OPENFILE {%s\\%s\\%s-b.eeg}','\r\n'],path,id,id);
fprintf(fid,['ARTREJ_EX REJCRITERIA Y x x Y -80 80 Y Y { ALL } ','\r\n']);
fprintf(fid,['SAVEAS {%s\\%s\\%s-ar.eeg}','\r\n'],path,id,id);


fprintf(fid,['OPENFILE {%s\\%s\\%s-ar.eeg}','\r\n'],path,id,id);
fprintf(fid,['CLOSEFILE {%s-b.eeg}','\r\n'],id);

fprintf(fid,['CREATESORT SORT44','\r\n']);
fprintf(fid,['SORT44 -TypeEnabled T','\r\n']);
fprintf(fid,['SORT44 -TypeCriteria 3','\r\n']);
fprintf(fid,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(fid,['SORT44 -CorrectCriteria CORRECT','\r\n']);
fprintf(fid,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(3-201).avg}','\r\n'],path,id,id);
fprintf(fid,['DELETESORT SORT44','\r\n']);


fprintf(fid,['CREATESORT SORT44','\r\n']);
fprintf(fid,['SORT44 -TypeEnabled T','\r\n']);
fprintf(fid,['SORT44 -TypeCriteria 3','\r\n']);
fprintf(fid,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(fid,['SORT44 -CorrectCriteria INCORRECT','\r\n']);
fprintf(fid,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(3-202).avg}','\r\n'],path,id,id);
fprintf(fid,['DELETESORT SORT44','\r\n']);


fprintf(fid,['CREATESORT SORT44','\r\n']);
fprintf(fid,['SORT44 -TypeEnabled T','\r\n']);
fprintf(fid,['SORT44 -TypeCriteria 5','\r\n']);
fprintf(fid,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(fid,['SORT44 -CorrectCriteria CORRECT','\r\n']);
fprintf(fid,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(5-201).avg}','\r\n'],path,id,id);
fprintf(fid,['DELETESORT SORT44','\r\n']);


fprintf(fid,['CREATESORT SORT44','\r\n']);
fprintf(fid,['SORT44 -TypeEnabled T','\r\n']);
fprintf(fid,['SORT44 -TypeCriteria 5','\r\n']);
fprintf(fid,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(fid,['SORT44 -CorrectCriteria INCORRECT','\r\n']);
fprintf(fid,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(5-202).avg}','\r\n'],path,id,id);
fprintf(fid,['DELETESORT SORT44','\r\n']);


fprintf(fid,['CREATESORT SORT44','\r\n']);
fprintf(fid,['SORT44 -TypeEnabled T','\r\n']);
fprintf(fid,['SORT44 -TypeCriteria 7','\r\n']);
fprintf(fid,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(fid,['SORT44 -CorrectCriteria CORRECT','\r\n']);
fprintf(fid,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(7-201).avg}','\r\n'],path,id,id);
fprintf(fid,['DELETESORT SORT44','\r\n']);


fprintf(fid,['CREATESORT SORT44','\r\n']);
fprintf(fid,['SORT44 -TypeEnabled T','\r\n']);
fprintf(fid,['SORT44 -TypeCriteria 7','\r\n']);
fprintf(fid,['SORT44 -CorrectEnabled T','\r\n']);
fprintf(fid,['SORT44 -CorrectCriteria INCORRECT','\r\n']);
fprintf(fid,['AVERAGE_EX TIME Y AMPLITUDE 10 COSINE PRESTIMINTERVALNOISE x x POSTSTIMINTERVALSIGNAL x x SORT44 {%s\\%s\\%s-avg(7-202).avg}','\r\n'],path,id,id);
fprintf(fid,['DELETESORT SORT44','\r\n']);



try
    st = fclose(fid);
    if ~(st==0)
        fprintf(['[maketcl] !!!WARNING!!!: Something went wrong while closing file!','\n']);
        fprintf(['[maketcl]: Try closing all files...','\n']);
        log.error=1;
        log.errormsg='Something wrong while closing file.';
        st = fclose('all');
    end
    fprintf(['[maketcl]: File now (should be) closed...[st=%d]','\n'],st);
catch exc
    rethrow(exc)
end


log.done = 1;

end
