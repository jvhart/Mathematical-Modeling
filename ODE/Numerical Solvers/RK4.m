% Author: Jarod Hart
% Data: 11/15/17

% Description: This function implements Runge-Kutta's order 4 method to find a numerical solution to the specified initial value problem associated to a system of ODEs.  It returns a solution to the ode:
%	dY/dt=fh(t,Y); Y(a)=y0
% on the interval [a,b] with N steps, where Y represents the vector solution of the equation.

% Inputs:

%	a - double/float, left endpoint of time interval
%	b - double/float, right endpoint of time interval
%	N - integer, number of time steps for the numerical solution
%	y0 - double/float row vector, initial condition for the ODE
%	fh - function handle, the function handle f(t,y) for the right hand side of the ODE

% Outputs:

%	Y - double/float matrix, (N+1)x(num variables+1) matrix that contains the numerical approximations of (t,y1,...,yn) variables as columns.


% Resources:  The description of this method can be found in any introductory ODE textbook or online.

function [Y] = RK4(a,b,N,y0,fh)

n=length(y0);
h=(b-a)/N;
Y=zeros(N+1,n+1);
t=a;
Y(1,1)=t;
y=y0;
Y(1,2:n+1)=y;

for i=2:N+1
    
    k1=h*fh(t,y);
    k2=h*fh(t+h/2,y+k1/2);
    k3=h*fh(t+h/2,y+k2/2);
    k4=h*fh(t+h,y+k3);
    y=y+(k1+2*k2+2*k3+k4)/6;

    t=t+h;
    Y(i,1)=t;
    Y(i,2:n+1)=y;
end

