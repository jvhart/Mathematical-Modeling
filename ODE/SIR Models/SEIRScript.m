% Author: Jarod Hart
% Data: 11/15/17

% Description: This script uses Runge-Kutta order 4 to find a numerical 
% solution to a system of ODEs for an SEIR model.

% Dependencies: RK4.m

% Resources:  A description of these equations can be found in most ordinary
% differential equation textbooks or online.

addpath(genpath('../Numerical Solvers/'));

% use these parameters for constant population model
beta=.25; % infection parameter
gamma=.1; % recovery parameter
a=.2; % exposure latency parameter

% set these parameters to zero for a constant population model
Lambda=0; % population independent growth rate
mu=.1; % death rate

S_0=.8; % initial prey population
E_0=0; % initial predator population
I_0=.2; % initial predator population
R_0=0; % initial predator population

a=0; % start of time interval
b=50; % end of time interval
N=500; % number of points for solver

F=@(t,y)[Lambda-mu*y(1)-beta*y(1)*y(3),beta*y(1)-(mu+a)*y(2),...
           a*y(2)-(gamma+mu)*y(3),gamma*y(3)-mu*y(4)];
        % Function for the sysem of ODEs describing the competing SIR model

y0=[S_0,E_0,I_0,R_0]; % full initial condition

Y=RK4(a,b,N,y0,F); % finde numerical solution
T=Y(:,1); % parse results
E=Y(:,2);
S=Y(:,3);
I=Y(:,4);
R=Y(:,5);

% make plots

figure('Position',[200,200,600,600])
subplot(2,2,1)
hold on
plot(T,S)
xlabel('Time')
ylabel('Susceptible Population')

subplot(2,2,2)
hold on
plot(T,E)
xlabel('Time')
ylabel('Exposed Population')

subplot(2,2,3)
hold on
plot(T,I)
xlabel('Time')
ylabel('Infected Population')

subplot(2,2,4)
hold on
plot(T,R)
xlabel('Time')
ylabel('Recovered Population')

figure
hold on
plot(T,S,'b-')
plot(T,E,'r-')
plot(T,I,'g-')
plot(T,R,'m-')
xlabel('Time')
ylabel('Population')
legend('Susceptible','Exposed','Infected','Recovered')

