function tab = outputStepTwoData( bMap )

% Building names
bNames = cell(27,1);
for i=1:27
    bNames{i} = bMap(int2str(i)).name;
end

% Get north
northNames = cell(27,1);
for i=1:27
    desc = '';
    blds = bMap(int2str(i)).north;
    for j=1:length(blds)
        if j == 1
            desc = bMap(int2str(blds(j))).name;
        else
            desc = strcat(desc, {', '}, bMap(int2str(blds(j))).name);
        end
    end
    northNames{i} = desc;
end

% Get east
eastNames = cell(27,1);
for i=1:27
    desc = '';
    blds = bMap(int2str(i)).east;
    for j=1:length(blds)
        if j == 1
            desc = bMap(int2str(blds(j))).name;
        else
            desc = strcat(desc, {', '}, bMap(int2str(blds(j))).name);
        end
    end
    eastNames{i} = desc;
end

% Get south
southNames = cell(27,1);
for i=1:27
    desc = '';
    blds = bMap(int2str(i)).south;
    for j=1:length(blds)
        if j == 1
            desc = bMap(int2str(blds(j))).name;
        else
            desc = strcat(desc, {', '}, bMap(int2str(blds(j))).name);
        end
    end
    southNames{i} = desc;
end

% Get west
westNames = cell(27,1);
for i=1:27
    desc = '';
    blds = bMap(int2str(i)).west;
    for j=1:length(blds)
        if j == 1
            desc = bMap(int2str(blds(j))).name;
        else
            desc = strcat(desc, {', '}, bMap(int2str(blds(j))).name);
        end
    end
    westNames{i} = desc;
end

tab = table(bNames, northNames, eastNames, southNames, westNames);

end

