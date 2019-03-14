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

function graphResultsnewSKEH(RPM,results_struct,dir_model,blade_model,endwall_model,cfd_model)

% Function to graph CFD results
%
% Input:
%   RPM -               turbine test speed (string)
%   results_struct -    struct containing processed results
%   dir_model -         struct containing directory parameters
%   blade_model -       struct containing turbine parameters
%   endwall_model -     struct containing endwall parameters
%   cfd_model -         struct containing CFD parameters
%
% Output:
%   null -
%

% Set figure properties
set(0,'defaultLineLineWidth',1.25,'defaultAxesFontName','Arial','defaultAxesFontSize',12,'defaultFigureVisible','off',...
    'defaultFigureUnits','centimeters','defaultFigurePosition',[1 1 20 15],'defaultFigurePaperPositionMode','auto',...
    'defaultFigurePaperUnits','centimeters','defaultFigurePaperSize',[20 15]);%,'defaultTextInterpreter','latex');

t_model = cfd_model.t_model; 
endwalltype = endwall_model.endwall_type;

% Load reference data
cd(dir_model.reference_data_directory);

    % Load design reference data
    X3_design = dlmread('X3_design.csv',',',1,0);         % imports design data for CSIR turbine:     span/beta3/w3/LossCoeff/StageTT/RotorTT
    X4_design = dlmread('X4_design.csv',',',1,0);         % imports design data for CSIR turbine:     span/alpha4/v4/LossCoeff/etaN2

    X3_design_span = X3_design(:,1);
    X3_design_beta = X3_design(:,2);
    X3_design_W = X3_design(:,3);
    X3_design_alpha = X3_design(:,4);
    X3_design_V = X3_design(:,5);
    X3_design_loss = X3_design(:,6);
    X3_design_eta_stage_total = X3_design(:,7);
    X3_design_eta_rotor_total = X3_design(:,8);
    X3_design_Wdotspan = X3_design(:,9);
    X3_design_Wdotbeta = X3_design(:,10);
    X3_design_Vdotalpha = X3_design(:,11);
    X3_design_Vdotspan = X3_design_Wdotspan;

    X4_design_span = X4_design(:,1);
    X4_design_alpha = X4_design(:,2);
    X4_design_V = X4_design(:,3);
    X4_design_loss = X4_design(:,4);
    X4_design_etaN2 = X4_design(:,5);

    %load experimental reference data    
    X3_filename = sprintf('%s_X3_%s_experimental.csv',RPM,endwalltype);
    X3_experimental = dlmread(X3_filename,',',1,0);
    
    X3_experimental_span = X3_experimental(:,1);
    X3_experimental_beta = X3_experimental(:,2);
    X3_experimental_W = X3_experimental(:,3);
    X3_experimental_alpha = X3_experimental(:,4);
    X3_experimental_V = X3_experimental(:,5);
    X3_experimental_pitch = X3_experimental(:,6);
    X3_experimental_loss = X3_experimental(:,7);
    X3_experimental_eta_stage_total = X3_experimental(:,8);
    X3_experimental_eta_stage_static = X3_experimental(:,9);
    X3_experimental_eta_rotor_total = X3_experimental(:,10);
    X3_experimental_eta_rotor_static = X3_experimental(:,11);
    X3_experimental_Cske = X3_experimental(:,12);
    X3_experimental_beta_dev = X3_experimental(:,13);
    
    X4_filename = sprintf('%s_X4_%s_experimental_no_S2.csv',RPM,endwalltype);
    X4_experimental = dlmread(X4_filename,',',1,0);
    
    X4_experimental_span = X4_experimental(:,1);
    X4_experimental_alpha = X4_experimental(:,2);
    X4_experimental_V = X4_experimental(:,3);
    X4_experimental_beta = X4_experimental(:,4);
    X4_experimental_W = X4_experimental(:,5);
    X4_experimental_loss = X4_experimental(:,6);
    X4_experimental_Cske = X4_experimental(:,10);

    %load annular CFD reference data  
    X3_filename = sprintf('%s_X3_%s_CFD.csv',RPM,endwalltype);
    X3_CFD = dlmread(X3_filename,',',1,0);
    
    X3_CFD_span = X3_CFD(:,1);
    X3_CFD_beta = X3_CFD(:,2);
    X3_CFD_Wmag = X3_CFD(:,3);
    X3_CFD_alpha = X3_CFD(:,4);
    X3_CFD_Vmag = X3_CFD(:,5);
    X3_CFD_pitch = X3_CFD(:,6);
    X3_CFD_loss = X3_CFD(:,7);
    X3_CFD_eta_rotor_total = X3_CFD(:,10);
    X3_CFD_eta_rotor_static = X3_CFD(:,11);
    X3_CFD_Cske = X3_CFD(:,12);
    X3_CFD_deviation = X3_CFD(:,13);
    X3_CFD_HSke = X3_CFD(:,14);
    X3_CFD_Vdotalpha = X3_CFD(:,15);
    X3_CFD_Wdotbeta = X3_CFD(:,16);   
    
    X4_filename = sprintf('%s_X4_%s_CFD.csv',RPM,endwalltype);
    X4_CFD = dlmread(X4_filename,',',1,0);
    
    X4_CFD_span = X4_CFD(:,1);
    X4_CFD_beta = X4_CFD(:,2);
    X4_CFD_Wmag = X4_CFD(:,3);
    X4_CFD_alpha = X4_CFD(:,4);
    X4_CFD_Vmag = X4_CFD(:,5);
    X4_CFD_pitch = X4_CFD(:,6);
    X4_CFD_loss = X4_CFD(:,7);
    X4_CFD_Cske = X4_CFD(:,12);
    X4_CFD_HSke = X4_CFD(:,14);  
    
