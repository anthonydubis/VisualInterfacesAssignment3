clc; clear; close all;

%% Step 0 - Get the campus map, a BW represention, and a labeled version

campus  = imread('ass3-campus.pgm');
BW      = im2bw(campus, 0);
% figure; imshow(BW);
labeled = imread('ass3-labeled.pgm');
labeled = correctedLabeled(labeled);

% Map the building numbers to their names
b_names = containers.Map();
strs = textread('ass3-table.txt', '%s', 'delimiter', '\n');
for i=1:length(strs)
    str = strs{i};
    len = length(str);
    eqls = strfind(str, '=');
    b_names(str(1:eqls-1)) = str(eqls+1:len);
end

%% Step 1 - Set the building features and descriptions

% Get the desired region properties for the buildings
stats = regionprops(BW, 'Area', 'BoundingBox', 'Centroid', ... 
    'MajorAxisLength', 'MinorAxisLength', 'Orientation', 'PixelList', ... 
    'ConvexHull', 'ConvexArea', 'Image');
N = length(stats);

% Set the building objects
buildings = containers.Map();
areaMin = double(intmax);
areaMax = 0.0;
turns = zeros(27,1);

for i=1:N
    b_stats = stats(i);
    b = Building;
    
    % Get a point within the building to set the building name and number
    pt = b_stats.PixelList(1,:);
    b.number = labeled(pt(2), pt(1));
    b.name = b_names(int2str(b.number))

    % Set basic properties
    b.area = b_stats.Area;
    b.centroid = b_stats.Centroid;
    b = b.setOrientation(b_stats.Orientation);
    b.boundingBox = b_stats.BoundingBox;
    b = b.setImage(b_stats.Image);
    turns(b.number) = b.numTurns;
    buildings(int2str(b.number)) = b;
    
    areaMin = min(areaMin, b.area);
    areaMax = max(areaMax, b.area);
end

% Set the size attribute
for i=1:N
    b = buildings(int2str(i));
    b.buildingSize = getSizeDescription(b.area, areaMin, areaMax);
    buildings(int2str(i)) = b;
end

% Set building shape
for i=1:N
    key = int2str(i);
    b = buildings(key);
    b.shape = determineShape(b, labeled)
    buildings(key) = b;
end

% Find buildings with center of mass in background
for i=1:N
    b = buildings(int2str(i));
    cent = round(b.centroid);
    background = labeled(cent(2), cent(1));
    if background == 0
        b.number;
    end
end
    


% Let's create the Building objects based on the map
% map = java.util.HashMap;










