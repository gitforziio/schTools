function dat = datPairReader(patha,pathb)

data=datReader(patha);
datb=datReader(pathb);

dat=datCombine(data,datb);

end