if (strcmpi(blade_model.blade_type,'rotor') == 1)
   %% Rotor graphs - beta3, W3, rotor efficiency, stage efficiency, Cske
    % Set variables to local function workspace
    X3_span = results_struct.X3_span; X3_beta = results_struct.X3_beta; X3_W = results_struct.X3_W; X3_alpha = results_struct.X3_alpha;
    X3_Cske = results_struct.X3_Cske; X3_HSke = results_struct.X3_HSke; X3_loss = results_struct.X3_loss; X3_V = results_struct.X3_V;
    eta_rotor_total = results_struct.eta_rotor_total; eta_rotor_static = results_struct.eta_rotor_static; 
    X3_Wdotbeta = results_struct.X3_Wdotbeta; X3_Vdotalpha = results_struct.X3_Vdotalpha; 
    wake = results_struct.wake; X3_deviation = results_struct.X3_deviation; X3_Cm = results_struct.X3_Cm;
    
	f = figure(9);
    hold all;  
	%plot(X3_design_beta,X3_design_span,'-k',X3_experimental_beta,X3_experimental_span,'o-k',X3_beta.*180/pi,X3_span,'d-b');
	plot(X3_design_beta,X3_design_span,'-k',X3_experimental_beta,X3_experimental_span,'o-k',X3_CFD_beta.*180/pi,X3_CFD_span,'o-r',X3_beta.*180/pi,X3_span,'d-b');
    %plot(X3_design_beta,X3_design_span,'-k',X3_experimental_beta,X3_experimental_span,'o-k',X3_beta.*180/pi,X3_span,'d-b');legend('design','experimental','annular','location','SW','orientation','vertical');
    title('X3 Rotor exit angle (beta)'); xlabel('degrees');ylabel('Span');
	legend('design','experimental','annular','contoured','location','SW','orientation','vertical');
	legend boxon
	axis([45 80 0 100])
	grid on; 

	f = figure(10);
    hold all;
	%plot(X3_design_W,X3_design_span,'-k',X3_experimental_W,X3_experimental_span,'o-k',X3_W,X3_span,'d-b');
    plot(X3_design_W,X3_design_span,'-k',X3_experimental_W,X3_experimental_span,'o-k',X3_CFD_Wmag,X3_CFD_span,'o-r',X3_W,X3_span,'d-b');
    %plot(X3_design_W,X3_design_span,'-k',X3_experimental_W,X3_experimental_span,'o-k',X3_W,X3_span,'d-b');legend('design','experimental','annular','location','SW','orientation','vertical');
	title('X3 Rotor exit relative velocity (W)'); xlabel('m/s');ylabel('Span');
	legend('design','experimental','annular','contoured','location','SW','orientation','vertical');
	legend boxon
	axis([40 65 0 100])
	grid on

	f = figure(11);
    hold all;
	%plot(X3_design_eta_rotor_total,X3_design_span,'-k',X3_experimental_eta_rotor_total,X3_experimental_span,'o-k',eta_rotor_total,X3_span,'d-b');
    plot(X3_design_eta_rotor_total,X3_design_span,'-k',X3_experimental_eta_rotor_total,X3_experimental_span,'o-k',X3_CFD_eta_rotor_total,X3_CFD_span,'o-r',eta_rotor_total,X3_span,'d-b');
	%plot(X3_design_eta_rotor_total,X3_design_span,'-k',X3_experimental_eta_rotor_total,X3_experimental_span,'o-k',eta_rotor_total,X3_span,'d-b');legend('design','experimental','annular','location','SW','orientation','vertical');
    title('Efficiency: Rotor (total-total)'); xlabel('efficiency');ylabel('Span');
	legend('design','experimental','annular','contoured','location','SW','orientation','vertical');
	legend boxon
	axis([0.5 1 0 100])
	grid on

	f = figure(12);
    hold all;
	%plot(X3_experimental_eta_rotor_static,X3_experimental_span,'o-k',eta_rotor_static,X3_span,'d-b');
    plot(X3_experimental_eta_rotor_static,X3_experimental_span,'o-k',X3_CFD_eta_rotor_static,X3_CFD_span,'o-r',eta_rotor_static,X3_span,'d-b');
    %plot(X3_experimental_eta_rotor_static,X3_experimental_span,'o-k',eta_rotor_static,X3_span,'d-b');legend('experimental','annular','location','SW','orientation','vertical');
	title('Efficiency: Rotor (total-static)'); xlabel('efficiency');ylabel('Span');
	legend('experimental','annular','contoured','location','SW','orientation','vertical');
	legend boxon
	axis([0.5 1 0 100])
	grid on

	f = figure(13);
    hold all;
	%plot(X3_experimental_Cske,X3_experimental_span,'o-k',X3_Cske,X3_span,'d-b');
    plot(X3_experimental_Cske,X3_experimental_span,'o-k',X3_CFD_Cske,X3_CFD_span,'o-r',X3_Cske,X3_span,'d-b');
    %plot(X3_experimental_Cske,X3_experimental_span,'o-k',X3_Cske,X3_span,'d-b');legend('experimental','annular','location','SE','orientation','vertical');
	title('X3 Coefficient of SKE (Cske)'); xlabel('Cske');ylabel('Span');
	legend('experimental','annular','contoured','location','SE','orientation','vertical');
	legend boxon
	axis([0 1.5 0 100])
	grid on

	f = figure(14);
    hold all;
	%plot(X3_design_loss,X3_design_span,'-k',X3_experimental_loss,X3_experimental_span,'o-k',X3_loss,X3_span,'d-b');
	plot(X3_design_loss,X3_design_span,'-k',X3_experimental_loss,X3_experimental_span,'o-k',X3_CFD_loss,X3_CFD_span,'o-r',X3_loss,X3_span,'d-b');
    %plot(X3_design_loss,X3_design_span,'-k',X3_experimental_loss,X3_experimental_span,'o-k',X3_loss,X3_span,'d-b');legend('design','experimental','annular','location','SE','orientation','vertical');
    title('X3 Rotor exit loss (Cp0,rel)'); xlabel('Cp0,rel');ylabel('Span');
	legend('design','experimental','annular','contoured','location','SE','orientation','vertical');
	legend boxon
	axis([-0.2 1 0 100])
	grid on

	f = figure(15);
    hold all;
    plot(X3_HSke,X3_span,'d-b');
	%plot(X3_CFD_HSke,X3_span,'o-r',X3_HSke,X3_span,'d-b');
    %plot(X3_CFD_HSke,X3_span,'o-r',X3_HSke,X3_span,'d-b');legend('annular','location','SE','orientation','vertical');
	title('X3 Secondary kinetic energy Helicity (SKEH)'); xlabel('SKEH');ylabel('Span');
	legend('annular','contoured','location','SE','orientation','vertical');
	legend boxon
	axis([-0.01 3.5e4 0 100])
	grid on

	f = figure(16);
    hold all;
    %plot(ones(9,1),X3_design_Wdotspan,'-k',X3_Wdotbeta,X3_span,'d-b'); %X3_design_Wdotbeta,X3_design_Wdotspan,'-k');
    plot(ones(9,1),X3_design_Wdotspan,'-k',X3_CFD_Wdotbeta,X3_CFD_span,'o-r',X3_Wdotbeta,X3_span,'d-b'); %X3_design_Wdotbeta,X3_design_Wdotspan,'-k');
    %plot(ones(9,1),X3_design_Wdotspan,'-k',X3_Wdotbeta,X3_span,'d-b');legend('design','annular','location','SW','orientation','vertical');
	title('X3 Relative design efficacy (Wdotbeta)'); xlabel('Wdotbeta');ylabel('Span');
	legend('design','annular','contoured','location','SW','orientation','vertical');
	legend boxon
	%axis([0.5 1.5 0 100])
	grid on

	f = figure(17);
    hold all;
	%plot(ones(9,1),X3_design_Vdotspan,'-k',X3_Vdotalpha,X3_span,'d-b'); %X3_design_Vdotalpha,X3_design_Vdotspan,'-k');
    plot(ones(9,1),X3_design_Vdotspan,'-k',X3_CFD_Vdotalpha,X3_CFD_span,'o-r',X3_Vdotalpha,X3_span,'d-b'); %X3_design_Vdotalpha,X3_design_Vdotspan,'-k');
    %plot(ones(9,1),X3_design_Vdotspan,'-k',X3_Vdotalpha,X3_span,'d-b');legend('design','annular','location','NE','orientation','vertical');
	title('X3 Absolute design efficacy (Vdotalpha)'); xlabel('Vdotalpha');ylabel('Span');
	legend('design','annular','contoured','location','NE','orientation','vertical');
	legend boxon
	%axis([0.5 1.5 0 100])
	grid on

	f = figure(18);
    hold all;
	plot(wake(:,2)*180/pi,'-b');
	title('Rotor exit wake angle'); xlabel('degrees');ylabel('Span');
	legend('contoured','location','NE','orientation','vertical');
	legend boxon
	%axis(auto)
	grid on

	f = figure(181);
    hold all;
	plot(wake(:,2)*180/pi,'-b'); xlabel('degrees');ylabel('Span');
	title('Rotor exit wake angle (extended)');
	legend('contoured','location','NE','orientation','vertical');
	legend boxon
	axis([0 2500 -90 0])
	%axis(auto)
	grid on

	f = figure(19);
    hold all;
	%plot(X3_experimental_beta_dev,X3_experimental_span,'o-k',X3_deviation.*X3_Cm*180/pi,X3_span,'d-b');
    plot(X3_experimental_beta_dev,X3_experimental_span,'o-k',X3_CFD_deviation.*X3_Cm*180/pi,X3_CFD_span,'o-r',X3_deviation.*X3_Cm*180/pi,X3_span,'d-b');
    %plot(X3_experimental_beta_dev,X3_experimental_span,'o-k',X3_deviation.*X3_Cm*180/pi,X3_span,'d-b');legend('experimental','annular','location','NE','orientation','vertical');
	title('Flow deviation from design (beta-dev)'); xlabel('degrees');ylabel('Span');
	legend('experimental','annular','contoured','location','NE','orientation','vertical');
	legend boxon
	grid on;

    f = figure(20);
    hold all;
	%plot(X3_design_alpha,X3_design_span,'-k',X3_experimental_alpha,X3_experimental_span,'o-k',X3_alpha.*180/pi,X3_span,'d-b');
    plot(X3_design_alpha,X3_design_span,'-k',X3_experimental_alpha,X3_experimental_span,'o-k',X3_CFD_alpha.*180/pi,X3_CFD_span,'o-r',X3_alpha.*180/pi,X3_span,'d-b');
    %plot(X3_design_alpha,X3_design_span,'-k',X3_experimental_alpha,X3_experimental_span,'o-k',X3_alpha.*180/pi,X3_span,'d-b');legend('design','experimental','annular','location','SW','orientation','vertical');
	title('X3 Rotor exit relative flow angle (alpha)'); xlabel('degrees');ylabel('Span');
	legend('design','experimental','annular','contoured','location','SW','orientation','vertical');
	legend boxon
	grid on;
    
    f = figure(21);
    hold all;
	%plot(X3_design_V,X3_design_span,'-k',X3_experimental_V,X3_experimental_span,'o-k',X3_V,X3_span,'d-b');
    plot(X3_design_V,X3_design_span,'-k',X3_experimental_V,X3_experimental_span,'o-k',X3_CFD_Vmag,X3_CFD_span,'o-r',X3_V,X3_span,'d-b');
    %plot(X3_design_V,X3_design_span,'-k',X3_experimental_V,X3_experimental_span,'o-k',X3_V,X3_span,'d-b');legend('design','experimental','annular','location','SE','orientation','vertical');
	title('X3 Rotor exit relative velocity (V)'); xlabel('m/s');ylabel('Span');
	legend('design','experimental','annular','contoured','location','SE','orientation','vertical');
	legend boxon
	grid on;
        
   %% X4 - alpha4, V4, nozzle efficiency, Cske
    % Set variables to local function workspace
    X4_span = results_struct.X4_span; X4_alpha = results_struct.X4_alpha; 
    X4_Cske = results_struct.X4_Cske; X4_HSke = results_struct.X4_HSke; 
    X4_loss = results_struct.X4_loss; X4_V = results_struct.X4_V;
    X4_beta = results_struct.X4_beta; X4_W = results_struct.X4_W;
    
	f = figure(22);
    hold all;
	%plot(X4_experimental_alpha,X4_experimental_span,'o-k',X4_alpha.*180/pi,X4_span,'d-b');
    plot(X4_experimental_alpha,X4_experimental_span,'o-k',X4_CFD_alpha.*180/pi,X4_CFD_span,'o-r',X4_alpha.*180/pi,X4_span,'d-b');
    %plot(X4_experimental_alpha,X4_experimental_span,'o-k',X4_alpha.*180/pi,X4_span,'d-b');legend('experimental','annular','location','SW','orientation','vertical');
	title('X4 Rotor exit absolute flow angle (alpha)');xlabel('degrees');ylabel('Span');
	legend('experimental','annular','contoured','location','SW','orientation','vertical');
	legend boxon
	axis([-35 60 0 100])
	grid on

	f = figure(23);
    hold all;
	%plot(X4_experimental_V,X4_experimental_span,'o-k',X4_V,X4_span,'d-b');
    plot(X4_experimental_V,X4_experimental_span,'o-k',X4_CFD_Vmag,X4_CFD_span,'o-r',X4_V,X4_span,'d-b');
    %plot(X4_experimental_V,X4_experimental_span,'o-k',X4_V,X4_span,'d-b');legend('experimental','annular','location','SE','orientation','vertical');
	title('X4 Rotor exit absolute velocity (V)');xlabel('m/s');ylabel('Span');
	legend('experimental','annular','contoured','location','SE','orientation','vertical');
	legend boxon
	axis([18 34 0 100])
	grid on

    f = figure(24);
    hold all;
	%plot(X4_experimental_beta,X4_experimental_span,'o-k',X4_beta.*180/pi,X4_span,'d-b');
    plot(X4_experimental_beta,X4_experimental_span,'o-k',X4_CFD_beta.*180/pi,X4_CFD_span,'o-r',X4_beta.*180/pi,X4_span,'d-b');
    %plot(X4_experimental_beta,X4_experimental_span,'o-k',X4_beta.*180/pi,X4_span,'d-b');legend('experimental','annular','location','SW','orientation','vertical');
	title('X4 Rotor exit relative flow angle (beta)');xlabel('degrees');ylabel('Span');
	legend('experimental','annular','contoured','location','SW','orientation','vertical');
	legend boxon
	%axis([-35 60 0 100])
    axis auto;
	grid on

	f = figure(25);
    hold all;
	%plot(X4_experimental_W,X4_experimental_span,'o-k',X4_W,X4_span,'d-b');
    plot(X4_experimental_W,X4_experimental_span,'o-k',X4_CFD_Wmag,X4_CFD_span,'o-r',X4_W,X4_span,'d-b');
    %plot(X4_experimental_W,X4_experimental_span,'o-k',X4_W,X4_span,'d-b');legend('experimental','annular','location','SE','orientation','vertical');
	title('X4 Rotor exit relative velocity (W)');xlabel('m/s');ylabel('Span');
	legend('experimental','annular','contoured','location','SE','orientation','vertical');
	legend boxon
	%axis([18 34 0 100])
    axis auto
	grid on
    
	f = figure(26);
    hold all;
	%plot(X4_experimental_Cske,X4_experimental_span,'o-k',X4_Cske,X4_span,'d-b');
    plot(X4_experimental_Cske,X4_experimental_span,'o-k',X4_CFD_Cske,X4_CFD_span,'o-r',X4_Cske,X4_span,'d-b');
    %plot(X4_experimental_Cske,X4_experimental_span,'o-k',X4_Cske,X4_span,'d-b');legend('experimental','annular','location','SE','orientation','vertical');
	title('X4 Coefficient of SKE (Cske)');xlabel('Cske');ylabel('Span');
	legend('experimental','annular','contoured','location','SE','orientation','vertical');
	legend boxon
	axis([0 1.5 0 100])
	grid on

	f = figure(27);
    hold all;
 	%plot(X4_experimental_loss,X4_experimental_span,'o-k',X4_loss,X4_span,'d-b');
    plot(X4_experimental_loss,X4_experimental_span,'o-k',X4_CFD_loss,X4_CFD_span,'o-r',X4_loss,X4_span,'d-b');
    %plot(X4_experimental_loss,X4_experimental_span,'o-k',X4_loss,X4_span,'d-b');legend('experimental','annular','location','SE','orientation','vertical');
	title('X4 Rotor exit loss (Cp0,rel)');xlabel('Cp0,rel');ylabel('Span');
	legend('experimental','annular','contoured','location','SE','orientation','vertical');
	legend boxon
	axis([-0.2 1 0 100])
	grid on

	f = figure(28);
    hold all;
	plot(X4_HSke,X4_span,'d-b');
    %plot(X4_CFD_HSke,X4_CFD_span,'o-r',X4_HSke,X4_span,'d-b');
    %plot(X4_CFD_HSke,X4_CFD_span,'o-r',X4_HSke,X4_span,'d-b');legend('annular','location','SE','orientation','vertical');
	title('X4 Secondary kinetic energy Helicity (SKEH)');xlabel('SKEH');ylabel('Span');
	legend('annular','contoured','location','SE','orientation','vertical');
	legend boxon
	axis([-0.01 3.5e4 0 100])
	grid on

end
cd('..');

