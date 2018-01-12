% Author:   Jarod Hart
% Date:     January 5, 2018
% Description: This function performs k-means on the input data set.  It
% initializes the centers to random members of the dataset, and computes
% the cluster average for each center thereafter.  

% Inputs
%       X - materix, mxn for dataset with m entries of vectors in R^n
%       k - integer larger than 2, number of clusters
%       maxiter - positive integer, maximum number of integers

% Outputs
%       G - integer array, group number for corresponding dataset element
%       SSE - float/double, sum of square distances of elements to their
%             cluster center


function [ G, SSE ] = k_means(X,k,maxiter)

[m,n]=size(X);
G=zeros(m,1);
centers=X(randsample(m,k),:);
% sig=var(X(:))^.5;
% centers=sig*rand(k,n);

for its=1:maxiter
    for i=1:1:m
        [~,G(i)]=min(sum((ones(k,1)*X(i,:)-centers).^2,2));
    end
    for j=1:k
        centers(j,:)=sum(X(G==j,:),1)/sum(G==j);
    end
    if length(unique(G))<k
        centers=X(randsample(m,k),:);
        its=1;
    end
end

SSE=0;
for i=1:k
    SSE=SSE+sum((X(G==i,:)-centers(i,:)).^2);
end
