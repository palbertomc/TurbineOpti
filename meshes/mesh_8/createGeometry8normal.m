function createGeometry8normal(blade_model,dir_model,resource_model,x,iga,GUIhandles)

% Function to generate geometry input files for turbine mesher and CFD
% software
%
% Input:
%   par -       vector (1 x n) of endwall parameters
%
% Output:
%   null
%
% Notes:
%
% J Bergh, 2014

% Get gui handle data;
if (nargin > 5)
    handles = guidata(GUIhandles);
end

% Create working directory
newdir = sprintf('%sGeneration_%.1f',dir_model.work_dir,iga); 
mkdir(newdir); cd(newdir);

% Read in blade mean camberline coordinates for MAIN control lines and convert to (r,theta,z)
blade_points = dlmread(sprintf('%s%s_axial_planes',dir_model.turbine_dir,blade_model.blade_type));
blade_z = blade_points(:,3);
blade_x = blade_points(:,1);
blade_y = blade_points(:,2);

blade_axial = transpose(blade_z);                           
blade_r = sqrt(blade_x.^2 + blade_y.^2);

for q = 1:1:4
    if (blade_y(q,1) >= 0)
        blade_theta(q,1) = asin(blade_x(q,1)./blade_r(q,1));
    else
        blade_theta(q,1) = -asin(blade_x(q,1)./blade_r(q,1)) + pi;
    end
end

% Read in blade mean camberline coordinates for FAUX control lines and convert to (r,theta,z)
blade_points_extra = dlmread(sprintf('%s%s_axial_planes_extra',dir_model.turbine_dir,blade_model.blade_type));
blade_z_extra = blade_points_extra(:,3);
blade_x_extra = blade_points_extra(:,1);
blade_y_extra = blade_points_extra(:,2);

blade_axial_extra = transpose(blade_z_extra);                           
blade_r_extra = sqrt(blade_x_extra.^2 + blade_y_extra.^2);

for q = 1:1:3
    if (blade_y(q,1) >= 0)
        blade_theta_extra(q,1) = asin(blade_x_extra(q,1)./blade_r_extra(q,1));
    else
        blade_theta_extra(q,1) = -asin(blade_x_extra(q,1)./blade_r_extra(q,1)) + pi;
    end
end

% Form co-efficient vector
coeff = [x(1) x(2) x(3), x(4) x(5) (x(3)+x(6)), x(7) x(8) (x(3)+x(6)+x(9)), x(10) x(11) (x(3)+x(6)+x(9)+x(12))];

% Clear curves plot
if (nargin > 5)
    cla(handles.axes7)
end

