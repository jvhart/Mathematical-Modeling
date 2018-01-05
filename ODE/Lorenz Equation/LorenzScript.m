% Author: Jarod Hart
% Data: 11/15/17

% Description: This script uses Runge-Kutta order 4 to find a numerical 
% solution to The Lorenz equations.

% Dependencies: RK4.m

% Resources:  A description of these equations can be found in most ordinary
% differential equation textbooks or online.

addpath(genpath('../Numerical Solvers/'));

save_video=false; % save video? true/false. This will slow the video down
filename='SIR.avi'; % if true, include a filename to save the 
                                % video, .avi file extension must be
                                % included.

sigma=10;
rho=28;
beta=8/3;

x_0=1; % initial prey population
y_0=1; % initial predator population
z_0=1; % initial predator population

a=0; % start of time interval
b=50; % end of time interval
N=3000; % number of points for solver

F=@(t,y)[sigma*(y(2)-y(1)),y(1)*(rho-y(3))-y(2),y(1)*y(2)-beta*y(3)];
        % Function for the Lorenz systems of equations

y0=[x_0,y_0,z_0]; % full initial condition

S=RK4(a,b,N,y0,F); % finde numerical solution
T=S(:,1); % parse results
X=S(:,2);
Y=S(:,3);
Z=S(:,4);

% make plots

figure('Position',[200,200,900,350])
subplot(1,3,1)
hold on
plot(T,X)
xlabel('Time')
ylabel('Rate of Convection')

subplot(1,3,2)
hold on
plot(T,Y)
xlabel('Time')
ylabel('Horizontal Temperature Variation')

subplot(1,3,3)
hold on
plot(T,Z)
xlabel('Time')
ylabel('Vertical Temperature Variation')

figure
line(X,Y,Z)
xlabel('Rate of Convection')
ylabel('Horizontal Temperature Variation')
zlabel('Vertical Temperature Variation')
title('Lorenz Model')

figure
hold on
plot(T,X,'b-')
plot(T,Y,'r-')
plot(T,Z,'g-')
xlabel('Time')
title('Lorenz Model')
legend('Rate of Convection','Horizontal Temperature Variation',...
    'Vertical Temperature Variation')

% make video 

fig=figure('Position',[200,200,600,600]);
hold on
line(X,Y,Z)
plot3(x_0,y_0,z_0,'b.','MarkerSize',16)
xlabel('Rate of Convection')
ylabel('Horizontal Temperature Variation')
zlabel('Vertical Temperature Variation')
title('Lorenz Model')

if save_video
    V=VideoWriter(filename);
    open(V)
    F=getframe(fig);
    P=frame2im(F);
    writeVideo(V,P);
end

pause

for t=1:1:N+1
    line(X,Y,Z)
    plot3(X(t),Y(t),Z(t),'b.','MarkerSize',16)
    
    if save_video
        F=getframe(fig);
        P=frame2im(F);
        writeVideo(V,P);
    end
    pause(.01);
    cla
end
close(fig)
if save_video
    close(V)
end
