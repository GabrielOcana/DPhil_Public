

% first load an Fall.mat file and the corresponding outDat file into the workspace; outDat file specifies the order in which the stimuli, i.e. the tones were presented 

% this converts the raw fluorescence trace to dF/F
clear dF
for jj=1:size(F,1);
    dF(jj,:)=calc_dF(F(jj,:));
end
        
clear AlltrialResp
   
% this script returns the average response per trial. In the below example
% the arguments specify that the interval between stimuli was 45 frames (i.e. each trial lasted 45 frames),
% that each tone was repeated 15 times overall and that the response window
% lasted from frame 1 to 15 of each trial.

%AlltrialResp=GetTuningCurves2to64_9Trials(dF,TotalOrder,45,135,1:15); %run this line if you want to analyse all putative ROIs

AlltrialResp=GetTuningCurves2to64_9Trials(dF(find(iscell(:,1)),:),TotalOrder,45,135,1:15);
% %run this line if you want to make a preselection based on the Suite2P
% 'iscell' variable


%%

% this code finds the ROIs which show a statistically significant response
% to the tones; finds the Best Frequency (BF) for each ROI, i.e. the tone
% with the strongest response; Normalizes the responses by z-scoring them

clear p
clear BF
clear NormAlltrialResp
for i=1:size(AlltrialResp,1)  
    
    p(i)=anova1(squeeze(AlltrialResp(i,:,:)),[],'off');
  
    [M,I]=max(squeeze(mean(AlltrialResp(i,:,:),2))');
    BF(i)=I;
    
    temp=AlltrialResp(i,:,:);
    NormAlltrialResp(i,:,:)=(AlltrialResp(i,:,:)-mean(temp(:))) ./std(temp(:));
 
end
% here we select the ROIs that pass a particular threshold
selected=find(p<0.001);


%%

% plots the frequency tuning curves of each of the selected ROIs 

figure,
for i=1:length(selected),
    
    hold on
    subtightplot(ceil(sqrt(length(selected))),ceil(sqrt(length(selected))),i)
    errorbar(squeeze(mean(AlltrialResp(selected(i),:,:),2)),squeeze(std(AlltrialResp(selected(i),:,:),[],2))./sqrt(15),'k.-', 'MarkerSize',10)
    axis off
    axis tight
end


% plots the response over time for each of the selected ROIs
figure,

for i=1:length(selected)
    
    subtightplot(ceil(sqrt(length(selected))),ceil(sqrt(length(selected))),i)
    imagesc(squeeze(AlltrialResp(selected(i),:,:)))
    axis off
    
end

%%

% this section plots the average response over at the BF over time for the population of selected ROIs 

clear BFtrialResp
figure

for j=1:length(selected);
    
   subtightplot(ceil(sqrt(length(selected))),ceil(sqrt(length(selected))),j)
   plot(NormAlltrialResp(selected(j),:,BF(selected(j))))
   box off
   axis off
   BFtrialResp(j,:)=NormAlltrialResp(selected(j),:,BF(selected(j)));
  
   
end
   
figure
errorbar(mean(BFtrialResp),std(BFtrialResp)./sqrt(length(selected)))

    title('Mean-BF-Trial-Response')
    
    
%%
%Bootstrapping method to figure out whether the difference in mean response
%strength between the first two stimulus presentations and the last two stimulus 
%presentations is statistically significant. The script essentially works out a 
%confidence interval (using the matlab 'bootci' function) for this difference 
%and then creates a variable that codes the neurons/boutons which significantly decrease 
%their response from the first two to the last two presentations with a '1', 
%those that increase their response with a '-1' and those that do not change 
%significantly with a '0'. 
clear boot_ci_BF
for i=1:length(selected)
    two_first_two_last=@(x)mean(x(1:2))-mean(x(134:135));
    
    ci=bootci(10000,{two_first_two_last,BFtrialResp(i,:)},'type','per');
    
    if (mean(BFtrialResp(i,1:2))-mean(BFtrialResp(i,134:135))) < ci(1)
        boot_ci_BF(i)=-1;
    elseif (mean(BFtrialResp(i,1:2))-mean(BFtrialResp(i,134:135))) > ci(2)
        boot_ci_BF(i)=1;
    else
        boot_ci_BF(i)=0;
    end   
end

%SELECTED CORRESPONDS TO THE "AFTER-CLASSIFYING CRITERIA"... HOW TO TRACK
%THE ROI NUMBER BACK TO SUITE2P!?
%%
% ROI number converter from after-classifier to suite2p
ROIs_after_classification = selected(boot_ci_BF==1);
for ii=1:size(ROIs_after_classification,2)
  ROIs_Suite2p (1,ii) = ROI_converter(ROIs_after_classification(1,ii),size(dF,1),iscell)-1;
end
display(ROIs_Suite2p);
