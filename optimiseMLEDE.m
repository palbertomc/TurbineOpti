% TurbineOpti
% Copyright (C) 2019  J. Bergh
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

function [theta,MLE,iga,telapsed] = optimiseMLEDE(fmodel,tolerance,GUIhandles)

% Function to maximise objective function for MLE using the Differential
% evolution algorithm of Storn and Price (1996)
%
% Input
%   fitmodel -  struct
%            -  maxit = maximum GA iterations
%            -  theta0 = initial theta values
%
% Output
%   MLE -       maximum value of MLE function
%   theta -     theta weights which maximise MLE
%   iga -       No. of iteration generations

% Start fitting timer
tstart = tic;

% Get gui handle data
if (nargin > 2)
    handles = guidata(GUIhandles);
end

%-------------------------------------------------------------------------%
% Initialise parameters
%-------------------------------------------------------------------------%
npar = fmodel.npar; objfunc = fmodel.objfunc;
varhi = fmodel.varhi; varlo = fmodel.varlo;
X = fmodel.X; Y = fmodel.Y;
Ph = fmodel.Ph; f = fmodel.f;

maxit = fmodel.maxit;
mincost = -1e200;

popsize = fmodel.popsize;
F = 0.8;
Cr = 0.8;

debug = 'n';

%-------------------------------------------------------------------------%
% Create initial population
%-------------------------------------------------------------------------%
iga = 0;
par = 10.^((varhi-varlo).*rand(npar,popsize) + (varlo));
%par = 10.^((varhi-varlo).*haltonGen(npar,popsize) + (varlo));

% Get no. of parameters (n) and popsize (m)
[n,m] = size(par);
    
%-------------------------------------------------------------------------%
% Calculate A-matrix for kriging system
%-------------------------------------------------------------------------%
A = calcXK(X);

%-------------------------------------------------------------------------%
% Iterate
%-------------------------------------------------------------------------%
while (iga < maxit)
       
    iga = iga + 1;
    
    %---------------------------------------------------------------------%
    % Perform vector mutation
    %---------------------------------------------------------------------%
    v = zeros(n,m);

    for i= 1:m

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

        d = par(:,r1) - par(:,r2);
        v(:,i) = par(:,r0) + F * d;

    end
    
    %---------------------------------------------------------------------%
    % Perform vector crossover
    %---------------------------------------------------------------------%
    u = zeros(n,m);
    
    for i = 1:m

        % Compute a random crossover parameter index
        jrand = ceil(rand(1)*n);

        % for each vector component
        for j = 1:n
           if ((rand(1) <= Cr) || (j == jrand))

                u(j,i) = v(j,i);

            else

                u(j,i) = par(j,i);

            end
        end
    end
    
    %---------------------------------------------------------------------%
    % Run vector selection routine
    %---------------------------------------------------------------------%
    f_u = zeros(m,1);
    f_par = zeros(m,1);
    cost = zeros(m,1);
    condR = zeros(m,1);
    
    % Calculate objfunc value for each target and trial vector
    parfor i = 1:m

        % Check boundary constraints on theta and if ok, calc objfunc
        if ((any(u(:,i) > 10^varhi)) || (any(u(:,i) < 10^varlo)))

            f_u(i) = 99999;

        else

            % Make R, beta and sigma2
            [R,condR(i)] = calcRrevised(A,u(:,i),Ph);
            beta = calcBeta(f,R,Y);
            sigma2 = calcVariance(f,beta,R,Y);

            % Calculate logMLE
            f_u(i) = (-1)*feval(objfunc,R,sigma2);           

        end
        
        % Check constraints on objfunc
        if (condR(i) > 1e15)
            
            f_u(i) = 99999;
            
        elseif ((f_u(i) > 1e15) || (f_u(i) < -1e15))
                       
            f_u(i) = 99999;
            
        end

        % Check boundary constraints on each theta and if ok, calc objfunc
        if ((any(par(:,i) > 10^varhi)) || (any(par(:,i) < 10^varlo)))

            f_par(i) = 99999;

        else

            % Make R, beta and sigma2
            [R,condR(i)] = calcRrevised(A,par(:,i),Ph);
            beta = calcBeta(f,R,Y);
            sigma2 = calcVariance(f,beta,R,Y);

            % Calculate logMLE
            f_par(i) = (-1)*feval(objfunc,R,sigma2);           

        end
        
        % Check constraints on objfunc
        if (condR(i) > 1e15)
            
            f_par(i) = 99999;
            
        elseif ((f_par(i) > 1e15) || (f_par(i) < -1e15))
            
            f_par(i) = 99999;
            
        end

        % Select best performing vectors and assign cost vector
        if (f_u(i) < f_par(i))

            par(:,i) = u(:,i);
            cost(i) = f_u(i);

        else

            par(:,i) = par(:,i);
            cost(i) = f_par(i);

        end

    end
    
    %---------------------------------------------------------------------%
    % Do stats
    %---------------------------------------------------------------------%
    minc(iga) = min(cost);
    meanc(iga) = mean(cost);
    maxc(iga) = max(cost); 
    
    %---------------------------------------------------------------------%
    % Check stopping criteria
    %---------------------------------------------------------------------%
    if ((abs(minc(iga)-maxc(iga)) < tolerance) && (iga > 1000))
        break
    end
       
end

%---------------------------------------------------------------------%
% Sort costs and parameters
%---------------------------------------------------------------------%
%[cost,ind] = sort(cost);  %%MISTAKE HERE I THINK
[costopt,ind] = min(cost);
paropt = par(:,ind);
    
%---------------------------------------------------------------------%
% Assign outputs
%---------------------------------------------------------------------%
theta = paropt;
MLE = (-1)*costopt;

% Plot progress
if (nargin > 2)
    axes(handles.axes3);
    iters = 0:length(minc)-1;
    plot(iters,(-1)*minc,'-b');
    grid on;
    xlabel('Iteration'); ylabel('MLE');
end

% Stop fitting timer and calculate elapsed time
telapsed = toc(tstart);
