% Author: Jarod Hart
% Data: 11/15/17

% Description: This script uses Runge-Kutta order 4 to find a numerical 
% solution to a system of ODEs for a double pendulum.  It generates plots
% of the (x,y) coordinates for each point mass, the angles for both arms,
% and the angular velocity of both arms.  It also generates a video, which
% can be saved in .avi format using the parameters below.

% Dependencies: RK4.m

% Resources:  A descrption of these equations can be found in physics
% textbooks or online.

addpath(genpath('../Numerical Solvers/'));

save_video=false; % save video? true/false. This will slow the video down
filename='DoublePendVideo.avi'; % if true, include a filename to save the 
                                % video, .avi file extension must be
                                % included.

g=9.81; % force of gravity
L1=10; % length of first pendulum arm
L2=9; % length of second pendulum arm
m1=8; % mass of first point mass
m2=10; % mass of second point mass

theta1_0=0; % initial angle of first arm
theta2_0=0; % initial angle of second arm
omega1_0=4; % initial angular velocity of first arm
omega2_0=-8; % initial angular velocity of second arm

a=0; % start of time interval
b=12*pi; % end of time interval
N=2000; % number of points for solver

M=m1+m2; % total mass
F=@(t,y)[y(3),...
         y(4),...
         (-g*(M+m1)*sin(y(1))-m2*sin(y(1)-2*y(2))-2*sin(y(1)-y(2))*m2...
              *(y(3)^2*L1*cos(y(1)-y(2))+y(4)^2*L2))...
              /(L1*(M+m1-m2*cos(2*y(1)-2*y(2)))),...
         (2*sin(y(1)-y(2))*(M*y(3)^2*L1+g*M*cos(y(1))+y(4)^2*L2*m2...
              *cos(y(1)-y(2))))/(L2*(M+m1-m2*cos(2*y(1)-2*y(2))))];
        % Function for the sysem of ODEs describing the double pendulum
        % (after reduction of order)

y0=[theta1_0,theta2_0,omega1_0,omega2_0]; % full initial condition

Y=RK4(a,b,N,y0,F); 
T=Y(:,1);
X1=L1*sin(Y(:,2));
X2=L1*sin(Y(:,2))+L2*sin(Y(:,3));
Y1=-L1*cos(Y(:,2));
Y2=-L1*cos(Y(:,2))-L2*cos(Y(:,3));

figure
subplot(2,4,1)
hold on
plot(T,X1)
xlabel('Time')
ylabel('Arm 1 x position')

subplot(2,4,2)
hold on
plot(T,Y1)
xlabel('Time')
ylabel('Arm 1 y position')

subplot(2,4,3)
hold on
plot(T,X2)
xlabel('Time')
ylabel('Arm 2 x position')

subplot(2,4,4)
hold on
plot(T,Y2)
xlabel('Time')
ylabel('Arm 2 y position')

subplot(2,4,5)
hold on
plot(T,Y(:,2))
xlabel('Time')
ylabel('Arm 1 angle')

subplot(2,4,7)
hold on
plot(T,Y(:,3))
xlabel('Time')
ylabel('Arm 1 angular velocity')

subplot(2,4,6)
hold on
plot(T,Y(:,4))
xlabel('Time')
ylabel('Arm 2 angle')

subplot(2,4,8)
hold on
plot(T,Y(:,5))
xlabel('Time')
ylabel('Arm 2 angular velocity')


fig=figure;                 % Opens a new figure and names it fig
hold on % Holds the line in the figure
axis tight manual           % Fixes the axes of the figure
axis([-(L1+L2+2),L1+L2+2,-(L1+L2+2),L1+L2+2])    % Sets the x and y range for the axes
line([0,X1(1)],[0,Y1(1)])
line([X1(1),X2(1)],[Y1(1),Y2(1)])
plot(0,0,'bo','MarkerSize',10)
plot(X1(1),Y1(1),'b.','MarkerSize',3*m1)
plot(X2(1),Y2(1),'b.','MarkerSize',3*m2)
title('Double Pendulum Video')

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
    line([0,X1(t)],[0,Y1(t)])
    line([X1(t),X2(t)],[Y1(t),Y2(t)])
    plot(0,0,'bo','MarkerSize',10)
    plot(X1(t),Y1(t),'b.','MarkerSize',3*m1)
    plot(X2(t),Y2(t),'b.','MarkerSize',3*m2)
    title('Double Pendulum Video')
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
