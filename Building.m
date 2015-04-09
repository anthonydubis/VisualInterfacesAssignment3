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
        image;
        corners;
        boundaries;
        numTurns;
        numLargeCircles = 0;
        numMediumCircles = 0;
        
        % Text descriptions
        buildingSize;
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
        
        function obj = setImage(obj, image)
            obj.image = image;
            obj = obj.setBoundaries(bwboundaries(image));
            
            [centers, ~] = imfindcircles(image, [20, 35]);
            obj.numLargeCircles = size(centers,1);
            
            [centers, ~] = imfindcircles(image, [10, 20]);
            obj.numMediumCircles = size(centers,1);
        end
        
        function obj = setBoundaries(obj, boundaries)
            obj.boundaries = boundaries;
            n_turns = 1;
            
            for i=1:length(boundaries)
                vert_line = false;
                horz_line = false;
                bounds = boundaries{i};
                sz = size(bounds,1);
                prev = bounds(sz,:);
                for j=1:sz
                    curr = bounds(j,:);
                    if ~vert_line && ~horz_line
                        if     (prev(1) == curr(1)); horz_line = true;
                        elseif (prev(2) == curr(2)); vert_line = true;
                        else   n_turns = n_turns + 1;
                        end
                    elseif vert_line
                        if prev(2) ~= curr(2)
                            vert_line = false;
                            n_turns = n_turns + 1;
                        end
                    else
                        if prev(1) ~= curr(1)
                            horz_line = false;
                            n_turns = n_turns + 1;
                        end
                    end
                    prev = curr;
                end
            end
            obj.numTurns = n_turns;
        end
    end
    
end

