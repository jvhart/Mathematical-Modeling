% Author: Jarod Hart
% Data: 11/15/17

% Description: This script uses Runge-Kutta order 4 to find a numerical 
% solution to a system of ODEs for the N body problem.  This model does not
% address collisions between bodies.  To ease some computational problems
% with the singularity that occurs at collisions, the ODE is truncated by
% an epsilon parameter in the NBodyFunc3d function.  For the same reason,
% this model will be unreliable after bodies collide or nearly collide.

% Dependencies: NBodyFunc3d.m, RK4.m

% Resources:  A descrption of these equations can be found in physics
% textbooks or online.

addpath(genpath('../Numerical Solvers/'));

show_trail=true; % vide effect active? true/false, show paths of bodies

save_video=false; % save video? true/false. This will slow the video down
filename='Nbody3d.avi'; % if true, include a filename to save the 
                                % video, .avi file extension must be
                                % included.


% Modify the following 6 objects to adjust the number of bodies and their
% initial conditions.  The code will automatically adjust to it.  The code
% will run as long as you have at least one color listed.  It will just
% cycle through the color list to assign colors if there are more bodies
% than colors listed.
% As an example, you can try the following: 

M=[2,2,2,2,2,2];
X_0=[1,-1,0,0,0,0]; Y_0=[0,0,1,-1,0,0]; Z_0=[0,0,0,0,1,-1];
Vx_0=[0,0,1,-1,0,0]; Vy_0=[1,-1,0,0,0,0]; Vz_0=[0,0,1,-1,0,0];
colors={'blue','red','green','magenta','black','cyan','yellow',[.5,.3,.1]};

a=0; % start of time interval
b=15; % end of time interval
N=1000; % number of points for solver

g=1; % force of gravity

F=@(t,y) feval('NBodyFunc3d',t,y,g,M);
        % Function for the sysem of ODEs describing the double pendulum
        % (after reduction of order)

y0=[X_0,Y_0,Z_0,Vx_0,Vy_0,Vz_0]; % full initial condition

S=RK4(a,b,N,y0,F); 
T=S(:,1);
X={};
Y={};
Z={};
Vx={};
Vy={};
Zy={};
num_bodies=length(M);
for i=1:num_bodies
    X{i}=S(:,1+i);
    Y{i}=S(:,num_bodies+1+i);
    Z{i}=S(:,2*num_bodies+1+i);
    Vx{i}=S(:,3*num_bodies+1+i);
    Vy{i}=S(:,4*num_bodies+1+i);
    Vz{i}=S(:,5*num_bodies+1+i);
end

num_colors=length(colors);
if num_colors==0
    colors={'blue'};
end

figure('Position',[200,200,850,350])
subplot(1,3,1)
hold on
xlabel('Time')
ylabel('x position')

subplot(1,3,2)
hold on
xlabel('Time')
ylabel('y position')

subplot(1,3,3)
hold on
xlabel('Time')
ylabel('z position')

lgnd={};
for i=1:num_bodies
    subplot(1,3,1)
    plot(T,X{i},'Color',colors{1+mod(i-1,num_colors)})
    subplot(1,3,2)
    plot(T,Y{i},'Color',colors{1+mod(i-1,num_colors)})
    subplot(1,3,3)
    plot(T,Z{i},'Color',colors{1+mod(i-1,num_colors)})
    lgnd=[lgnd,strcat('Body',32,int2str(i))];
end
legend(lgnd)


figure
hold on
title('N Body Plot')
for i=1:num_bodies
    line(X{i},Y{i},Z{i},'Color',colors{1+mod(i-1,num_colors)})
end
legend(lgnd)

allX=[];
allY=[];
allZ=[];
for i=1:num_bodies
    allX=[allX,X{i}'];
    allY=[allY,Y{i}'];
    allZ=[allY,Z{i}'];
end


fig=figure('Position',[200,200,800,800]);
hold on 
axis tight manual
axis([min(allX)-1,max(allX)+1,min(allY)-1,max(allY)+1,min(allZ)-1,max(allZ)+1])
for i=1:num_bodies
    plot3(X{i}(1),Y{i}(1),Z{i}(1),'Marker','.','MarkerSize',10*M(i),...
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
        plot3(X{i}(t),Y{i}(t),Z{i}(t),'Marker','.','MarkerSize',10*M(i),...
               'Color',colors{1+mod(i-1,num_colors)})
        if show_trail
            line(X{i}(1:t),Y{i}(1:t),Z{i}(1:t),'Color',colors{1+mod(i-1,num_colors)})
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
