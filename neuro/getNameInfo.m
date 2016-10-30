function [ info ] = getNameInfo( filepath )
%getNameInfo
%   haha


%--------------------------------------------------------------------------

% clc;

%--------------------------------------------------------------------------

% Log or not
global RobotCanSay;
if isempty(RobotCanSay)
    RobotCanSay=0;
end

% Logger defination
robot = 'nameinfo-Getter';

% make this function able to say
    function say(varargin)
        if RobotCanSay && exist('robotSay','file')
            robotSay(robot,varargin{:});
        else
            fprintf(varargin{:});
            fprintf('\n');
        end
    end

say('%s is ready.',robot);

%--------------------------------------------------------------------------

% nargin test
if nargin<1 || isempty(filepath)
    say('Function datReader(''filepath'') unable to find a filepath.');
    info.error=1;
    info.errormsg='No input.';
    return;
end

[fpath, fname, fext] = fileparts(filepath);
info.filepath=fpath;
info.filename=[fname,fext];

regOfsubid           =  '^(?<v>\d)+-avg';
regOfcode            =  'avg\((?<v>[\d,]+)_';
regOfcondition       =  '_(?<v>[a-zA-Z_]+)\)$';
regOfvalidity        =  'avg\((?<v>[-a-zA-Z]+)_';

structOfsubid        =  regexp(fname, regOfsubid, 'names');
structOfcode         =  regexp(fname, regOfcode, 'names');
structOfcondition    =  regexp(fname, regOfcondition, 'names');
structOfvalidity     =  regexp(fname, regOfvalidity, 'names');

info.subid           =  [structOfsubid(:).v];
info.code            =  [structOfcode(:).v];
info.condition       =  [structOfcondition(:).v];
info.validity        =  [structOfvalidity(:).v];

if ~isempty(info.code) && isempty(info.validity)
    if strcmp(info.code, '10,11')||strcmp(info.code, '17,18')...
            ||strcmp(info.code, '10')||strcmp(info.code, '11')...
            ||strcmp(info.code, '17')||strcmp(info.code, '18')
        info.validity    =  'Valid';
    elseif strcmp(info.code, '12,13')||strcmp(info.code, '15,16')...
            ||strcmp(info.code, '12')||strcmp(info.code, '13')...
            ||strcmp(info.code, '15')||strcmp(info.code, '16')
        info.validity    =  'Invalid';
    elseif strcmp(info.code, '14')||strcmp(info.code, '19')
        info.validity    =  'Cue-only';
    end
end

if strfind(info.condition,'Fast')
    info.FastOrSlow      =  'Fast';
elseif strfind(info.condition,'Slow')
    info.FastOrSlow      =  'Slow';
else
    info.FastOrSlow      =  '';
end

if strfind(info.condition,'Contra')
    info.ContraOrIpsi      =  'Contra';
elseif strfind(info.condition,'Ipsi')
    info.ContraOrIpsi      =  'Ipsi';
else
    info.ContraOrIpsi      =  '';
end


%info.FastOrSlow      =  ;
%info.ContraOrIpsi    =  ;


say('%s''s work finished.',robot);
end

