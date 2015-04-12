function [ region ] = getRegion( pt, img2D )
% Returns the region, which consists of two parts
% Part One: North, Middle, South
% Part Two: West, Center, East

[yMax, xMax] = size(img2D);
ySeg = yMax/3;
xSeg = xMax/3;
x = pt(1);
y = pt(2);

if x<xSeg && y<ySeg
    region = 'northwest';
elseif x<xSeg*2 && y<ySeg
    region = 'north-center';
elseif y<ySeg
    region = 'northeast';
elseif x<xSeg && y<ySeg*2
    region = 'mid-west';
elseif x<xSeg*2 && y<ySeg*2
    region = 'center';
elseif y<ySeg*2;
    region = 'mid-east';
elseif x<xSeg 
    region = 'southwest';
elseif x<xSeg*2
    region = 'south-center';
else
    region = 'southeast';
end


end

