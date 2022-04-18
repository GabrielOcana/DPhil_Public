function dF=calc_dF(input)

%Johannes 2012

% calculate F/F0
input=input-min(input);

tmp=prctile(input,[10 70],2);


low_tc=tmp(1);
high_tc=tmp(2);

ind=input>low_tc & input<high_tc;


F0=median(input(ind),2);

dF=(input-F0)/F0;