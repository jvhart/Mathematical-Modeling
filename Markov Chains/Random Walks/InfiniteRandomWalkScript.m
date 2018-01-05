% Author:   Jarod Hart
% Date:     November 20, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate how to do some random walks on an infinite
% number of states.  Two examples are given, on the integers Z and on the
% integer lattice Z^2.

% Dependencies: None

% Resources:  These random walks are standard in any Markov chain textbook.

p=.5; % probability of moving to the right
LengthSimulation=10000; % length of the simulation

r=rand(1,LengthSimulation);
r=2*(r<p)-1;
x=cumsum(r);

figure('Position',[100,100,800,600])
hold on
plot(1:LengthSimulation,x,'b')
scatter(1:LengthSimulation,x,10,'blue','filled')


%%


p=[.25,.25,.25,.25]; % probability of moving [right, left, up, down]
p=p/sum(p);
LengthSimulation=100000;

P=cumsum(p);
r=rand(1,LengthSimulation);
r=[ (2*(r<P(1))-1).*(r<P(2));(2*(r<P(3))-1).*(r>=P(2))];
x=[cumsum(r(1,:));cumsum(r(2,:))];

figure('Position',[100,100,800,600])
hold on
line(x(1,:),x(2,:))
scatter(x(1,:),x(2,:),10,'blue','filled')
