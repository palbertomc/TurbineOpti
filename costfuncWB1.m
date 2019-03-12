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

function cost = costfuncWB1(x,X,Y,theta,Ph,R,beta,f)

% Function to calculate the Watson & Barnes 1 (WB1) EI criteria value for the EGO
% algorithm
%
% Input:
%   x -       input vector (1 x m) m = no. of dimensions
%
% Output:
%   cost -      EI output (scalar) for input vector x
%
% J Bergh, 2013

% Predict y for input vector x
r = calcRvec(x',X,theta,Ph);
minY = min(Y);

[y,MSE] = predict(r,R,Y,beta,f);
s = sqrt(MSE);

% Calculate EI

if (s == 0)
    
    cost = 0;
    
elseif (s > 0)
    
    cost = calcCDF((minY - y)/s);
    
else
    
    % Do nothing
    
end
