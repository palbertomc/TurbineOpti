function MLE = costfunclogMLE(R,sigma2)

% Function to calculate Maximum Liklihood Estimate (MLE) of kriging model
% for theta optimisation
%
% Input:
%   R -     correlation matrix (n x n) of data points
%   sigma2 -variance of kriging model
%
% Ouput:
%   MLE -   Maximum Likelihood Estimate
%
% J Bergh, 2013

% Get no of data points in R
[~,n] = size(R);

% Calculate MLE
MLE = (-1)*(n*log(sigma2) + log(det(R)))/2;

end
