%MATLAB Program 6.1 for Example 6.2
% compute y(n)=2x(n)-4x(n-1)-0.5y(n-1)-0.5y(n-2)
%Non-zero initial conditions: 
% y(-2)=1, y(-1)=0, x(-1) =-1, and x(n)=(0.8)^n*u(n)
%
close all; clear all
y = zeros(1,20);     		 %set up a vector to store y(n)
y = [ 1 0 y];       	     %add initial condition of y(-2) and y(-1)
n=0:1:19;            		 %compute time indexes
x=(0.8).^n;         		 %compute 20 input samples of x(n)
x = [ 0 -1 x];       		 %add initial condition of x(-2)=0 and x(-1)=1
for n=1:20
   y(n+2)= 2*x(n+2)-4*x(n+1)-0.5*y(n+1)-0.5*y(n);   %compute 20 outputs of y(n)
end
n=0:1:19;
subplot(3,1,1);stem(n,x(3:22));grid;ylabel('Input x(n)');xlabel('Sample number');
Subplot(3,1,2); stem(n,y(3:22)),grid;
xlabel('Number of samples, n; part (a)'); ylabel('Output y(n)');
y(3:22)              %output y(n)
%Zero- initial conditions: 
% y(-2)=0, y(-1)=0, x(-1) =0, and x(n)=1/(n+1)
%
y = zeros(1,20);     	    %set up a vector to store y(n)
y = [ 0 0 y];        		%add zero initial condition of y(-2) and y(-1)
n=0:1:19;           		 %compute time indexes
x=(0.8).^n;         		 %compute 20 input samples of x(n)
x = [ 0 0 x];       		 %add zero initial condition of x(-2)=0 and x(-1)=0
for n=1:20
   y(n+2)= 2*x(n+2)-4*x(n+1)-0.5*y(n+1)-0.5*y(n);   %compute 20 outputs of y(n)
end
n=0:1:19;
subplot(3,1,3); stem(n,y(3:22)),grid;
xlabel('Number of samples, n; part (b)'); ylabel('Output y(n)');
y(3:22)                                                %output y(n)
