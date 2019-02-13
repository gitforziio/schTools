function [err,exc]=datWriter(dat,filepath)
%datWriter ....
%   ....
%
%   dat: the structure of the dat file to read.

exc={};

%% Logger
%--------------------------------------------------------------------------

% Log or not
global RobotCanSay;
if isempty(RobotCanSay)
    RobotCanSay=0;
end

% Logger defination
robot = 'DAT-file-Writer';

% make this function able to say
    function say(varargin)
        if RobotCanSay && exist('robotSay','file')
            robotSay(robot,varargin{:});
        else
            fprintf(varargin{:});
            fprintf('\n');
        end
    end

say(' ');
say('%s is ready.',robot);


%% Open
%--------------------------------------------------------------------------
say('Try openning file...');

try
    [fid,falseMsg]=fopen(filepath,'w');
    if fid==-1
        say('!!!WARNING!!!: [ %s ]',falseMsg);
        err=1;
        return
    end
    say('File now created and opened...');
catch exc
    err=1;
    return
end



%% Writer
%--------------------------------------------------------------------------

% [Subject]
say('Writing [Subject]...');
fprintf(fid,'[Subject]\t\r\n');

fns=fieldnames(dat.subject);

for i=1:length(fns)
    fni=fns{i};
    vi=dat.subject.(fni);
    fprintf(fid,'[%s]\t%s\n',fni,vi);
end

% [Electrode Labels]
say('Writing [Electrode Labels]...');
fprintf(fid,'[Electrode Labels]\t\r\n');

labels=dat.labels;
channels=length(labels);

for i=1:channels
    span=labels{i};
    fprintf(fid,'[%s]\t',span);
end
fprintf(fid,'\n');

% [Electrode XUnits]
say('Writing [Electrode XUnits]...');
fprintf(fid,'[Electrode XUnits]\t\r\n');
for i=1:channels
    fprintf(fid,'[Default]\t');
end
fprintf(fid,'\n');

% [Electrode YUnits]
say('Writing [Electrode YUnits]...');
fprintf(fid,'[Electrode YUnits]\t\r\n');
for i=1:channels
    fprintf(fid,'[Default]\t');
end
fprintf(fid,'\n');

% [Average Data]
say('Writing [Average Data]...');
fprintf(fid,'[Average Data]\t\r\n');

ad=dat.adStruct;
lad=length(ad);
for i=1:lad
    for m=1:channels
        newcell=num2str(ad(i).(labels{m}));
        fprintf(fid,'%s\t',newcell);
    end
    fprintf(fid,'\n');
end


% [Standard Deviation Data]
say('Writing [Standard Deviation Data]...');
fprintf(fid,'[Standard Deviation Data]\t\r\n');

sd=dat.adStruct;
lsd=length(sd);
for i=1:lsd
    for m=1:channels
        newcell=num2str(sd(i).(labels{m}));
        fprintf(fid,'%s\t',newcell);
    end
    fprintf(fid,'\n');
end
fprintf(fid,'\n');


%% Endding
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
    say('File now (should be) closed...[st:%s]',st);
catch exc
    rethrow(exc)
end


% finish
err=0;
say('Done.');
say('%s''s work finished.',robot);
say(' ');

end