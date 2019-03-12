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

function MLE = costfunclogMLE(R,sigma2)

% Function to calculate Maximum Liklihood Estimate (MLE) of kriging model
% for theta optimisation
%
% Input:
%   R -     correlation matrix (n x n) of data points
%   sigma2 -variance of kriging model
%
% Ouput:
%   MLE -   Maximum Likelihood Estimate
%
% J Bergh, 2013

% Get no of data points in R
[~,n] = size(R);

% Calculate MLE
MLE = (-1)*(n*log(sigma2) + log(det(R)))/2;

end
