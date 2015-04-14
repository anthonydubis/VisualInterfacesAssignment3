function [ corrected ] = correctedLabeled( L )
%CORRECTEDLABELED Summary of this function goes here
%   Detailed explanation goes here

label = 1;
for i=1:255
    if ismember(i,L)
        L(L == i) = label;
        label = label + 1;
    end
end

corrected = L;

end

