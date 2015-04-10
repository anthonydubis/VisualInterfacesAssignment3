function [ bMap ] = pruneRelationships( bMap, b )
% Prune away relationships that can be inferred
% bMap is a key-value map of (string b_num : Building b)
% b is the Building object you're pruning
b = prune(bMap, b, b, 'north');
b = prune(bMap, b, b, 'south');
b = prune(bMap, b, b, 'west');
b = prune(bMap, b, b, 'east');
bMap(int2str(b.number)) = b;

end

function orig = prune(bMap, curr, orig, dir)
% Get the edges for the current node given the direction
adj_curr = getAdjacentNodes(curr, dir);
if isempty(adj_curr); return; end;

% Recurse on adjacent nodes
for i=1:length(adj_curr)
    orig = prune(bMap, bMap(int2str(adj_curr(i))), orig, dir);
end

% If the current building == the original, you're done
if curr.number == orig.number
    return;
end

% Prune adjacent nodes of the current from the original
adj_orig = getAdjacentNodes(orig, dir);
for i=1:length(adj_curr)
    % Remove adj_curr[i] from adj_orig if it's present
    len = length(adj_orig);
    index = find(adj_orig == adj_curr(i));
    if index > 0
        adj_orig = [adj_orig(1:index-1), adj_orig(index+1:len)];
    end
end
orig = setAdjacentNodes(orig, adj_orig, dir);
end

function adj = getAdjacentNodes(building, dir)
switch dir
    case 'east';  adj = building.east;
    case 'west';  adj = building.west;
    case 'north'; adj = building.north;
    case 'south'; adj = building.south;
end
end

function building = setAdjacentNodes(building, adj, dir)
switch dir
    case 'east';  building.east = adj;
    case 'west';  building.west = adj;
    case 'north'; building.north = adj;
    case 'south'; building.south = adj;
end
end

