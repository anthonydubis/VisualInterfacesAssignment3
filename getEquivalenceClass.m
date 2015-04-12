function [ pts ] = getEquivalenceClass(bOrig, bMap, descOrig, labeled)
% Determines what other pixels share the same description as bOrig
fprintf('Computing the pixel cloud. Please wait...\n');

bldNum = labeled(bOrig.centroid(2), bOrig.centroid(1));
queue = java.util.LinkedList();
visited = zeros(size(labeled)); % Will contain 1 for points we've visited
pts = java.util.LinkedList(); % Points in the equivalance class

queue.add(bOrig.centroid);

while ~queue.isEmpty()    
    % Get the next point
    pt = queue.remove()';
    
    % Check to see if the point is valid and we haven't visited it before
    if visited(pt(2), pt(1)) || isInvalidPt(pt,labeled) ...
            || changedPerspective(pt, bldNum, labeled)
        continue;
    end
    
    % Process the point
    [~, bMap] = buildingForPoint(bMap, 30, 'Dummy', pt);
    desc = getBuildingSpatialDesc(bMap('30'), bMap, labeled);
    if strcmp(descOrig, desc)
        pts.add(pt);
        % Add the four surrounding points
        queue.add([pt(1)-1, pt(2)]);
        queue.add([pt(1),   pt(2)-1]);
        queue.add([pt(1)+1, pt(2)]);
        queue.add([pt(1),   pt(2)+1]);
    end
    % Set the point to visited so we don't process it again
    visited(pt(2), pt(1)) = 1;
end

end

function isInvalid = isInvalidPt(pt,labeled) 
isInvalid = false;
[y_sz, x_sz] = size(labeled);
x = pt(1);
y = pt(2);
if x < 0 || y < 0 || x > x_sz || y > y_sz
    isInvalid = true;
end
end

function didChange = changedPerspective(pt, bldNum, labeled)
didChange = (bldNum ~= labeled(pt(2),pt(1)));
end

