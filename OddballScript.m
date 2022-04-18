%Load Fall.mat document and OutDat
%Extract Fs corresponding to a specific odball presentation, 1:9000 ||
%9001:18000 || 18001:27000 || 27001: 36 000
Subplot_Size = ceil(sqrt(size(F,1))); % Depending on the number of ROIs
Freal = F(:, 1:9000);
% this converts the raw fluorescence trace to dF/F
clear dF
for jj=1:size(Freal,1)
    dF(jj,:)=calc_dF(Freal(jj,:));
end
%% 
%Only cells classified by Suite2p
%IMPORTANT if the classifing cells were manually modified in Suite2p, you
%have to re-save the matlab docutment, only the stats.npy file gets
%automatically updated!
dF = dF(find(iscell(:,1)),:);
Subplot_Size = ceil(sqrt(size(dF,1))); %Number of selected ROIs
%%
%Average response per presentation
    clear trialresponse
    Rwind = 20;
    trialresponse = [];
    for jj = 1:size(dF,1)
        for ii= 1:((size(dF,2)-Rwind)/Rwind)
            tmp = dF(jj,Rwind*ii:Rwind*(ii+1));
            trialresponse(jj,ii+1) = mean(tmp,2);
        end
        tmp = dF(jj,1:Rwind);
        trialresponse(jj,1) = mean(tmp); %Cheap solution to not loose the first presentation
    end 
 %%
 %Sort by stimulus presentation
%[a,ind]=sort(outDat.trialOrder);
%sorted_response = trialresponse(:,ind);
Boolean_Trial10 = (outDat.trialOrder == 10)';
Salient_Responses =[];
for ii = 1:size(trialresponse,1)
    tmp = trialresponse (ii,:);
    Salient_Responses (ii,:) = tmp(Boolean_Trial10);
end
Boolean_CommonSound = (outDat.trialOrder ~= 10)';
Common_Responses =[];
for ii = 1:size(trialresponse,1)
    tmp = trialresponse (ii,:);
    Common_Responses (ii,:) = tmp(Boolean_CommonSound);
end
%%
%Plot: answer to each type of sound across time
figure,
for ii=1:size(trialresponse,1)
   subplot(Subplot_Size,Subplot_Size,ii);
   plot(Salient_Responses(ii,:));
   hold on;
end
sgtitle('Response to salient sound');
figure,
for ii=1:size(trialresponse,1)
   subplot(Subplot_Size,Subplot_Size,ii);
   plot(Common_Responses(ii,:));
   hold on;
end
sgtitle('Response to common sound');
%%
%Plot Together and highlight oddball
figure,
for ii=1:size(trialresponse,1)
   subplot(Subplot_Size,Subplot_Size,ii);
   plot(trialresponse(ii,:));
   hold on;
   for jj=1:size(trialresponse,2)
      tmp = Boolean_Trial10(1,jj);
      if tmp == 1
       scatter(jj,trialresponse(ii,jj),'r')
      end
   end
end
sgtitle('Response all sounds with salient highlighted');
%%
% Single Plot add specific ROI in the plot and scatter commands
figure,
plot(trialresponse(12,:));
hold on
for jj=1:size(trialresponse,2)
      tmp = Boolean_Trial10(1,jj);
      if tmp == 1
       scatter(jj,trialresponse(12,jj),'r')
      end
   end
%% 
%Linear Regression
%for ii=1:size(trialresponse,1)
   % tmp = mat2dataset(Salient_Responses (1,:));
   % mdl = fitlm(tmp,'linear')
  
%SINGLE I THINK IT'S WRONG BECAUSE SOME SHOULD HAVE NEGATIVE SLOPES AND
%THEY DON'T -.-" TRY WITH POLYVAL and POLYFIT
%trials=[1, 1:(size(trialresponse,2)-1)];
%linear_relation_one = trialresponse(1,:);
%slope_one =linear_relation_one/trials;
%Y_plot = slope_one*trials;
%scatter(trials,trialresponse(1,:));
%hold on
%plot(trials,Y_plot);
%ALL
%figure,
%for ii = 1:size(trialresponse)
%    subplot(Subplot_Size,Subplot_Size,ii);
%    Slope = (trialresponse(ii,:))/trials;
%    scatter(trials,trialresponse(ii,:));
%    hold on
%    plot(trials,Slope*trials);
%    sgtitle('linear regressions');
%end
% Linear regression with POLYFIT
%SALIENT
figure,
tmp = [1,1:(size(Salient_Responses,2)-1)];
slopes_salient = []; %Contains the slope and intercept for the linear regression of each ROI
for ii = 1:size(trialresponse)
    subplot(Subplot_Size,Subplot_Size,ii);
    scatter(tmp,Salient_Responses(ii,:),'b','*');
    P = polyfit(tmp, Salient_Responses(ii,:), 1);
    slopes_salient(ii,1) = P(1);
    slopes_salient(ii,2) = P(2);
    yfit = P(1)*tmp+P(2);
    hold on;
    plot(tmp,yfit,'r');
