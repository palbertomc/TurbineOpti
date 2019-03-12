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

function processResultsCFD(graphresults,cfd_model,blade_model,endwall_model,dir_model)

% Function to calculate CFD results
%
% Input:
%   cfd_model -     struct containing CFD parameters
%   blade_model -   struct containing turbine parameters
%   endwall_model - struct containing endwall parameters
%   dir_model -         struct containing directory parameters
%
% Output:
%   null -
%
% J Bergh, 2014

% Set figure name and format for graphing
figurename = 'fig'; filetype = 'pdf';
working_directory = cd;

% Calculate reference pressure values
density_ref = cfd_model.P_ref/(287*(cfd_model.T_ref+273.15));
Pdynamic_ref = 0.5*density_ref*cfd_model.V_inlet^2;

% Read in torque data
if (strcmpi(blade_model.blade_type,'rotor') == 1)
	fid = fopen('torque');                                            
	for line_n = 1:1:23
	    txtstr = fgetl(fid);
	    if (line_n == 23)                                             % torque is on line 17 (31 for hex meshes)
        	temp = textscan(txtstr,'%*s %*s %*s %s','delimiter');
	        torque = str2double(temp{1}{1});            
        	torque = torque*blade_model.no_blades*(-1);             
	        torque = torque + cfd_model.torque_correction;
	    end
	end
	fclose(fid);
end

% Read in blade wake data
wake = dlmread('wake-angle','',3,0);

% Read in inlet density data
fid = fopen('density');                                    
for line_n = 1:1:6    
    txtstr = fgetl(fid);
    if (line_n == 6)                                                % average inlet density is on line 6 (10 for hex meshes)
        temp = textscan(txtstr,'%*s %s','delimiter');          
        density = str2double(temp{1}{1});                        
        density_inlet = density;                      
    end
end
fclose(fid);

% Read in inlet static pressure data
fid = fopen('pressure');
for line_n = 1:1:6 
    txtstr = fgetl(fid);
    if (line_n == 6)                                                % pressure is on line 6 (10 for hex meshes)
        temp = textscan(txtstr,'%*s %s','delimiter');      
        pressure = str2double(temp{1}{1});                 
        P_inlet = pressure + cfd_model.operating_pressure;               
    end
end
fclose(fid);

