function x_s = simplexShrink(simplex,NM_model)

% simplexShrink.m - Matlab function to compute shrink points for Nelder Mead optimisation algorithm
%
% Input:
%   simplex -       matrix of simplex vertices x parameters (npar+1 x npar)
%
% Output:
%   x_s -           matrix (npar+1 x npar) of shrink point coordinates
%
% J Bergh, 2014

% Set best point as first output vertex
x_s(1,:) = simplex(1,:);

% Shrink remaining simplex points towards first output vertex
for i = 2:1:NM_model.npar+1
    x_s(i,:) = NM_model.sigma * simplex(i,:) + (1 - NM_model.sigma) * simplex(1,:);
end