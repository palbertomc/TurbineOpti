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

function A = lhsGen(pop,ndim,vlo,vhi)

% Wrapper function to generate matrix (pop x ndim) of points between [0,1)
% based on the Latin Hyper Squares approach
%
% Input:
%   pop -       no. of points to create
%   ndim -      no. of dimensions of each point
%   vlo -       vector (1 x ndim) of variable lower bounds
%   vhi -       vector (1 x ndim) of variable upper bounds
%
% Output:
%   A -         matrix (pop x ndim) of data point coordinates
%
% J Bergh, 2014

A = lhsdesign(pop,ndim,'criterion','maximin','iterations',pop*ndim*500);

for i = 1:pop
    
    for j = 1:ndim
        
        if (nargin > 2)
            
            A(i,j) = (vhi(j) - vlo(j)).*A(i,j) + vlo(j);
            
        else
            
            A(i,j) = A(i,j);    % Do nothing
            
        end
        
    end
    
end