% Import X2 / X3 / X4 CFD solution data
if (strcmpi(blade_model.blade_type,'rotor') == 1)

	X2_data = dlmread('x2_averaged.csv',',',0,0);	% Read X2 data

	X2_r = X2_data(:,1);              % radius
	X2_Vz = X2_data(:,5);             % velocity - axial
	X2_Vt = X2_data(:,7);             % velocity - tangential
	X2_Vr = X2_data(:,6);             % velocity - radial
	X2_Vmag = X2_data(:,4);           % velocity - magnitude
	X2_Ps = X2_data(:,2);             % static pressure
	X2_Pt = X2_data(:,3);             % total pressure
	X2_alpha = X2_data(:,8);          % alpha1
	X2_helicity = X2_data(:,9);       % helicity
	
	X3_data = dlmread('x3_averaged.csv',',',0,0);	% Read X3 data

	X3_r = X3_data(:,1);              % radius
	X3_Vz = X3_data(:,6);             % velocity - axial
	X3_Vt = X3_data(:,8);             % velocity - tangential
	X3_Vr = X3_data(:,7);             % velocity - radial
	X3_Vmag = X3_data(:,5);           % velocity - magnitude
	X3_Ps = X3_data(:,2);             % static pressure
	X3_Pt = X3_data(:,3);             % total pressure
	X3_Ptrel = X3_data(:,4);          % relative total pressure
	X3_alpha = X3_data(:,10);         % alpha3
	X3_beta = X3_data(:,11);          % beta3
	X3_Wmag = X3_data(:,9);           % velocity - relative (magnitude)
	X3_helicity = X3_data(:,12);      % helicity

    X4_data = dlmread('x4_averaged.csv',',',0,0);	% Read X3 data

	X4_r = X4_data(:,1);              % radius
	X4_Vz = X4_data(:,6);             % velocity - axial
	X4_Vt = X4_data(:,8);             % velocity - tangential
	X4_Vr = X4_data(:,7);             % velocity - radial
	X4_Vmag = X4_data(:,5);           % velocity - magnitude
	X4_Ps = X4_data(:,2);             % static pressure
	X4_Pt = X4_data(:,3);             % total pressure
	X4_Ptrel = X4_data(:,4);          % relative total pressure
	X4_alpha = X4_data(:,10);         % alpha3
	X4_beta = X4_data(:,11);          % beta3
	X4_Wmag = X4_data(:,9);           % velocity - relative (magnitude)
	X4_helicity = X4_data(:,12);      % helicity
    
    % Read design data into Matlab
    cd(dir_model.reference_data_directory);
    
    X3_design_data = dlmread('X3_design.csv',',',1,0);    
    X3_design_span = X3_design_data(:,1);         % design span data
    X3_design_beta = X3_design_data(:,2);         % design relative flow angle (beta)
    X3_design_W = X3_design_data(:,3);            % design relative flow velocity (W)
    X3_design_alpha = X3_design_data(:,4);        % design flow angle (alpha)
    X3_design_V = X3_design_data(:,5);            % design flow velocity (V)
    X3_design_Wdotspan = X3_design_data(:,9);     % design span for Wdotbeta data
    X3_design_Wdotdata = X3_design_data(:,10);     % design Wdotbeta data
    X3_design_Vdotspan = X3_design_Wdotspan;      % design span Vdotalpha is the same as Wdotbeta
    X3_design_Vdotdata = X3_design_data(:,11);     % design Vdotalpha data
    
    cd(working_directory);
    
	% Miscellaneous calcs
	X3_beta = X3_beta*(-1);                                     % Correct sign of beta angle - Fluent beta has incorrect sense (i.e. -ve)
    X4_beta = X4_beta*(-1);                                     % Correct sign of beta angle - Fluent beta has incorrect sense (i.e. -ve)
	Pdynamic_inlet = 0.5*density_inlet*cfd_model.V_inlet^2;     % calculate inlet dynamic pressure
    Pdynamic_ratio = Pdynamic_ref/Pdynamic_inlet;               % Calculate dyanmic pressure ratio for scaling

	%% PROCESS RESULTS FOR X2
	% Flow properties
	X2_span = (X2_r - blade_model.R0) / (blade_model.blade_max - blade_model.R0) .*100;
    
	X2_pitch = atan(X2_Vr./X2_Vz);
	X2_vratio = X2_Vmag./X2_Vmag;                          % calculate velocity ratio
	X2_helicity = X2_helicity.*(X2_vratio).^2;          % scale helicity

	U = (cfd_model.RPM*360/60) * (pi/180) .* X2_r .* (-1);    % Multiply by (-1) since the turbine axis of rotation is the +z-axis
	X2_W = sqrt((X2_Vmag .* cos(X2_alpha)).^2 + (X2_Vt - U).^2);
	X2_beta = asin((X2_Vt - U) ./ X2_W);
    X2_Ptrel = X2_Ps + 0.5 * density_ref * X2_W.^2;

	% Flow coefficients
	X2_Cm = X2_Vmag ./ cfd_model.V_inlet;                         % calculate Cm values 
    X2_Cm(1,1) = X2_Cm(1,1) * (17/20);                         % correct lower wall value
    X2_Cm(30,1) = X2_Cm(30,1) * (17/20);                       % correct upper wall value
	X2_Cv = (0.5 * density_ref .* X2_Vmag.^2) / Pdynamic_ref;
	X2_Cp0ref_Ps = (cfd_model.P_ref - X2_Ps) / Pdynamic_ref;
	X2_Cp0ref_Pt = (cfd_model.P_ref - X2_Pt) / Pdynamic_ref;

	% Average coefficients
	X2_Cvbar = X2_Cv .* X2_Cm;
	X2_CvBAR = sum(X2_Cvbar) / sum(X2_Cm);

	X2_Cp0ref_Psbar = X2_Cp0ref_Ps .* X2_Cm;
	X2_Cp0ref_PsBAR = sum(X2_Cp0ref_Psbar) / sum(X2_Cm);

	X2_Cp0ref_Ptbar = X2_Cp0ref_Pt .* X2_Cm;
	X2_Cp0ref_PtBAR = sum(X2_Cp0ref_Ptbar) / sum(X2_Cm);

	%% PROCESS RESULTS FOR X3
	% Flow properties
	X3_span = (X3_r - blade_model.R0) / (blade_model.blade_max - blade_model.R0) .* 100;
   
	X3_pitch = atan(X3_Vr./X3_Vz);
	X3_vratio = X3_Vmag./X3_Vmag;                        % calculate velocity ratio
	X3_helicity = X3_helicity.*(X3_vratio).^2;        % scale helicity

	X3_beta = X3_beta; 
   
	% Flow coefficients
	X3_Cm = X3_Vmag ./ cfd_model.V_inlet;                        % calculate Cm values 
    X3_Cm(1,1) = X3_Cm(1,1) * (17/20);                        % correct lower wall value
    X3_Cm(30,1) = X3_Cm(30,1) * (17/20);                      % correct upper wall value
	X3_Cv = (0.5 * density_ref * X3_Vmag.^2) ./ Pdynamic_ref;
	X3_Cp0ref_Ps = (cfd_model.P_ref - X3_Ps) / Pdynamic_ref;
	X3_Cp0ref_Pt = (cfd_model.P_ref - X3_Pt) / Pdynamic_ref;
	X3_Comega = (2 * pi * cfd_model.RPM * torque) ./ (60 * cfd_model.V_inlet * pi * (0.203^2 - 0.142^2) * density_ref * Pdynamic_ref);

	% Average coefficients
	X3_Cvbar = X3_Cv .* X3_Cm;
	X3_CvBAR = sum(X3_Cvbar) / sum(X3_Cm);

	X3_Cp0ref_Psbar = X3_Cp0ref_Ps .* X3_Cm;
	X3_Cp0ref_PsBAR = sum(X3_Cp0ref_Psbar) / sum(X3_Cm);

	X3_Cp0ref_Ptbar = X3_Cp0ref_Pt .* X3_Cm;
	X3_Cp0ref_PtBAR = sum(X3_Cp0ref_Ptbar) / sum(X3_Cm);

    X3_Comegabar = X3_Comega .* X3_Cm;
	X3_ComegaBAR = sum(X3_Comegabar) / sum(X3_Cm);

    % Calculate polynominal coefficients for design alpha and beta,
    % Vdotalpha and Wdotbeta, and design W and V
    P1 = polyfit(X3_design_Wdotspan,X3_design_Wdotdata,3);
    X3_design_Wdotbeta = (P1(1) * X3_span.^3 + P1(2) * X3_span.^2 + P1(3) * X3_span + P1(4));%.*pi/180;
    
    P2 = polyfit(X3_design_Vdotspan,X3_design_Vdotdata,3);
    X3_design_Vdotalpha = (P2(1) * X3_span.^3 + P2(2) * X3_span.^2 + P2(3) * X3_span + P2(4));%.*pi/180;
    
    P3 = polyfit(X3_design_span,X3_design_alpha,3);
    X3_Vdotalphadesign_alpha = (P3(1) * X3_span.^3 + P3(2) * X3_span.^2 + P3(3) * X3_span + P3(4)) .* pi / 180;
    
    P4 = polyfit(X3_design_span,X3_design_beta,3);
    X3_Wdotbetadesign_beta = (P4(1) * X3_span.^3 + P4(2) * X3_span.^2 + P4(3) * X3_span+P4(4)) .* pi / 180;
    
    P5 = polyfit(X3_design_span,X3_design_V,3);
    X3_design_V = (P5(1)*X3_span.^3+P5(2)*X3_span.^2+P5(3)*X3_span+P5(4));
  
    P6 = polyfit(X3_design_span,X3_design_W,3);
    X3_design_W = (P6(1)*X3_span.^3+P6(2)*X3_span.^2+P6(3)*X3_span+P6(4));
    
    P7 = polyfit(X3_design_span,X3_design_beta,3);
    X3_design_beta = (P7(1) * X3_span.^3 + P7(2) * X3_span.^2 + P7(3) * X3_span + P7(4)) .* pi / 180;
    
    % Calculate (VdotAlpha) and (WdotBeta) design criteria and rotor results for rotor;
    X3_Vdotalphadesign_axial = cos(X3_Vdotalphadesign_alpha);
    X3_Vdotalphadesign_tangential = sin(X3_Vdotalphadesign_alpha);
    X3_Vdotalphadesign_radial = 0;
    
    X3_Vdotalpha_axial = X3_Vdotalphadesign_axial .* (X3_Vmag .* cos(X3_alpha));
    X3_Vdotalpha_tangential = X3_Vdotalphadesign_tangential .* (X3_Vmag .* sin(X3_alpha));
    X3_Vdotalpha_radial = X3_Vdotalphadesign_radial .* (X3_Vmag .* sin(X3_pitch)); %sin(X3_pitch));
    
    X3_Wdotbetadesign_axial = cos(X3_Wdotbetadesign_beta);
    X3_Wdotbetadesign_tangential = sin(X3_Wdotbetadesign_beta);
    X3_Wdotbetadesign_radial = 0;
    
    X3_Wdotbeta_axial = X3_Wdotbetadesign_axial .* (X3_Wmag .* cos(X3_beta));
    X3_Wdotbeta_tangential = X3_Wdotbetadesign_tangential .* (X3_Wmag .* sin(X3_beta));
    X3_Wdotbeta_radial = X3_Wdotbetadesign_radial .* (X3_Wmag .* sin(X3_pitch)); %sin(X3_pitch));
     
	% Calculate efficiencies, Cske, beta_dev
	eta_rotor_total = (X3_Comega) ./ (X3_Cp0ref_Ps - X3_Cv - X2_Cp0ref_PtBAR);
	eta_rotor_static = (X3_Comega) ./ (X3_Cp0ref_Ps - X2_Cp0ref_PtBAR);
    
	X3_Cske = ((X3_Vmag .* sin(X3_alpha - mean(X3_alpha))).^2 - (X3_Vmag .* sin(X3_pitch)).^2) / (cfd_model.V_inlet)^2;
    X3_SKEH = abs(X3_helicity) .* X3_Cske;
    X3_loss = (X2_Ptrel - X3_Ptrel) ./ (mean(X3_Ptrel) - mean(X3_Ps));    
    
    X3_deviation = (abs(X3_beta - X3_design_beta));                       % Overturning is positive, underturning is negative
    
    X3_Wdotbeta = (X3_Wdotbeta_axial + X3_Wdotbeta_tangential + X3_Wdotbeta_radial) ./ X3_design_W;
    X3_Wdotbeta_deviation = X3_design_Wdotbeta-X3_Wdotbeta;
    X3_Vdotalpha = (X3_Vdotalpha_axial + X3_Vdotalpha_tangential + X3_Vdotalpha_radial) ./ X3_design_V;
    X3_Vdotalpha_deviation = X3_design_Vdotalpha-X3_Vdotalpha;
    
    eta_rotor_totalBAR = X3_ComegaBAR / (X3_Cp0ref_PsBAR - X3_CvBAR - X2_Cp0ref_PtBAR);
	eta_rotor_staticBAR = X3_ComegaBAR / (X3_Cp0ref_PsBAR - X2_Cp0ref_PtBAR);
    
    % Find row index for partial span averaging
    for i = 1:1:30                            
        if (X3_span(i,1) <= cfd_model.span_avg)
            break_row = i;
        end
    end
    
