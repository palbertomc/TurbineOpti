function [y,MSE] = predict(r,R,Y,beta,f)

% Predictor function for kriging model
%
% Input:
%   r -     correlation vector (n x 1)
%   f -     function handle to regression function
%   R -     correlation matrix (n x n)
%   Y -     vector (n x 1) of known data point values
%   beta -  regression constant
%
% Ouput:
%   y -     predicted function value
%   MSE -  mean square error of prediction
%
% J Bergh, 2013

y = beta + r'/R*(Y-f*beta);

MSE = calcVariance(f,beta,R,Y)*(1 - r'/R*r + ((1 - f'/R*r)^2)/(f'/R*f));

end
