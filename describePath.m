function [ directions ] = describePath( bMap, path )
steps = size(path,1);
directions = cell(steps, 1);


for i=1:(steps-1)
    info = path(i,:);
    b = bMap(int2str(path(i,4)));
    
    % Start the move
    move = strcat({'Go '}, getDirectionFromIdentifer(info(2)), {' '});
    
    % Add near if applicable
    if info(3) == 1
        move = strcat(move, {'and near '});
    end
    
    % Describe the building
    move = strcat(move, {'(to the buiding that is '}, ...
        b.getDescription, {')'});
    
    move = strcat(move, '.');
    directions{i} = move;
end

% Give terminal directions
info = path(steps,:);
terminal = strcat({'Go to the area that is '}, ...
    getDirectionFromIdentifer(info(2)));
if info(3) == 1
    terminal = strcat(terminal, {' and near '});
end
terminal = strcat(terminal, '.');
directions{steps} = terminal;

end

