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
    S.near = [S.near T.number];
end

function [S, T] = east(S, T)
    if S.centroid(1) < T.centroid(1)
        S.east = [S.east T.number];
    end
end

function [S, T] = west(S, T)
    if S.centroid(1) > T.centroid(1)
        S.west = [S.west T.number];
    end
end

function [S, T] = north(S, T)
    if S.centroid(2) > T.centroid(2)
        S.north = [S.north T.number];
    end
end

function [S, T] = south(S, T)
    if S.centroid(2) < T.centroid(2)
        S.south = [S.south T.number];
    end
end
