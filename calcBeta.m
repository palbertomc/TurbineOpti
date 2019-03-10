function beta = calcBeta(f,R,Y)

% Function to calculate 'beta' of kriging predictor
%
% Input:
%   f -     function handle to regression function
%   R -     correlation matrix (n x n)
%   Y -     vector (n x 1) of known data point values
%
% Ouput:
%   beta -  beta value in kriging predictor
%
% J Bergh, 2013

% Calculate estimate of beta
beta = (f'/R*Y)/(f'/R*f);
