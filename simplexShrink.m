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

function x_s = simplexShrink(simplex,NM_model)

% simplexShrink.m - Matlab function to compute shrink points for Nelder Mead optimisation algorithm
%
% Input:
%   simplex -       matrix of simplex vertices x parameters (npar+1 x npar)
%
% Output:
%   x_s -           matrix (npar+1 x npar) of shrink point coordinates
%
% J Bergh, 2014

% Set best point as first output vertex
x_s(1,:) = simplex(1,:);

% Shrink remaining simplex points towards first output vertex
for i = 2:1:NM_model.npar+1
    x_s(i,:) = NM_model.sigma * simplex(i,:) + (1 - NM_model.sigma) * simplex(1,:);
end
