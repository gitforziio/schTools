function [ content, monster, log ] = ev2tocsv( file, csvpath )
%EV2READ Read ev2 data.
%   file: ev2 file to read.
%   content: content of ev2 file.
%   monster: struct type output.
%   log: log.

%--------------------------------------------------------------------------

% nargin test
if nargin<1 || isempty(file)
    fprintf(['[ev2tocsv] ERROR: No file.','\n']);
    log.error=1;
    log.errormsg='No file.';
    return;
end

% does file exist?
if exist(file,'file')==2
    [fpath, fname, fext] = fileparts(file);
    log.filepath=fpath;
    log.filename=[fname,fext];
    fprintf(['[ev2tocsv]: Successfully found file [%s]. Fine.','\n'],[fname,fext]);
else
    fprintf(['[ev2tocsv] ERROR: File [%s] not found.','\n'],file);
    log.error=1;
    log.errormsg='File not found.';
    return;
end

if nargin<2 || isempty(csvpath)
    csvpath = fullfile(fpath, [fname, '.csv']);
end

%--------------------------------------------------------------------------

[ content, monster, readlog ] = ev2read(file);
log.readreport=readlog;
csvwrite(csvpath,content);

%--------------------------------------------------------------------------

% finish
log.error=0;
fprintf(['[ev2tocsv]: Done.','\n']);
fprintf('\n');

%--------------------------------------------------------------------------

end