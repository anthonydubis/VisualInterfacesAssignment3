% clc; clear; close all;

resetData = false;

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

if resetData
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
        [S, T] = setSpatialRelationships(S, T);
        buildings(int2str(i)) = S;
        buildings(int2str(j)) = T;
    end
end

% Prune the graph to remove relationships that can be inferred
fprintf('Pruning the graph\n');
for i=1:N
    bMap = pruneRelationships(buildings, buildings(int2str(i)));
end
fprintf('Done pruning the graph\n');

end

%% Step 3 - Setting and describing sources & targets

% Get the source (S) 
figure(); imshow(campus);
sLoc = int16(ginput(1));

% Set it up as a building and enter it in the graph
fprintf('Working on S\n');
S = Building;
S.number = 28;
S.name = 'Source';
S.centroid = sLoc;
S = S.setBoundingBox([sLoc(1) sLoc(2) 1 1]);
buildings('28') = S;
for i=1:N
    [S, T] = setSpatialRelationships(S, buildings(int2str(i)));
    buildings('28') = S;
    buildings(int2str(i)) = T;
end
% Don't prune for now - let's work with raw relationships
% bMap = pruneRelationships(buildings, buildings('28'));

%% Step 3.5 - Error checking
figure(); imshow(campus); hold on;
for i=1:N
    bld = buildings(int2str(i));
    pts = bld.spatialPts;
    for j=1:size(pts,1)
        center = plot(pts(j,1), pts(j,2), 'o', 'MarkerEdgeColor', 'r');
        set(center, 'MarkerSize', 6, 'LineWidth', 3);
    end
end
center = plot(S.centroid(1), S.centroid(2), 'o', 'MarkerEdgeColor', 'r');
set(center, 'MarkerSize', 6, 'LineWidth', 3);

hold off;

% Get the sources description
sDesc = getBuildingSpatialDesc(buildings('28'), buildings, labeled)
fprintf('Finishing working on S\n');

% T = ginput(1);
% fprintf('Show the red cloud and the T description');
