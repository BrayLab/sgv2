function [newMask] = mergemasks(mask1,mask2, mask3)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

newMask = mask1;                %# Start with mask1
index = (mask2 ~= 0);           %# Logical index: ones where mask2 is nonzero
newMask(index) = mask2(index);  %# Overwrite with nonzero values of mask2
index = (mask3 ~= 0);           %# Logical index: ones where mask3 is nonzero
newMask(index) = mask3(index);  %# Overwrite with nonzero values of mask3

end

