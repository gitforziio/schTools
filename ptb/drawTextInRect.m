function [ cedrect ] = drawTextInRect( wptr,tstring,rect,color )
% [ cedrect ] = drawTextInRect( wptr,tstring,rect,color )
%   wptr: the window pointer.
%   tstring: the text string you want to draw.
%   rect: the rect you want the text to fit in.
%   color: the color of the text.
%   cedrect: rect of the centered text.

global RobotCanSay;
robot = 'TextDrawer';
    function say(varargin)
        if RobotCanSay && exist('robotSay','file')
            robotSay(robot,varargin{:});
        end
    end

say( 'run [%s].',mfilename);

% Set Defult Args
if nargin < 2 || isempty(wptr)
    error('Usage: cedrect=drawTextInRect( wptr,tstring,rect,color )');
end

if nargin < 3 || isempty(rect)
    [width, height]=Screen('WindowSize', wptr);
    rect = [width, height];
end

if nargin < 4 || isempty(color)
    color = 0;
end

% Get the rect size of trect
trect=Screen('TextBounds',wptr,tstring,0,0);

% Make trect at the center of the fixed rect
cedrect=CenterRect(trect,rect);

% Draw the text
Screen('DrawText',wptr,tstring,cedrect(1),cedrect(2),color);
say( 'Drew Texts: [%s]',tstring);

say( 'Done.');

end

