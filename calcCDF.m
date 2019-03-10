function p = calcCDF(x,mu,sigma)

% Function to calculate the Cumulative distribution function for the normal
% distribution
%
% Input:
%   x -     input variable
%   mu -    distribution median
%   sigma - distribution std deviation
%
% Output:
%   p -     cdf result for x / mu / sigma
%
% J Bergh, 2014

% Set default values for mu & sigma if too few input arguments
if (nargin < 3)
    
    mu = 0;
    sigma = 1;
    
end

% Check for out of range parameters
sigma(sigma <= 0) = NaN;

try
    
    z = (x - mu) ./ sigma;
    
catch
    
    error('calcCDF: Non-scalar arguments must be the same size');
    
end

p = 0.5 * erfc(-z ./ sqrt(2));
