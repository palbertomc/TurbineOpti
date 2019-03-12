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

function p = calcCDF(x,mu,sigma)

% Function to calculate the Cumulative distribution function for the normal
% distribution
%
% Input:
%   x -     input variable
%   mu -    distribution median
%   sigma - distribution std deviation
%
% Output:
%   p -     cdf result for x / mu / sigma
%
% J Bergh, 2014

% Set default values for mu & sigma if too few input arguments
if (nargin < 3)
    
    mu = 0;
    sigma = 1;
    
end

% Check for out of range parameters
sigma(sigma <= 0) = NaN;

try
    
    z = (x - mu) ./ sigma;
    
catch
    
    error('calcCDF: Non-scalar arguments must be the same size');
    
end

p = 0.5 * erfc(-z ./ sqrt(2));
