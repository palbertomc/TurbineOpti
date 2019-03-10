function newpar = generatePar4(endwall_model,popsize)

% Function to generate geometry matrix for contoured endwalls
%
% Input:
%   constantshi/lo -    upper and lower limits for initial geomtry matrix
%                       coefficients
%   heighthi/lo -       upper and lower limits for endwall amplitude
%                       scaling
%   popsize -           no. of individuals in initial population
%   npar -              no. of parameters used in endwall parameterisation
%
% Output:
%   newpar -            matrix (m x n) of geometry coefficient and scaling
%                       factors, m = no. of parameters, n = popsize
%
% J Bergh, 2013

% Generate intial unscaled parameter matrix
newpar = (endwall_model.constantshi - endwall_model.constantslo) * rand(popsize,endwall_model.npar) + endwall_model.constantslo;

% Scale parameters matrix to max / min amplitude heights
for col = (endwall_model.npar/endwall_model.no_lines):(endwall_model.npar/endwall_model.no_lines):endwall_model.npar
    
    for cycle=1:1:popsize  
        
        if (newpar(cycle,col) < 0)
            
            newpar(cycle,col) = (-1) * newpar(cycle,col); % NB scaling must be positive
            
        end
        
        newpar(cycle,col) = endwall_model.heighthi * newpar(cycle,col);
        
    end
end
