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

function cleanUp(work_dir,blade_type,iga)

% Function to remove simulation files after run completion
%
% Input:
%   iga -   population (iteration) number
%
% Output: 
%   null
%

fprintf('\nCleaning up files ...\n');
  
% List of system commands
sy1a=sprintf('rm %sGeneration_%.1f/gambit_out.txt',work_dir,iga);
sy1b=sprintf('rm %sGeneration_%.1f/icem_out.txt',work_dir,iga);
sy1c=sprintf('rm %sGeneration_%.1f/fluent_out.txt',work_dir,iga);

sy2a=sprintf('rm %sGeneration_%.1f/*.tin',work_dir,iga);
sy2b=sprintf('rm %sGeneration_%.1f/boco',work_dir,iga);
sy2c=sprintf('rm %sGeneration_%.1f/*.uns',work_dir,iga);
sy2d=sprintf('rm %sGeneration_%.1f/*.prj',work_dir,iga);
sy2e=sprintf('rm %sGeneration_%.1f/*.blk',work_dir,iga);
sy2f=sprintf('rm %sGeneration_%.1f/*.par',work_dir,iga);
sy2g=sprintf('rm %sGeneration_%.1f/*.atr',work_dir,iga);
sy2h=sprintf('rm %sGeneration_%.1f/*.*fbc*',work_dir,iga);
sy2i=sprintf('rm %sGeneration_%.1f/*.bak',work_dir,iga);
sy2j=sprintf('rm %sGeneration_%.1f/*.sat',work_dir,iga);

sy3a=sprintf('rm %sGeneration_%.1f/%s.cas.gz',work_dir,iga,blade_type);
sy3b=sprintf('rm %sGeneration_%.1f/%s.dat.gz',work_dir,iga,blade_type);
sy3c=sprintf('rm %sGeneration_%.1f/%s.msh',work_dir,iga,blade_type);
sy3d=sprintf('rm %sGeneration_%.1f/wake*',work_dir,iga);

sy4a=sprintf('rm %sGeneration_%.1f/torque',work_dir,iga);
sy4b=sprintf('rm %sGeneration_%.1f/density',work_dir,iga);
sy4c=sprintf('rm %sGeneration_%.1f/pressure',work_dir,iga);
sy4d=sprintf('rm %sGeneration_%.1f/results.txt',work_dir,iga);
sy4e=sprintf('rm %sGeneration_%.1f/reference',work_dir,iga);
sy4f=sprintf('rm %sGeneration_%.1f/result',work_dir,iga);
sy4g=sprintf('rm %sGeneration_%.1f/reference_averaged.csv',work_dir,iga);
sy4h=sprintf('rm %sGeneration_%.1f/result_averaged.csv',work_dir,iga);
sy4i=sprintf('rm %sGeneration_%.1f/line*.dat',work_dir,iga);
sy4j=sprintf('rm %sGeneration_%.1f/*.png',work_dir,iga);

sy5a=sprintf('rm %sGeneration_%.1f/inputfile',work_dir,iga);
sy5b=sprintf('rm %sGeneration_%.1f/*.jou',work_dir,iga);
sy5c=sprintf('rm %sGeneration_%.1f/%s_data_export',work_dir,iga,blade_type);
sy5d=sprintf('rm %sGeneration_%.1f/*.rpl',work_dir,iga);
sy5e=sprintf('rm %sGeneration_%.1f/*.prof',work_dir,iga);
sy5f=sprintf('rm %sGeneration_%.1f/*.sh',work_dir,iga);


% UNCOMMENT LINES TO REMOVE FILES

% Transcript files
%system(sy1a);   % gambit_out.txt
%system(sy1b);   % icem_out.txt
%system(sy1c);   % fluent_out.txt

% ICEM files
system(sy2a);   % .tin
%system(sy2b);  % boco file
system(sy2c);   % .uns 
system(sy2d);   % .prj
system(sy2e);   % .blk
%system(sy2f);  % .par
system(sy2g);   % .atr
system(sy2h);   % .fbc
%system(sy2i);  % .bak
system(sy2j);   % .sat

% Fluent files
%system(sy3a);  % .cas.gz
%system(sy3b);  % .dat.gz
system(sy3c);  % .msh
%system(sy3d); % wake-angle

% Results processing and CFD output files
%system(sy4a);  % torque file
%system(sy4b);  % density file
%system(sy4c); % pressure file
%system(sy4d);  % results.txt file
%system(sy4e);  % reference file
%system(sy4f);  % result file
%system(sy4g);  % reference_averaged.csv
%system(sy4h);  % result_averaged.csv
%system(sy4i);  % Line_1-6.dat
%system(sy4j);  % Matlab figures

% System files 
system(sy5a);   % fluent journal
system(sy5b);   % gambit journal
system(sy5c);   % fluent data_export journal
system(sy5d);   % icem journal
system(sy5e);   % CFD inlet / outlet profiles
%system(sy5f);   % system batch files
  
% Print user message
fprintf('\t Complete\n');
