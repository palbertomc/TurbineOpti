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

function [y,MSE] = predict(r,R,Y,beta,f)

% Predictor function for kriging model
%
% Input:
%   r -     correlation vector (n x 1)
%   f -     function handle to regression function
%   R -     correlation matrix (n x n)
%   Y -     vector (n x 1) of known data point values
%   beta -  regression constant
%
% Ouput:
%   y -     predicted function value
%   MSE -  mean square error of prediction
%
% J Bergh, 2013

y = beta + r'/R*(Y-f*beta);

MSE = calcVariance(f,beta,R,Y)*(1 - r'/R*r + ((1 - f'/R*r)^2)/(f'/R*f));

end
