%% editprofile.m

% Matlab function to remove duplicate entries from inlet velocity profile
% NB last line of the profile must be added manually

function editprofile(name,name2,lines)

% Open file and read in contents
fid = fopen(name);
fid2= fopen(name);

line2 = fgetl(fid2);

fidwrite = fopen(name2,'w');

for i=1:1:lines-1
    line = fgetl(fid);
    temp1 = textscan(line,'%s %s','delimiter');
    
    line2 = fgetl(fid2);
    temp2 = textscan(line2,'%s %s','delimiter');
    
    %fprintf(fidwrite,'%1.9f %1.9f \n',str2double(temp1{1,1}),str2double(temp1{1,2}));
    
    if strcmp(temp1{1,1},temp2{1,1})
        % do nothing
    else
        fprintf(fidwrite,'%1.9f %1.9f \n',str2double(temp1{1,1}),str2double(temp1{1,2}));
    end 
end

fclose('all');

end

    
    