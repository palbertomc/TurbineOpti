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

function sigma2 = calcVariance(f,beta,R,Y)

% Function to calculate variance of kriging model
%
% Input:
%   f -     function handle to regression function
%   beta -  estimated regression constant
%   R -     correlation matrix (n x n)
%   Y -     vector (n x 1) of known data point values
%
% Ouput:
%   sigma2 -  beta value in kriging predictor
%
% J Bergh, 2013

% Get no of sample points in fitting data
[m,~] = size(Y);

% Calculate variance 'sigma^2'
sigma2 = ((Y - f*beta)'/R*(Y - f*beta))/(m);

end
