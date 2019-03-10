function x = calcNormInv(p,mu,sigma)

% Function to calculate the inverse of the normal CDF
%
% Input:
%   p -     input variable
%   mu -    distribution mean
%   sigma - distribution std deviation
%
% Output:
%   x -     output variable
%
% J Bergh, 2014

% Check input arguments and set defaults if required
if (nargin < 3)
    
    mu = 0;
    sigma = 1;
    
end

% Check for out of range parameters
sigma(sigma <= 0) = NaN;
p(p < 0 | 1 < p) = NaN;

x0 = -sqrt(2) .* erfcinv(2*p);

try 
    
    x = sigma .* x0 + mu;
    
catch
    
    error('calcNormInv: Non-scalar arguments must be the same size');
    
end
