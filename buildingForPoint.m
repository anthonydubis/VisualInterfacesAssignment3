function [bld, bMap] = buildingForPoint(bMap, num, name, loc)
% Create and setup a new building object for a point

side = 1;

N = 27; % Number of buildings on campus.
bld = Building;
bld.number = num;
bld.name = name;
bld.centroid = loc;
bld = bld.setBoundingBox([loc(1)-(side/2) loc(2)-(side/2) side side]);
bMap(int2str(num)) = bld;
for i=1:N
    [bld, T] = setSpatialRelationships(bld, bMap(int2str(i)));
    bMap(int2str(num)) = bld;
    bMap(int2str(i)) = T;
end
end

