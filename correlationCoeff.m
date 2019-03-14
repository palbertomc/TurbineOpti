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

function [rsquared] = correlationCoeff(f,fhat)

% Function to calculate crossvalidate predictions for kriging model
%
% Input:
%   f -         vector of true (CFD / real) OF values
%   fhat -      vector of corresponding predicted OF values
%
% Output:
%   rsquared -  corr coeff (scalar)
%

% check inputs
if (nargin < 2)
    
    error('Not enough input arguments');
    
elseif (length(f) ~= length(fhat))
    
    error('Input vectors must be the same length');
    
elseif ((min(size(f)) ~= 1) || (min(size(fhat)) ~= 1))
    
    error('Inputs must be vectors only');
    
end
   
% Get no of real inputs
n = length(f);

% Calc correlation coefficient

rsquared = ((n * sum((f.*fhat)) - (sum(f) * sum(fhat))) / sqrt((n * sum(f.^2) - (sum(f))^2) * (n * sum(fhat.^2) - (sum(fhat))^2)))^2;
