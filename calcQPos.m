function y = calcQPos(x)

% Function to calculation quantile positions for Q-Q plot
%
% Input:
%   x -     vector of input values
%
% Output:
%   y -     vector of quantiles
%
% J Bergh, 2014

% Get size of x
[n,m] = size(x);


ntot = sum(~isnan(x));

y = repmat((1:n)',1,m);
y = (y - 0.5) ./ repmat(ntot,n,1);
y(isnan(x)) = NaN;
