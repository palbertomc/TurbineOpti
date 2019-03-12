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

function Z=circumAve(inputfile,column)

% Matlab function to import CFD results and produce radially averaged averaged quantities
% Part of Matlab script extract.m
%
% Inputs are CFD results filename (inputfile) and column number of first data column
% Output is matrix Z of radial values and corresponding averages

% Initialise counters
count=0;

% Import raw data from Fluent ASCII file
data=dlmread(inputfile,',',1,0);

% Read node xyz locations and produce r-theta-z coordinates for node points
x=data(:,2);		% x coordinate
y=data(:,3);		% y coordinate
z=data(:,4);		% Z coordinate

n_points = length(y);

% Compute r
r = sqrt(x.^2 + y.^2);

% Compute theta
for count=1:1:n_points			% for all y-locations
	if (y(count,1) >= 0)   
    		theta(count,1) = abs(asin(x(count,1) / r(count,1)));		% calculate theta if y>=0        
    else  
    		theta(count,1) = pi-abs(asin(x(count,1) / r(count,1)));		% calculate theta if y<0       
	end
end

% Set up vectors of required r and theta values at which to extract data
radii=[0.1435 0.1455 0.1475 0.1495 0.1515 0.1535 0.1555 0.1575 0.1595 0.1615 ...
    0.1635 0.1655 0.1675 0.1695 0.1715 0.1735 0.1755 0.1775 0.1795 0.1815 0.1835 ...
    0.1855 0.1875 0.1895 0.1915 0.1935 0.1955 0.1975 0.1995 0.2015]; 

thetavalue=linspace(min(theta),max(theta),1000);        % Produce 1000 points across measurement plane

% Starts the process by extracting and processing each data column in succession
i=0;
for j=1:1:length(radii)
    rvalue = radii(j);
    
    i = i + 1;
    
    % Searches data matrix for data values specified in column and returns data in
    % temporary vector 'temp'
    temp1 = data(:,column);
    
    % Sets up an interpolant for use with the data
    F = TriScatteredInterp(y,x,temp1);

    % Set up x and y values at which to evaluate the
    % interpolant
    xvalue=rvalue * sin(thetavalue);
    yvalue=rvalue * cos(thetavalue);

    % Produces theoretical data values at specified points by interpolating between nearest real values from CFD data
    temp2 = F(yvalue,xvalue);         % produce interpolated data and store in temporary vector 'temp2' including any NaN's produced by TriScatteredInterp

    % Clean up temp vector by removing NaN's
    n = 0;
    temp3 = 0;                        % set temp3=0 in case first value is NaN in which case a 0 would be normally be produced as first vector element
    
    for m=1:1:length(temp2)         % ignore values which are NaN
        
        if (~isnan(temp2(m)))
            n = n + 1;
            temp3(n) = temp2(m);  % form 'temp3' using only non-NaN values
        end
        
    temp4 = mean(temp3);              % calculate mean of circumferential points
    
    end
    
    Z(j,1) = rvalue;                  % build results matrix of radius points and corresponding averages
    Z(j,2) = temp4;
    
%     if (strcmp(inputfile,'x3') && (column == 5) && (mod(i,3) == 0))
%         figure(200)
%         hold on; grid on; box on;
%         plot(temp3,'-','linewidth',2);title('X3 Ps');
%     
%     elseif (strcmp(inputfile,'x3') && (column == 6) && (mod(i,3) == 0))
%         figure(201)
%         hold on; grid on; box on;
%         plot(temp3,'-','linewidth',2);title('X3 Pt');
%         
%     elseif (strcmp(inputfile,'x3') && (column == 8) && (mod(i,3) == 0))
%         figure(202)
%         hold on; grid on; box on;
%         plot(temp3,'-','linewidth',2);title('X3 V');
%     end
%     
%     if (strcmp(inputfile,'x4') && (column == 5) && (mod(i,3) == 0))
%         figure(203)
%         hold on; grid on; box on;
%         plot(temp3,'-','linewidth',2);title('X4 Ps');
%     
%     elseif (strcmp(inputfile,'x4') && (column == 6) && (mod(i,3) == 0))
%         figure(204)
%         hold on; grid on; box on;
%         plot(temp3,'-','linewidth',2);title('X4 Pt');
%         
%     elseif (strcmp(inputfile,'x4') && (column == 8) && (mod(i,3) == 0))
%         figure(205)
%         hold on; grid on; box on;
%         plot(temp3,'-','linewidth',2);title('X4 V');
%     end
%     
%     if (strcmp(inputfile,'x2') && (column == 5) && (mod(i,3) == 0))
%         figure(206)
%         hold on; grid on; box on;
%         plot(temp3,'-','linewidth',2);title('X4 Ps');
%     
%     elseif (strcmp(inputfile,'x2') && (column == 6) && (mod(i,3) == 0))
%         figure(207)
%         hold on; grid on; box on;
%         plot(temp3,'-','linewidth',2);title('X4 Pt');
%         
%     elseif (strcmp(inputfile,'x2') && (column == 8) && (mod(i,3) == 0))
%         figure(208)
%         hold on; grid on; box on;
%         plot(temp3,'-','linewidth',2);title('X4 V');
%     end
    
end

% Test data mapping
%hold on;
%plot(y,x,'o');
%plot(yvalue,xvalue,'or');

end
