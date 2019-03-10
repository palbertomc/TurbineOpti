%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TurbineOpti_nogui.m
% 
% None gui version of TurbineOpti.m
% for use on clusters / via SSH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set initial values for main global and local optimisation loops
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.previous_run = 1; 	% 1 for yes
handles.iga = 150; 		% iga to start from
handles.save_interval = 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%START - Set parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.R0 = 0.142;
handles.blade_type = 'rotor';
handles.blade_height = 0.202;
handles.no_blades = 20;
handles.blade_angle = (360/(handles.no_blades*2));

handles.RPM = 2300;
handles.V_inlet = 21.38;
handles.T_ref = 25;
handles.P_ref = 86431;
handles.operating_pressure = 86431;
handles.torque_correction = -1.67;
handles.t_model = 'k-omega';
handles.endwall_type = 'annular';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Endwall parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.maxphase = 45;
handles.harmonicshi = 1;
handles.harmonicslo = 0.5;
handles.heighthi = 3.5;
handles.no_lines = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN Optimisation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.optimiser_type = 'DE'; %'GA'
handles.maxit = 300; % 300
handles.mincost = 0;
handles.span_avg = 100;
handles.wake_tolerance = 1;
handles.username = 'jonathan';
handles.ncores = 16;
handles.CFDcostfuncno = 11;
handles.EIfunc = 'costfuncWB1';

if (strcmp(handles.optimiser_type,'DE') == 1) 
    handles.popsize = 48;
    handles.F = 0.8;
    handles.Cr = 0.8;
elseif (strcmp(handles.optimiser_type,'GA') == 1)    
    handles.popsize = 48;
    handles.mutation_rate = 0.2;
    handles.selection_rate = 0.5;
    handles.selection_routine = 'artifical';
else
    % Do nothing   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kriging model parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.kriging_data_dir = 'XY_gen_150.mat';
handles.kriging_theta_dir = 'thetas_gen_150.mat';
handles.variogram_type = 'Gaussian'; %'Exponential'

handles.optimiseMLEtype = 'DE'; %'GA'
handles.kopt_popsize = 48;
handles.kopt_maxit = 3500;
handles.kopt_varhi = 2;
handles.kopt_varlo = -12;
handles.npar = 12;

if (strcmp(handles.variogram_type,'Gaussian') == 1) 
        handles.Ph = 1.9; 
elseif (strcmp(handles.variogram_type,'Exponential') == 1) 
        handles.Ph = 1;  
else
    % Do nothing 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nelder-Mead parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.localoptimisermaxit = 10000;
handles.NM_tolerance = 2e-9;
handles.local_span_avg = 100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Working directories
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.base_dir = '/home/jonathan/Dropbox/linux_code_gui/';
handles.work_dir = '/home/jonathan/RUN104.3-Vdotalpha/';
handles.turbine_dir = '/home/jonathan/Dropbox/linux_code_gui/turbine_data/';
handles.reference_data_directory = '/home/jonathan/Dropbox/linux_code_gui/reference/';

if (exist(handles.work_dir,'dir')) 
    cd(handles.work_dir);
else
    mkdir(handles.work_dir);
    cd(handles.work_dir);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD XY database and theta files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load XY data
filename = handles.kriging_data_dir;
load(filename); [m,n] = size(X); f = ones(n,1);

fprintf('\nPoint data loaded ...\n    No. of data points: %g \n    No. of parameters: %g\n',n,m);

handles.X = X; handles.Y = Y;
handles.npar = m; handles.f = f;

if (exist('minY','var')) 
    handles.minY = minY;
end
    
if (exist('dbmax','var'))
    handles.dbmax = dbmax;
else
    handles.dbmax = n;
end

% Load theta data
filename = handles.kriging_theta_dir;
load(filename); [m,~] = size(theta);

fprintf('\nTheta data loaded ...\n    No. of parameters: %g \n    Theta = %s\n',m,mat2str(theta,8));

handles.theta = theta;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Crossvalidate model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[y,stdR] = crossValidate(handles.X,handles.Y,handles.theta,handles.Ph,handles.f);
[RMSE,max_error] = calcMSE(y(:,1),handles.Y);
A = calcXK(handles.X);
[~,condR] = calcRrevised(A,handles.theta,handles.Ph);

