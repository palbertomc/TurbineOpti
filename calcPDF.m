function y = calcPDF(x,mu,sigma)

% Function to calculate the Normal Probability Density function
%
% Input:
%   x -     input variable
%   mu -    distribution median
%   sigma - distribution std deviation
%
% Output:
%   y -     output variable
%
% J Bergh, 2014

% Default values for mu & sigma

if (nargin < 3)
    
    mu = 0;
    sigma = 1;
    
end

% Check for out of bounds parameters
sigma(sigma <= 0) = NaN;

% Calculate probability

try
    
    y = exp(-0.5 * ((x - mu)./sigma).^2) ./ (sqrt(2*pi) .* sigma);
    
catch
    
    error('calcPDF: Non-scalar arguments must be the same size');
    
end
