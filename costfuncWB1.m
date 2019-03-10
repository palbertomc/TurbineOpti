function cost = costfuncWB1(x,X,Y,theta,Ph,R,beta,f)

% Function to calculate the Watson & Barnes 1 (WB1) EI criteria value for the EGO
% algorithm
%
% Input:
%   x -       input vector (1 x m) m = no. of dimensions
%
% Output:
%   cost -      EI output (scalar) for input vector x
%
% J Bergh, 2013

% Predict y for input vector x
r = calcRvec(x',X,theta,Ph);
minY = min(Y);

[y,MSE] = predict(r,R,Y,beta,f);
s = sqrt(MSE);

% Calculate EI

if (s == 0)
    
    cost = 0;
    
elseif (s > 0)
    
    cost = calcCDF((minY - y)/s);
    
else
    
    % Do nothing
    
end
