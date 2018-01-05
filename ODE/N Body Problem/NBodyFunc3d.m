% Author:        Jarod Hart
% Date:          November 15, 2017
% Description:   This function is the right hand side of the N-body problem
% in 3 dimensions with an arbitrary number of bodies.

% Inputs:
%             t - double/float column vector, time variable
%             t - double/float vector, y variables
%             G - positive double/float variable, force of gravity
%             mass - positive double/float vector, mass of bodies

% Outputs:
%             dy - double/float vector, value of the function on the right
%                  hand side of the N-body ODE after reduction of order

% Dependencies: none

% Resources:  Description of the N-body problem can be found in many
% physics books or online.

function [dy] = NBodyFunc3d(t,y,G,mass)

N=length(y);
n=N/6;
dy(1:3*n)=y(3*n+1:end);
epsilon=.05;

count=0;
for i=3*n+1:4*n
    count=count+1;
    X=y(1:n);
    Y=y(n+1:2*n);
    Z=y(2*n+1:3*n);
    xi=X(count);
    yi=Y(count);
    zi=Z(count);
    temp=X(1:count-1);
    X=[temp,X(count+1:end)];
    temp=Y(1:count-1);
    Y=[temp,Y(count+1:end)];
    temp=Z(1:count-1);
    Z=[temp,Z(count+1:end)];
    mtemp=mass(1:count-1);
    mtemp=[mtemp,mass(count+1:end)];
    xterms=G.*mtemp.*(X-xi).*...
        ( epsilon+ (xi-X).^2+(yi-Y).^2+(zi-Z).^2).^(-1.5);
    yterms=G.*mtemp.*(Y-yi).*...
        ( epsilon+ (xi-X).^2+(yi-Y).^2+(zi-Z).^2).^(-1.5);
    zterms=G.*mtemp.*(Z-zi).*...
        ( epsilon+ (xi-X).^2+(yi-Y).^2+(zi-Z).^2).^(-1.5);
    dy(i)=sum(xterms);
    dy(i+n)=sum(yterms);
    dy(i+2*n)=sum(zterms);
end

