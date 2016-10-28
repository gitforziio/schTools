function [exptr,settings,d] = MyExperiment(varargin)
%   MyExperiment is a standard framework of psychology experiment program.
%   MyExperiment是一个心理学实验程序的基本框架。
%
%   Examples
%     % To build platform dependent paths to files:
%        fullfile(matlabroot,'toolbox','matlab','general','Contents.m')
%
%     % To build platform dependent paths to a folder:
%        fullfile(matlabroot,'toolbox','matlab',filesep)
%
%     % To build a collection of platform dependent paths to files:
%        fullfile(toolboxdir('matlab'),'iofun',{'filesep.m';'fullfile.m'})
%
%
%   See also fullfile, exp.

%   2016-10-06
%   Author: Roomcar.
%   Not Built-in function.


    narginchk(1, Inf);

    % 调用和定义实验
    exptr = defExperiment('testEXP',4,3) ;


    % 调用实验参数
    settings = expSet()    ;


    d=dd();


end


%--------------------------------------------------------------------------

%% 【函数】定义实验
function experiment = defExperiment(expname,bN,tN)

experiment.title                = expname ;
experiment.blockNumber          = bN    ;
experiment.trialNumberPerBlock  = tN    ;

end

%% 【函数】实验参数设置
function settings = expSet()

settings.bgcolor = 128 ;

end



function d=dd()


if ~exist('./data','dir')
    mkdir('./data');
end
d.dirExistData = exist('./data','dir');


if ~exist('./data/edf','dir')
    mkdir('./data/edf');
end
d.dirExistEdf = exist('./data/edf','dir');


if ~exist('./data/trial','dir')
    mkdir('./data/trial');
end
d.dirExistTrial = exist('./data/trial','dir');


if ~exist('./data/img','dir')
    mkdir('./data/img');
end
d.dirExistImg = exist('./data/img','dir');

end