fprintf('\nMax error:\t %g\n',max_error);
fprintf('RMSE:\t\t %g\n',RMSE); 
fprintf('\nFitting results ... \n    IGA: n/a \n    MLE: n/a \n    Telapsed: n/a \n    cond(R): %g (cond(R) -> inf = bad)\n\n    Theta: %s\n',condR,mat2str(handles.theta,8));

% Plot some diagnostics
% Predicted y vs Actual Y
%axes(handles.axes6);
%plot(y,handles.Y,'ob',linspace(min(min(y),min(handles.Y)),max(max(y),max(handles.Y)),100),linspace(min(min(y),min(handles.Y)),max(max(y),max(handles.Y)),100),'-k');
%axis([min(min(y),min(handles.Y)) max(max(y),max(handles.Y)) min(min(y),min(handles.Y)) max(max(y),max(handles.Y))]);
%xlabel('Predicted y'); ylabel('Actual Y');
%grid on;

% Standardised residual
%axes(handles.axes4);
%plot(y,stdR,'ob',linspace(min(min(y),min(handles.Y)),max(max(y),max(handles.Y)),2),[3 3],'--b',linspace(min(min(y),min(handles.Y)),max(max(y),max(handles.Y)),2),[-3 -3],'--b');
%axis([min(min(y),min(handles.Y)) max(max(y),max(handles.Y)) min(min(stdR),-3.5) max(max(stdR),3.5)]);
%xlabel('Predicted y'); ylabel('Standardised Residual');
%grid on;

% Q-Q plot
%axes(handles.axes5);
%ystdR = sort(stdR);
%x = calcQPos(ystdR); x = calcNormInv(x);
%plot(x,ystdR,'ob',linspace(min(min(x),min(ystdR)),max(max(x),max(ystdR)),100),linspace(min(min(x),min(ystdR)),max(max(x),max(ystdR)),100),'-k');
%axis([min(min(x),min(ystdR)) max(max(x),max(ystdR)) min(min(x),min(ystdR)) max(max(x),max(ystdR))]);
%xlabel('Standard Normal Quantile'); ylabel('Standardised Residual');
%grid on;
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTER MAIN ROUTINE CODE HERE
% Set misc variables
minc = 99999; meanc = 99999;

% Create local variables for guidata variables for use in optimisation loop
X = handles.X; Y = handles.Y;
theta = handles.theta; f = handles.f;
Ph = handles.Ph; popsize = handles.popsize;
Cr = handles.Cr; F = handles.F; EIfunc = handles.EIfunc;
iters = 0; dbmax = handles.dbmax;

% Construct required model structs
endwall_model = struct('maxphase',handles.maxphase,'harmonicshi',handles.harmonicshi,'harmonicslo',...
                        handles.harmonicslo,'heighthi',handles.heighthi,'no_lines',handles.no_lines,...
                        'npar',handles.npar,'endwall_type',handles.endwall_type);

blade_model = struct('blade_type',handles.blade_type,'R0',handles.R0,'no_blades',handles.no_blades,...
                        'blade_max',handles.blade_height,'blade_angle',handles.blade_angle);

cfd_model = struct('operating_pressure',handles.operating_pressure,'torque_correction',handles.torque_correction,...
                    'T_ref',handles.T_ref,'P_ref',handles.P_ref,'V_inlet',handles.V_inlet,'t_model',handles.t_model,...
                    'span_avg',handles.span_avg,'wake_tolerance',handles.wake_tolerance,'RPM',handles.RPM);

dir_model = struct('work_dir',handles.work_dir,'turbine_dir',handles.turbine_dir,...
                    'reference_data_directory',handles.reference_data_directory,'base_dir',handles.base_dir);

resource_model = struct('username',handles.username,'CFDcostfuncno',handles.CFDcostfuncno,...
                        'ncores',handles.ncores);

fmodel = struct('maxit',handles.kopt_maxit,'npar',handles.npar,...
    'varhi',handles.kopt_varhi,'varlo',handles.kopt_varlo,...
    'popsize',handles.kopt_popsize,'Ph',handles.Ph,'X',handles.X,...
    'Y',handles.Y,'f',handles.f,'objfunc',@costfunclogMLE);

