function x_c = simplexContractionO(simplex,NM_model)

% simplexReflection.m - Matlab function to compute reflection point for Nelder Mead optimisation algorithm
%
% Input:
%   simplex -       matrix of simplex vertices x parameters (npar+1 x npar)
%
% Output:
%   x_c -           vector (npar x 1) of reflected point coordinates
%
% J Bergh, 2014

% Calculate simplex centroid of best points for outside contraction
simplex_bar = sum(simplex(1:NM_model.npar,:)) / NM_model.npar;

% Calculate outside contraction point
x_c = (1 + NM_model.rho * NM_model.gamma) * simplex_bar - NM_model.rho * NM_model.gamma * simplex(NM_model.npar+1,:);