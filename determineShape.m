function [ shape ] = determineShape( b, labeled )
% Determine the shape of the building
% b is a Building object

box = b.boundingBox;
buildingArea = b.area;
boundingArea = getBoxArea(box);

if b.numLargeCircles > 0
    shape = 'contains a large curved room';
elseif b.numMediumCircles > 0
    shape = 'contains a medium sized curved room';
elseif dividesCampus(b, labeled)
    shape = 'divides campus';
elseif buildingArea == boundingArea
    if isSquare(b.boundingBox)
        shape = 'square in shape';
    else
        shape = 'rectangle in shape';
    end
elseif isIShaped(b)
    shape = 'I-shaped';
elseif hasHole(b)
    shape = 'irregular in shape with a hole';
elseif buildingArea / boundingArea >= .85
    shape = 'close to a rectangle in shape';
elseif isLShaped(b)
    shape = 'L-shaped';
elseif isCShaped(b)
    shape = 'C-shaped';
elseif isCrossShaped(b)
    shape = 'cross shaped';
else
    shape = 'irregular in shape';
end
end



%% Helper functions

% Gets the area of the bounding box
function area = getBoxArea(p)
area = (p(3) * p(4));
end

function doesDivide = dividesCampus(b, labeled)
doesDivide = false;
img = b.image;
if (size(img,1) == size(labeled,1)) || (size(img,2) == size(labeled,2))
    doesDivide = true;
end
end

% Determines if the bounding box is a square
function isSqr = isSquare(p)
isSqr = p(3) == p(4);
end

function isI = isIShaped(b) 
isI = false;
img = b.image;
x_sz = size(img,2);
y_org = round(size(img,1) / 2);

if fillsCorners(b)
    if ~(img(y_org, 1)) && ~(img(y_org, x_sz))
        isI = true;
    end
end
end

function fills = fillsCorners(b) 
fills = false;
img = b.image;
x_sz = size(img, 2);
y_sz = size(img, 1);
if img(1,1) && img(1,x_sz) && img(y_sz,1) && img(y_sz,x_sz)
    fills = true;
end
end

function hole = hasHole(b)
hole = false;
numBoundaries = length(b.boundaries);
if numBoundaries > 1
    hole = true;
end
end

function isL = isLShaped(b)
isL = false;
img = b.image;

x_rng = round(size(img, 2) / 2 - 1);
y_rng = round(size(img, 1) / 2 - 1);

if (sum(sum(img(1:y_rng, 1:x_rng))) == 0) ...
        || (sum(sum(img(y_rng:y_rng*2, 1:x_rng))) == 0) ...
        || (sum(sum(img(1:y_rng, x_rng:x_rng*2))) == 0) ...
        || (sum(sum(img(y_rng:y_rng*2, x_rng:x_rng*2))) == 0)
    isL = true;
end
end

function isC = isCShaped(b)
isC = false;
img = b.image;

x_rng = round(size(img, 2) / 2 - 1);
x_org = round(x_rng / 2);
y_rng = round(size(img, 1) / 2 - 1);
y_org = round(y_rng / 2);

if (sum(sum(img(y_org:y_rng, 1:x_rng))) == 0) ...
        || (sum(sum(img(y_org:y_rng, x_org:x_rng))) == 0)
    isC = true;
end
end

function crossShaped = isCrossShaped(b)
crossShaped = false;
if ~fillsCorners(b)
    img = b.image;
    y_sz = size(img,1);
    x_sz = size(img,2);
    y_sz_half = round(y_sz / 2);
    x_sz_half = round(x_sz / 2);
    if img(1, x_sz_half) && img(y_sz_half, 1) && img(y_sz_half, x_sz) ...
            && img(y_sz, x_sz_half)
        crossShaped = true;
    end
end
end