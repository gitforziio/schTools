function [ content, monster, log ] = ev2read( file )
%EV2READ Read ev2 data.
%   file: ev2 file to read.
%   content: content of ev2 file.
%   monster: struct type output.
%   log: log.

%--------------------------------------------------------------------------

% nargin test
if nargin<1 || isempty(file)
    fprintf(['[ev2read] ERROR: No file.','\n']);
    log.error=1;
    log.errormsg='No file.';
    return;
end

% does file exist?
if exist(file,'file')==2
    [fpath, fname, fext] = fileparts(file);
    log.filepath=fpath;
    log.filename=[fname,fext];
    fprintf(['[ev2read]: Successfully found file [%s]. Fine.','\n'],[fname,fext]);
else
    fprintf(['[ev2read] ERROR: File [%s] not found.','\n'],file);
    log.error=1;
    log.errormsg='File not found.';
    return;
end

% open file
[fid,falseMsg]=fopen(file,'r');
if fid==-1
    fprintf(['[ev2read] ERROR: [%s]','\n'],falseMsg);
    log.error=1;
    log.errormsg=falseMsg;
    return;
end

%--------------------------------------------------------------------------

content = [];
monster = struct([]);

regOfEV2 = '^ *(?<column1>[\d]+) *(?<column2>[\d]+) *(?<column3>[\d]+) *(?<column4>[\d]+) *(?<column5>[\d\.]+) *(?<column6>[\d]+)$';

while true
%for i=1:20
    tline=fgetl(fid);
    if ~ischar(tline)
        break
    else
        lineregexp = regexp(tline, regOfEV2, 'names');
        doublecolumn1 = str2double(strtrim(lineregexp.column1));
        doublecolumn2 = str2double(strtrim(lineregexp.column2));
        doublecolumn3 = str2double(strtrim(lineregexp.column3));
        doublecolumn4 = str2double(strtrim(lineregexp.column4));
        doublecolumn5 = str2double(strtrim(lineregexp.column5));
        doublecolumn6 = str2double(strtrim(lineregexp.column6));
        linedouble = [doublecolumn1,doublecolumn2,doublecolumn3,doublecolumn4,doublecolumn5,doublecolumn6];
        linestruct.id = doublecolumn1;
        linestruct.eventcode = doublecolumn2;
        linestruct.c3 = doublecolumn3;
        linestruct.c4 = doublecolumn4;
        linestruct.c5 = doublecolumn5;
        linestruct.time = doublecolumn6;
        tmp = content;
        content = [tmp;linedouble];
        tmp = monster;
        monster = [tmp,linestruct];
    end
end

%--------------------------------------------------------------------------

% close file
try
    st = fclose(fid);
    if ~(st==0)
        fprintf(['[ev2read] !!!WARNING!!!: Something went wrong while closing file!','\n']);
        fprintf(['[ev2read]: Try closing all files...','\n']);
        log.error=1;
        log.errormsg='Something wrong while closing file.';
        st = fclose('all');
    end
    fprintf(['[ev2read]: File now (should be) closed...[st=%d]','\n'],st);
catch exc
    rethrow(exc)
end

% finish
log.error=0;
fprintf(['[ev2read]: Done.','\n']);
fprintf('\n');

%--------------------------------------------------------------------------

end



