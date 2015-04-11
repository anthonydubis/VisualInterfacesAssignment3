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
        spatialPts; % Used to determine N,S,E,W relationships
        expandedBoundingBox;
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
        
        function obj = setBoundingBox(obj, rec)
            obj.boundingBox = rec;
                        
            % Set spatialPts
            pts = zeros(4,2);
            pts(1,:) = [rec(1)+rec(3)/2, rec(2)]; % North pt
            pts(2,:) = [rec(1)+rec(3), rec(2)+rec(4)/2]; % East pt
            pts(3,:) = [rec(1)+rec(3)/2, rec(2)+rec(4)]; % South pt
            pts(4,:) = [rec(1), rec(2)+rec(4)/2]; % West pt
            obj.spatialPts = pts;
            
            % Set expandedBoundingBox
            scale_factor = 2.1;
            minIncrease = 30;
            maxIncrease = 70;
            % Determine new width with min/max boundaries
            newW = rec(3) * scale_factor;
            newW = max(newW, rec(3)+minIncrease);
            newW = min(newW, rec(3)+maxIncrease);
            % Determine new height with min/max boundaries
            newH = rec(4) * scale_factor;
            newH = max(newH, rec(4)+minIncrease);
            newH = min(newH, rec(4)+maxIncrease);
            % Determine new origin
            newX = rec(1) - ((newW - rec(3)) / 2);
            newY = rec(2) - ((newH - rec(4)) / 2);
            obj.expandedBoundingBox = [newX, newY, newW, newH];
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

