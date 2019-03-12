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

function [newX,newY] = addData(X,Y,addX,addY)

% Function to add newX & newY to X & Y data
%
% Input:
%   X -         existing X data
%   Y -         existing Y data
%   addX -      new X data to be added
%   addY -      new Y data to be added
%
% Output:
%   newX -      augmented X data
%   newY -      augmented Y data
%
% J Bergh, 2013

% Check size of existing X data
[~,n] = size(X);

% Add new data points
X(:,n+1) = transpose(addX);
Y(n+1) = addY;

% Assign return values
newX = X;
newY = Y;
