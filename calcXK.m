function A = calcXK(X)

% Function to generate 'XK' matrix for correlation matrix ('R') generation
%
% Input:
%   X -     matrix of data points (m x n) where m = parameters, n = no. of
%           points
%
% Ouput:
%   XK -     matrix of data points (n x n)
%
% J Bergh, 2013

% Get no of parameters and no of sample points
[m,~] = size(X);

% Create cell array to hold difference matrices
A = cell(m,1);

% Generate XK matrix
for k = 1:m
    
    XK = meshgrid(X(k,:));
    XK = abs(XK' - XK);

    A{k} = XK;
    
end