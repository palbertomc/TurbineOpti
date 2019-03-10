function [newX,newY] = addData(X,Y,addX,addY)

% Function to add newX & newY to X & Y data
%
% Input:
%   X -         existing X data
%   Y -         existing Y data
%   addX -      new X data to be added
%   addY -      new Y data to be added
%
% Output:
%   newX -      augmented X data
%   newY -      augmented Y data
%
% J Bergh, 2013

% Check size of existing X data
[~,n] = size(X);

% Add new data points
X(:,n+1) = transpose(addX);
Y(n+1) = addY;

% Assign return values
newX = X;
newY = Y;