% Generate control lines
for line = 0:1:3
    
    % Generate xval and yval value at 0.1rad intervals for control lines:
    % <line1> line2<0> line3<1> line4<2> line5<3> <line5>
    
    xval = linspace(0,(blade_model.blade_angle*2)*pi/180,629);
    yval = 0; ymax = 0;
    
    yval = yval + coeff(1,1+(line*3))*sin((coeff(2+(line*3))*xval)*(360/(2*blade_model.blade_angle)) + coeff(3+line*3));
   
    %%%REMOVE
   % [coeff(1,1+(line*3)),...
   % coeff(2+(line*3)),...
   % coeff(3+(line*3))]
    %%%REMOVE
    
    %Catch NaN's for bad coefficients and set perturbation to zero if this
    %is the case
    if (isnan(yval))
        yval = zeros(1,629); 
    end
    
    %%%REMOVE
    %figure(200)
    if (nargin > 5)
        axes(handles.axes7);
        hold all;
        plot(xval,yval,'-')
        grid on; axis([0 ((blade_model.blade_angle*2)*pi/180) -4 4]);
        xlabel('SS ------------------------------------------- PS'); ylabel('Amplitude (mm)');
    end
    %%%REMOVE
    
    % Add mean turbine hub radius to yval
    r = yval + (blade_model.R0 * 1000);
    
    % Offset xval by start position (i.e. blade camberline)
    xval = (blade_theta(line+1) - blade_model.blade_angle * pi / 180) + xval;

    % Convert (r,theta,z) back into (x,y,z) and flip L -> R
    yval = fliplr(r.*sin(xval));
    xval = fliplr(r.*cos(xval));                         
    
    % Write out yval and xval to file
    filename = ['line_' int2str(line+2) '.dat'];
    [fid] = fopen(filename, 'w');
    fprintf(fid,'629\t1\n');
    for o=1:1:629
        fprintf(fid,'%2.6f', yval(o));
        fprintf(fid,'\t');
        fprintf(fid,'%3.6f', xval(o));
        fprintf(fid,'\t');
        fprintf(fid,'%3.6f\n', blade_axial(line+1));      
    end
    fclose(fid);
    
    % If inbetween line<1><2><3>, generate faux control line
    if ((line == 0) || (line == 1) || (line == 2))
       
        xval = linspace(0,(blade_model.blade_angle*2)*pi/180,629);
        yval = 0; ymax = 0;
            
        yval = yval + ((coeff(1,1+(line*3))+coeff(1,1+((line+1)*3)))/2)*sin((((coeff(2+(line*3))+coeff(2+((line+1)*3)))/2)*xval)*(360/(2*blade_model.blade_angle)) +...
                (coeff(3+(line*3))+coeff(3+((line+1)*3)))/2);
   
        %%%REMOVE
      %  [(coeff(1,1+(line*3))+coeff(1,1+((line+1)*3)))/2,...
      %  (coeff(2+(line*3))+coeff(2+((line+1)*3)))/2,...
      %  (coeff(3+(line*3))+coeff(3+((line+1)*3)))/2]
        %%%REMOVE
    
        % Catch NaN's for bad coefficients and set perturbation to zero if this
        % is the case
        if (isnan(yval))
            yval = zeros(1,629); 
        end
        
        %%%REMOVE
        %figure(200)
        if (nargin > 5)
            axes(handles.axes7)
            plot(xval,yval,'--')
            hold off;
        end
        %%%REMOVE

        % Add mean turbine hub radius to yval
        r = yval + (blade_model.R0 * 1000);

        % Offset xval by start position (i.e. blade camberline)
        xval = (blade_theta_extra(line+1) - blade_model.blade_angle * pi / 180) + xval;

        % Convert (r,theta,z) back into (x,y,z) and flip L -> R
        yval = fliplr(r.*sin(xval));                      
        xval = fliplr(r.*cos(xval));                      

        % Write out yval and xval to file
        filename = ['line_' int2str(line+2) 'a.dat'];
        [fid] = fopen(filename, 'w');
        fprintf(fid,'629\t1\n');
        for o=1:1:629
            fprintf(fid,'%2.6f', yval(o));
            fprintf(fid,'\t');
            fprintf(fid,'%3.6f', xval(o));
            fprintf(fid,'\t');
            fprintf(fid,'%3.6f\n', blade_axial_extra(line+1));      
        end
        fclose(fid);

    end
    
end

% Copy meshing and CFD setup files to working dir
sy1a = sprintf('cp %s%s_mesh_endwall_only.jou ./%s_mesh_endwall_only.jou',dir_model.base_dir,blade_model.blade_type,blade_model.blade_type);
system(sy1a);

%[hname,~] = system('hostname');
%
%if (strcmp(hname,'cerecam-xeon16-0-2.local') || strcmp(hname,'cerecam-xeon16-0-1.local'))
%	sy1b = sprintf('cp %s%s_mesh_chimera.rpl ./%s_mesh.rpl',dir_model.base_dir,blade_model.blade_type,blade_model.blade_type);
%else
%	sy1b = sprintf('cp %s%s_mesh_normal.rpl ./%s_mesh.rpl',dir_model.base_dir,blade_model.blade_type,blade_model.blade_type);
%end
sy1b = sprintf('cp %s%s_mesh_normal.rpl ./%s_mesh.rpl',dir_model.base_dir,blade_model.blade_type,blade_model.blade_type);
system(sy1b);	

