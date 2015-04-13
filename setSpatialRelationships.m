function [S, T] = setSpatialRelationships( S, T )
% Determines spatial relations for the source (S) and the target (T) 
% S and T are Building objects
% Example of how to read north(S, T) : North of S is T
[S, T] = setSpatialRelationship(S, T, 'near');
[S, T] = setSpatialRelationship(S, T, 'east');
[S, T] = setSpatialRelationship(S, T, 'west');
[S, T] = setSpatialRelationship(S, T, 'north');
[S, T] = setSpatialRelationship(S, T, 'south');
end

function [S, T] = setSpatialRelationship( S, T, rel)
% Determines if the source (S) and the target (T) is spacially related
% S and T are Building objects
% rel is a string: 'east' 'west' 'north' or 'south'
% Example of how to read north(S, T) : North of S is T

switch rel
    case 'near'
        [S, T] = near(S, T);
    case 'east'
        [S, T] = east(S, T);
    case 'west' 
        [S, T] = west(S, T);
    case 'north'
        [S, T] = north(S, T);
    case 'south'
        [S, T] = south(S, T);
end
end

function [S, T] = near(S, T)
    if rectint(S.expandedBoundingBox, T.boundingBox) > 0
        S.near = [S.near T.number];
    end
end

function doIntersect = doRangesIntersect(r1, r2)
adjustment = min(r1(1), r2(1));
r1 = r1 - adjustment;
r2 = r2 - adjustment;

if (r1(1) > r2(2) || r2(1) > r1(2)) % No intersection
    doIntersect = false;
else
    doIntersect = true;
end
end

function areInLine = areInLineHorizontally(S, T)
areInLine = false;
s_yrange = [S.spatialPts(1,2), S.spatialPts(3,2)];
t_yrange = [T.spatialPts(1,2), T.spatialPts(3,2)];

if doRangesIntersect(s_yrange, t_yrange)
    areInLine = true;
end
end

function areInLine = areInLineVertically(S, T)
areInLine = false;
s_xrange = [S.spatialPts(4,1), S.spatialPts(2,1)];
t_xrange = [T.spatialPts(4,1), T.spatialPts(2,1)];

if doRangesIntersect(s_xrange, t_xrange);
    areInLine = true;
end
end

function [S, T] = east(S, T)
if S.centroid(1) < T.centroid(1) 
    if areInLineHorizontally(S, T)
        S.east = [S.east T.number];
    end
end

%     if S.spatialPts(2,1) < T.spatialPts(4,1)
%         S.east = [S.east T.number];
%     end
end

function [S, T] = west(S, T)
if S.centroid(1) > T.centroid(1)
    if areInLineHorizontally(S, T);
        S.west = [S.west T.number];
    end
end

%     if S.spatialPts(4,1) > T.spatialPts(2,1)
%         S.west = [S.west T.number];
%     end
end

function [S, T] = north(S, T)
if S.centroid(2) > T.centroid(2)
    if areInLineVertically(S, T);
        S.north = [S.north T.number];
    end
end

%     if S.spatialPts(1,2) > T.spatialPts(3,2)
%         S.north = [S.north T.number];
%     end
end

function [S, T] = south(S, T)
if S.centroid(2) < T.centroid(2)
    if areInLineVertically(S, T);
        S.south = [S.south T.number];
    end
end

%     if S.spatialPts(3,2) < T.spatialPts(1,2)
%         S.south = [S.south T.number];
%     end
end
