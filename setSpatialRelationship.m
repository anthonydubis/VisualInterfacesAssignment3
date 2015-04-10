function [S, T] = setSpatialRelationship( S, T, rel )
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

function [S, T] = east(S, T)
    if S.spatialPts(2,1) < T.spatialPts(4,1)
        S.east = [S.east T.number];
    end
end

function [S, T] = west(S, T)
    if S.spatialPts(4,1) > T.spatialPts(2,1)
        S.west = [S.west T.number];
    end
end

function [S, T] = north(S, T)
    if S.spatialPts(1,2) > T.spatialPts(3,2)
        S.north = [S.north T.number];
    end
end

function [S, T] = south(S, T)
    if S.spatialPts(3,2) < T.spatialPts(1,2)
        S.south = [S.south T.number];
    end
end
