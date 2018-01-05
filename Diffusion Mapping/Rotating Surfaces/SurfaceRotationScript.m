% Author:   Jarod Hart
% Date:     December 11, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate the manifold learning capabilities of
% diffusion mapping in the context of images of a similar object from
% differnt viewing angles.  The subject of these images is a surface plot
% of a function of two variables, which is viewed from several different
% angles.

% Dependencies: GenerateK.m, DiffusionMap.m, Mug Shots folder of images

% Resources:  See some diffusion mapping articles about image processing

addpath(genpath('../Diffusion Map/'));

n=100;
f=@(x,y) sin(x).*sin(y);

[X,Y]=meshgrid(linspace(-5,5,n),linspace(-5,5,n));

fig=figure;
s=surf(X,Y,f(X,Y),'mesh','none');
box off
axis off

i=1;
j=1;
Images={};
tic
for az=0:4:90
    for el=0:4:90
        view(az, el);
        pause(.01)
        F=getframe(fig);
        P=frame2im(F);
        Images{i,j}=P;
        j=j+1;
    end
    i=i+1;
    j=1;
end
close(fig)
toc

xx=linspace(-4,4,12);
[XX,YY]=meshgrid(xx,xx);
K=exp(-(XX.^2+YY.^2));

[I,J]=size(Images);
X=[];
tic
for i=1:I
    for j=1:J
        A=double(Images{i,j});
        A=[conv2(A(:,:,1),K,'same'),conv2(A(:,:,2),K,'same'),...
            conv2(A(:,:,3),K,'same')];
        A=A(1:20:end,1:20:end,:);
        A=A(:);
        X=[X;A'];
    end
end
X(X==240)=0;
X=sparse(X);
toc

tic
[~,num_pixels]=size(X);
Kfun=@(x,y) exp(-sum(abs(x-y))/(20*num_pixels));
tic
K=GenerateK(X,Kfun);
toc


m=4;
tic
[Lambda,Psi,P] = DiffusionMap(K,m);
toc


figure('Position',[100,100,1200,550])
subplot(1,2,2)
hold on
for i=1:I
    for j=1:J
        
        subplot(1,2,1)
        image(Images{i,j})
        subplot(1,2,2)
        cla
        scatter3(Psi(:,1),Psi(:,2),Psi(:,3),10,'blue','filled')
        k = (i-1)*J + j;
        plot3(Psi(k,1),Psi(k,2),Psi(k,3),'ro','MarkerSize',10)
        pause(.2)
    end
end
close(gcf)



figure
scatter3(Psi(:,1),Psi(:,2),Psi(:,3),10,'blue','filled')

figure
scatter(Psi(:,1),Psi(:,2),10,'blue','filled')


figure
subplot(2,2,1)
scatter3(Psi(:,1),Psi(:,2),Psi(:,3),10,'blue','filled')
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_3')
subplot(2,2,2)
scatter3(Psi(:,1),Psi(:,2),Psi(:,4),10,'blue','filled')
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_4')
subplot(2,2,3)
scatter3(Psi(:,1),Psi(:,3),Psi(:,4),10,'blue','filled')
xlabel('Psi_1')
ylabel('Psi_3')
zlabel('Psi_4')
subplot(2,2,4)
scatter3(Psi(:,2),Psi(:,3),Psi(:,4),10,'blue','filled')
xlabel('Psi_2')
ylabel('Psi_3')
zlabel('Psi_4')
