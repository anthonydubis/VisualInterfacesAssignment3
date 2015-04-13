function [tab] = outputStepOneData( bMap )

% Build Nums
bNums = [1:27]';

% Building names
bNames = cell(27,1);
for i=1:27
    bNames{i} = bMap(int2str(i)).name;
end

% Centroids
cents = cell(27,1);
for i=1:27
    cents{i} = round(bMap(int2str(i)).centroid);
end

% Area
areas = cell(27,1);
for i=1:27
    areas{i} = bMap(int2str(i)).area;
end

% Bounding box
bboxes = cell(27,1);
for i=1:27
    box = bMap(int2str(i)).boundingBox;
    bboxes{i} = round([box(1), box(2), box(1)+box(3), box(2)+box(4)]);
end

descriptions = cell(27,1);
for i=1:27
    descriptions{i} = bMap(int2str(i)).getDescription;
end

tab = table(bNums,bNames, cents, areas, bboxes, descriptions);

end

