function st = fileSaverClose(fid)

global RobotCanSay;
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
        say('!!!WARNING!!!: Something went wrong when closing file!');
        say('Try closing all files...');
        st = fclose('all');
    end
    say('File now (should be) closed...');
catch exc
    rethrow(exc)
end

end