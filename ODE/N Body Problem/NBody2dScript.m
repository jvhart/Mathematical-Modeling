% Author: Jarod Hart
% Data: 11/15/17

% Description: This script uses Runge-Kutta order 4 to find a numerical 
% solution to a system of ODEs for the N body problem.  This model does not
% address collisions between bodies.  To ease some computational problems
% with the singularity that occurs at collisions, the ODE is truncated by
% an epsilon parameter in the NBodyFunc2d function.  For the same reason,
% this model will be unreliable after bodies collide or nearly collide.

% Dependencies: NBodyFunc2d.m, RK4.m

% Resources:  A description of these equations can be found in physics
% textbooks or online.

addpath(genpath('../Numerical Solvers/'));

show_trail=true; % vide effect active? true/false, show paths of bodies

save_video=false; % save video? true/false. This will slow the video down
filename='Nbody2d.avi'; % if true, include a filename to save the 
                                % video, .avi file extension must be
                                % included.


% Modify the following 6 objects to adjust the number of bodies and their
% initial conditions.  The code will automatically adjust to it.  The code
% will run as long as you have at least one color listed.  It will just
% cycle through the color list to assign colors if there are more bodies
% than colors listed.
% As an example, you can try the following: 

% M=[2,2];X_0=[1.5,-1.5];Y_0=[0,0];Vx_0=[0,0];Vy_0=[.5,-.5];
%         a=0;b=100;N=2000;colors={'blue','red'};

% M=[3,3,3,3];X_0=[2,-2,0,0];Y_0=[0,0,2,-2];Vx_0=[0,0,-1,1];Vy_0=[1,-1,0,0];
%         a=0;b=40;N=500;colors={'blue','blue','red','red'};

M=[2.5,2.5,3,3];X_0=[15,-15,0,0];Y_0=[0,0,4,-4];Vx_0=[0,0,-.5,.5];Vy_0=[-.25,.25,0,0];
        a=0;b=250;N=2500;colors={'blue','blue','red','red'};

% M=[2.5,2.5,2.5,1.5,1.5,1.5];
%  X_0=3*[cos(0),cos(2*pi/3),cos(4*pi/3),2*cos(pi/3),2*cos(pi),2*cos(5*pi/3)];
%  Y_0=3*[sin(0),sin(2*pi/3),sin(4*pi/3),2*sin(pi/3),2*sin(pi),2*sin(5*pi/3)];
%  Vx_0=-[.6*sin(0),.6*sin(2*pi/3),.6*sin(4*pi/3),1.3*sin(pi/3),1.3*sin(pi),1.3*sin(5*pi/3)];
%  Vy_0=[.6*cos(0),.6*cos(2*pi/3),.6*cos(4*pi/3),1.3*cos(pi/3),1.3*cos(pi),1.3*cos(5*pi/3)];
%         a=0;b=200;N=2000;colors={'blue','blue','blue','red','red','red'};

% M=[3,3,3,3]; % masses of objects
% X_0=[2,-2,0,0]; % initial x positions
% Y_0=[0,0,2,-2]; % initial y positions
% Vx_0=[0,0,-1,1]; % initial x velocities
% Vy_0=[1.02,-1.02,0,0]; % initial y velocities
% colors={'blue','blue','red','red'};
% 
% a=0; % start of time interval
% b=20; % end of time interval
% N=600; % number of points for solver

g=1; % force of gravity

F=@(t,y) feval('NBodyFunc2d',t,y,g,M);
        % Function for the sysem of ODEs describing the double pendulum
        % (after reduction of order)

y0=[X_0,Y_0,Vx_0,Vy_0]; % full initial condition

S=RK4(a,b,N,y0,F); 
T=S(:,1);
X={};
Y={};
Vx={};
Vy={};
num_bodies=length(M);
for i=1:num_bodies
    X{i}=S(:,1+i);
    Y{i}=S(:,num_bodies+1+i);
    Vx{i}=S(:,2*num_bodies+1+i);
    Vy{i}=S(:,3*num_bodies+1+i);
end

num_colors=length(colors);
if num_colors==0
    colors={'blue'};
end

figure('Position',[200,200,850,350])
subplot(1,2,1)
hold on
xlabel('Time')
ylabel('x position')

subplot(1,2,2)
hold on
xlabel('Time')
ylabel('y position')

lgnd={};
for i=1:num_bodies
    subplot(1,2,1)
    plot(T,X{i},'Color',colors{1+mod(i-1,num_colors)})
    subplot(1,2,2)
    plot(T,Y{i},'Color',colors{1+mod(i-1,num_colors)})
    lgnd=[lgnd,strcat('Body',32,int2str(i))];
end
legend(lgnd)


figure
hold on
title('N Body Plot')
for i=1:num_bodies
    plot(X{i},Y{i},'Color',colors{1+mod(i-1,num_colors)})
end
legend(lgnd)

allX=[];
allY=[];
for i=1:num_bodies
    allX=[allX,X{i}'];
    allY=[allY,Y{i}'];
end


fig=figure('Position',[200,200,800,800]);
hold on 
axis tight manual
axis([min(allX)-5,max(allX)+5,min(allY)-5,max(allY)+5])
for i=1:num_bodies
    plot(X{i}(1),Y{i}(1),'Marker','.','MarkerSize',10*M(i),...
            'Color',colors{1+mod(i-1,num_colors)})
end
title('N Body Video')

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
    for i=1:num_bodies
        plot(X{i}(t),Y{i}(t),'Marker','.','MarkerSize',10*M(i),...
               'Color',colors{1+mod(i-1,num_colors)})
        if show_trail
            plot(X{i}(1:t),Y{i}(1:t),'Color',colors{1+mod(i-1,num_colors)})
        end
    end
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
