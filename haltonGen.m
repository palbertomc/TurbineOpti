function A = haltonGen(pop,ndim,vlo,vhi)

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

A = zeros(pop,ndim);

for i = 1:pop
    
    for j = 1:ndim
        
        if (nargin > 2)
            
            A(i,j) = (vhi(j) - vlo(j)).*haltonSequence(i,j) + vlo(j);
            
        else
            
            A(i,j) = haltonSequence(i,j);
            
        end
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auxillary function
function sum = haltonSequence(i,j)

% Function to calculate the next number in the Halton quasi-random number
% sequence for space-filling for up to 12 dimensions
%
% J Bergh, 2014

primelist = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37];

p1 = primelist(j);
p2 = p1;
sum = 0;

while (i > 0)
    
    x = mod(i,p1);
    sum = sum + x/p2;
    i = floor(i/p1);
    p2 = p2 * p1;
    
end