% Get plot axes for various plots
%axes(handles.axes1); a1 = gca; grid on;
%axes(handles.axes3); a3 = gca; grid on;
%axes(handles.axes4); a4 = gca; grid on;
%axes(handles.axes5); a5 = gca; grid on;
%axes(handles.axes6); a6 = gca; grid on;
%axes(handles.axes7); a7 = gca; grid on;

% Calculate initial kriging model parameters
A = calcXK(X);
R = calcRrevised(A,theta,Ph);
beta = calcBeta(f,R,Y);
        
if (strcmp(handles.optimiser_type,'DE') == 1)

    % Run DE routine
    if (handles.previous_run == 1)
        %Starting iga is the last full iteration run i.e. start from run xx
        iga = handles.iga;
        minY = handles.minY;
    else
        iga = 0;
        minY = [];
    end
   
    while (iga < handles.maxit)
               
        % Initialise
        iga = iga + 1;
        x = generatePar8(endwall_model,popsize);
        
        % Reset inner loop counter
        inner_loop_iterations = 0;
        
        % Start inner loop optimisation
        while (inner_loop_iterations <= 5000)
            
            % Run inner iterations
            v = mutateVec(x,F);
            u = crossOver(v,x,Cr);
            [x,y] = selectVec(EIfunc,u,x,X,Y,theta,Ph,R,beta,f,endwall_model);
            
            % Check inner loop convergence
            if ((inner_loop_iterations > 1000) && (abs(max(y) - min(y))/abs(max(y) + eps) * 100) <= 1)                     
                break;          
            end
            inner_loop_iterations = inner_loop_iterations + 1;
        end
        
        % Extract minimum vector
        [~,yind] = min(y);
        xopt = x(yind,:);

	% Check constraints satisifed
        c_flag = checkConstraints8(endwall_model,xopt);
        
        if (c_flag == 1)            
            fprintf('\n\nInner loop iterations: %g \n\tNB constraint(s) violated\n\n',inner_loop_iterations);     
        else
            fprintf('\n\nInner loop iterations: %g \n\tAll constraint(s) satisfied\n\n',inner_loop_iterations);               
        end
        
        % Run meshing and CFD routines
        createGeometry8chimera(blade_model,dir_model,resource_model,xopt,iga);
        [meshstatus,cfdstatus] = runModel(blade_model.blade_type,iga,resource_model);

        if ((meshstatus == 1) || (cfdstatus == 1))
            [~,hostname] = system('hostname');
            sendMail('***REMOVED***','Mesh or CFD failed',sprintf('Either the mesher or CFD run has failed on %s',hostname));
            fprintf('\nManually create mesh and/or run CFD simulation\n');
            pause;
        end
       
        [newX,newY,unsteady] = processModel(cfd_model,blade_model,endwall_model,dir_model,xopt,iga,resource_model.CFDcostfuncno);
        
        if (unsteady == 1)    
            [~,hostname] = system('hostname');
            sendMail('***REMOVED***','UNSTEADINESS DETECTED',sprintf('CFD run has produced an unsteady result on %s',hostname));
            fprintf('\nPlease manually inspect unsteady CFD result\n');
            pause;
        end
        
        cleanUp(dir_model.work_dir,blade_model.blade_type,iga);
        
        % Rebuild kriging database
        [X,Y] = addData(X,Y,newX,newY);
        
        % Rebuild fmodel database
        f = fxConstant(X);        
        fmodel.f = f;
        fmodel.X = X;
        fmodel.Y = Y;
        
        % Refit kriging model
        if (handles.optimiseMLEtype == 'GA')
            [theta,MLE,k_iga,telapsed] = optimiseMLEGA(fmodel);   
        else
            [theta,MLE,k_iga,telapsed] = optimiseMLEDE(fmodel,0.0001);
        end
                        
        % Crossvalidate
        [y,stdR] = crossValidate(X,Y,theta,Ph,f);
        [RMSE,max_error] = calcMSE(y(:,1),Y);

        % Re-calculate kriging model
        A = calcXK(X);
        [R,condR] = calcRrevised(A,theta,Ph);
        beta = calcBeta(f,R,Y);

        % Write fit info to screen  
	fprintf('\nMax error:\t %g\n',max_error);
	fprintf('RMSE:\t\t %g\n',RMSE);               
        fprintf('\nFitting results ... \n    IGA: %g \n    MLE: %g \n    Telapsed: %.2f secs\n    cond(R): %g (cond(R) -> inf = bad)\n\n Theta: %s\n'...
                             ,k_iga,MLE,telapsed,condR,mat2str(theta,8));

        % Plot diagnostics
        % Predicted y vs Actual Y
