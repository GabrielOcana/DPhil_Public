function [d_SSA] = SSA_index(n,Salient_mean_STD,Common_mean_STD)
%Calculates the SSA index of an oddball paradigm for n ROIs giving 
d_SSA=zeros(n,1);
for ii=1:n
d_SSA(ii,1) = (Salient_mean_STD(ii,1)-Common_mean_STD(ii,1))/sqrt(0.5*(Salient_mean_STD(ii,2)^2+Common_mean_STD(ii,2)^2));
end