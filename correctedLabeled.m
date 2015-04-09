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

% L(L == 9) = 1;
% L(L == 19) = 2;
% L(L == 28) = 3;
% L(L == 38) = 4;
% L(L == 47) = 5;
% L(L == 57) = 6;
% L(L == 66) = 7;
% L(L == 76) = 8;
% L(L == 85) = 9;
% L(L == 94) = 10;
% L(L == 104) = 11;
% L(L == 113) = 12;
% L(L == 123) = 13;
% L(L == 132) = 14;
% L(L == 142) = 15;
% L(L == 151) = 16;
% L(L == 161) = 17;
% L(L == 170) = 18;
% L(L == 179) = 19;
% L(L == 189) = 20;
% L(L == 198) = 21;
% L(L == 208) = 22;
% L(L == 217) = 23;
% L(L == 227) = 24;
% L(L == 236) = 25;
% L(L == 246) = 26;
% L(L == 255) = 27;

corrected = L;

end

