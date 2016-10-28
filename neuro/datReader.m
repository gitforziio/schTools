function [ dat ] = datReader( filepath )
%DATREADER A function to read .dat file from neuroscan avg.
%   filepath: The path of dat file to read.
%
%   dat: the structure of the dat file.


%--------------------------------------------------------------------------

clc;

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
else
    say('File [%s] not found.',filepath);
    dat.error=1;
    dat.errormsg='File not found.';
    return;
end

% open file
[fid,falseMsg]=fopen(filepath,'r');
if fid==-1
    say('Something wrong:%s',falseMsg);
    dat.error=1;
    dat.errormsg=falseMsg;
    return;
end

%--------------------------------------------------------------------------

% start to read
say('Start to read DAT file [%s]...',filepath);
while true
    tline=fgetl(fid);
    if ~ischar(tline)
        break
    else
        processline(tline)
    end
end





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
    say('File now (should be) closed...');
catch exc
    rethrow(exc)
end


% finish
dat.error=0;
say('Done.');

end



function processline(line)
disp(line);
end
