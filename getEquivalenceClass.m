function [ pts, rejected ] = getEquivalenceClass(bOrig, bMap, descOrig, labeled)
% Determines what other pixels share the same description as bOrig

bldNum = labeled(bOrig.centroid(2), bOrig.centroid(1));
queue = java.util.LinkedList();
visited = [0 0]; %Will contains points we've seen before
pts = java.util.LinkedList(); % Points in the equivalance class
rejected = java.util.LinkedList(); % See what points were rejected

% Limit the number of iterations for testing purposes
i = 1;
len = 1;

queue.add(bOrig.centroid);

while ~queue.isEmpty()
    % Make sure there's enough room in the visited array
    if i > len
        visited = [visited; zeros(len,2)];
        len = len * 2;
    end
    
    % Get the next point
    pt = queue.remove()';
    
    % Check to see if the point is valid and we haven't visited it before
    if isInvalidPt(pt,labeled) ...
            || sum(ismember(visited, pt, 'rows')) > 0 ...
            || changedPerspective(pt, bldNum, labeled)
        continue;
    end
    
    % Process the point
    visited(i,:) = pt;
    [~, bMap] = buildingForPoint(bMap, 30, 'Dummy', pt);
    desc = getBuildingSpatialDesc(bMap('30'), bMap, labeled);
    if strcmp(descOrig, desc)
        pts.add(pt);
        % Add the four surrounding points
        queue.add([pt(1)-1, pt(2)]);
        queue.add([pt(1),   pt(2)-1]);
        queue.add([pt(1)+1, pt(2)]);
        queue.add([pt(1),   pt(2)+1]);
    else
        rejected.add(pt);
    end
    
    i = i + 1;
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

