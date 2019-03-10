function newpar = generatePar8(endwall_model,popsize)

% Function to generate geometry matrix for contoured endwalls
% (PHASE SHIFT VERSION)
%
%                            |n*pi*theta         |
%   R(theta) = R0 + c_n * sin|----------  + gamma|
%                            |    P              |
% where:
%   R0      = mean turbine hub radius
%   c_n     = max curve amplitude
%   theta   = theta-coordinate
%   n       = curve periodicity
%   P       = blade pitch
%   gamma   = phase shift
%   
% Input:
%   harmonicshi/lo -    upper and lower limits for sinusiod periodicity
%
%   heighthi -          upper and lower limits for endwall maximum amplitude
%                       scaling
%
%   popsize -           no. of individuals in initial population
%
%   npar -              no. of parameters used in endwall parameterisation
%
% Output:
%   newpar -            matrix (m x n) of geometry coefficient and scaling
%                       factors, m = no. of parameters, n = popsize
%
% J Bergh, 2014

% Generate initial unscaled parameter matrix
newpar = rand(popsize,endwall_model.npar);

% Scale parameters matrix to max / min levels of design
% i.e. heighthi, max / min harmonics etc 
for cycle=1:1:popsize  
    
    % First, 0 <= c_n <= endwall_model.heighthi
    for col = [1,4,7,10]
        
        newpar(cycle,col) = endwall_model.heighthi * newpar(cycle,col); % NB scaling must be positive
        
    end
    
    % Second, scale the harmonic
    for col = [2,5,8,11]
        
        newpar(cycle,col) = (endwall_model.harmonicshi - endwall_model.harmonicslo) * newpar(cycle,col) + endwall_model.harmonicslo;
        
    end
    
    % Third, scale the phase angle of line_2 (1st line)
    for col = [3]
        
        newpar(cycle,col) = (pi - (-pi)) * newpar(cycle,col) + (-pi);
        
    end
    
    % Fourth,scale the phase shift angle of line_3 / 4 / 5 (2nd, 3rd, 4th)
    
    for col = [6,9,12]
        
        newpar(cycle,col) = (endwall_model.maxphase*pi/180 - (-endwall_model.maxphase*pi/180)) * newpar(cycle,col) + (-endwall_model.maxphase*pi/180);
        
    end
    
end