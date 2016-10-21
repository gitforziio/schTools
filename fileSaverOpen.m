function [ fid,falseMsg ] = fileSaverOpen( fileName, folderName, permission )

global RobotCanSay;
robot = 'FileSaver';
    function say(varargin)
        if RobotCanSay && exist('robotSay','file')
            robotSay(robot,varargin{:});
        end
    end

if nargin<1 || isempty(fileName)
    fileName='tempSave.txt';
end
if nargin<2 || isempty(folderName)
    folderName='data';
end
if nargin<3 || isempty(permission)
    permission='a';
end

say('Creating file...');
say('  - file name:      [ %s ]',fileName);
say('  - save in folder: [ %s ]',folderName);
say('  - permission:     [ %s ]',permission);

if ~(exist(folderName,'dir')==7)
    mkdir(folderName);
end

filePath = fullfile(pwd,folderName,fileName);

try
    [fid,falseMsg]=fopen(filePath,permission);
    if fid==-1
        say('!!!WARNING!!!: [ %s ]',falseMsg);
    end
    say('File now created and opened...');
catch exc
    rethrow(exc)
end

end


