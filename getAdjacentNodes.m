function adj = getAdjacentNodes(building, dir)
switch dir
    case 'east';  adj = building.east;
    case 'west';  adj = building.west;
    case 'north'; adj = building.north;
    case 'south'; adj = building.south;
end
end