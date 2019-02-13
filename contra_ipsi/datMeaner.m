function dat = datMeaner(patha,pathb,choice)

%% init
% -------------------------------------------------------------------------

if nargin<2 || isempty(patha) || isempty(pathb)
    error('Uncompleted input!');
end
if nargin<3 || isempty(choice)
    choice='r';
end

if ischar(choice)
    if strcmp(choice(1),'l') || strcmp(choice(1),'L')
        choice='l';
    elseif ~isnan(str2double(choice))
        choice=str2double(choice);
    else
        choice='r';
    end
end

if isfloat(choice)
    if mod(choice,2)
        choice='l';
    else
        choice='r';
    end
end



% -------------------------------------------------------------------------

global RobotCanSay;
RobotCanSay=1;

disp('Function [datPairReader()] start to run.');



data=datReader(patha);
datb=datReader(pathb);

dat=datMean(data,datb,choice);



disp('Function [datPairReader()] end.');
disp('');
disp('');

end
