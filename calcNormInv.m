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

function x = calcNormInv(p,mu,sigma)

% Function to calculate the inverse of the normal CDF
%
% Input:
%   p -     input variable
%   mu -    distribution mean
%   sigma - distribution std deviation
%
% Output:
%   x -     output variable
%
% J Bergh, 2014

% Check input arguments and set defaults if required
if (nargin < 3)
    
    mu = 0;
    sigma = 1;
    
end

% Check for out of range parameters
sigma(sigma <= 0) = NaN;
p(p < 0 | 1 < p) = NaN;

x0 = -sqrt(2) .* erfcinv(2*p);

try 
    
    x = sigma .* x0 + mu;
    
catch
    
    error('calcNormInv: Non-scalar arguments must be the same size');
    
end
