
function [Converted_ROI] = ROI_converter(ROI,number_ROIs,iscell)
%ROI number converter from after suite2p classifier to pre-classifier
%input ROI from after-class, total number of ROIs and iscell
%receive the converted (pre-class) ROI number
for ii= 1:number_ROIs
    tmp = sum(iscell(1:ii,1));
    if tmp == ROI
       Converted_ROI = ii;
       break
    end
end