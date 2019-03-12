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

function [y,stdR] = crossValidate(X,Y,theta,Ph,f)

% Function to calculate crossvalidate predictions for kriging model
%
% Input:
%   X -         matrix of data point coordinates
%   Y -         vector of corresponding function values
%   theta -     vector of therta weightings
%   Ph -        exponent for correlation
%
% Output:
%   y -         vector of crossvalidated predictions for Y
%   stdR -      vector of standard residuals
%
% J Bergh, 2014

% Get size of data base
[~,n] = size(X);

% Conduct L-O-O crossvalidation

for i = 1:1:n
    Xold = X;
    Xnew = X;
    Yi = Y;
    fi = f;
    Xnew(:,i) = [];
    Yi(i,:) = [];
    fi(i,:) = [];
    ri = calcRvec(Xold(:,i),Xnew,theta,Ph);
    Ai = calcXK(Xnew);
    Ri = calcRrevised(Ai,theta,Ph);
    betai = calcBeta(fi,Ri,Yi);
    [y(i,1),MSE(i,1)] = predict(ri,Ri,Yi,betai,fi);
    stdR(i,1) = ((Y(i) - y(i)) / sqrt(MSE(i)));
end

