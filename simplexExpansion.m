function x_e = simplexExpansion(simplex,NM_model)

% simplexExpansion.m - Matlab function to compute expansion point for Nelder Mead optimisation algorithm
%
% Input:
%   simplex -       matrix of simplex vertices x parameters (npar+1 x npar)
%
% Output:
%   x_e -           vector (npar x 1) of expanded point coordinates
%
% J Bergh, 2014

% Calculate simplex centroid of best points for expansion
simplex_bar = sum(simplex(1:NM_model.npar,:))/NM_model.npar;

% Calculate expansion point
x_e = (1 + NM_model.rho * NM_model.psi) * simplex_bar - NM_model.rho * NM_model.psi * simplex(NM_model.npar+1,:);
