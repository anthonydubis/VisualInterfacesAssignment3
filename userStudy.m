clc; clear; close all;
source = [187 42; 241 456; 144 152; 64 421; 26 189; 64 467; 144 41; ...
    135 422];

campus  = imread('supporting/ass3-campus.pgm');

for i=1:length(source)
    S = source(i,:);
    
    figure; imshow(campus); hold on;
    
    % Label the center
    start = plot(S(1), S(2), 'o', 'MarkerEdgeColor', 'g');
    set(start, 'MarkerSize', 6, 'LineWidth', 3);
    
    selectedPts = ginput
    
    for j=1:size(selectedPts,1)
        point = selectedPts(j,:);
        pt = plot(point(1), point(2), 'o', 'MarkerEdgeColor', 'r');
        set(pt, 'MarkerSize', 6, 'LineWidth', 3);
    end
    hold off;
end