%     X3_CskeBAR = sum(X3_Cske(1:break_row,1) .* X3_Cm(1:break_row,1)) / sum(X3_Cm(1:break_row,1));
% 	  X3_HSkeBAR = sum(X3_HSke(1:break_row,1) .* X3_Cm(1:break_row,1)) / sum(X3_Cm(1:break_row,1));
% 	  X3_lossBAR = sum(X3_loss(1:break_row,1) .* X3_Cm(1:break_row,1)) / sum(X3_Cm(1:break_row,1));
%     
%     X3_deviationBAR = sum(X3_deviation(1:break_row,1) .* X3_Cm(1:break_row,1)) / sum(X3_Cm(1:break_row,1));
%     X3_WdotbetaBAR = sum(X3_Wdotbeta(1:break_row,1) .* X3_Cm(1:break_row,1)) / sum(X3_Cm(1:break_row,1));
%     X3_VdotalphaBAR = sum(X3_Vdotalpha(1:break_row,1) .* X3_Cm(1:break_row,1)) / sum(X3_Cm(1:break_row,1));

    X3_CskeBAR = sum(X3_Cske(1:break_row,1) .* X3_Cm(1:break_row,1)) / sum(X3_Cm(1:break_row,1));
	X3_SKEHBAR = sum(X3_SKEH(1:break_row,1) .* X3_Cm(1:break_row,1)) / sum(X3_Cm(1:break_row,1));
	X3_lossBAR = sum(X3_loss(1:break_row,1) .* X3_Cm(1:break_row,1)) / sum(X3_Cm(1:break_row,1));
    
    X3_deviationBAR = sum(X3_deviation(1:break_row,1) .* X3_Cm(1:break_row,1)) / sum(X3_Cm(1:break_row,1));
    X3_WdotbetaBAR = sum(X3_Wdotbeta(1:break_row,1) .* X3_Cm(1:break_row,1)) / sum(X3_Cm(1:break_row,1));
    X3_VdotalphaBAR = sum(X3_Vdotalpha(1:break_row,1) .* X3_Cm(1:break_row,1)) / sum(X3_Cm(1:break_row,1));
    
    %% PROCESS RESULTS FOR X4
	% Flow properties
	X4_span = (X4_r - blade_model.R0) / (blade_model.blade_max - blade_model.R0) .* 100;      

	X4_pitch = atan(X4_Vr ./ X4_Vz);
	X4_vratio = X4_Vmag ./ X4_Vmag;                     % calculate velocity ratio
	X4_helicity = X4_helicity .* (X4_vratio).^2;        % scale helicity
  
    X4_beta = X4_beta;
   
	% Flow coefficients
	X4_Cm = X4_Vmag ./ cfd_model.V_inlet;                     % calculate Cm values 
    X4_Cm(1,1) = X4_Cm(1,1) * (17/20);                        % correct lower wall value
    X4_Cm(30,1) = X4_Cm(30,1) * (17/20);                      % correct upper wall value
     
	% Calculate efficiencies, Cske, beta_dev
	X4_Cske = ((X4_Vmag .* sin(X4_alpha - mean(X4_alpha))).^2 - (X4_Vmag .* sin(X4_pitch)).^2) / (cfd_model.V_inlet)^2;
    
    X4_SKEH = abs(X4_helicity) .* X4_Cske;
    X4_loss = (X2_Ptrel - X4_Ptrel) ./ (mean(X4_Ptrel) - mean(X4_Ps));	
    
    % Find row index for partial span averaging
    for i = 1:1:30                            
        if (X4_span(i,1) <= cfd_model.span_avg)
            break_row = i;
        end
    end
    
