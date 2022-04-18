%Load csv table and select pupil left and pupil right data, then import.
%Change file name for "coordinates" and import outDat
%%
%Euclidean Distance for diameter of the pupil
coordinates = table2array(coordinates);
Diameter=zeros(4500,1);
for ii = 1:size(coordinates,1)
    Diameter(ii,1) = sqrt(sum((coordinates(ii,4:5) - coordinates(ii,1:2)) .^ 2));
end
Diameter= repelem(Diameter,2);
Diameter=Diameter(1:9000);
%%
% Sound-locked
figure
Diameter2 = reshape(Diameter,20,450);
plot(mean(Diameter2,2))
figure
for ii=1:size(Diameter2,2)
    subplot(22,22,ii)
    plot(Diameter2(:,ii))
end
%%
%Average response per presentation
    Rwind = 20;
    trialresponse = zeros(450,1);
    for ii= 1:((size(Diameter,1)-Rwind)/Rwind)
        trialresponse(ii+1,1) = mean(Diameter(Rwind*ii:Rwind*(ii+1),1));
    end
    trialresponse(1,1) = mean(Diameter(1:Rwind,1)); %Cheap solution to not loose the first presentation
%%
%Sort the densities by the type of presentation
[a,ind]=sort(outDat.trialOrder);
sorted_response = trialresponse(ind);
AlltrialResp=reshape(sorted_response,[45,10]);
%%
%
figure,
Boolean_Trial10 = (outDat.trialOrder == 10)';
plot(trialresponse);
hold on
for jj=1:size(trialresponse,1)
      tmp = Boolean_Trial10(1,jj);
      if tmp == 1
       scatter(jj,trialresponse(jj,1),'r')
      end
end
figure,
for ii=1:10
subplot(4,4,ii);
plot(AlltrialResp(:,ii));
end
%%
%
mean(AlltrialResp)
Diameter2=Diameter2';
sorted_response_2 = Diameter2(ind,:);
Max_Frame=max(sorted_response_2');
figure
plot(Max_Frame);
Max_Frame_2 =reshape(Max_Frame, 45,10);
mean(Max_Frame_2)