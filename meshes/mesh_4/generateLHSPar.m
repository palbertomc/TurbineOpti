function [lhspar] = generateLHSPar(endwall_model,sample_size)

% Function to generate an initial geometry matrix using Latin Hypercube
% Sampling (LHS) for CFD database
%
% Input:
%   constantshi/lo -    upper and lower limits for initial geomtry matrix
%                       coefficients
%   heighthi/lo -       upper and lower limits for endwall amplitude
%                       scaling
%   sample_size -       no. of individuals in initial population
%   npar -              no. of parameters used in endwall parameterisation
%
% Output:
%   lhspar -            matrix (m x n) of geometry coefficient and scaling
%                       factors, m = no. of parameters, n = popsize
%
% J Bergh, 2013

% Generate intial unscaled parameter matrix using lhsdesign
lhspar = (endwall_model.constantshi - endwall_model.constantslo)*lhsdesign(sample_size,endwall_model.npar,'smooth','off') + endwall_model.constantslo;

% Scale parameters matrix to max / min amplitude heights
for col=(endwall_model.npar/endwall_model.no_lines):(endwall_model.npar/endwall_model.no_lines):endwall_model.npar
    
  for cycle=1:1:sample_size
      
      if lhspar(cycle,col) < 0
          lhspar(cycle,col) = (-1) * lhspar(cycle,col); % NB scaling must be positive
      end
    
      lhspar(cycle,col) = ((endwall_model.heighthi - endwall_model.heightlo) * lhspar(cycle,col));
  end
  
end
