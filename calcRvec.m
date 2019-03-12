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

function r = calcRvec(x,X,theta,Ph)

% Function to calculate correlation vector 'r'
%
% Input:
%   x -     prediction point (m x 1)
%   X -     input data points (m x n)
%   theta - kriging model weights (m x 1) 
%   Ph -    correlation exponent (exponential - Ph = 1, Gaussian - Ph = 2) 
%
% Ouput:
%   r -     correlation vector (n x 1)
%
% J Bergh, 2013

% Get sizes of x and X
% [a,~] = size(x);
[~,n] = size(X);

% Compute correlation vector
r = zeros(n,1);

for i = 1:1:n
    r(i,1) = exp(-1*(sum(theta.*(abs((x - X(:,i)).^Ph)))));
end

end
