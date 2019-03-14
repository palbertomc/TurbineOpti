% TurbineOpti
% Copyright (C) 2019  J. Bergh
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

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

    
    