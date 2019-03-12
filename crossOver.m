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

function u = crossOver(v,x,Cr)

% Function to perform dual crossover of trial vector
%
% Input:
%   v -         matrix of mutatant input vectors (m x n)
%   x -         matrix of target input vectors (m x n)
%   Cr -        crossover probablilty (0,1)
%
% Ouput:
%   u -         matrix of trial output vectors (m x n)
%
% J Bergh, 2013

% Get popsize (m) and no of dimensions (n) from input mutant vector matrix
[m,n] = size(v);
u = zeros(m,n);

% For each of the input vectors
for i = 1:1:m
    
    % Compute a random crossover parameter index
    jrand = ceil(rand(1)*n);
    
    % for each vector component
    for j = 1:1:n
       if (rand(1) <= Cr) || (j == jrand)
            
            u(i,j) = v(i,j);
            
        else
            
            u(i,j) = x(i,j);
            
        end
    end
end
        