sy1c = sprintf('cp %s/turbine_data/line* ./',dir_model.base_dir);
system(sy1c);
sy2a = sprintf('cp %s%s_inputfile2_FULL ./inputfile',dir_model.base_dir,blade_model.blade_type);
system(sy2a);
sy2b = sprintf('cp %s%s_data_export2 ./data_export',dir_model.base_dir,blade_model.blade_type);
system(sy2b);
sy2c = sprintf('cp %s%s_inlet_Vel5.prof ./%s_inlet_Vel.prof',dir_model.base_dir,blade_model.blade_type,blade_model.blade_type);
system(sy2c);
sy2d = sprintf('cp %s%s_intdata2.ip ../intdata.ip',dir_model.base_dir,blade_model.blade_type);

if (~(exist('../intdata.ip','file')))
    system(sy2d);
end

% Write mesher and CFD script files
%filename=['mesh_' num2str(iga) '.sh'];
filename = sprintf('mesh_%.1f.sh',iga);
[fid]=fopen(filename, 'w');
fprintf(fid,'#!/bin/bash \n');
fprintf(fid,'# Script to generate CFD mesh \n');
fprintf(fid,'nameofhost=`hostname` \n');
fprintf(fid,'if [ -f results.txt ] ; then \n');
fprintf(fid,' : #Do nothing \n');
fprintf(fid,'elif [ -f rotor.msh ] ; then \n');
fprintf(fid,' : #Do nothing \n');
fprintf(fid,'else \n');
fprintf(fid,'\t if [ -f endwall.sat ] ; then \n');
fprintf(fid,'\t\t if [ "$nameofhost" == "cerecam-xeon16-0-2.local" ] || [ "$nameofhost" == "cerecam-xeon16-0-1.local" ] || [ "$nameofhost" == "cerecam-opteron12-0-1.local" ]; then \n');
fprintf(fid,'\t\t\t /share/apps/ansys_inc/v145/icemcfd/linux64_amd/bin/icemcfd -batch -script %s_mesh.rpl | tee icem_out.txt \n',blade_model.blade_type);
fprintf(fid,'\t\t else \n');
fprintf(fid,'\t\t\t /opt/ansys_inc/v145/icemcfd/linux64_amd/bin/icemcfd -batch -script %s_mesh.rpl | tee icem_out.txt \n',blade_model.blade_type);
fprintf(fid,'\t\t fi \n');
fprintf(fid,'\t else \n');
fprintf(fid,'\t\t if [ "$nameofhost" == "cerecam-xeon16-0-2.local" ] || [ "$nameofhost" == "cerecam-xeon16-0-1.local" ] || [ "$nameofhost" == "cerecam-opteron12-0-1.local" ]; then \n');
fprintf(fid,'\t\t\t /share/apps/Fluent.Inc/bin/gambit -inp %s_mesh_endwall_only.jou | tee gambit_out.txt \n',blade_model.blade_type);
fprintf(fid,'\t\t\t rm -r GAMBIT* \n');
fprintf(fid,'\t\t\t rm -r default_id* \n');
fprintf(fid,'\t\t\t /share/apps/ansys_inc/v145/icemcfd/linux64_amd/bin/icemcfd -batch -script %s_mesh.rpl | tee icem_out.txt \n',blade_model.blade_type);
fprintf(fid,'\t\t else \n');
fprintf(fid,'\t\t\t /opt/Fluent.Inc/bin/gambit -inp %s_mesh_endwall_only.jou | tee gambit_out.txt \n',blade_model.blade_type);
fprintf(fid,'\t\t\t rm -r GAMBIT* \n');
fprintf(fid,'\t\t\t rm -r default_id* \n');
fprintf(fid,'\t\t\t /opt/ansys_inc/v145/icemcfd/linux64_amd/bin/icemcfd -batch -script %s_mesh.rpl | tee icem_out.txt \n',blade_model.blade_type);
fprintf(fid,'\t\t fi \n');
fprintf(fid,'\t fi \n');
fprintf(fid,'fi \n');
fclose(fid); 		

