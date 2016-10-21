function tryRun(func,varargin)
% tryRun(@function[, varargins...])
% to run function or script without SyncTest.
%
% by SunCH
% 2016-10-10
% Soochow University

global RobotCanSay;
robot = 'tryRun';
    function say(varargin)
        if RobotCanSay && exist('robotSay','file')
            robotSay(robot,varargin{:});
        end
    end


say('SkipSyncTests...');
Screen('Preference','SkipSyncTests', 1);

say('Now try run...');
try
    if ~isempty(varargin)
        func(varargin{:});
    else
        func();
    end
catch exc
    sca();
    rethrow(exc);
end

say('Mission complete...');

end