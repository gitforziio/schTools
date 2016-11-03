function [nx, ny, textbounds] =  drawCenteredTextInRect(wptr,tstring,rect,color)


global RobotCanSay;
if isempty(RobotCanSay)
    RobotCanSay=0;
end

robot = 'TextDrawer';
    function say(varargin)
        if RobotCanSay && exist('robotSay','file')
            robotSay(robot,varargin{:});
        end
    end

say( 'run [%s].',mfilename);

% Set Defult Args
if nargin < 2 || isempty(wptr)
    error('Usage: [nx, ny, textbounds] =  drawCenteredTextInRect(wptr,tstring,rect,color))');
end

if nargin < 3 || isempty(rect)
    [width, height]=Screen('WindowSize', wptr);
    rect = [width, height];
end

if nargin < 4 || isempty(color)
    color = 0;
end

% Check Version and DrawFormattedText
Sver=Screen('Version');
if (Sver.major>3)||((Sver.major==3) && (Sver.minor>0 || Sver.point>=11))
    [nx, ny, textbounds] = DrawFormattedText( wptr,double(tstring),'center','center',color,[],[],[],[],[],rect);
else
    say( '!Warning!: PTB is old version: [%s], so the parameter ''rect'' will not work!',Sver.version);
    [nx, ny, textbounds] = DrawFormattedText( wptr,double(tstring),'center','center',color,[],[],[],[],[]);
end
say( 'Drew Texts: [%s]',tstring);

say( 'Done.');

end