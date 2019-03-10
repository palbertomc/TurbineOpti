function u = crossOver(v,x,Cr)

% Function to perform dual crossover of trial vector
%
% Input:
%   v -         matrix of mutatant input vectors (m x n)
%   x -         matrix of target input vectors (m x n)
%   Cr -        crossover probablilty (0,1)
%
% Ouput:
%   u -         matrix of trial output vectors (m x n)
%
% J Bergh, 2013

% Get popsize (m) and no of dimensions (n) from input mutant vector matrix
[m,n] = size(v);
u = zeros(m,n);

% For each of the input vectors
for i = 1:1:m
    
    % Compute a random crossover parameter index
    jrand = ceil(rand(1)*n);
    
    % for each vector component
    for j = 1:1:n
       if (rand(1) <= Cr) || (j == jrand)
            
            u(i,j) = v(i,j);
            
        else
            
            u(i,j) = x(i,j);
            
        end
    end
end
        
