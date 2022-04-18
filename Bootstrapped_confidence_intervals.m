



clear boot_ci_BF
for i=1:length(selected)
    two_first_two_last=@(x)mean(x(1:2))-mean(x(14:15));
    
    ci=bootci(10000,{two_first_two_last,BFtrialResp(i,:)},'type','per');
    
    if (mean(BFtrialResp(i,1:2))-mean(BFtrialResp(i,14:15))) < ci(1)
        boot_ci_BF(i)=-1;
    elseif (mean(BFtrialResp(i,1:2))-mean(BFtrialResp(i,14:15))) > ci(2)
        boot_ci_BF(i)=1;
    end   
end





