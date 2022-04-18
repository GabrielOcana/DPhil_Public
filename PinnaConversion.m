%Upload outDat and table with densities. Change name table to "PinnaROI".
clear pinna

%%
% Extract mean densities, normalize them by area and duplicate the values
% to match the frame count
    pinna = repelem((table2array(PinnaROI(:,3)))/(mean(table2array(PinnaROI(:,2)))),2);
%%
%Average response per presentation
    Rwind = 45;
    trialresponse = [];
    for ii= 1:((size(pinna,1)-Rwind)/Rwind)
        trialresponse(ii+1,1) = mean(pinna(Rwind*ii:Rwind*(ii+1),1));
    end
    trialresponse(1,1) = mean(pinna(1:Rwind,1)); %Cheap solution to not loose the first presentation
%%
%Sort the densities by the type of presentation
[a,ind]=sort(outDat.trialOrder);
sorted_response = trialresponse(ind);
AlltrialResp=reshape(sorted_response,[15,16]);
figure
%%
%Plot of pinna movements across presentations
for ii=1:size(AlltrialResp,2)
   subplot(4,4,ii);
   plot(AlltrialResp(:,ii));
   hold;
end
sgtitle('Pinna movement accross trials');


%% NA for this script, it's the oppositte to trialresponse(ind)
%for ii= 1:size(trialresponse)
 %   sorted_response (ii,1) = trialresponse (ind()==ii);
%end



            