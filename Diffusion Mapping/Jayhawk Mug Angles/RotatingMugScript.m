% Author:   Jarod Hart
% Date:     December 11, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate the manifold learning capabilities of
% diffusion mapping in the context of images of a similar object from
% differnt viewing angles.  The subject of the pictures is a KU Jayhawk mug
% from various angles.  Each of the series of images is independently
% smoothed with a Gaussian filter, then subsampled.  Post-processed images
% are treates as elements of Euclidean space, and similarity rankings are
% computed based on an exponential decay function composed with the 
% Euclidean distance.

% Dependencies: GenerateK.m, DiffusionMap.m, Mug Shots folder of images

% Resources:  See some diffusion mapping articles about image processing

addpath(genpath('../Diffusion Map/'));

Folder=dir('Mug Shots/*.jpg'); % made directory object of all images in 
                               % "Mug Shots" folder

[x,y]=meshgrid(linspace(-2,2,20),linspace(-2,2,20)); % make square grid
convkern=exp(-(x.^2+y.^2)); % make Gaussian convolution kernel

num_images=length(Folder); % number of images
num_rowcols=ceil(num_images^.5); % number of rows/columns

% view all images as the are imported
figure('Position',[100,100,600,600])
tic
X=[];
Images={};
for i=1:num_images
    filename=strcat('Mug Shots/',Folder(i).name); % read image filename
    Im=imread(filename); % import image
    Images{i}=Im;
    subplot(num_rowcols,num_rowcols,i)
    image(Im)
    title(strcat('Image',32,int2str(i)))
    Im=double(Im); % convert to double
    Im=(Im(:,:,1)+Im(:,:,2)+Im(:,:,3))/3; % set to grayscale
    Im=conv2(Im,convkern,'valid'); % smooth image
    Im=Im(1:10:end,1:10:end); % subsample smoothed image
    Im=Im(:)'; % vectorize
    X=[X;Im]; % append smoothed, subsampled, vectorized image to dataset
end
toc


[~,num_pixels]=size(X);
Kfun=@(x,y) exp(-sum(abs(x-y))/(2000*num_pixels)); % define similarity function
m=4; % number of embedding dimensions

tic
K=GenerateK(X,Kfun); % make similarity matrix
toc
tic
[Lambda,Psi,P] = DiffusionMap(K,m); % make diffusion map
toc
labels = num2str((1:num_images)','%d'); % make labels

% show progresion of images and diffusion map
fig=figure('Position',[200,200,1000,450]);
subplot(1,2,1)
image(Images{1})
subplot(1,2,2)
hold on
axis([0,num_images,min(min(Psi))*1.1,max(max(Psi))*1.1])
count=0;
for i=1:num_images
    subplot(1,2,1)
    image(Images{i})
    count=count+1;
    subplot(1,2,2)
    plot(1:count,Psi(1:count,1),'b')
    plot(1:count,Psi(1:count,2),'r')
    plot(1:count,Psi(1:count,3),'g')
    plot(1:count,Psi(1:count,4),'m')
    plot(count,Psi(count,1),'Marker','.','MarkerSize',12,'Color','b')
    plot(count,Psi(count,2),'Marker','.','MarkerSize',12,'Color','r')
    plot(count,Psi(count,3),'Marker','.','MarkerSize',12,'Color','g')
    plot(count,Psi(count,4),'Marker','.','MarkerSize',12,'Color','m')
    pause(.2)
end
close(fig)


figure('Position',[0,100,600,500])
hold on
plot3(Psi(:,1),Psi(:,2),Psi(:,3),'b.-','MarkerSize',14)
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_3')
text(Psi(:,1),Psi(:,2),Psi(:,3),labels,'horizontal','left','vertical','bottom')

figure('Position',[250,100,600,500])
plot3(Psi(:,1),Psi(:,2),Psi(:,4),'b.-','MarkerSize',14)
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_4')
text(Psi(:,1),Psi(:,2),Psi(:,4),labels,'horizontal','left','vertical','bottom')

figure('Position',[500,100,600,500])
plot3(Psi(:,1),Psi(:,3),Psi(:,4),'b.-','MarkerSize',14)
xlabel('Psi_1')
ylabel('Psi_3')
zlabel('Psi_4')
text(Psi(:,1),Psi(:,3),Psi(:,4),labels,'horizontal','left','vertical','bottom')

figure('Position',[750,100,600,500])
plot3(Psi(:,2),Psi(:,3),Psi(:,4),'b.-','MarkerSize',14)
xlabel('Psi_2')
ylabel('Psi_3')
zlabel('Psi_4')
text(Psi(:,2),Psi(:,3),Psi(:,4),labels,'horizontal','left','vertical','bottom')
