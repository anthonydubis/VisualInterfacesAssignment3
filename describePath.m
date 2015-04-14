function [ directions ] = describePath( bMap, path )
steps = size(path,1);
directions = cell(steps, 1);

for i=1:(steps-1)
    info = path(i,:);
    b = bMap(int2str(path(i,4)));
    
    % Start the move
    move = strcat({'Go to the building that is '}, ...
        getDirectionFromIdentifer(info(2)), {' '});
    
    % Add near if applicable
    if info(3) == 1
        move = strcat(move, {'and near '});
    end
    
    % Describe the building
    move = strcat(move, {'(and that is '}, ...
        b.getDescription, {')'});

    directions{i} = move;
end

% Give terminal directions
info = path(steps,:);

if ~strcmp(bMap('29').name, 'Target')
    % We are giving directions to a building
    terminal = strcat({'Go to the building that is '}, ...
        getDirectionFromIdentifer(info(2)));
    if info(3) == 1
        terminal = strcat(terminal, {' and near '});
    end
    
    % Give building description
    terminal = strcat(terminal, {'(and that is '}, ...
        bMap(int2str(29)).getDescription, {')'});
else
    % We are giving directions to an area
    terminal = strcat({'Go to the area that is '}, ...
        getDirectionFromIdentifer(info(2)));
    if info(3) == 1
        terminal = strcat(terminal, {' and near'});
    end
    terminal = strcat(terminal, '.');
end
directions{steps} = terminal;

end

