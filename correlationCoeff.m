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
% J Bergh, 2015

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