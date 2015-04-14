function path = getPath(bMap, S, T)

edgeTo = bfs(bMap, S, T);
path = reconstructPath(edgeTo);

end

function edgeTo = bfs( bMap, S, T )
% Does a breadth first search to discover the shortest path
% Returns a 29x3 matrix that shows how we got to each building
% Column 1 represents the building we came from, column 2 represents the
% direction we came (1=north, 2=east, 3=south, 4=west), column 3 is a flag
% that is 1 when the reference is near the building the edge points to

edgeTo = zeros(29,3);
tNum = T.number;

queue = java.util.LinkedList();
queue.add(S.number);
edgeTo(S.number,:) = [S.number, S.number, 1];

while ~queue.isEmpty()
    bNum = queue.remove();
    b = bMap(int2str(bNum));
    
    % North
    for i=b.north
        if edgeTo(i,1) == 0
            edgeTo(i,:) = [bNum, 1, 0];
            if any(b.near == i)
                edgeTo(i,3) = 1;
            end
            if i == tNum
                return; 
            end
            queue.add(i);
        end
    end
    
    % East
    for i=b.east
        if edgeTo(i,1) == 0
            edgeTo(i,:) = [bNum, 2, 0];
            if any(b.near == i)
                edgeTo(i,3) = 1;
            end
            if i == tNum
                return; 
            end
            queue.add(i);
        end
    end
    
    % South
    for i=b.south
        if edgeTo(i,1) == 0
            edgeTo(i,:) = [bNum, 3, 0];
            if any(b.near == i)
                edgeTo(i,3) = 1;
            end
            if i == tNum
                return; 
            end
            queue.add(i);
        end
    end
    
    % West
    for i=b.west
        if edgeTo(i,1) == 0
            edgeTo(i,:) = [bNum, 4, 0];
            if any(b.near == i)
                edgeTo(i,3) = 1;
            end
            if i == tNum
                return; 
            end
            queue.add(i);
        end
    end
end
end

function path = reconstructPath(edgeTo)
% Start at the target and work our way backwards through the selected edges
% The final path is a Nx4 matrix. N is the number of steps taken. The three
% columns are in the form: [build1 directionTake isNear build2]. In other 
% words, it repesents the direction taken to go from building1 to 
% building 2. The matrix is also ordered (the steps should be taken in 
% sequence)
path = [];
bNum = 29; % The target
while true 
    path = [[edgeTo(bNum,1) edgeTo(bNum,2) edgeTo(bNum,3) bNum]; path];
    bNum = edgeTo(bNum,1);
    if bNum == 28 % The source
        break;
    end
end
end

