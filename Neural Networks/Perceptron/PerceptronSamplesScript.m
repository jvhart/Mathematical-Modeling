% Author:   Jarod Hart
% Date:     November 20, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate the capabilities of the Perceptron.  This
% generates two clusters of datat that are linearly separable, and learns a
% classification rule using the Perceptron.  A few ways to visualise this
% are provided.

% Dependencies: TrainPerceptron.m, EvaluatePerceptron.m

% Resources:  Two possible resources are:
%       Mitchell, Machine Learning, McGraw-Hill, 1997. See chpt 4.
%       Krone and van der Smart, An Introduction to Neural Networks, Eighth
%         Edition, University of Amsterdam, 1996. Available at archive.org

n1=50;     % number of points per cluster
n2=20;     % number of points per cluster
sigma1=.5; % variance of cluster 1
sigma2=.5; % variance of cluster 2
c1=[0,4];  % center of cluster 1
c2=[3,3];  % center of cluster 2

Data=[];   % initialize training data matrix

X=ones(n1,1)*c1+sigma1*randn(n1,2);  % generate points for cluster 1
X=[X,ones(n1,1)];  % append label of 1 for cluster 1
Data=[Data;X];     % append data to training data matrix X

X=ones(n2,1)*c2+sigma2*randn(n2,2);  % generate point for cluster 2
X=[X,-ones(n2,1)]; % append label of -1 for cluster 2
Data=[Data;X];     % append data to training data matrix X

eta=.2;    % set learning rate
MaxEpoch=200; % set maximum epochs allowed for training

tic
W=TrainPerceptron(Data,eta,MaxEpoch); % train the weight vector
toc % display time elapse from tic to toc. you can set t=toc to store value

[T,n]=size(Data);  % read size of training set
NumInputs=n-1;     % number of inputs is one less than number of columns
group1=(Data(:,3)==1); % make boolean matrix for data elements in cluster 1
group2=(Data(:,3)==-1); % save for cluster 2

figure  % open new figure
hold on % enable multiple plots
axis([-3,6,-1,6]) % set axes view
scatter(Data(group1,1),Data(group1,2),'rx') % plot cluster 1 as red x
scatter(Data(group2,1),Data(group2,2),'bo') % plot cluster 2 as blue O

[X,Y]=meshgrid(-3:.05:6,-1:.05:6); % create mesh
[m,n]=size(X); % read size of mesh
Z=zeros(m,n); % initialize Z for Perceptron outputs
for i=1:m
    for j=1:n
        x=[X(i,j);Y(i,j)];
        Z(i,j)=EvaluatePerceptron(x,W); % compute network output for each 
                                        % mesh element
    end
end

contour(X,Y,Z,[-.001,.001],'green') % plot contour between -.001 and .001 
                                    % netowrk output to show decision line

figure % open new figure
hold on
axis([-3,6,-1,6])
surf(X,Y,Z,'mesh','none') % plot network function as a surface
scatter3(Data(group1,1),Data(group1,2),Data(group1,3)+.1,'rx')
scatter3(Data(group2,1),Data(group2,2),Data(group2,3)-.1,'bo')
