function [theta,MLE,iga] = optimiseMLE(GUIhandles,fmodel)

% Function to maximise objective function for MLE using the Continuous
% genetic algorithm as implemented by Haupt & Haupt (2004)
%
% Input
%   fitmodel -  struct
%            -  maxit = maximum GA iterations
%            -  theta0 = initial theta values
%
% Output
%   maxvalue -  maximum value of MLE function
%   theta -     theta weights which maximise MLE
%   RMSE -      root mean square for data points
%   objfunc -   function handle to function to minimise

% Get gui handle data
handles = guidata(GUIhandles);

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
mutrate = 0.5;
selection = 0.5;
Nt = npar;

keep = floor(selection*popsize);
nmut = ceil((popsize-1)*Nt*mutrate);

M = ceil((popsize-keep)/2);

debug = 'n';

%-------------------------------------------------------------------------%
% Create initial population
%-------------------------------------------------------------------------%
iga = 0;
par = 10.^((varhi-varlo).*rand(popsize,npar) + (varlo))
%par = 10.^((varhi-varlo).*haltonGen(popsize,npar) + (varlo));
cost = zeros(1,popsize);

%-------------------------------------------------------------------------%
% Evaluate initial population and sort
%-------------------------------------------------------------------------%
A = calcXK(X);

parfor i = 1:length(par(:,1))
    pari = par(i,:)';
    
    % Make R, beta and sigma2
    [R,condR] = calcRrevised(A,pari,Ph);
    %[R,condR] = calcR(X,pari,Ph);
    beta = calcBeta(f,R,Y);
    sigma2 = calcVariance(f,beta,R,Y);

    cost(i) = (-1)*feval(objfunc,R,sigma2);
    
    if (condR > 1e15)

        %disp('clipping -condR')
        cost(i) = 9999

    end

    if ((cost(i) < -1e15) || (cost(i) > 1e15))

        %disp('clipping -cost')
        cost(i) = 9999; %cost(i) + (cost(i) + 1e200)^2;

    end   
end

[cost,ind] = sort(cost);
par = par(ind,:);
minc(1) = min(cost);
meanc(1) = mean(cost);

% Plot logMLE function to check optimisation process
if ((strcmp(debug,'y') == 1) || (npar == 2))

    figure(102)

    xplot = logspace(varlo,varhi,100);
    yplot = logspace(varlo,varhi,100);
    [xgrid,ygrid] = meshgrid(xplot,yplot);

    yreal = zeros(100,100);
    
    for i = 1:1:100
        for j = 1:1:100
            
            [R,condR]=calcRrevised(A,[xgrid(i,j);ygrid(i,j)],Ph);
            beta=calcBeta(f,R,Y);
            sigma2=calcVariance(f,beta,R,Y);
            yreal(i,j) = feval(objfunc,R,sigma2);
      
            if (condR > 1e15)

                yreal(i,j) = 50;

            elseif ((yreal(i,j) > 1e15) || (yreal(i,j) < -1e15))

                yreal(i,j) = 50;

            end   
        end
    end

    mesh(xgrid,ygrid,yreal);
    set(gca,'XScale','log','YScale','log');
    
    hold on;
    plot3(par(:,1),par(:,2),(-1).*cost,'ok');
    hold off;
    
    view([150 43]);

end

