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

function [output,cost] = selectVec(EIfunc,u,par,X,Y,theta,Ph,R,beta,f,endwall_model)

% Function to selection between trial and target vectors
%
% Input:
%   u -         trial input vector
%   par -       target input vector
%
% Output:
%   output -    vector containing either 'u' or 'x' depending on whether
%               f(u) or f(x) is better (lower)
%   cost -      costfunction value associated with output vector


% Get popsize (m) and no. of parameters (n)
[m,n] = size(par);

% Initialise vectors
f_u = zeros(m,1);
f_x = zeros(m,1);
output = zeros(m,n);
cost = zeros(m,1);

% Calculate EIfunc value for each target and trial vector
parfor i = 1:m
  
    if (checkConstraints8(endwall_model,u(i,:)) == 1)
        
        f_u(i) = 99999;
        
    else
        
        f_u(i) = (-1)*feval(EIfunc,u(i,:),X,Y,theta,Ph,R,beta,f);
        
    end
    
    if (checkConstraints8(endwall_model,par(i,:)) == 1)
        
        f_x(i) = 99999;
        
    else
        
        f_x(i) = (-1)*feval(EIfunc,par(i,:),X,Y,theta,Ph,R,beta,f);
        
    end
    
    % Assign outputs
    if (f_u(i) < f_x(i))
    
        output(i,:) = u(i,:);
        cost(i) = f_u(i);
        
    else
    
        output(i,:) = par(i,:);
        cost(i) = f_x(i);
    
    end
        
end

