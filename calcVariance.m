function sigma2 = calcVariance(f,beta,R,Y)

% Function to calculate variance of kriging model
%
% Input:
%   f -     function handle to regression function
%   beta -  estimated regression constant
%   R -     correlation matrix (n x n)
%   Y -     vector (n x 1) of known data point values
%
% Ouput:
%   sigma2 -  beta value in kriging predictor
%
% J Bergh, 2013

% Get no of sample points in fitting data
[m,~] = size(Y);

% Calculate variance 'sigma^2'
sigma2 = ((Y - f*beta)'/R*(Y - f*beta))/(m);

end
