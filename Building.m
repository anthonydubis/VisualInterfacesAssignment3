classdef Building
    % This class represents a building on a map, its description, and its
    % relationships to other buildings
    
    properties
        % Numeric properties
        number; 
        name;   
        area;
        centroid;
        orientation;
        boundingBox;
        
        % Text descriptions
        size;
        oriented;
        shape;
        
        % Spacial relationships
        north;
        south;
        east;
        west;
        near;
    end
    
    methods
        function obj = setOrientation(obj, b_orientation)
            obj.orientation = b_orientation;
            if b_orientation < 45 && b_orientation > -45
                obj.oriented = 'WestToEast';
            else
                obj.oriented = 'NorthToSouth';
            end 
        end
    end
    
end

