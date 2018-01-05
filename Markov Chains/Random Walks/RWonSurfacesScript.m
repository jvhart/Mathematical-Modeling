% Author:   Jarod Hart
% Date:     November 20, 2017
% Description: This is a script file.  It can be run as is.  This script
% shows some different ways to visualize random walks on differnt surfaces.
% Below are random walks plotted on a torus and on an elipsoid.

% Dependencies: None

%% Generate random walk

p=[.25,.25,.25,.25]; % probability of moving [right, left, up, down]
p=p/sum(p);
LengthSimulation=20000;

P=cumsum(p);
r=rand(1,LengthSimulation);
r=[ (2*(r<P(1))-1).*(r<P(2));(2*(r<P(3))-1).*(r>=P(2))];
x=[cumsum(r(1,:));cumsum(r(2,:))];

%% Random walk on a torus

u=.005*2*pi*x(1,:);
v=.005*2*pi*x(2,:);
[U,V]=meshgrid(0:.1:2*pi+.05,0:.1:2*pi+.05);% make mesh

c=1; % large radius of torus
r=.5; % small radius of torus

Torus1=@(x,y) (c+r*cos(y)).*cos(x); % parameterize the torus
Torus2=@(x,y) (c+r*cos(y)).*sin(x);
Torus3=@(x,y) r*sin(y);

figure
hold on
surf(Torus1(U,V),Torus2(U,V),Torus3(U,V),'mesh','none','FaceAlpha',0.5)
plot3(Torus1(u,v),Torus2(u,v),Torus3(u,v),'LineWidth',2 )
axis([-(c+r+.5),c+r+.5,-(c+r+.5),c+r+.5,-(r+.5),r+.5])

%% Random walk on an elipsoid

u=.005*2*pi*x(1,:);
v=.005*2*pi*x(2,:);
[U,V]=meshgrid(0:.1:2*pi+.05,0:.1:2*pi+.05);% make mesh

r1=2; % radius 1
r2=2; % radius 2
r3=2; % radius 3
      % r1=r2=r3 gives sphere
      
Elipsoid1=@(x,y) r1*cos(x).*sin(y); % parameterize the elipsoid
Elipsoid2=@(x,y) r2*sin(x).*sin(y);
Elipsoid3=@(x,y) r3*cos(y);

figure
hold on
surf(Elipsoid1(U,V),Elipsoid2(U,V),Elipsoid3(U,V),'mesh','none','FaceAlpha',0.5)
plot3(Elipsoid1(u,v),Elipsoid2(u,v),Elipsoid3(u,v),'LineWidth',2 )
axis([-max([r1,r2,r3]),max([r1,r2,r3]),...
    -max([r1,r2,r3]),max([r1,r2,r3]),-max([r1,r2,r3]),max([r1,r2,r3])])












