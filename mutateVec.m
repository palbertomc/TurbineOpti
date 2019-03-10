function [v,ndiff,rcomb] = mutateVec(x,F)

% Function to select mutation vectors
%
% Input:
%   x -       matrix of input target vectors (m x n), (m = pop, n = ndim)
%   F -       scale factor (0,1+)
%
% Output:
%   v -       matrix of output mutant vectors (m x n)
%
% J Bergh, 2013

% Get no. of parameters from input target vector matrix
[m,n] = size(x);

v = zeros(m,n);
ndiff = zeros(m,1); 
rcomb = zeros(m,3);

for i= 1:1:m
    
    r0 = 0; r1 = 0; r2 = 0;
    
    while (r0 == i) || (r0 == 0)
        r0 = floor(rand(1)*m);
    end
    
    while (r1 == r0) || (r1 == i) || (r1 == 0)
        r1 = floor(rand(1)*m);
    end
    
    while (r2 == r1) || (r2 == r0) || (r2 == i) || (r2 == 0)
        r2 = floor(rand(1)*m);
    end
        
    d = x(r1,:) - x(r2,:);
    v(i,:) = x(r0,:) + F * d;
    ndiff(i) = norm(d,2);
    rcomb(i,:) = [r0,r1,r2];

end
