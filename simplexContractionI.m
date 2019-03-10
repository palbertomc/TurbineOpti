function x_c = simplexContractionI(simplex,NM_model)

% simplexContractionI.m - Matlab function to compute inside constraction point for Nelder Mead optimisation algorithm
%
% Input:
%   simplex -       matrix of simplex vertices x parameters (npar+1 x npar)
%
% Output:
%   x_c -           vector (npar x 1) of inside contraction point coordinates
%
% J Bergh, 2014

% Calculate simplex centroid of best points for inside contraction
simplex_bar = sum(simplex(1:NM_model.npar,:))/NM_model.npar;

% Calculate inside contraction point
x_c = (1 - NM_model.gamma) * simplex_bar + NM_model.gamma * simplex(NM_model.npar+1,:);
