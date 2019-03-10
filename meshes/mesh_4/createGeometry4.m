function createGeometry4(blade_model,dir_model,endwall_model,x,iga)

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

% Create working directory
newdir = sprintf('%sGeneration_%d',dir_model.work_dir,iga); 
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

for line = 0:1:3
    
    % Generate xval and yval value at 0.1rad intervals for control lines:
    % <line1> line2<0> line3<1> line4<2> line5<3> <line5>
    
    xval = linspace(0,(blade_model.blade_angle*2)*pi/180,629);
    yval = 0; ymax = 0;
       
    for harm=1:1:endwall_model.harmonics
        yval = yval + ((x(1,(harm+(((endwall_model.harmonics*2)+1)*line))))*sin((360/(2*blade_model.blade_angle))*harm*xval)) + ...
            ((x(1,((harm+endwall_model.harmonics)+(((endwall_model.harmonics*2)+1)*line))))*cos((360/(2*blade_model.blade_angle))*harm*xval));
    end
       
    %%%REMOVE
    [x(1,(harm+(((endwall_model.harmonics*2)+1)*line))),...
    x(1,((harm+endwall_model.harmonics)+(((endwall_model.harmonics*2)+1)*line))),...
    x(endwall_model.npar/4 + endwall_model.npar/4*line)]
    %%%REMOVE
    
    % Find max of yval and scale amplitude
    ymax = max(abs(max(yval)),abs(min(yval)));
    yval = yval * x(endwall_model.npar/4 + endwall_model.npar/4*line) / ymax;

    if (isnan(yval))
        yval = zeros(1,629); 
    end
    
    %%%REMOVE
    hold all;
    plot(xval,yval,'-')
    grid on
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

        for harm=1:1:endwall_model.harmonics
            yval = yval + (((x(1,(harm+(((endwall_model.harmonics*2)+1)*line)))+x(1,(harm+(((endwall_model.harmonics*2)+1)*(line+1)))))/2)*sin((360/(2*blade_model.blade_angle))*harm*xval)) + ...
                (((x(1,((harm+endwall_model.harmonics)+(((endwall_model.harmonics*2)+1)*line)))+x(1,((harm+endwall_model.harmonics)+(((endwall_model.harmonics*2)+1)*(line+1)))))/2)...
                *cos((360/(2*blade_model.blade_angle))*harm*xval));
        end
           
        %%%REMOVE
        [(x(1,(harm+(((endwall_model.harmonics*2)+1)*line)))+x(1,(harm+(((endwall_model.harmonics*2)+1)*(line+1)))))/2,...
        (x(1,((harm+endwall_model.harmonics)+(((endwall_model.harmonics*2)+1)*line)))+x(1,((harm+endwall_model.harmonics)+(((endwall_model.harmonics*2)+1)*(line+1)))))/2,...
        (x(endwall_model.npar/4 + endwall_model.npar/4*line) + x(endwall_model.npar/4 + endwall_model.npar/4*(line+1)))/2]
        %%%REMOVE
    
        % Find max of yval and scale amplitude by average of x2 adjacent
        % lines
        ymax = max(abs(max(yval)),abs(min(yval)));
        yval = yval * ((x(endwall_model.npar/4 + endwall_model.npar/4*line) + x(endwall_model.npar/4 + endwall_model.npar/4*(line+1)))/2) / ymax;

        if (isnan(yval))
            yval = zeros(1,629); 
        end
        
        %%%REMOVE
        hold all;
        plot(xval,yval,'--')
        grid on
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
sy1b = sprintf('cp %s%s_mesh4.rpl ./%s_mesh.rpl',dir_model.base_dir,blade_model.blade_type,blade_model.blade_type);
system(sy1b);
sy1c = sprintf('cp %s/turbine_data/line* ./',dir_model.base_dir);
system(sy1c);
sy2a = sprintf('cp %s%s_inputfile1_extended_energy.txt ./inputfile',dir_model.base_dir,blade_model.blade_type);
system(sy2a);
sy2b = sprintf('cp %s%s_data_export.txt ./%s_data_export',dir_model.base_dir,blade_model.blade_type,blade_model.blade_type);
system(sy2b);
sy2c = sprintf('cp %sprofiles/%s_inlet_Vel5.prof ./%s_inlet_Vel.prof',dir_model.base_dir,blade_model.blade_type,blade_model.blade_type);
system(sy2c);
sy2d = sprintf('cp %s%s_intdata_extended_energy.ip ../intdata.ip',dir_model.base_dir,blade_model.blade_type);

