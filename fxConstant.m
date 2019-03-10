function f = fxConstant(X)

% Constant regression function for kriging model
%
% Input:
%   X -     matrix of input data points
%
% Output:
%   f -  vector of ones (1's) (n x 1)
%
% J Bergh, 2013

% Retrieve no of samples in X
[~,n] = size(X);

f = ones(n,1);

end
