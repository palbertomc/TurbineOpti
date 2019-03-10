function r = calcRvec(x,X,theta,Ph)

% Function to calculate correlation vector 'r'
%
% Input:
%   x -     prediction point (m x 1)
%   X -     input data points (m x n)
%   theta - kriging model weights (m x 1) 
%   Ph -    correlation exponent (exponential - Ph = 1, Gaussian - Ph = 2) 
%
% Ouput:
%   r -     correlation vector (n x 1)
%
% J Bergh, 2013

% Get sizes of x and X
% [a,~] = size(x);
[~,n] = size(X);

% Compute correlation vector
r = zeros(n,1);

for i = 1:1:n
    r(i,1) = exp(-1*(sum(theta.*(abs((x - X(:,i)).^Ph)))));
end

end
