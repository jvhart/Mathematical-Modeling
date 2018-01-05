% Author: Jarod Hart
% Data: 11/15/17

% Description: This script uses Runge-Kutta order 4 to find a numerical 
% solution to a system of ODEs for an SIS model.

% Dependencies: RK4.m

% Resources:  A description of these equations can be found in most ordinary
% differential equation textbooks or online.

addpath(genpath('../Numerical Solvers/'));

save_video=false; % save video? true/false. This will slow the video down
filename='SIS.avi'; % if true, include a filename to save the 
                                % video, .avi file extension must be
                                % included.
                                
% use these parameters for constant population model
beta=.25; % infection parameter
gamma=.1; % recovery parameter

% set these parameters to zero for a constant population model
Lambda=0; % population independent growth rate
mu=0; % death rate

S_0=.8; % initial prey population
I_0=.2; % initial predator population

a=0; % start of time interval
b=50; % end of time interval
N=500; % number of points for solver

F=@(t,y)[Lambda-mu*y(1)-beta*y(1)*y(2)+gamma*y(2),...
           (beta*y(1)-gamma-mu)*y(2)];
        % Function for the sysem of ODEs describing the competing SIR model

y0=[S_0,I_0]; % full initial condition

Y=RK4(a,b,N,y0,F); % finde numerical solution
T=Y(:,1); % parse results
S=Y(:,2);
I=Y(:,3);

% make plots

figure('Position',[200,200,900,350])
subplot(1,2,1)
hold on
plot(T,S)
xlabel('Time')
ylabel('Susceptible Population')
axis([a,b,0,1])

subplot(1,2,2)
hold on
plot(T,I)
xlabel('Time')
ylabel('Infected Population')
axis([a,b,0,1])

figure
plot(S,I,'b-')
xlabel('Susceptibe Population')
ylabel('Infected Population')
title('SIS Model')
axis([0,1,0,1])

figure
hold on
plot(T,S,'b-')
plot(T,I,'r-')
axis([a,b,0,1])
xlabel('Time')
ylabel('Population')
legend('Susceptible','Infected')

% make video 

fig=figure('Position',[200,200,1000,300]);
subplot(1,3,1)
hold on
plot(S,I,'b-')
plot(S_0,I_0,'bo','MarkerSize',8)
xlabel('Susceptibe Population')
ylabel('Infected Population')
axis([0,1,0,1])

subplot(1,3,2)
hold on
plot(T,S,'r-')
plot(a,S_0,'ro','MarkerSize',8)
xlabel('Time')
ylabel('Susceptible Population')
axis([a,b,0,1])

subplot(1,3,3)
hold on
plot(T,I,'r-')
plot(a,I_0,'ro','MarkerSize',8)
xlabel('Time')
ylabel('Infected Population')
axis([a,b,0,1])

if save_video
    V=VideoWriter(filename);
    open(V)
    F=getframe(fig);
    P=frame2im(F);
    writeVideo(V,P);
end

for t=1:1:N+1
    
    subplot(1,3,1)
    plot(S,I,'b-')
    plot(S(t),I(t),'bo','MarkerSize',8)

    subplot(1,3,2)
    plot(T,S,'r-')
    plot(T(t),S(t),'ro','MarkerSize',8)

    subplot(1,3,3)
    plot(T,I,'r-')
    plot(T(t),I(t),'ro','MarkerSize',8)
    
    if save_video
        F=getframe(fig);
        P=frame2im(F);
        writeVideo(V,P);
    end
    pause(.001);
    subplot(1,3,1)
    cla
    subplot(1,3,2)
    cla
    subplot(1,3,3)
    cla
end
close(fig)
if save_video
    close(V)
end
