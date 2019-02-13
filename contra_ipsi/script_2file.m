

[fname1,fpath1,findex1]=uigetfile('*.dat','Select the 1st dat file');
[fname2,fpath2,findex2]=uigetfile('*.dat','Select the 2nd dat file');

dat = datMeaner([fpath1,fname1],[fpath2,fname2]);
defultName=datNamer(dat);

[file,path]=uiputfile(defultName,'Save to');
[err,exc]=datWriter(dat,[path,file]);

