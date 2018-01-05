% Author:        Jarod Hart
% Date:          January 3, 2018
% Description:   This function produces an animation of a simulated Markov
% chain.  Several configurations are allowed for animation, including
% circle, random, line, and graph (graph is the graph of a function that
% must also be an input when specified).

% Inputs:
%             AllStates - integer vector of states in the simulation
%             type - configuration of points, choose from 'circle',
%                    'random', 'line', and 'graph' (graphs requires f to be
%                    specified as well
%             f - inline function, must be specified for 'graph' option,
%                 should map [-1,1] into [-1,1]

% Outputs: none

% Dependencies: none

function [] = AnimateMC(AllStates,type,speed,f)

T=length(AllStates);
n=max(AllStates);

active=((1:n)==AllStates(1));

if strcmp(type,'circle')
    s=linspace(0,2*pi,n+1);
    s=s(1:end-1);
    x=cos(s);
    y=sin(s);
elseif strcmp(type,'random')
    x=2*rand(1,n)-1;
    y=2*rand(1,n)-1;
elseif strcmp(type,'line')
    x=linspace(-1,1,n);
    y=zeros(1,n);
elseif strcmp(type,'graph')
    x=linspace(-1,1,n);
    y=f(x);
end

fig=figure('Position',[100,100,600,600]);
axis tight manual
axis([-1.2,1.2,-1.2,1.2])
hold on
scatter(x(active),y(active),40,'red','filled')
scatter(x(~active),y(~active),40,'blue','filled')
xlabel('Press any key')

pause
xlabel(' ')
for t=2:T
    lastactive=active;
    active=((1:n)==AllStates(t));
    x0=x(lastactive);
    y0=y(lastactive);
    x1=x(active);
    y1=y(active);
    d=((x1-x0)^2+(y1-y0)^2)^.5;
    u=0:.05/d:1;
    X=x0+u*(x1-x0);
    Y=y0+u*(y1-y0);
    for i=1:1:length(u)
        cla
        scatter(x,y,40,'blue','filled')
%       scatter(X(1:i),Y(1:i),40,'red','filled') % uncomment to show trails
        scatter(X(i),Y(i),40,'red','filled')
        pause(1/((length(u)+1)*speed))
    end
    cla
    scatter(x(~active),y(~active),40,'blue','filled')
    scatter(x(active),y(active),40,'red','filled')
    pause(1/((length(u)+1)*speed))
end
close(fig)