end
sgtitle('Linear regression of salient response for all ROIs');
%COMMON
figure,
tmp = [1,1:(size(Common_Responses,2)-1)];
slopes_common = []; %Contains the slope and intercept for the linear regression of each ROI
for ii = 1:size(trialresponse)
    subplot(Subplot_Size,Subplot_Size,ii);
    scatter(tmp,Common_Responses(ii,:),'b','*');
    P = polyfit(tmp,Common_Responses(ii,:), 1);
    slopes_common(ii,1) = P(1);
    slopes_common(ii,2) = P(2);
    yfit = P(1)*tmp+P(2);
    hold on;
    plot(tmp,yfit,'r');
end
sgtitle('Linear regression of common response for all ROIs');
mean(slopes_salient)
mean(slopes_common)
%%
%Correlation Coefficients Calculation
trials_salient = [1,1:44];
S = [];
for ii = 1:size(Salient_Responses)
 tmp = corrcoef(Salient_Responses(ii,:),trials_salient);
 S(1,ii)= tmp(1,2);
end
S_mean = mean(S);
S_std = std(S);
trials_common = [1,1:404];
C = [];
for ii = 1:size(Common_Responses)
  tmp = corrcoef(Common_Responses(ii,:),trials_common);
   C(1,ii)= tmp(1,2);
end
C_mean = mean(C);
C_std = std(C);
bar(1,S_mean,'r');
hold
bar(2,C_mean, 'b');
errorbar(1,S_mean, S_std);
errorbar(2,C_mean, C_std);
legend('Salient Sound', 'Common Sound');
title('Average coefficient correlation for salient and common sound');
%% 
%Diference for n firsts presentations vs n lasts presentations
n = 5;
mean_responses_salient =[];
mean_responses_common =[];
for ii= 1:size(Salient_Responses)
    mean_responses_salient(ii,1) = mean(Salient_Responses(ii,1:n),2);
    mean_responses_salient(ii,2) = mean(Salient_Responses(ii,(size(Salient_Responses,2)-n):(size(Salient_Responses,2))),2);
    mean_responses_common(ii,1) = mean(Common_Responses(ii,1:n),2);
    mean_responses_common(ii,2) = mean(Common_Responses(ii,(size(Common_Responses,2)-n):(size(Common_Responses,2))),2);
end
%Piece of code to remove negative values, not sure worth it...
%Remove negative value
%for ii= 1:size(Salient_Responses)
%    if mean_responses_salient(ii,1)<0
%       mean_responses_salient(ii,1) = 0.0001;
%    elseif mean_responses_salient(ii,2)<0
%       mean_responses_salient(ii,2) = 0.0001;
%    end
%end
%Salient sound
Difference_mean_salient = mean_responses_salient(:,1)-mean_responses_salient(:,2);
Fold_mean_salient = mean_responses_salient(:,2)./mean_responses_salient(:,1);
plot(Difference_mean_salient);
plot(Fold_mean_salient);
Proportion_adaptation_salient = (sum(Fold_mean_salient<1&Fold_mean_salient>0))/size(Fold_mean_salient,1);
%Common Sound
Difference_mean_common = mean_responses_common(:,1)-mean_responses_common(:,2);
Fold_mean_common = mean_responses_common(:,2)./mean_responses_common(:,1);
plot(Difference_mean_common);
plot(Fold_mean_common);
Proportion_adaptation_common = (sum(Fold_mean_common<1&Fold_mean_common>0))/size(Fold_mean_common,1); 
%Fold_mean_common (23)=[]; %REMOVED outlier! 
mean_common_fold = mean(Fold_mean_common);
%%
%Oddball indexes: d'SSA Chen et al. (2015) in Journal of Neuroscience
Salient_mean_STD=zeros(size(Salient_Responses,1),2);
for ii=1:size(Salient_Responses,1)
    tmp=Salient_Responses(ii,:);
    Salient_mean_STD(ii,1)=mean(tmp);
    Salient_mean_STD(ii,2)=std(tmp);
