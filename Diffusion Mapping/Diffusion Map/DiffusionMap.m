% Author:        Jarod Hart
% Date:          November 18, 2017
% Description:   This function implements a diffusion map using a
% similarity matrix K into m dimensional Euclidean space.

% Inputs:
%           K - full/sparse symmetric square matrix, similarity matrix
%           m - integer, target dimension, must be smaller than size of K
%           alpha - (optional) float/double 0<=alpha<=1, density parameter

% Outputs:
%           Lambda - float/double matrix, eigenvalues of transition matrix
%                    if connected, otherwise a matrix with eigenvalues of
%                    submatrices corresponding to connected components
%           Psi - float/double matrix, eigenvectors of transition matrix 
%           P - float/double matrix, transition matrix 

% Dependencies: none

% Resources: 
%       - Coifman and Lafon, Diffusion Maps, Applied and Computational
%         Harmonic Analysis, 2006

% Note: Roughly speaking alpha=0 allows the diffusion map to lend
% consideration to the density of point, while alpha=1 disregards the
% density of points in fitting a manilfold to the data.  In other settings,
% the alpha=0 situation corresponds to analysis involving the graph
% Laplacian and alpha=1 corresponds to an approximation of the
% Laplace-Beltrami operator related to the Riemannian manifold fitting the
% data.

function [Lambda,Psi,P] = DiffusionMap(K,m,alpha)

if nargin<3
    alpha=0;
end

q=sum(K); % comput row/column sums (K is symmetric by assumption)
K=diag(q.^-alpha)*K*diag(q.^-alpha); % accound for data set distribution
D=diag(sum(K).^-1); % recompute row sums
P=D*K; % normalize row sums

N=length(P);
A=sparse(P>0); % make adjascency matrix
G=graph(A); % make graph
v=conncomp(G); % compute connected components
NumComponents=max(v); % compute number of connected components


Psi=zeros(N,m); % initialize diffusion map
Lambda=zeros(NumComponents,m); % initialize eigenvalues
for i=1:NumComponents
    mprime=min(m,sum(v==i)-1); 
                    % if component is too small, replace m by mprime
    [psi,E]=eigs(P(find(v==i),find(v==i)),mprime+1); 
                    % compute m+1 largest eigenvectors and eigenvalues
    Psi(find(v==i),1:mprime)=psi(:,2:mprime+1); 
                    % disregard first eigenvector
    lambda=[]; % put eigenvalues in vector, disregarding the first one
    for j=2:mprime+1
        lambda=[lambda,E(j,j)];
    end
    Lambda(1:mprime)=lambda; % set lambdas
end



