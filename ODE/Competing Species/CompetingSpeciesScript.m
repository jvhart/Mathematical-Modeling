% Author: Jarod Hart
% Data: 11/15/17

% Description: This script uses Runge-Kutta order 4 to find a numerical 
% solution to a system of ODEs for a competing species model.

% Dependencies: RK4.m

% Resources:  A description of these equations can be found in most ordinary
% differential equation textbooks or online.  The paper linked below also 
% provides analysis of results related to this system:

% http://scholar.rose-hulman.edu/cgi/viewcontent.cgi?article=1033&context=rhumj

addpath(genpath('../Numerical Solvers/'));

save_video=false; % save video? true/false. This will slow the video down
filename='CompetingSpecies.avi'; % if true, include a filename to save the 
                                % video, .avi file extension must be
                                % included.
alpha1=.1; % species 1 growth rate
alpha2=2.1; % species 2 growth rate
beta1=1; % species 1 overpopulation parameter
beta2=4; % species 2 competition parameter
gamma1=.5; % species 1 competition parameter
gamma2=1; % species 2 overpopulation parameter

S1_0=1; % initial prey population
S2_0=4; % initial predator population

a=0; % start of time interval
b=5; % end of time interval
N=200; % number of points for solver

F=@(t,y)[y(1)*(alpha1-beta1*y(1)-gamma1*y(2)),...
         y(2)*(alpha2-beta2*y(1)-gamma2*y(2))];
        % Function for the sysem of ODEs describing the competing species
        % model

y0=[S1_0,S2_0]; % full initial condition

Y=RK4(a,b,N,y0,F); % finde numerical solution
T=Y(:,1); % parse results
S1=Y(:,2);
S2=Y(:,3);

% make plots

figure
subplot(1,2,1)
hold on
plot(T,S1)
xlabel('Time')
ylabel('Species 1 Population')

subplot(1,2,2)
hold on
plot(T,S2)
xlabel('Time')
ylabel('Species 2 Population')

figure
plot(S1,S2)
xlabel('Species 1 Population')
ylabel('Species 2 Population')
title('Competing Species Population Model')

% make video 

fig=figure('Position',[200,200,1000,300]);
subplot(1,3,1)
hold on
plot(S1,S2,'b-')
plot(S1_0,S2_0,'bo','MarkerSize',8)
xlabel('Species 1 Population')
ylabel('Species 2 Population')

subplot(1,3,2)
hold on
plot(T,S1,'r-')
plot(a,S1_0,'ro','MarkerSize',8)
xlabel('Time')
ylabel('Species 1 Population')

subplot(1,3,3)
hold on
plot(T,S2,'r-')
plot(a,S2_0,'ro','MarkerSize',8)
xlabel('Time')
ylabel('Species 2 Population')

if save_video
    V=VideoWriter(filename);
    open(V)
    F=getframe(fig);
    P=frame2im(F);
    writeVideo(V,P);
end

for t=1:1:N+1
    
    subplot(1,3,1)
    plot(S1,S2,'b-')
    plot(S1(t),S2(t),'bo','MarkerSize',8)
    
    subplot(1,3,2)
    plot(T,S1,'r-')
    plot(T(t),S1(t),'ro','MarkerSize',8)
    
    subplot(1,3,3)
    plot(T,S2,'r-')
    plot(T(t),S2(t),'ro','MarkerSize',8)
    
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
