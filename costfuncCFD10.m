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

function [cost] = costfuncCFD10(Cske,SKEH,deviation,Cp0,Vdotalpha,efficiency)

% Function to return selected function value from processed CFD data
%
% Input:
%   Cske/HSke/deviation/Cp0/Vdotalpha/efficiency -   processed data from
%                                                   extract.m and results.m
%
% Output:
%   cost -  function value to be returned to database
%
%   NB newSKEH COSTFUNCTION
%

% Coefficient of secondary kinetic energy (Cske)
f_Cske = Cske;                      
f_Cske = 0;                         % Comment to use in cost calculation

% Helicity.Secondary kinetic energy (SKEH)
f_SKEH = SKEH;                      
%f_SKEH = 0;                         % Comment to use in cost calculation

% Flow deviation (deviation)
f_dev = deviation;                  
f_dev = 0;                          % Comment to use in cost calculation

% Total pressure loss coefficient
f_Cp0 = Cp0;
f_Cp0 = 0;                          % Comment to use in cost calculation

% W dot Beta
f_Vdotalpha = Vdotalpha;
f_Vdotalpha = 0;                     % Comment to use in cost calculation

% Efficiency (total-total)
f_efficiency = efficiency;
f_efficiency = 0;                  % Comment to use in cost calculation

% Penalty functions
% Loss
% Datum case loss 0-100% mass average = 0.15837
if (Cp0 > 0.15837)
    c_Cp0 = (((Cp0-0.15837)/0.15837)*(100/1))^2;
    c_Cp0 = 0;                      % Comment to use in penalty calculation
else
    c_Cp0 = 0;
end

% Weightings                         % Cost quantity weightings
weight_Cske = 0;
weight_SKEH = 1;
weight_dev = 0;
weight_Cp0 = 0;
weight_Vdotalpha = 0;
weight_efficiency = 0;

% Calculate cost
cost = (weight_Cske*f_Cske*100) + (weight_SKEH*f_SKEH/1000) + ...
    (weight_dev*f_dev) + (weight_Cp0*f_Cp0*100) + (weight_Vdotalpha*(abs(1 - f_Vdotalpha)*100)) + ...
    (weight_efficiency*(1 - f_efficiency)*100) + (c_Cp0);
