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

function [R,condR] = calcRrevised(A,theta,Ph)

% Function to calculate correlation matrix 'R' between input sample point
% set 'X'
%
% Input:
%   A -     cell array of data point differences (Size of A is equal to
%           ndim of the problem i.e. if ndim = 2, A = cell(2,1)
%   theta - column vector of correlation weights (m x 1)
%   Ph -    distance formula exponent (1 - exponential, 2 - Gaussian)
%
% Ouput:
%   R -     matrix of correlations (n x n)
%   condR - condition indicator of R matrix (1 = good, condR >> 1 = poor)
%
% J Bergh, 2013

% Get no of dimensions in data and no. of data points
[m,~] = size(A);
[~,n] = size(A{1});

% Check length of theta equals no of parameters in X
if (length(theta) ~= m)
    error('calcR error - Length of theta must be equal to number of parameters in X');
end

% Pre-allocate memory for 'R'
R = zeros(n,n);

%tic()

for k = 1:m
    
    R = R + theta(k)*A{k}.^Ph;
 
end
 
R = exp(-R);

%toc()

% Tikhonov regularisation
mu = eye(n,n)*(10 * m)*eps;
R = R + mu;

% Condition number
condR = cond(R);

% Calculate Cholesky decomposition of R
%L = chol(R);

end
