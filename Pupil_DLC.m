%Load csv table and select pupil left and pupil right data, then import.
%Change file name for "coordinates" and import outDat
%%
%Euclidean Distance for diameter of the pupil
coordinates = table2array(coordinates);
Diameter=zeros(5400,1);
for ii = 1:size(coordinates,1)
    Diameter(ii,1) = sqrt(sum((coordinates(ii,4:5) - coordinates(ii,1:2)) .^ 2));
end
Diameter= repelem(Diameter,2);

%%
%Response sound locked
Diameter2 = reshape(Diameter,45,240);
plot(mean(Diameter2,2))
for ii=1:240
    subplot(16,16,ii)
    plot(Diameter2(:,ii))
end
%%
%Average response per presentation
    Rwind = 45;
    trialresponse = zeros(120,1);
    for ii= 1:((size(Diameter,1)-Rwind)/Rwind)
        trialresponse(ii+1,1) = mean(Diameter(Rwind*ii:Rwind*(ii+1),1));
    end
    trialresponse(1,1) = mean(Diameter(1:Rwind,1)); %Cheap solution to not loose the first presentation
%%
%Sort the densities by the type of presentation
[a,ind]=sort(outDat.trialOrder);
sorted_response = trialresponse(ind);
AlltrialResp=reshape(sorted_response,[15,16]);
%%
%Plot of pupil diameter across presentations
figure
for ii=1:size(AlltrialResp,2)
   subplot(4,4,ii);
   plot(AlltrialResp(:,ii));
   hold;
end
sgtitle('Pupil Diametre accross repetitions');
%%
%Plot diametre across trials (unsorted)
figure
time=[1,1:239];
plot(time, trialresponse);
xlabel('Trial Number');
ylabel('Pupil Diameter');
title('Pupil Diameter acrooss time');
%%
%Plot diametre across trials (unsorted)
figure
time=[1,1:239];
plot(time, sorted_response);
xlabel('Trial Number');
ylabel('Pupil Diameter');
title('Pupil Diameter acrooss time');
%%
%Linear Regressions
%For each Frequency
figure,
tmp = [1,2:(size(AlltrialResp,1))];
slopes = zeros(16,1); %Contains the slope and intercept for the linear regression of each ROI
for ii = 1:size(AlltrialResp,2)
    subplot(4,4,ii);
    scatter(tmp,AlltrialResp(:,ii),'b','*');
    P = polyfit(tmp, AlltrialResp(:,ii), 1);
    slopes(ii,1) = P(1);
    slopes(ii,2) = P(2);
    yfit = P(1)*tmp+P(2);
    hold on;
    plot(tmp,yfit,'r');
    texto = append('Slope = ',num2str(P(1)));
    text(10.5,275,texto);
    %ylim([100,300]);
end
sgtitle('Linear regression of Pupil Diametre accross repetitions for each frequency');
%Global
figure,
tmp = [1,2:(size(trialresponse,1))];
scatter(tmp,trialresponse(:,1),'b','*');
P = polyfit(tmp, trialresponse(:,1), 1);
yfit = P(1)*tmp+P(2);
hold on;
plot(tmp,yfit,'r');
texto = append('Slope = ',num2str(P(1)));
text(180,325,texto);
ylim([100,350]);
sgtitle('Linear regression of Pupil Diametre accross time');
ylabel('Pupil Diameter');
xlabel('Trial number');
%%
%Significance of the diferent between first and last presentations
%By frequency
sorted_response_reshaped = reshape(sorted_response,[15,16]);
clear boot_ci_BF
boot_ci_BF = zeros(1,16);
for i=1:size(sorted_response_reshaped,2)
    two_first_two_last=@(x)mean(x(1:2))-mean(x(14:15));
    
    ci=bootci(10000,{two_first_two_last,sorted_response_reshaped(:,i)},'type','per');
    
    if (mean(sorted_response_reshaped(1:2,i))-mean(sorted_response_reshaped(14:15,i))) < ci(1)
        boot_ci_BF(i)=-1;
    elseif (mean(sorted_response_reshaped(1:2,i))-mean(sorted_response_reshaped(14:15,i))) > ci(2)
        boot_ci_BF(i)=1;
    else
        boot_ci_BF(i)=0;
    end
end
Number_of_frequencies_significant_pupil_adaptation = sum(boot_ci_BF);%Only works if there are no inceases (-1), double check!
%All trials 
trialresponse_reshaped = reshape(trialresponse,[15,16]);
two_first_two_last=@(x)mean(x(1:2))-mean(x(14:15));
ci=bootci(10000,{two_first_two_last,trialresponse_reshaped(:,1)},'type','per');
if (mean(trialresponse_reshaped(1:2,1))-mean(trialresponse_reshaped(14:15,1))) < ci(1)
  disp('-1');
elseif (mean(trialresponse_reshaped(1:2,1))-mean(trialresponse_reshaped(14:15,1))) > ci(2)
  disp('1');
else
   disp('0');
end

