function AlltrialResp=GetTuningCurves2to57_9Trials(Traces,TotalOrder,repRate,reps,rwind)


                
        AlltrialResp=[];
        
            trials=size(TotalOrder,1);
                        
            tmp=(reshape(Traces,size(Traces,1),repRate,trials));
            
            trialResp=squeeze(mean(tmp(:,rwind,:),2));
            tmp=[];
            
            [a,ind]=sort(TotalOrder);
            tmp=trialResp(:,ind);
            
            if i==1;
                AlltrialResp=reshape(tmp,size(Traces,1),reps,16);
            else
                AlltrialResp=[AlltrialResp reshape(tmp,size(Traces,1),reps,16)];
            end;
            
            