if (~(exist('../intdata.ip','file')))
    system(sy2d);
end

% Write mesher and CFD script files
filename=['mesh_' int2str(iga) '.sh'];
[fid]=fopen(filename, 'w');
fprintf(fid,'#!/bin/bash \n');
fprintf(fid,'# Script to generate CFD mesh \n');
fprintf(fid,'if [ -f results.txt ] ; then \n');
fprintf(fid,' : \n');
fprintf(fid,'elif [ -f rotor.msh ] ; then \n');
fprintf(fid,' : \n');
fprintf(fid,'else \n');
fprintf(fid,'\t if [ -f endwall.sat ] ; then \n');
fprintf(fid,'\t\t /opt/ansys_inc/v145/icemcfd/linux64_amd/bin/icemcfd -batch -script %s_mesh.rpl &> icem_out.txt \n',blade_model.blade_type);
fprintf(fid,'\t else \n');
fprintf(fid,'\t\t /opt/Fluent.Inc/bin/gambit -inp %s_mesh_endwall_only.jou &> gambit_out.txt \n',blade_model.blade_type);
fprintf(fid,'\t\t rm -r GAMBIT* \n');
fprintf(fid,'\t\t rm -r default_id* \n');
fprintf(fid,'\t\t /opt/ansys_inc/v145/icemcfd/linux64_amd/bin/icemcfd -batch -script %s_mesh.rpl &> icem_out.txt \n',blade_model.blade_type);
fprintf(fid,'\t fi \n');
fprintf(fid,'fi \n');
fclose(fid); 		

filename=['CFD_' int2str(iga) '.sh'];
[fid]=fopen(filename, 'w');
fprintf(fid,'#!/bin/bash \n');
fprintf(fid,'# Script to run CFD simulation \n');
fprintf(fid,'if [ -f results.txt ] ; then \n');
fprintf(fid,' : \n');
fprintf(fid,'elif [ -f %s.cas.gz ] ; then \n',blade_model.blade_type);
fprintf(fid,'\t if [ ! -f %s.dat.gz ] ; then \n',blade_model.blade_type);
fprintf(fid,'\t : \n');
fprintf(fid,'\t else \n');
fprintf(fid,'\t\t if [ -f result ] ; then \n');
fprintf(fid,'\t\t : \n');
fprintf(fid,'\t\t else \n');
fprintf(fid,'\t\t /opt/ansys_inc/v150/fluent/bin/fluent 3d -g -gr -i %s_data_export &> data_export.txt \n',blade_model.blade_type);
fprintf(fid,'\t\t fi \n');
fprintf(fid,'\t fi \n');
fprintf(fid,'else \n');
fprintf(fid,'/opt/ansys_inc/v150/fluent/bin/fluent 3d -t12 -g -gr -i inputfile &> fluent_out.txt \n');
fprintf(fid,'fi \n');
fclose(fid);


