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

function y = calcQPos(x)

% Function to calculation quantile positions for Q-Q plot
%
% Input:
%   x -     vector of input values
%
% Output:
%   y -     vector of quantiles
%

% Get size of x
[n,m] = size(x);


ntot = sum(~isnan(x));

y = repmat((1:n)',1,m);
y = (y - 0.5) ./ repmat(ntot,n,1);
y(isnan(x)) = NaN;
