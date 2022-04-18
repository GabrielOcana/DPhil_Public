function [CSI]=CSI(n,Salient_mean_STD,Common_mean_STD,Salient_mean_STD_2,Common_mean_STD_2)
%Calculates "CSI" based on Chen et al.(2005)although paper's formula has a
%typo!
CSI=zeros(n,1);
for ii=1:n
    CSI(ii,1)=((Salient_mean_STD(ii,1) + Salient_mean_STD_2(ii,1))-(Common_mean_STD(ii,1) + Common_mean_STD_2(ii,1)))/((Salient_mean_STD(ii,1) + Salient_mean_STD_2(ii,1))+(Common_mean_STD(ii,1) + Common_mean_STD_2(ii,1)));
end