function [RMSE,max_error] = calcMSE(y,Y)

% Function to calculate mean square error between prediction y and actual
% value Y
%
% Input:
%   y -     predicted function value
%   Y -     actual function value
%
% Ouput:
%   MSE -   mean square error between predicted and actual function values
%
% J Bergh, 2013

% Get sizes of y and Y
[m,n] = size(Y);
[a,b] = size(y);

if (m ~=a) || (n ~= b)
    error('Error - Vector y and Y must be the same length');
end

d = (y - Y);
RMSE = sqrt(sum(d.^2) / m);
max_error = max(abs(d));
