function st = fileSaverClose(fid)

global RobotCanSay;
if isempty(RobotCanSay)
    RobotCanSay=0;
end

robot = 'FileSaver';
    function say(varargin)
        if RobotCanSay && exist('robotSay','file')
            robotSay(robot,varargin{:});
        end
    end

if nargin<1 || isempty(fid) || fid<3
    fid='all';
end

try
    st = fclose(fid);
    if ~(st==0)
        say('!!!WARNING!!!: Something went wrong while closing file!');
        say('Try closing all files...');
        st = fclose('all');
    end
    say('File now (should be) closed...[st:%s]',st);
catch exc
    rethrow(exc)
end

end