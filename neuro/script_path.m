



[fpath]=uigetdir;


folderName=fullfile(fpath,'output');


if ~(exist(folderName,'dir')==7)
    mkdir(folderName);
else
    tstr=datestr(now,'_yyyymmddHHMMSS');
    mkdir([folderName,tstr]);
end


defultName='noname.dat';


[file,path]=uiputfile(defultName,'Save to');