%-------------------------------------------------------------------------%
% Iterate
%-------------------------------------------------------------------------%
while iga < maxit
       
    iga = iga + 1;
    
    %---------------------------------------------------------------------%
    % Pair and mate
    %---------------------------------------------------------------------%
    prob = flipud([1:keep]'/sum([1:keep]));
    
    odds = [0 cumsum(prob(1:keep))'];
        
    pick1 = rand(1,M);
    pick2 = rand(1,M);
    
    ic = 1;
    
    while ic <= M
        for id = 2:keep+1
            if pick1(ic) <= odds(id) && pick1(ic)>odds(id-1)
                ma(ic) = id -1;
            end
            if pick2(ic) <= odds(id) && pick2(ic) > odds(id-1)
                pa(ic) = id -1;
            end
        end
        ic = ic + 1;
    end
    
    %---------------------------------------------------------------------%
    % Mate using single-point crossover
    %---------------------------------------------------------------------%
    ix = 1:2:keep;
    xp = ceil(rand(1,M)*Nt);
    r = rand(1,M);
    
    for ic = 1:M
        xy = par(ma(ic),xp(ic)) - par(pa(ic),xp(ic));
        
        par(keep+ix(ic),:) = par(ma(ic),:);
        par(keep+ix(ic)+1,:) = par(pa(ic),:);
        par(keep+ix(ic),xp(ic)) = par(ma(ic),xp(ic)) - r(ic).*xy;
        
        par(keep+ix(ic)+1,xp(ic)) = par(pa(ic),xp(ic))+r(ic).*xy;
        
        if xp(ic) < npar
            par(keep+ix(ic),:) = [par(keep+ix(ic),1:xp(ic)) par(keep+ix(ic)+1,xp(ic)+1:npar)];
            par(keep+ix(ic)+1,:) = [par(keep+ix(ic)+1,1:xp(ic)) par(keep+ix(ic),xp(ic)+1:npar)];
        end
    end
    
    %---------------------------------------------------------------------%
    % Mutate the population
    %---------------------------------------------------------------------%
    mrow = sort(ceil(rand(1,nmut)*(popsize-1))+1);
    mcol = ceil(rand(1,nmut)*Nt);
    
    for ii = 1:nmut
        par(mrow(ii),mcol(ii)) = 10.^((varhi - varlo).*rand + varlo);
    end

    %---------------------------------------------------------------------%
    % Evaluate offspring
    %---------------------------------------------------------------------%
    parfor i = 1:length(par(:,1))
        pari = par(i,:)';

        % Make R, beta and sigma2
        [R,condR] = calcRrevised(A,pari,Ph);
        %[R,condR] = calcR(X,pari,Ph);
        beta = calcBeta(f,R,Y);
        sigma2 = calcVariance(f,beta,R,Y);

        cost(i) = (-1)*feval(objfunc,R,sigma2)

        if (condR > 1e15)

            %disp('clipping -condR')
            cost(i) = 9999
            
        end

        if ((cost(i) < -1e15) || (cost(i) > 1e15))

            %disp('clipping -cost')
            cost(i) = 9999; %cost(i) + (cost(i) + 1e200)^2;

        end
    end
    
    
    %---------------------------------------------------------------------%
    % Sort costs and parameters
    %---------------------------------------------------------------------%
    [cost,ind] = sort(cost);
    par = par(ind,:);
    
    %cost
    %par(1,:)
    
    %---------------------------------------------------------------------%
    % Do stats
    %---------------------------------------------------------------------%
    minc(iga+1) = min(cost);
    meanc(iga+1) = mean(cost);
   
    %---------------------------------------------------------------------%
    % Plot progress
    %---------------------------------------------------------------------%
    
    % Plot logMLE function to check optimisation process
    if ((strcmp(debug,'y') == 1) || (npar == 2))

        figure(102)

        mesh(xgrid,ygrid,yreal);
        set(gca,'XScale','log','YScale','log');
        view([150 43]);
        
        hold on;
        plot3(par(:,1),par(:,2),(-1).*cost,'ok');

        hold off;

    end

    %---------------------------------------------------------------------%
    % Check stopping criteria
    %---------------------------------------------------------------------%
    if iga > maxit || cost(1) < mincost
        break
    end
       
end

%---------------------------------------------------------------------%
% Assign outputs
%---------------------------------------------------------------------%
theta = par(1,:)';
MLE = (-1)*cost(1);

% Plot progress
axes(handles.axes3);
iters = 0:length(minc)-1;
plot(iters,(-1)*minc,'-b');
grid on;
xlabel('Iteration'); ylabel('MLE');
