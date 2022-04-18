%Analysis of pinna movements. load csv and import all colomns but the first
%Rename file to "pinna"
%%
%Data extraction
pinna=table2array(pinna);
P1(:,1)=repelem(pinna(:,1),2);
P1(:,2)=repelem(pinna(:,2),2);
P2(:,1)=repelem(pinna(:,4),2);
P2(:,2)=repelem(pinna(:,5),2);
P3(:,1)=repelem(pinna(:,7),2);
P3(:,2)=repelem(pinna(:,8),2);
P = [P1,P2,P3];
%%
%Average response per presentation
    Rwind = 45;
    trialresponse = zeros((size(P1,1)/Rwind),2);
    for ii = 1:((size(P1,1)-Rwind)/Rwind)
        for kk = 1:size(P,2)
        trialresponse(ii+1,kk) = mean(P(Rwind*ii:Rwind*(ii+1),kk));
        end
    end
    
    for kk = 1:size(P,2)
    trialresponse(1,kk) = mean(P(1:Rwind,kk)); %Cheap solution to not loose the first presentation
    end 

%%
%Sort the densities by the type of presentation
[a,ind]=sort(outDat.trialOrder);
sorted_response = trialresponse(ind,:);
AlltrialResp=reshape(sorted_response,[15,16,6]);


%%
% Trials... Not worth it these, skip
Coord_1_freq = [AlltrialResp(:,1,1),AlltrialResp(:,1,2)];
trialnumber = [1:15]';
figure
surfc(Coord_1_freq(:,1),Coord_1_freq(:,2),trialnumber);
colormap
plot3(Coord_1_freq(:,1),Coord_1_freq(:,2),trialnumber)
%ALL frequencies 
 trialnumber = [1:15]';
for kk=1:(size(AlltrialResp,3)/2)
 figure
    for ii=1:size(AlltrialResp,2)
        if kk==1
            tmp = [AlltrialResp(:,ii,1),AlltrialResp(:,ii,2)];
        elseif kk==2
            tmp = [AlltrialResp(:,ii,3),AlltrialResp(:,ii,4)];
        elseif kk==2
            tmp = [AlltrialResp(:,ii,5),AlltrialResp(:,ii,6)];
        end
        subplot(4,4,ii);
        plot3(tmp(:,1),tmp(:,2),trialnumber)
        xlabel('Coord1')
        ylabel('Coord2')
        zlabel('Trial Number')
    end
   sgtitle('Movement of Pinna across trial repetition');
end
%ALL together
trialnumber = [1:240]';
figure
for kk=1:(size(AlltrialResp,3)/2)
        if kk==1
            tmp = [trialresponse(:,1),trialresponse(:,2)];
        elseif kk==2
            tmp = [trialresponse(:,3),trialresponse(:,4)];
        elseif kk==2
            tmp = [trialresponse(:,5),trialresponse(:,6)];
        end
        subplot(1,3,kk);
        plot3(tmp(:,1),tmp(:,2),trialnumber)
        xlabel('Coord1')
        ylabel('Coord2')
        zlabel('Trial Number')
        sgtitle('Movement of Pinna across trial repetition');
end 
%%
%Euclidean distance 
%Each Freq
for kk=1:(size(AlltrialResp,3)/2)
 figure
    for ii=1:size(AlltrialResp,2)
        if kk==1
            tmp = [AlltrialResp(:,ii,1),AlltrialResp(:,ii,2)];
            for jj=1:(size(AlltrialResp,1)-1)
            tmp2(jj,1) = sqrt(sum((tmp(jj,1:2) - tmp(jj+1,1:2)) .^ 2));
            end
        elseif kk==2
            tmp = [AlltrialResp(:,ii,3),AlltrialResp(:,ii,4)];
            for jj=1:(size(AlltrialResp,1)-1)
            tmp2(jj,1)= sqrt(sum((tmp(jj,1:2) - tmp(jj+1,1:2)) .^ 2));
            end
        elseif kk==3
            tmp = [AlltrialResp(:,ii,5),AlltrialResp(:,ii,6)];
            for jj=1:(size(AlltrialResp,1)-1)
            tmp2(jj,1)= sqrt(sum((tmp(jj,1:2) - tmp(jj+1,1:2)) .^ 2));
            end
        end
        trialnumber=[1:size(tmp2,1)];
        subplot(4,4,ii);
        plot(trialnumber,tmp2)
        xlabel('Trial Repetition Number')
        ylabel('Euclidean Distance Pinna Movement')
    end
   sgtitle('Distance of Pinna Movement between trials');
end
%All freq
figure
for kk=1:(size(AlltrialResp,3)/2)
        if     kk==1
            tmp = [trialresponse(:,1),trialresponse(:,2)];
            for jj=1:(size(trialresponse,1)-1)
            tmp2(jj,1) = sqrt(sum((tmp(jj,1:2) - tmp(jj+1,1:2)) .^ 2));
            end
        elseif kk==2
            tmp = [trialresponse(:,3),trialresponse(:,4)];
            for jj=1:(size(trialresponse,1)-1)
            tmp2(jj,1)= sqrt(sum((tmp(jj,1:2) - tmp(jj+1,1:2)) .^ 2));
            end
        elseif kk==3
            tmp = [trialresponse(:,5),trialresponse(:,6)];
            for jj=1:(size(trialresponse,1)-1)
            tmp2(jj,1)= sqrt(sum((tmp(jj,1:2) - tmp(jj+1,1:2)) .^ 2));
            end
        end
        trialnumber=[1:size(tmp2,1)];
        subplot(1,3,kk);
        plot(trialnumber,tmp2)
        xlabel('Trial Number')
        ylabel('Euclidean Distance Pinna Movement')
end
   sgtitle('Distance of Pinna Movement between trials');
%%
%Eucclidean distance to the first point
Distances = zeros((size(P,1)-2),3);
for jj=1:(size(P,1))
    tmp = [P(:,1),P(:,2)];     %Change P column value to look at different Pinna markers (1&2, 3&4 or 5&6)
    Distances(jj,1) = sqrt(sum((tmp(jj,1:2) - tmp(1,1:2)) .^ 2));
end
Distance1=reshape(Distances(:,1),45,240);
figure
for ii = 1:45
    Average_Movement(ii,1)=mean(Distance1(ii,:));
end
plot(Average_Movement);
title('240-trials average distance to initial position');
xlabel('Frame number');
ylabel('Eucclidean Distance to initial position');
figure
for ii= 1:size(Distance1,2)
    subplot(16,15,ii)
    plot(Distance1(:,ii))
    hold;
end
sgtitle('Pinna movement in each trial');
%%
%Compare Max movement
figure
Distance_window=Distance1(10,:);
Peaks = max(Distance_window,2);
plot(Peaks);
[a,ind]=sort(outDat.trialOrder);
sorted_response = Peaks(:,ind);
