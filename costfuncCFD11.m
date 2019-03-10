function [cost] = costfuncCFD11(Cske,SKEH,deviation,Cp0,Vdotalpha,efficiency)

% Function to return selected function value from processed CFD data
%
% Input:
%   Cske/HSke/deviation/Cp0/Vdotalpha/efficiency -   processed data from
%                                                   extract.m and results.m
%
% Output:
%   cost -  function value to be returned to database
%
% J Bergh, 2014

% Coefficient of secondary kinetic energy (Cske)
f_Cske = Cske;                      
f_Cske = 0;                         % Comment to use in cost calculation

% Helicity.Secondary kinetic energy (SKEH)
f_SKEH = SKEH;                      
f_SKEH = 0;                         % Comment to use in cost calculation

% Flow deviation (deviation)
f_dev = deviation;                  
f_dev = 0;                          % Comment to use in cost calculation

% Total pressure loss coefficient
f_Cp0 = Cp0;
f_Cp0 = 0;                          % Comment to use in cost calculation

% W dot Beta
f_Vdotalpha = Vdotalpha;
%f_Vdotalpha = 0;                     % Comment to use in cost calculation

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
weight_SKEH = 0;
weight_dev = 0;
weight_Cp0 = 0;
weight_Vdotalpha = 1;
weight_efficiency = 0;

% Calculate cost
cost = (weight_Cske*f_Cske*100) + (weight_SKEH*f_SKEH/100000) + ...
    (weight_dev*f_dev) + (weight_Cp0*f_Cp0*100) + (weight_Vdotalpha*((1 - f_Vdotalpha)^2 *1000)) + ...
    (weight_efficiency*(1 - f_efficiency)*100) + (c_Cp0);
