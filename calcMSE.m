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

function [RMSE,max_error] = calcMSE(y,Y)

% Function to calculate mean square error between prediction y and actual
% value Y
%
% Input:
%   y -     predicted function value
%   Y -     actual function value
%
% Ouput:
%   MSE -   mean square error between predicted and actual function values
%
% J Bergh, 2013

% Get sizes of y and Y
[m,n] = size(Y);
[a,b] = size(y);

if (m ~=a) || (n ~= b)
    error('Error - Vector y and Y must be the same length');
end

d = (y - Y);
RMSE = sqrt(sum(d.^2) / m);
max_error = max(abs(d));
