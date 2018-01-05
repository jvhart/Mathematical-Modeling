% Author: Jarod Hart
% Data: 11/15/17

% Description: This script uses Runge-Kutta order 4 to find a numerical 
% solution to a system of ODEs for a single pendulum.  It generates plots
% of the (x,y) coordinates for the point mass and the angle of the arm.  
% It also generates a video, which can be saved in .avi format using the 
% parameters below.

% Dependencies: RK4.m

% Resources:  A descrption of these equations can be found in physics
% textbooks or online.

save_video=false; % save video? true/false. This will slow the video down
filename='SinglePendVideo.avi'; % if true, include a filename to save the 
                                % video, .avi file extension must be
                                % included.

addpath(genpath('../Numerical Solvers/'));

g=9.81; % force of gravity
L=5; % length of pendulum arm
M=7; % mass of point mass

theta_0=pi/2; % initial angle of arm
omega_0=0; % initial angular velocity of arm

a=0; % start of time interval
b=20; % end of time interval
N=500; % number of points for solver

F=@(t,y)[y(2),-M*g*sin(y(1))/L];
        % Function for the sysem of ODEs describing the single pendulum
        % (after reduction of order)

y0=[theta_0,omega_0]; % full initial condition

Y=RK4(a,b,N,y0,F); 
T=Y(:,1);
theta=Y(:,2);
omega=Y(:,3);
x=L*sin(theta);
y=-L*cos(theta);

figure
subplot(2,2,1)
hold on
plot(T,x)
xlabel('Time')
ylabel('Arm x position')

subplot(2,2,2)
hold on
plot(T,y)
xlabel('Time')
ylabel('Arm y position')

subplot(2,2,3)
hold on
plot(T,theta)
xlabel('Time')
ylabel('Arm angle')

subplot(2,2,4)
hold on
plot(T,omega)
xlabel('Time')
ylabel('Arm angular velocity')


fig=figure;                 % Opens a new figure and names it fig
hold on % Holds the line in the figure
axis tight manual           % Fixes the axes of the figure
axis([-(L+2),L+2,-(L+2),L+2])    % Sets the x and y range for the axes
line([0,x(1)],[0,y(1)])
plot(0,0,'bo','MarkerSize',10)
plot(x(1),y(1),'b.','MarkerSize',3*M)
title('Single Pendulum Video')

if save_video
    V=VideoWriter(filename);
    open(V)
    F=getframe(fig);
    P=frame2im(F);
    writeVideo(V,P);
end
xlabel('Press any button to start video')
pause
for t=1:1:N+1
    line([0,x(t)],[0,y(t)])
    plot(0,0,'bo','MarkerSize',10)
    plot(x(t),y(t),'b.','MarkerSize',3*M)
    title('Single Pendulum Video')
    xlabel(strcat('Progress: ',32,num2str(100*t/(N+1)),'%'))
    if save_video
        F=getframe(fig);
        P=frame2im(F);
        writeVideo(V,P);
    end
    pause(.001);
    cla
end
close(fig)
if save_video
    close(V)
end
