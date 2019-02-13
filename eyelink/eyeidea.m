function eyeidea()
% EyeLink Ideas

%% Ideas
% -------------------------------------------------------------------------
% eyelink data viewer
% data recalibrator
% fix check
% shelter mask
% mouse simulation
% -------------------------------------------------------------------------

%% clear
% -------------------------------------------------------------------------
sca;
clc;


%% Keyboard Settings
% -------------------------------------------------------------------------

KbName('UnifyKeyNames');

key_esc = KbName('escape');
key_shift = KbName('shift');
key_enter = KbName('return');


%% Try...
% -------------------------------------------------------------------------
try

%% Get Subject Info

%% Create File To Record Data

%% Open Window
% -------------------------------------------------------------------------

% settings
AssertOpenGL;
scrnNum = max(Screen('Screens'));

% open window
[wptr,wrect]=Screen('OpenWindow',scrnNum,128,[10 10 810 610]);

% width & height of the window
WidthOfWindow = wrect(3);
HeightOfWindow = wrect(4);

% hide cursor
% HideCursor;

%% Main Exp Part
% -------------------------------------------------------------------------




% -------------------------------------------------------------------------
%% Catch Errors
catch exc
    sca();
    disp(exc);
    rethrow(exc);
end
% -------------------------------------------------------------------------
%% Something
% show cursor
% ShowCursor;
% close all windows
Screen('CloseAll');



end