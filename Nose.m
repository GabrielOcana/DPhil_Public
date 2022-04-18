%Nose DLC data analysis pipeline
%Load all .csv file and import all columns except the first, rename the
%file "nose"
nose1x=table2array(nose(:,1));
nose1x=[nose1x;0];
nose1x=reshape(nose1x,45,240);
%%
%Sound Locked?
plot(mean(nose1x,2));
%%
%
[a,ind]=sort(outDat.trialOrder);
sorted_response = nose1x(:,ind);
sorted_mean = mean(sorted_response);
sorted_mean = reshape(sorted_mean,15,16);
figure
for ii=1:size(sorted_mean,2)
    subplot(4,4,ii)
    plot(sorted_mean(:,ii))
end