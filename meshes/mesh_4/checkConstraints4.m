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

function checkConstraints4(xopt)

% Function to check the compliance of xopt with various constraints. Prints
% message to screen indicating which constraint(s) are violated
%
% Input:
%   xopt -      input vector to check
%
% Output:
%   null
%

% Get columns in xopt
[~,n] = size(xopt);
c_flag = 0;

% Set constraints
constantshi = 1;
constantslo = -1;
heighthi = 3.5;
amp_max = hhi * 2 * 0.8;

for j = 1:n

    % Boundary - constants (constantshi/lo)
    if ((mod(j,3) ~= 0) && ((xopt(j) > constantshi) || (xopt(j) < constantslo)))

        disp('Constants hi/lo violated');
        c_flag = 1;
        
    end

    % Boundary - constants (heighthi)
    if ((mod(j,3) == 0) && ((xopt(j) > heighthi) || (xopt(j) < 0)))

        disp('Height hi violated');
        c_flag = 1;
    
    end

end

% Feasibility - amplitude
%if ((abs(xopt(3) - xopt(6)) > amp_max) || (abs(xopt(6) - xopt(9)) > amp_max) || (abs(xopt(9) - xopt(12)) > amp_max))

if (abs(sqrt(xopt(2)^2 + xopt(1)^2)*xopt(3) - sqrt(xopt(5)^2 + xopt(4)^2)*xopt(6)) > amp_max || abs(sqrt(xopt(5)^2 + xopt(4)^2)*xopt(6) - sqrt(xopt(8)^2 + xopt(7)^2)*xopt(9)) > amp_max || ...
        abs(sqrt(xopt(8)^2 + xopt(7)^2)*xopt(9) - sqrt(xopt(11)^2 + xopt(10)^2)*xopt(12)) > amp_max)
    
    disp('Amp_max violated');
    c_flag = 1;

end

% Feasibility - Phase angle
if ((abs(atan2(xopt(2),xopt(1)) - atan2(xopt(5),xopt(4))) > 0.7854) || (abs(atan2(xopt(5),xopt(4)) - atan2(xopt(8),xopt(7))) > 0.7854) ...
        || (abs(atan2(xopt(8),xopt(7)) - atan2(xopt(11),xopt(10))) > 0.7854))

    disp('Phase angle violated');
    c_flag = 1;

end
    
if (c_flag == 0)
    
    disp('All constraints satisfied');
    
end