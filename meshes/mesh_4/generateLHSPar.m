% TurbineOpti
% Copyright (C) 2019  J. Bergh
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

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
