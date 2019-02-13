function dat = datPairReader(patha,pathb)

global RobotCanSay;
RobotCanSay=1;

disp('Function [datPairReader()] start to run.');



data=datReader(patha);
datb=datReader(pathb);

dat=datCombine(data,datb);



disp('Function [datPairReader()] end.');
disp('');
disp('');

end
