% Author:   Jarod Hart
% Date:     December 18, 2017
% Description: This is a script file.  It can be run as is. 

% Dependencies: GenerateK.m, DiffusionMap.m, Mug Shots folder of images

% Resources:  See some diffusion mapping articles about image processing

addpath(genpath('../Diffusion Map/'));

V=VideoReader('Snow Hall Video/Video 1.mov');

[x,y]=meshgrid(linspace(-2,2,25),linspace(-2,2,25));
convkern=exp(-(x.^2+y.^2));
X=[];
while hasFrame(V)
    video = readFrame(V);
    x=double(video);
    x=(x(:,:,1)+x(:,:,2)+x(:,:,3))/3;
    x=conv2(x,convkern,'valid');
    x=x(1:5:end,1:5:end);
    X=[X;x(:)'];
end

[num_frames,num_pixels]=size(X);
Kfun=@(x,y) exp(-sum(abs(x-y).^2)/(500*num_pixels).^2);
K=GenerateK(X,Kfun);

m=4;
[Lambda,Psi,P] = DiffusionMap(K,m);

labels = num2str(((1:num_frames)/V.FrameRate)','%f');
[~,label_size]=size(labels);
for i=1:length(labels)
    if mod(i,15)~=1
        labels(i,:)=zeros(1,label_size);
    end
end
labels=labels(:,1:3);

V.CurrentTime=0;
fig=figure('Position',[200,200,1200,550]);
subplot(1,2,2)
hold on
axis([min(Psi(:,1)-.1),max(Psi(:,1)+.1),min(Psi(:,2)-.1),...
       max(Psi(:,2)+.1),min(Psi(:,3)-.1),max(Psi(:,3)+.1)])
count=0;
while hasFrame(V)
    subplot(1,2,1)
    video = readFrame(V);
    image(video)
    count=count+1;
    subplot(1,2,2)
    line(Psi(1:count,1),Psi(1:count,2),Psi(1:count,3))
    plot3(Psi(count,1),Psi(count,2),Psi(count,3),'Marker','.','MarkerSize',12)
    pause(1/V.FrameRate)
    cla
end
close(fig)

V.CurrentTime=0;
fig=figure('Position',[200,200,1200,550]);
subplot(1,2,2)
hold on
axis([0,ceil(V.Duration*V.FrameRate),min(min(Psi))*1.15,max(max(Psi))*1.15])
count=0;
while hasFrame(V)
    subplot(1,2,1)
    video = readFrame(V);
    image(video)
    count=count+1;
    subplot(1,2,2)
    plot(1:count,Psi(1:count,1),'b')
    plot(1:count,Psi(1:count,2),'r')
    plot(1:count,Psi(1:count,3),'g')
    plot(1:count,Psi(1:count,4),'m')
    plot(count,Psi(count,1),'Color','b','Marker','.','MarkerSize',12)
    plot(count,Psi(count,2),'Color','r','Marker','.','MarkerSize',12)
    plot(count,Psi(count,3),'Color','g','Marker','.','MarkerSize',12)
    plot(count,Psi(count,4),'Color','m','Marker','.','MarkerSize',12)
    pause(1/V.FrameRate)
    cla
end
close(fig)

figure('Position',[0,100,500,500])
hold on
scatter3(Psi(:,1),Psi(:,2),Psi(:,3),14,'filled')
line(Psi(:,1),Psi(:,2),Psi(:,3))
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_3')
text(Psi(:,1),Psi(:,2),Psi(:,3),labels,'horizontal','left','vertical','bottom')

figure('Position',[250,100,500,500])
hold on
scatter3(Psi(:,1),Psi(:,2),Psi(:,4),14,'filled')
line(Psi(:,1),Psi(:,2),Psi(:,4))
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_4')
text(Psi(:,1),Psi(:,2),Psi(:,4),labels,'horizontal','left','vertical','bottom')

figure('Position',[500,100,500,500])
hold on
scatter3(Psi(:,1),Psi(:,3),Psi(:,4),14,'filled')
line(Psi(:,1),Psi(:,3),Psi(:,4))
xlabel('Psi_1')
ylabel('Psi_3')
zlabel('Psi_4')
text(Psi(:,1),Psi(:,3),Psi(:,4),labels,'horizontal','left','vertical','bottom')

figure('Position',[750,100,500,500])
hold on
scatter3(Psi(:,2),Psi(:,3),Psi(:,4),14,'filled')
line(Psi(:,2),Psi(:,3),Psi(:,4))
xlabel('Psi_2')
ylabel('Psi_3')
zlabel('Psi_4')
text(Psi(:,2),Psi(:,3),Psi(:,4),labels,'horizontal','left','vertical','bottom')
