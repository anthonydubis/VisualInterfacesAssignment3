clc; clear; close all;

%% Step 0 - Get the campus map, a BW represention, and a labeled version

campus  = imread('supporting/ass3-campus.pgm');
BW      = im2bw(campus, 0);
% figure; imshow(BW); hold on;
labeled = imread('supporting/ass3-labeled.pgm');
labeled = correctedLabeled(labeled);

% Map the building numbers to their names
b_names = containers.Map();
strs = textread('supporting/ass3-table.txt', '%s', 'delimiter', '\n');
N = length(strs);
for i=1:N
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

% Set the building objects
buildings = containers.Map();
areaMin = double(intmax);
areaMax = 0.0;

for i=1:N
    b_stats = stats(i);
    b = Building;
    
    % Get a point within the building to set the building name and number
    pt = b_stats.PixelList(1,:);
    b.number = labeled(pt(2), pt(1));
    b.name = b_names(int2str(b.number));
    
%     % Plot centroid
%     cent = b_stats.Centroid;
%     center = plot(cent(1), cent(2), 'o', 'MarkerEdgeColor', 'r');
%     set(center, 'MarkerSize', 6, 'LineWidth', 3);

    % Set basic properties
    b.area = b_stats.Area;
    b.centroid = b_stats.Centroid;
    b = b.setOrientation(b_stats.Orientation);
    b = b.setBoundingBox(b_stats.BoundingBox);
    b = b.setImage(b_stats.Image);
    b.shape = determineShape(b, labeled);
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


%% Step 2 - Set the spatial relationships between buildings

% Establish relationships between all buildings
for i=1:N
    for j=1:N
        if i == j; continue; end
        S = buildings(int2str(i));
        T = buildings(int2str(j));
        [S, T] = setSpatialRelationship(S, T, 'near');
        [S, T] = setSpatialRelationship(S, T, 'east');
        [S, T] = setSpatialRelationship(S, T, 'west');
        [S, T] = setSpatialRelationship(S, T, 'north');
        [S, T] = setSpatialRelationship(S, T, 'south');
        buildings(int2str(i)) = S;
        buildings(int2str(j)) = T;
    end
end

fprintf('About to prune the data\n');
% Let's prune the data
for i=1:N
    bMap = pruneRelationships(buildings, buildings(int2str(i)));
end
fprintf('Done pruning the data\n');
