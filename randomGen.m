function A = randomGen(pop,ndim,vlo,vhi)

% Wrapper function to generate matrix (pop x ndim) of points between [0,1)
% based on the Halton sequence
%
% Input:
%   pop -       no. of points to create
%   ndim -      no. of dimensions of each point
%   vlo -       variable lower bound
%   vhi -       variable upper bound
%
% Output:
%   A -         Matrix (pop x ndim) of data point coordinates
%
% J Bergh, 2014

A = rand(pop,ndim);

for i = 1:pop
    
    for j = 1:ndim
        
        if (nargin > 2)
            
            A(i,j) = (vhi(j) - vlo(j)).*A(i,j) + vlo(j);
            
        else
            
            A(i,j) = A(i,j);    % Do nothing
            
        end
        
    end
    
end