function [theta,phi,convertedData] = projectedToSpherical(theta_x, theta_y,data, degType);
%%%%%%
%%This function converts data reported in projected angles to spherical
%%coordinates
%%data is accepted as a 2-D matrix and returns 3, 1-D arrays with
%%corresponding theta, phi, and rho(data) 
%%
%% INPUTS: theta_x, theta_y - the projected angles are assumed to be the projection in the xz and yz
%%                           planes, measured with respect to the positive z axis (theta = 0 on
%%                           z-axis, and 90 in xy plane) NOTE: this may vary from other coordinate
%%                           definitions
%%          data -   the data that corresponds the projected angles theta_x and theta_y
%%
%% OUTPUTS: theta - same definition as above, measured wrt z-axis
%%          phi -   projected angle measured in the xy plane with respect
%%                          to positive x-axis
%%          convertedData - data resorted to correspond to theta and phi (can be treated as radial distance,rho)
%%                          NOTE: output data is no longer even along a rectilinear grid, and is therefore reported
%%                          as 3 1-D vectors
%%          NOTE #2 - projected angles of 90deg or pi/2 radian in either direction are a degenerate case and this data
%%                    is removed from the output data set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%written Barbara Kruse, 17Nov2015, rev1.0
%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Calculate theta and phi from projected angles
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
if degType   %if degrees
    theta_x = theta_x*pi/180;  %convert to radians
    theta_y = theta_y*pi/180;  
end
[angle_x angle_y] = meshgrid(theta_x,theta_y); %create grid of projected angle values
phi = atan2( tan( angle_y ), tan( angle_x ) )
theta = atan( 1 ./ sqrt( tan( angle_x ).^2 + tan( angle_y ).^2 ) )

theta = pi/2-theta;
if degType
    theta = 90-theta*180/pi;  %converts data back to degrees
    phi = phi*180/pi;
end
%
%
%%%%%%%%%%%%%%%%%%%%%%%%
%%convert Data and remove degenerate angle calculations
%%%%%%%%%%%%%%%%%%%%%%%%
[m n] = size(data);
%data((abs(angle_x) == pi/2)|(abs(angle_y) == pi/2))=NaN;  %flags Data as NaN since conversion to spherical is degenerate
%%
%%
%
data = reshape(data,1,m*n);
phi = reshape(phi,1,m*n);
theta = reshape(theta,1,m*n);
phi(isnan(data))=[];
theta(isnan(data))=[];
data(isnan(data))=[]; convertedData=data;


