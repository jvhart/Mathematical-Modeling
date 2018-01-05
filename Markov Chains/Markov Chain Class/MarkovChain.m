% Author:        Jarod Hart
% Date:          December 14, 2017
% Description:   This is a class meant to simulate and analyze Markov
%                chains. Upon running the initialization method, it will
%                populate several properties of the class that are
%                convenient for Markov chain analysis, including canonical
%                forms, commucation class decompositions, fundamental
%                matrix, and absorption probabilities/times.  It is also
%                capable of simulating the Markov chain based on an initial
%                distribution or given initial state.  To create a Markov
%                chain object, use the command MCobj=MarkovChain, where
%                MCobj is your desired object name.

% Properties: See properties definition below for list and description of
%             properties

% Methods: 

% self = initialize(self,P)   - Input a transition matrix P, and the
%                               function populates several of the
%                               properties.  This may take a little while
%                               to run for larger chains.  Run by using the
%                               command MCobj=MCobj.initialize(P)

% x = simulate(self,T,init)   - MarkovChain object must be initialized to
%                               run this method.  init is either an integer
%                               indicating the initial state of the
%                               simulation or a probability distribution on
%                               the states.  If it is unspecified it will
%                               use the initial distribution stored in the
%                               MarkovChain object.  T is the number of
%                               states to be simulated.  It returns the
%                               simulated states x.  Call by executing the
%                               command x=MCobj.simulate(T,init)

% showgraph(self,Labels)      - Show a depiction of the graph associated to
%                               the MarkovChain object.  The transition
%                               matrix must be defined for this method.  If
%                               Labels variable is undefined, the are
%                               automatically generated as "Node 1" through
%                               "Node n".

% Dependencies: Decompose.m, MakeCanonicalMatrix.m, SimulateMC.m,
%               DrawFrom.m

% Resources:  Any introductory textbook on Markov chains should include
%             theory related to communication classes, stationary vectors,
%             canonical forms, etc sufficient to understand the properties
%             given below.


classdef MarkovChain
    properties
        P % Transition matrix
        initial % initial distribution
        stationary % stationary distribution when chain is irreducible.
                   % If the chain is reducible, the stationary vector for
                   % each communication class is provided.
        CanP % Transition matrix with states reorganized to reflect 
          % communication class structure, i.e. canonical form
        Q % Submatrix of CanP representing the transient classes
        R % Submatrix of CanP representing transient classes moving to 
          % absorbing classes
        A % Submatrix of CanP representing absorbing classes
        N % Fundamental matrix for the chain, N=inv(I-Q)=I+Q+Q^2+...
        B % Absorption probability matrix
        T % Expected time to absorption
        ComClasses % Decomposition of communication classes
        Types % Communication class type: Transient or Absorbing
        Diag % Cell array made up of matrices of transitions within
             % communication classes
        UpperTriangle % Cell array made up block matrices given the 
                      % transition probability from transient classes to
                      % recurrent ones.
        order % An integer vector that describes the reordering of states
              % to make the canonical form transition matrix, i.e. order(i)
              % gives the the original index that is in the ith spot for
              % the canonical form transition matrix
        map % A function that provides the inverse of order, i.e. this is 
            % mapping that takes the original indices to the ones for the
            % canonical matrix; map(i) returns the new index for the
            % original ith index.
    end
    
    methods
        function self = initialize(self,P)
            if nargin>1
                self.P=P;
            end
            [self.Diag,self.UpperTriangle,self.ComClasses,self.Types]=...
                Decompose(self.P);
            [self.CanP,self.Q,self.R,self.A]=...
                MakeCanonicalMatrix(self.Diag,self.UpperTriangle);
            self.order=[];
            for i=1:length(self.ComClasses)
                self.order=[self.order,self.ComClasses{i}];
            end
            self.map=@(i) find(self.order==i);
            self.N=inv(eye(length(self.Q))-self.Q);
            self.B=self.N*self.R;
            self.T=self.N*ones(length(self.Q),1);
            self.stationary=[];
            for i=1:length(self.ComClasses)
                if strcmp(self.Types{i},'Absorbing')
                    [v,~]=eigs(self.P(self.ComClasses{i},...
                        self.ComClasses{i})',1);
                    V=zeros(length(self.P),1);
                    V(self.ComClasses{i})=v;
                    V=V/sum(V);
                    self.stationary=[self.stationary,V];
                end
                
            end
        end
        
        function [x] = simulate(self,T,init)
            if nargin>2
                self.initial=init;
            end
            x=SimulateMC(self.P,T,self.initial);
        end
        
        function [] = showgraph(self,Labels)
            if nargin<2
                Labels={};
                for i=1:length(self.P)
                    Labels=[Labels,strcat('Node',32,int2str(i))];
                end
            end
            G=digraph(self.P,Labels);
            plot(G)
 
        end
    end
end
