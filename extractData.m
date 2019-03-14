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

function extractData(cfd_model,blade_model)

% Matlab function to extract and average results from
% Fluent output files
%
% Uses function circumave.m. Input file data must be be in columns. 
%
% Standard format for 'x2' data file
%
%   node  x  y  z  Ps  Pt  Vmag  Vz  Vr  Vt  alpha helicity
%   1...  .. .. .. ..  ..  ...   ..  ..  ..  ....  ...
%   2...  .. .. .. ..  ..  ...   ..  ..  ..  ....  ...
%
% and for 'x3/x4'
%
%   node  x  y  z  Ps  Pt  Ptrel  Vmag  Vz  Vr  Vt  Vmag_rel alpha  beta helicity
%   1...  .. .. .. ..  ..  ....   ...   ..  ..  ..  ....     ....   .... ...
%   2...  .. .. .. ..  ..  ....   ...   ..  ..  ..  ....     ....   .... ...
%
% Produces output as .csv file 'outputfile_averaged.csv'
%
%	radial_point	property1 	property2	etc....
%	0.1440          ......		......		.......
%	0.1485          ......		......		.......
%	......          ......		......		.......
%	......          ......		......		.......
%

% Set data file names and initialise start column variable
data_planes = {'x2'; 'x3'; 'x4'}; 
start_column = 5;

% Open data file and extract all data columns
for x = 1:1:length(data_planes)
    
    inputfilename = char(data_planes(x,1));
    datafile = dlmread(inputfilename,',',1,0);
    datafile_size = size(datafile);
    columns_datafile = datafile_size(1,2);                  
    clear result;                                           
    
    % Iterate through all data columns and call function circumave.m to average data
    for column = start_column:1:columns_datafile
    	
        Z = circumAve(inputfilename,column);     
        result(:,1)=Z(:,1);                             
        result(:,column)=Z(:,2);                        
        
    end

    % Looks at 'result' matrix and extracts number of rows
    result_size = size(result);
    rows_result = result_size(1,1);
    columns_result = result_size(1,2);

    % Add Fluent operating pressure to pressure values to obtain true
    % pressure
    if ((strcmpi(blade_model.blade_type,'rotor') == 1) && ((strcmpi(inputfilename,'x3') == 1 || (strcmpi(inputfilename,'x4') == 1))))
        
        result(:,5)=result(:,5) + cfd_model.operating_pressure;
        result(:,6)=result(:,6) + cfd_model.operating_pressure;
        result(:,7)=result(:,7) + cfd_model.operating_pressure;
        
    else
        
        result(:,5)=result(:,5) + cfd_model.operating_pressure;
        result(:,6)=result(:,6) + cfd_model.operating_pressure;
        
    end
     
    % Write results data to .csv file
    outputfilename = [inputfilename '_averaged.csv'];
    [fid] = fopen(outputfilename, 'w');

    for o=1:1:rows_result
        
        fprintf(fid,'%.9f',result(o,1));			
        fprintf(fid,'%s',',');
        
        for p = start_column:1:columns_result
            
            fprintf(fid,'%.9f',result(o,p));        
            fprintf(fid,'%s',',');
            
        end
        
    fprintf(fid,'\n');
    
    end
    
    fclose(fid);

end
