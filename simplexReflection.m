function x_r = simplexReflection(simplex,NM_model)

% simplexReflection.m - Matlab function to compute reflection point for Nelder Mead optimisation algorithm
%
% Input:
%   simplex -       matrix of simplex vertices x parameters (npar+1 x npar)
%
% Output:
%   x_r -           vector (npar x 1) of reflected point coordinates
%
% J Bergh, 2014

% Calculate simplex centroid of best points for reflection
simplex_bar = sum(simplex(1:NM_model.npar,:))/NM_model.npar;

% Calculate reflection vertex
x_r = (1 + NM_model.rho) * simplex_bar - NM_model.rho * simplex(NM_model.npar+1,:);