% filename=['mesh_' int2str(iga) '.sh'];
% [fid]=fopen(filename, 'w');
% fprintf(fid,'#!/bin/sh \n');
% fprintf(fid,'# Script to generate CFD mesh \n');
% fprintf(fid,'if [ -f rotor.msh ] ; then \n');
% fprintf(fid,' : \n');
% fprintf(fid,'else \n');
% fprintf(fid,'\t if [ -f endwall.sat ] ; then \n');
% fprintf(fid,'\t\t /opt/ansys_inc/v145/icemcfd/linux64_amd/bin/icemcfd -batch -script %s_mesh.rpl &> icem_out.txt \n',blade_model.blade_type);
% fprintf(fid,'\t else \n');
% fprintf(fid,'\t\t /opt/Fluent.Inc/bin/gambit -inp %s_mesh_endwall_only.jou &> gambit_out.txt \n',blade_model.blade_type);
% fprintf(fid,'\t\t rm -r GAMBIT* \n');
% fprintf(fid,'\t\t rm -r default_id* \n');
% fprintf(fid,'\t\t /opt/ansys_inc/v145/icemcfd/linux64_amd/bin/icemcfd -batch -script %s_mesh.rpl &> icem_out.txt \n',blade_model.blade_type);
% fprintf(fid,'\t fi \n');
% fprintf(fid,'fi \n');
% fclose(fid); 		
% 
% filename=['CFD_' int2str(iga) '.sh'];
% [fid]=fopen(filename, 'w');
% fprintf(fid,'#!/bin/sh \n');
% fprintf(fid,'# Script to run CFD simulation \n');
% fprintf(fid,'if [ -f %s.cas.gz ] ; then \n',blade_model.blade_type);
% fprintf(fid,'\t if [ ! -f %s.dat.gz ] ; then \n',blade_model.blade_type);
% fprintf(fid,'\t : \n');
% fprintf(fid,'\t else \n');
% fprintf(fid,'\t\t if [ -f result ] ; then \n');
% fprintf(fid,'\t\t : \n');
% fprintf(fid,'\t\t else \n');
% fprintf(fid,'\t\t /opt/ansys_inc/v145/fluent/bin/fluent 3d -g -gr -i %s_data_export &> data_export.txt \n',blade_model.blade_type);
% fprintf(fid,'\t\t fi \n');
% fprintf(fid,'\t fi \n');
% fprintf(fid,'else \n');
% fprintf(fid,'/opt/ansys_inc/v145/fluent/bin/fluent 3d -t12 -g -gr -i inputfile &> fluent_out.txt \n');
% fprintf(fid,'fi \n');
% fclose(fid); 

%%% DO NOT REMOVE - OLD SCRIPT FORMAT
% filename=['mesh_' int2str(iga) '.sh'];
% [fid]=fopen(filename, 'w');
% fprintf(fid,'#!/bin/bash \n');
% fprintf(fid,'# Script to generate CFD mesh \n');
% fprintf(fid,'if [ -f results.txt ] ; then \n');
% fprintf(fid,' : \n');
% fprintf(fid,'elif [ -f rotor.msh ] ; then \n');
% fprintf(fid,' : \n');
% fprintf(fid,'else \n');
% fprintf(fid,'\t if [ -f endwall.sat ] ; then \n');
% fprintf(fid,'\t\t icemcfd -batch -script %s_mesh.rpl &> icem_out.txt \n',blade_model.blade_type);
% fprintf(fid,'\t else \n');
% fprintf(fid,'\t\t gambit -inp %s_mesh_endwall_only.jou &> gambit_out.txt \n',blade_model.blade_type);
% fprintf(fid,'\t\t rm -r GAMBIT* \n');
% fprintf(fid,'\t\t rm -r default_id* \n');
% fprintf(fid,'\t\t icemcfd -batch -script %s_mesh.rpl &> icem_out.txt \n',blade_model.blade_type);
% fprintf(fid,'\t fi \n');
% fprintf(fid,'fi \n');
% fclose(fid); 		
% 
% filename=['CFD_' int2str(iga) '.sh'];
% [fid]=fopen(filename, 'w');
% fprintf(fid,'#!/bin/bash \n');
% fprintf(fid,'# Script to run CFD simulation \n');
% fprintf(fid,'if [ -f results.txt ] ; then \n');
% fprintf(fid,' : \n');
% fprintf(fid,'elif [ -f %s.cas.gz ] ; then \n',blade_model.blade_type);
% fprintf(fid,'\t if [ ! -f %s.dat.gz ] ; then \n',blade_model.blade_type);
% fprintf(fid,'\t : \n');
% fprintf(fid,'\t else \n');
% fprintf(fid,'\t\t if [ -f result ] ; then \n');
% fprintf(fid,'\t\t : \n');
% fprintf(fid,'\t\t else \n');
% fprintf(fid,'\t\t fluent 3d -g -gr -i %s_data_export &> data_export.txt \n',blade_model.blade_type);
% fprintf(fid,'\t\t fi \n');
% fprintf(fid,'\t fi \n');
% fprintf(fid,'else \n');
% fprintf(fid,'fluent 3d -t12 -g -gr -i inputfile &> fluent_out.txt \n');
% fprintf(fid,'fi \n');
% fclose(fid); 
    