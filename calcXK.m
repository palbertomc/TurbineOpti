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

function A = calcXK(X)

% Function to generate 'XK' matrix for correlation matrix ('R') generation
%
% Input:
%   X -     matrix of data points (m x n) where m = parameters, n = no. of
%           points
%
% Ouput:
%   XK -     matrix of data points (n x n)
%


% Get no of parameters and no of sample points
[m,~] = size(X);

% Create cell array to hold difference matrices
A = cell(m,1);

% Generate XK matrix
for k = 1:m
    
    XK = meshgrid(X(k,:));
    XK = abs(XK' - XK);

    A{k} = XK;
    
end
