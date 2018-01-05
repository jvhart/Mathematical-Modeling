% Author: Jarod Hart
% Data: 11/15/17

% Description: This script uses Runge-Kutta order 4 to find a numerical 
% solution to a system of ODEs for a Lotka-Volterra predator prey model.  

% Dependencies: RK4.m

% Resources:  A descrption of these equations can be found in any standard
% ordinary differential equations textbook or online.

addpath(genpath('../Numerical Solvers/'));

save_video=false; % save video? true/false. This will slow the video down
filename='Pred_Prey.avi'; % if true, include a filename to save the 
                                % video, .avi file extension must be
                                % included.
alpha=2; % prey growth rate
beta=.5; % likelihood parameter for prey to be caught by a predator
delta=.4; % likelihood parameter for predator to catch prey
gamma=.25; % death rate of predator

Prey_0=5; % initial prey population
Pred_0=5; % initial predator population

a=0; % start of time interval
b=50; % end of time interval
N=1000; % number of points for solver

F=@(t,y)[(alpha-beta*y(2))*y(1),(delta*y(1)-gamma)*y(2)];
        % Function for the sysem of ODEs describing the Lotka-Volterra
        % system

y0=[Prey_0,Pred_0]; % full initial condition

Y=RK4(a,b,N,y0,F); % finde numerical solution
T=Y(:,1); % parse results
Prey=Y(:,2);
Pred=Y(:,3);

% make plots

figure
subplot(1,2,1)
hold on
plot(T,Prey)
xlabel('Time')
ylabel('Prey Population')

subplot(1,2,2)
hold on
plot(T,Pred)
xlabel('Time')
ylabel('Predator Population')

figure
plot(Prey,Pred)
xlabel('Prey Population')
ylabel('Predator Population')
title('Lotka-Volterra Predator-Prey Model')

% make video 

fig=figure('Position',[200,200,1000,300]);
subplot(1,3,1)
hold on
plot(Prey,Pred,'b-')
plot(Prey_0,Pred_0,'bo','MarkerSize',8)
xlabel('Prey Population')
ylabel('Predator Population')

subplot(1,3,2)
hold on
plot(T,Prey,'r-')
plot(a,Prey_0,'ro','MarkerSize',8)
xlabel('Time')
ylabel('Prey Population')

subplot(1,3,3)
hold on
plot(T,Pred,'r-')
plot(a,Pred_0,'ro','MarkerSize',8)
xlabel('Time')
ylabel('Predator Population')

if save_video
    V=VideoWriter(filename);
    open(V)
    F=getframe(fig);
    P=frame2im(F);
    writeVideo(V,P);
end

for t=1:1:N+1
    
    subplot(1,3,1)
    plot(Prey,Pred,'b-')
    plot(Prey(t),Pred(t),'bo','MarkerSize',8)
    
    subplot(1,3,2)
    plot(T,Prey,'r-')
    plot(T(t),Prey(t),'ro','MarkerSize',8)
    
    subplot(1,3,3)
    plot(T,Pred,'r-')
    plot(T(t),Pred(t),'ro','MarkerSize',8)
    
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
