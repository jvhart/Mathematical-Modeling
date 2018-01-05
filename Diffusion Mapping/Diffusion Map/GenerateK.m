% Author:        Jarod Hart
% Date:          November 18, 2017
% Description:   The function generates a similarity matrix, given a data
% set and similarity function.  It is intended to be sued in conjuction
% with DiffusionMap.m.

% Inputs:
%           X - full matrix, data set
%           Khandle - function handle, similarity function from X x X -> R

% Outputs:
%           K - float/double matrix, similarity matrix for X

% Dependencies: none

% Resources: 
%       - Coifman and Lafon, Diffusion Maps, Applied and Computational
%         Harmonic Analysis, 2006

function K = GenerateK(X,Khandle)

[N,~]=size(X); % number of data elements
K=zeros(N,N);
for i=1:N % compute similarity matrix
    for j=i:N
        K(i,j)=Khandle(X(i,:),X(j,:));
        K(j,i)=K(i,j);
    end
end



