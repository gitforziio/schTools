function [result]=datWriter(dat,filepath)
%datWriter ....
%   ....
%
%   dat: the structure of the dat file to read.


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

%--------------------------------------------------------------------------


%--------------------------------------------------------------------------

% [Subject]
say('Writing [Subject]...');
fprintf(fid,'[Subject]\t\r\n');

for i=1:length(fns)
    fni=fns(i);
    vi=getfield(dat,fni);
    fprintf(fid,'[%s]\t%s\n',fni,vi);
end

% [Electrode Labels]
say('Writing [Electrode Labels]...');
fprintf(fid,'[Electrode Labels]\t\r\n');

channels=length(dat.labels);

for i=1:channels
    span=dat.labels{i};
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

fprintf(fid,'testing...\n');


% [Standard Deviation Data]
say('Writing [Standard Deviation Data]...');
fprintf(fid,'[Standard Deviation Data]\t\r\n');

fprintf(fid,'testing...\n');


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
dat.error=0;
say('Done.');
say('%s''s work finished.',robot);
say(' ');

end