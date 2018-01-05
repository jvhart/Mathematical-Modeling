% Author:   Jarod Hart
% Date:     November 20, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate the the capabilities of multilayer 
% feedforward neural networks.  Below, you can manipulate training data and
% network parameters.  In particular, you can set different numbers of
% layers and different neurons per layer for the network.

% Dependencies: TrainML.m, EvaluateML.m

% Resources:  Two possible resources are:
%       Mitchell, Machine Learning, McGraw-Hill, 1997. See chpt 4.
%       Krone and van der Smart, An Introduction to Neural Networks, Eighth
%         Edition, University of Amsterdam, 1996. Available at archive.org

% Note: See PerceptronSamplesScript.m for similar code that is commented.

ns=[100,100,100,100,100,100,100,100,100,100,100,100];
sigma=[.25,.25,.25,.25,.25,.25,.25,.25,.25,.25,.25,.25];
c=[0,4;4,0;0,-4;-4,0;0,2;0,-2;3,3;3,-3;-3,-3;-3,3;2,0;-2,0];
labels=[1,1,1,1,1,1,-1,-1,-1,-1,-1,-1];

Data=[];
for i=1:length(ns)
    X=ones(ns(i),1)*c(i,:)+sigma(i)*randn(ns(i),2);
    X=[X,labels(i)*ones(ns(i),1)];
    Data=[Data;X];
end

NumInputs=2; % number of inputs for network
HiddenLayers=[30,20,10]; % number of neurons in hidden layers
eta=.75;
MaxEpoch=200;

tic
[W,Error] = TrainML(Data,NumInputs,HiddenLayers,eta,MaxEpoch);
toc

[T,n]=size(Data);
[epochs,~]=size(Error);
group1=Data(:,3)==1;
group2=Data(:,3)==-1;
NumOutputs=n-NumInputs;
figure
hold on
PlotStringList={'b','r','k','g','m','c','y'};
for i=1:NumOutputs
    plot(Error(:,i),'Color',PlotStringList{1+mod(i-1,7)})
    plot(Error(:,i),'Marker','.','MarkerSize',6,...
           'Color',PlotStringList{1+mod(i-1,7)})
end
axis([0,epochs,0,max(max(Error))+.1])

figure
hold on
scatter(Data(group1,1),Data(group1,2),'rx')
scatter(Data(group2,1),Data(group2,2),'bo')

[X,Y]=meshgrid(-6:.05:6,-6:.05:6);
[m,n]=size(X);
NumHiddenLayers=length(HiddenLayers);
for i=1:m
    for j=1:n
        x=[X(i,j);Y(i,j)];
        Z(i,j)=EvaluateML(x,W);
    end
end

contour(X,Y,Z,[-.001,.001],'green')
axis([-6,6,-6,6])


figure
hold on
surf(X,Y,Z,'mesh','none')
scatter3(Data(group1,1),Data(group1,2),Data(group1,3)+.1,'rx')
scatter3(Data(group2,1),Data(group2,2),Data(group2,3)-.1,'bo')

