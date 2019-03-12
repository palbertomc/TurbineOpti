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

function [newX,newY,unsteady] = processModel(cfd_model,blade_model,endwall_model,dir_model,x,iga,CFDcostfuncno,GUIhandles)

% Function to process CFD data
%
% Input:
%   iga -           iteration number (scalar)
%   cfd_model -     struct containing CFD model parameters (struct)
%   blade_model -   struct containing blade parameters (struct)
%   endwall_model - struct containing endwall parameters (struct)
%   dir_model -     struct containing directory paths (struct)
%
% Output:
%   newX,newY -     new data coordinates newX (m x 1) and function value newY (scalar) 
%                   for database
%
% J Bergh, 2014

% Reset cost vector
cost = 0; unsteady = 0;

% Load gui handle data
if (nargin > 7)
	handles = guidata(GUIhandles);
end

% Flag to determine whether to plot results or not
graphresults = 1;

% Process results
%if (nargin > 7)
%	 set(handles.txtInfo,'String',sprintf('Post processing data... (%g)\n',iga));
%end
fprintf('\n\nPost processing data... (%g)\n',iga)

% Check for last Fluent data file, process data if it exists
if (exist('x4','file'))
    
    if (~(exist('x4_averaged.csv','file')));
        extractData(cfd_model,blade_model)
    end

    if (~(exist('results.txt','file')));
        processResultsCFD(graphresults,cfd_model,blade_model,endwall_model,dir_model)
    end

    % Extract mass-averaged quantities from results.txt file
    fid = fopen('results.txt');

    if strcmpi(blade_model.blade_type,'rotor') == 1     % For a rotor blade
        line_efficiency=4;                      % Efficiency is found on line 4
        line_Cp0=9;                             % Cp0 is found on line 8
        line_Cske=10;                           % Cske is found on line 9
        line_HSke=11;                           % HSke is found on line 10
        line_deviation=12;                      % Flow deviation angle is found on line 11
        line_Vdotalpha=14;                      % Vdotalpha is found on line 12
        line_max=line_Vdotalpha;                % Last line of file is Vdotalpha
    end

    for line_n=1:1:line_max     % Max line we need to go to is line_max
        txt=fgetl(fid);
        if (line_n == line_efficiency)
            tmp=textscan(txt,'%*s %*s %*s %s','delimiter');
            efficiency=str2num(tmp{1}{1});
        end
        if (line_n == line_Cske)
            tmp=textscan(txt,'%*s %*s %s','delimiter');
            Cske=str2num(tmp{1}{1});
        end
        if (line_n == line_HSke)
            tmp=textscan(txt,'%*s %*s %s','delimiter');
            HSke=str2num(tmp{1}{1});
        end
        if (line_n == line_deviation)
            tmp=textscan(txt,'%*s %*s %*s %s','delimiter');
            deviation=str2num(tmp{1}{1});
        end
        if (line_n == line_Cp0)
            tmp=textscan(txt,'%*s %*s %s','delimiter');
            Cp0=str2num(tmp{1}{1});
        end
        if (line_n == line_Vdotalpha)
            tmp=textscan(txt,'%*s %*s %s','delimiter');
            Vdotalpha=str2num(tmp{1}{1});
        else
            Vdotalpha = 0;
        end
    end
    fclose(fid);

    % Check for unsteadiness in blade wake
   wake_data = dlmread('wake-angle','',3,0);
   wake_data = wake_data(:,2);
   [row,~] = size(wake_data);
   wake_max = max(wake_data((row-100):(row),:))*180/pi;
   wake_min = min(wake_data((row-100):(row),:))*180/pi;
   wake_deviation = (wake_max - wake_min);
%   wake_deviation = 0.1;

    if (wake_deviation >= cfd_model.wake_tolerance) % If variation detected in wake larger than specified wake_tolerance, assign cost=mean(Y) to that design
        if (nargin > 8)
	        set(handles.txtInfo,'String',sprintf('Post processing data... (%g)\n\tEvaluating cost function: WARNING - unsteadiness detected\n',iga));
        end
        fprintf('Post processing data... (%g)\n\tEvaluating cost function: WARNING - unsteadiness detected\n',iga);
        cost = feval(sprintf('costfuncCFD%d',CFDcostfuncno),Cske,HSke,deviation,Cp0,Vdotalpha,efficiency);
        unsteady = 1;
    else
        % Calculate Cost
        if (nargin > 8)
	        set(handles.txtInfo,'String',sprintf('Post processing data... (%g)\n\tEvaluating cost function: Complete\n',iga));
    	end
        fprintf('Post processing data... (%g)\n\tEvaluating cost function: Complete\n',iga);
        cost = feval(sprintf('costfuncCFD%d',CFDcostfuncno),Cske,HSke,deviation,Cp0,Vdotalpha,efficiency);
    end

else % If last Fluent data file does not exist, CFD must have failed and assign cost=mean(Y) to that design
	if (nargin > 8)
	    set(handles.txtInfo,'String',sprintf('Post processing data... (%g)\n\tEvaluating cost function: WARNING - CFD / Meshing not run\n',iga));
    end
    fprintf('Post processing data... (%g)\n\tEvaluating cost function: WARNING - CFD / Meshing not run\n',iga);
    cost = feval(sprintf('costfuncCFD%d',CFDcostfuncno),Cske,HSke,deviation,Cp0,Vdotalpha,efficiency);
    unsteady = 1;
end

% CD out of current chromosome directory
cd('..');

% Return newX and newY values
newX = x; newY = cost;