%   X4_CskeBAR = sum(X4_Cske(1:break_row,1) .* X4_Cm(1:break_row,1)) / sum(X4_Cm(1:break_row,1));
% 	X4_HSkeBAR = sum(X4_HSke(1:break_row,1) .* X4_Cm(1:break_row,1)) / sum(X4_Cm(1:break_row,1));
% 	X4_lossBAR = sum(X4_loss(1:break_row,1) .* X4_Cm(1:break_row,1)) / sum(X4_Cm(1:break_row,1));
    
    X4_CskeBAR = sum(X4_Cske(1:break_row,1) .* X4_Cm(1:break_row,1)) / sum(X4_Cm(1:break_row,1));
	X4_SKEHBAR = sum(X4_SKEH(1:break_row,1) .* X4_Cm(1:break_row,1)) / sum(X4_Cm(1:break_row,1));
	X4_lossBAR = sum(X4_loss(1:break_row,1) .* X4_Cm(1:break_row,1)) / sum(X4_Cm(1:break_row,1));
    
	% WRITE OUT RESULTS
	fid = fopen('results.txt','w');		% Write global results
	fprintf(fid,'Model: %s, %s, %s \n',int2str(cfd_model.RPM),endwall_model.endwall_type,cfd_model.t_model);
    fprintf(fid,'Torque: %5.5f \n',torque);
    fprintf(fid,'Efficiencies \n');
	fprintf(fid,'Rotor efficiency (total-total): %5.5f \n',eta_rotor_totalBAR);
	fprintf(fid,'Rotor efficiency (total-static): %5.5f \n',eta_rotor_staticBAR);
	fprintf(fid,' \n');
	fprintf(fid,'Mass-averaged quantities (0-%d%% span)\n',cfd_model.span_avg);
    fprintf(fid,'------X3------\n');
	fprintf(fid,'Rotor loss: %5.5f \n',X3_lossBAR);
	fprintf(fid,'Rotor Cske: %5.5f \n',X3_CskeBAR);
	fprintf(fid,'Rotor HSke_new: %5.5f \n',X3_SKEHBAR);
	fprintf(fid,'Rotor Flow deviation: %5.5f \n',X3_deviationBAR*180/pi);
    fprintf(fid,'Rotor Wdotbeta: %5.5f \n',X3_WdotbetaBAR);
    fprintf(fid,'Rotor Vdotalpha: %5.5f \n',X3_VdotalphaBAR);
    fprintf(fid,'------X4------\n');
	fprintf(fid,'Rotor loss: %5.5f \n',X4_lossBAR);
	fprintf(fid,'Rotor Cske: %5.5f \n',X4_CskeBAR);
	fprintf(fid,'Rotor HSke_new: %5.5f \n',X4_SKEHBAR);
	fprintf(fid,'Rotor Flow deviation: n/a \n');
    fprintf(fid,'Rotor Wdotbeta: n/a \n');
    fprintf(fid,'Rotor Vdotalpha: n/a \n');
    fclose(fid);

    results_struct = struct('X3_span',X3_span','X3_alpha',X3_alpha,'X3_beta',X3_beta,...
        'X3_W',X3_Wmag,'X3_Cske',X3_Cske,'X3_HSke',X3_SKEH,'X3_loss',X3_loss,...
        'eta_rotor_total',eta_rotor_total,'eta_rotor_static',eta_rotor_static,'X3_Wdotbeta',X3_Wdotbeta',...
        'X3_Vdotalpha',X3_Vdotalpha,'wake',wake,'X3_deviation',X3_deviation,'X3_Cm',X3_Cm,...
        'X3_V',X3_Vmag,...
        'X4_span',X4_span','X4_alpha',X4_alpha,'X4_beta',X4_beta,...
        'X4_W',X4_Wmag,'X4_Cske',X4_Cske,'X4_HSke',X4_SKEH,'X4_loss',X4_loss,...
        'X4_Cm',X4_Cm,'X4_V',X4_Vmag);
    
	% Graph results
    if (graphresults == 1)
        RPM = num2str(cfd_model.RPM);
        graphResults(RPM,results_struct,dir_model,blade_model,endwall_model,cfd_model)
        cd(working_directory);
        figureSave(figurename,filetype)
    end
end
    
