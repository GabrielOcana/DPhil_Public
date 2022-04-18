function [SI]=SI(n,deviant,standar)
%Calculates the frequency specific index "SI" on an Oddball paradigm for n
%ROIs, index obtained from Duque and Malmierca (2015)
SI=zeros(1,n);
  for i=1:n
      SI(1,i)=(deviant(i,1)-standar(i,1))/(deviant(i,1)+ standar(i,1));
  end
  