%        axes(handles.axes6);
%        plot(y,Y,'ob',linspace(min(min(y),min(Y)),max(max(y),max(Y)),100),linspace(min(min(y),min(Y)),max(max(y),max(Y)),100),'-k');
%        axis([min(min(y),min(Y)) max(max(y),max(Y)) min(min(y),min(Y)) max(max(y),max(Y))]);
%        xlabel('Predicted y'); ylabel('Actual Y');
%        grid on;

        % Standardised residual
%        axes(handles.axes4);
%        plot(y,stdR,'ob',linspace(min(min(y),min(Y)),max(max(y),max(Y)),2),[3 3],'--b',linspace(min(min(y),min(Y)),max(max(y),max(Y)),2),[-3 -3],'--b');
%        axis([min(min(y),min(Y)) max(max(y),max(Y)) min(min(stdR),-3.5) max(max(stdR),3.5)]);
%        xlabel('Predicted y'); ylabel('Standardised Residual');
%        grid on;

        % Q-Q plot
%        axes(handles.axes5);
%        ystdR = sort(stdR); x = calcQPos(ystdR); x = calcNormInv(x);
%        plot(x,ystdR,'ob',linspace(min(min(x),min(ystdR)),max(max(x),max(ystdR)),100),linspace(min(min(x),min(ystdR)),max(max(x),max(ystdR)),100),'-k');
%        axis([min(min(x),min(ystdR)) max(max(x),max(ystdR)) min(min(x),min(ystdR)) max(max(x),max(ystdR))]);
%        xlabel('Standard Normal Quantile'); ylabel('Standardised Residual');
%        grid on;
        
        % Calculate data base statistics
        [Yopt,~] = min(Y(dbmax+1:end));
        
        % Plot overall optimisation progress
%        axes(handles.axes1);
         minY(iga) = Yopt; 
%        iters = 1:1:iga;
%        plot(iters,minY,'o-b');
%        xlabel('Outer iterations'); ylabel('Objective function');
%        grid on;
        
        % Check outer loop convergence
        if ((abs(min(y)) / abs(min(Y))) * 100 <= 0.1)                
            break;         
        end
        
        % Save temp XY and theta data files %% To save us from load shedding
        save(sprintf('XY_temp'),'X','Y','minY','dbmax');
        save(sprintf('thetas_temp'),'theta');
        
	% Save XY and theta database values
	if (mod(iga,handles.save_interval) == 0)

	    save(sprintf('XY_gen_%d',iga),'X','Y','minY','dbmax');
	    save(sprintf('thetas_gen_%d',iga),'theta');

	end

    end
    
elseif (strcmp(handles.optimiser_type,'GA') == 1)
    
    % Run GA routine 
%    warndlg('GA optimisation code not implemented, choose another optimiser');
%
%     if (datalink == 1)
%         import
%     end
%     curve(par,popsize)
%     run(popsize)
%     importfile(popsize)
%     if (datalink ==1)
%         export
%     end
%     mutate(popsize)
%     cleanup(popsize)
    
else
    % DO NOTHING
end

% Update / reset handles parameters
handles.X = X;
handles.Y = Y;
handles.f = f;
handles.theta = theta;
handles.iga = iga;
handles.minY = minY;

% Save XY and theta data
save(sprintf('XY_gen_%d',iga),'-struct','handles','X','Y','minY','dbmax');
save(sprintf('thetas_gen_%d',handles.iga),'-struct','handles','theta');

%END - MAIN ROUTINE CODE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fitting Controls


% Fitting controls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%START - Kriging model


%END - Kriging model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%START - Computer resources


%END - Computer resources
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START - txtInfo


% END - txtInfo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start - Optimiser info


% END - Optimiser info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start - Local optimiser info


% END - Local optimiser info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%START - Extra functions


%END - Extra functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
