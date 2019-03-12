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

function f = fxConstant(X)

% Constant regression function for kriging model
%
% Input:
%   X -     matrix of input data points
%
% Output:
%   f -  vector of ones (1's) (n x 1)
%
% J Bergh, 2013

% Retrieve no of samples in X
[~,n] = size(X);

f = ones(n,1);

end
