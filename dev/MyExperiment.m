function [exptr,settings,d] = MyExperiment(varargin)
%   MyExperiment is a standard framework of psychology experiment program.
%   MyExperiment��һ������ѧʵ�����Ļ�����ܡ�
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

    % ���úͶ���ʵ��
    exptr = defExperiment('testEXP',4,3) ;


    % ����ʵ�����
    settings = expSet()    ;


    d=dd();


end


%--------------------------------------------------------------------------

%% ������������ʵ��
function experiment = defExperiment(expname,bN,tN)

experiment.title                = expname ;
experiment.blockNumber          = bN    ;
experiment.trialNumberPerBlock  = tN    ;

end

%% ��������ʵ���������
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