end
Common_mean_STD= zeros(size(Common_Responses,1),2);
for ii=1:size(Common_Responses,1)
    tmp=Common_Responses(ii,:);
    Common_mean_STD(ii,1)=mean(tmp);
    Common_mean_STD(ii,2)=std(tmp);
end
SSA=SSA_index(size(Salient_mean_STD,1),Salient_mean_STD,Common_mean_STD);
Proportion_stronger_response_oddball_tone = sum(SSA>0)/size(SSA,1);
%%
%Oddball indexes: CSI
%Load outDat for inverted oddball paradigm and update Freal values
Freal = F(:, 9001:18000);
%Freal = F(:, 27001:36000);
%%
% Repeated CODE
clear dF
for jj=1:size(Freal,1);
    dF(jj,:)=calc_dF(Freal(jj,:));
end
dF = dF(find(iscell(:,1)),:);
Subplot_Size = ceil(sqrt(size(dF,1))); %Number of selected ROIs

    clear trialresponse
    Rwind = 20;
    trialresponse = [];
    for jj = 1:size(dF,1)
        for ii= 1:((size(dF,2)-Rwind)/Rwind)
            tmp = dF(jj,Rwind*ii:Rwind*(ii+1));
            trialresponse(jj,ii+1) = mean(tmp,2);
        end
        tmp = dF(jj,1:Rwind);
        trialresponse(jj,1) = mean(tmp); %Cheap solution to not loose the first presentation
    end 

Boolean_Trial10 = (outDat.trialOrder == 10)';
Salient_Responses =[];
for ii = 1:size(trialresponse,1)
    tmp = trialresponse (ii,:);
    Salient_Responses (ii,:) = tmp(Boolean_Trial10);
end
Boolean_CommonSound = (outDat.trialOrder ~= 10)';
Common_Responses =[];
for ii = 1:size(trialresponse,1)
    tmp = trialresponse (ii,:);
    Common_Responses (ii,:) = tmp(Boolean_CommonSound);
end
%%
%Second SSA
salient_mean_STD_2=zeros(size(Salient_Responses,1),2);
for ii=1:size(Salient_Responses,1)
    tmp=Salient_Responses(ii,:);
    Salient_mean_STD_2(ii,1)=mean(tmp);
    Salient_mean_STD_2(ii,2)=std(tmp);
end
Common_mean_STD_2= zeros(size(Common_Responses,1),2);
for ii=1:size(Common_Responses,1)
    tmp=Common_Responses(ii,:);
    Common_mean_STD_2(ii,1)=mean(tmp);
    Common_mean_STD_2(ii,2)=std(tmp);
end
SSA_2=SSA_index(size(Salient_mean_STD_2,1),Salient_mean_STD_2,Common_mean_STD_2);
Proportion_stronger_response_oddball_tone_2 = sum(SSA_2>0)/size(SSA_2,1); %Proportion of ROIs that have stronger responses to the oddball tone
%%
%Frequency Specific index 2 from Duque and Malmierca (2015)
Si =SI(70,Salient_mean_STD,Common_mean_STD_2);
Proportion_Si = sum(Si>0)/size(Si,2);
Median_Si=median(Si(Si>0));
Average_Si=mean(Si(Si>0));
histogram(Si)
Si_2 =SI(70,Salient_mean_STD_2,Common_mean_STD);
Proportion_Si_2 = sum(Si_2>0)/size(Si_2,2);
Median_Si_2=median(Si_2(Si_2>0));
Average_Si_2=mean(Si_2(Si_2>0))
histogram(Si_2)
%%
%csi
CSi=CSI(size(Salient_mean_STD_2,1),Salient_mean_STD,Common_mean_STD,Salient_mean_STD_2,Common_mean_STD_2);
Median_CSI = median(CSi);
Proportion_CSI = sum(CSi>0)/size(CSi,1);
histogram(CSi)
title('Histogram of the CSI values for the different ROIs');
tmp=strcat('% of ROI with stronger answer for oddball = ',num2str(100*Proportion_CSI));
text(0.12,23,tmp);