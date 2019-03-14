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

function [c_flag,val] = checkConstraints8(endwall_model,xopt)

% Function to check the compliance of xopt with various constraints. Prints
% message to screen indicating which constraint(s) are violated
%
% Input:
%   xopt -      input vector to check
%
% Output:
%   c_flag -    boolean output 1 - constraints violated / 0 - contraints ok
%

% Set c_flag to zero
c_flag = 0;

% Set constraints
harmonicshi = endwall_model.harmonicshi;
harmonicslo = endwall_model.harmonicslo;
heighthi = endwall_model.heighthi;
heightlo = 0;
maxphase = endwall_model.maxphase;
max_amp_change = 2.0;
max_periodicity_change = 0.25;

% Boundary - constants (heighthi) (MAX CURVE HEIGHT)
if (any(xopt([1,4,7,10]) > heighthi) || any(xopt([1,4,7,10]) < heightlo))

    %disp('Constraint Height hi violated');
    c_flag = 1;

end

% Boundary constraints - constants (harmonicshi/lo) (MAX-MIN PERIODICITY)
if (any(xopt([2,5,8,11]) > harmonicshi) || any(xopt([2,5,8,11]) < harmonicslo))

    %disp('Constraint harmonics hi/lo violated');
    c_flag = 1;

end

% Phase angle (PHASE ANGLE CURVE 1)
if ((xopt(3) > 180*pi/180) || (xopt(3) < -180*pi/180))
 
    %disp('Phase angle violated');
    c_flag = 1;
 
end

% Phase shift (MAX PHASE ANGLE SHIFT CURVES 1-2,2-3,3-4)
if (any(xopt([6,9,12]) > maxphase*pi/180) || any(xopt([6,9,12]) < (-1)*maxphase*pi/180))
    
    %disp('Phase shift max angle violated');
    c_flag = 1;
    
end

% Maximum periodicity change between lines (MAX PERIODICITY CHANGE CURVES 1-2,2-3,3-4)
if ((abs(xopt(2) - xopt(5)) > max_periodicity_change) || (abs(xopt(5) - xopt(8)) > max_periodicity_change)...
        || (abs(xopt(8) - xopt(11)) > max_periodicity_change))
    
    %disp('Periodicity change violated');
    c_flag = 1;
    
end

% Maximum amplitude change between lines (MAX AMPLITUDE CHANGE CURVES 1-2,2-3,3-4)
if ((abs(0 - xopt(1)) > max_amp_change) || (abs(xopt(1) - xopt(4)) > max_amp_change) || (abs(xopt(4) - xopt(7)) > max_amp_change)...
        || (abs(xopt(7) - xopt(10)) > max_amp_change))
    
    %disp('Amplitude change violated');
    c_flag = 1;
    
end

% Monotonicity constraint
[~,maxampind] = max(xopt([1,4,7,10]));
amplitudes = xopt([1,4,7,10]);
a = [1:1:maxampind]; b = [maxampind:1:4];
no_prelines = max(size(a)); no_postlines = max(size(b));

if (maxampind ~= 1)
    for i = 1:1:(no_prelines-1)
    
        if (amplitudes(i) > amplitudes(i+1))
        
            %disp('Preline monotonicity violated');
            c_flag = 1;
        
        end
    
    end
end

if (maxampind ~= 4)
    
    for j = maxampind:1:3

        if (amplitudes(j) < amplitudes(j+1))
        
            %disp('Postline monotonicity violated');
            c_flag = 1;
        
        end
        
    end
    
end

% Else if everything is OK ...
if (c_flag == 0)
    
    %disp('All constraints satisfied');
    
end

val = 0;
