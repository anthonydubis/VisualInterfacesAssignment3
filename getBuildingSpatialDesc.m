function [ desc ] = getBuildingSpatialDesc( b, bMap, labeled )
% Return the spatial description of building b based on the graph made up
% of the other buildings in bMap

% First, determine if this building is 'in' another or if you need to find
% what is nearby. If you just need to find what is nearby, grab anything
% from the "near" relationship set.
desc = getNearbyDescription(b, bMap, labeled);

% Next, find the two closets relationships. Closest is defined as being
% closest to the spatialPt. The two results with related buildings that are
% the closest to b should be used in the description. The returned matrix
% will have two rows with the first column corresponding to the distance
% (1=North, 2=East, 3=South, 4=West) and the second the building number. If
% the row contains all zeros, then a good relationship couldn't be found.
R = getMostRelevantRelationships(b, bMap)

% Now apped these relevant relationships to the desc
directionalDesc = getDirectionalDescriptionForRelations(bMap, R);

if isempty(desc)
    desc = directionalDesc;
else
    desc = strcat(desc, {', '}, directionalDesc);
end

end

function desc = getNearbyDescription(b, bMap, labeled)
cent = b.centroid;
val = labeled(cent(2), cent(1));
if val ~= 0
    desc = strcat('in', {' '}, bMap(int2str(val)).name, {' '});
else
    nearAdj = bMap(int2str(b.number)).near;
    if isempty(nearAdj)
        desc = '';
    else
        desc = strcat('near', {' '}, bMap(int2str(nearAdj(1))).name);
    end
end
end

function R = getMostRelevantRelationships(b, bMap)
north = getMostRelevantRelationship(b, bMap, 'north');
east  = getMostRelevantRelationship(b, bMap, 'east');
south = getMostRelevantRelationship(b, bMap, 'south');
west  = getMostRelevantRelationship(b, bMap, 'west');
R = [north; east; south; west];

% Sort them
[~,I] = sort(R(:,2));
R = R(I,:);

% Remove relationships that don't exist 
while ~isempty(R) && R(1,2) == 0
    len = size(R,1);
    R = R(2:len,:);
end

% Return only the two most relevant
if size(R,1) > 2
    R = R(1:2,:);
end
end

% This is going to return a 1 x 3 vector. The first column will specify the
% the direction (1=N, 2=E, 3=S, 4=W). The second column will contain the
% distance between b and the nearest building with respect to the given
% direction (north, south, east, west). The third column will the building
% number.
function results = getMostRelevantRelationship(b, bMap, dir)
rid = getReverseDirectionIdentifier(dir);
results = [rid 0 0];

adj = getAdjacentNodes(b, dir);
len = length(adj);
if len > 0
    minDist = intmax;
    for i=1:len
        b2 = bMap(int2str(adj(i)));
        dist = distanceBetweenBuildings(b, b2);
        if dist < minDist
            results(2:3) = [dist b2.number];
            minDist = dist;
        end
    end
end
end

% Returns the minimum distance between b1 and b2 by comparing b1's centroid
% to b2's four spatial points
function dist = distanceBetweenBuildings(b1, b2)
dist = intmax;
b1Cent = double(b1.centroid);
b2Pts = double(b2.spatialPts);
for i=1:4
    dist = min(pdist([b1Cent; b2Pts(i,:)], 'euclidean'), dist);
end
end

function desc = getDirectionalDescriptionForRelations(bMap, R)
desc = '';
for i=1:size(R,1)
    seg = getDirectionFromIdentifer(R(i,1));
    seg = strcat(seg, {' '}, 'of', {' '}, bMap(int2str(R(i,3))).name);
    if i==1
        desc = seg;
    else
        desc = strcat(desc, {' and '}, seg);
    end
end
end