%filename=['CFD_' num2str(iga) '.sh'];
filename = sprintf('CFD_%.1f.sh',iga);
[fid]=fopen(filename, 'w');
fprintf(fid,'#!/bin/bash \n');
fprintf(fid,'# Script to run CFD simulation \n');
fprintf(fid,'nameofhost=`hostname` \n');
fprintf(fid,'if [ -f results.txt ] ; then \n');
fprintf(fid,' : #Do nothing \n');
fprintf(fid,'elif [ -f %s.cas.gz ] ; then \n',blade_model.blade_type);
fprintf(fid,'\t if [ ! -f %s.dat.gz ] ; then \n',blade_model.blade_type);
fprintf(fid,'\t : #Do nothing \n');
fprintf(fid,'\t else \n');
fprintf(fid,'\t\t if [ -f result ] ; then \n');
fprintf(fid,'\t\t : #Do nothing \n');
fprintf(fid,'\t\t else \n');
fprintf(fid,'\t\t\t if [ "$nameofhost" == "cerecam-xeon16-0-2.local" ] || [ "$nameofhost" == "cerecam-xeon16-0-1.local" ] || [ "$nameofhost" == "cerecam-opteron12-0-1.local" ]; then \n');
fprintf(fid,'\t\t\t\t /share/apps/ansys_inc/v150/fluent/bin/fluent 3d -g -gr -i data_export | tee data_export.txt \n');
fprintf(fid,'\t\t\t else \n');
fprintf(fid,'\t\t\t\t /opt/ansys_inc/v150/fluent/bin/fluent 3d -g -gr -i data_export | tee data_export.txt \n');
fprintf(fid,'\t\t\t fi \n');
fprintf(fid,'\t\t fi \n');
fprintf(fid,'\t fi \n');
fprintf(fid,'else \n');
fprintf(fid,'\t if [ "$nameofhost" == "cerecam-xeon16-0-2.local" ] || [ "$nameofhost" == "cerecam-xeon16-0-1.local" ] || [ "$nameofhost" == "cerecam-opteron12-0-1.local" ]; then \n');
fprintf(fid,'\t\t /share/apps/ansys_inc/v150/fluent/bin/fluent 3d -t%d -mpi=intel -gu -driver null -i inputfile | tee fluent_out.txt \n',resource_model.ncores);
fprintf(fid,'\t else \n');
fprintf(fid,'\t\t /opt/ansys_inc/v150/fluent/bin/fluent 3d -t%d -mpi=intel -gu -driver null -i inputfile | tee fluent_out.txt \n',resource_model.ncores);
fprintf(fid,'\t fi \n');
fprintf(fid,'fi \n');
fclose(fid);

% Prepare rsync scripts to move files on/off compute node
% filename='copy.sh';
% [fid]=fopen(filename,'w');
% fprintf(fid,'#!/bin/bash \n');
% fprintf(fid,'# Script to copy data to cluster for processing \n');
% %%fprintf(fid,'sshpass -p %s ssh %s@%s "mkdir -p /home/%s/temp/" > /dev/null \n',resource_model.cluster_password,resource_model.username,resource_model.cluster_address,resource_model.username);
% fprintf(fid,'COMMAND="rsync -rz --exclude="project*" --exclude="nastran*" --exclude="endwall*" --exclude="hex*" --exclude="*.txt" --exclude="family*" --exclude="*.dat" --exclude="*.rpl" --exclude="*.jou" --exclude="mesh_*.*" --exclude="retrieve.sh" --ignore-existing %sGeneration_%d %s@%s:/home/%s/temp/" \n',dir_model.work_dir,iga,resource_model.username,resource_model.cluster_address,resource_model.username);
% fprintf(fid,'while ! $COMMAND \n');
% fprintf(fid,'do \n');
% fprintf(fid,'\t echo "Trying to connect ..." \n');
% fprintf(fid,'\t sleep 60 \n');
% fprintf(fid,'done \n');
% fclose(fid);
% 
% filename='retrieve.sh';
% [fid]=fopen(filename,'w');
% fprintf(fid,'#!/bin/bash \n');
% fprintf(fid,'# Script to remove data from cluster for processing \n');
% fprintf(fid,'COMMAND="rsync -rz --ignore-existing --max-size="350MB" %s@%s:/home/%s/temp/Generation_%d ../" \n',resource_model.username,resource_model.cluster_address,resource_model.username,iga);
% fprintf(fid,'while ! $COMMAND \n');
% fprintf(fid,'do \n');
% fprintf(fid,'\t echo "Trying to connect ..." \n');
% fprintf(fid,'\t sleep 60 \n');
% fprintf(fid,'done \n');
% fclose(fid);
