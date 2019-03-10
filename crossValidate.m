function [y,stdR] = crossValidate(X,Y,theta,Ph,f)

% Function to calculate crossvalidate predictions for kriging model
%
% Input:
%   X -         matrix of data point coordinates
%   Y -         vector of corresponding function values
%   theta -     vector of therta weightings
%   Ph -        exponent for correlation
%
% Output:
%   y -         vector of crossvalidated predictions for Y
%   stdR -      vector of standard residuals
%
% J Bergh, 2014

% Get size of data base
[~,n] = size(X);

% Conduct L-O-O crossvalidation

for i = 1:1:n
    Xold = X;
    Xnew = X;
    Yi = Y;
    fi = f;
    Xnew(:,i) = [];
    Yi(i,:) = [];
    fi(i,:) = [];
    ri = calcRvec(Xold(:,i),Xnew,theta,Ph);
    Ai = calcXK(Xnew);
    Ri = calcRrevised(Ai,theta,Ph);
    betai = calcBeta(fi,Ri,Yi);
    [y(i,1),MSE(i,1)] = predict(ri,Ri,Yi,betai,fi);
    stdR(i,1) = ((Y(i) - y(i)) / sqrt(MSE(i)));
end

