% Script that defines parameters for this project

%   Copyright 2012 The MathWorks, Inc.

%% Specify control system sample time
T_sample_control = 1e-3;

%% PID parameter setup 
% We would like the parameters of the PID controller to appear as a
% tunable structure in the generated code. To do this, we must first create
% a bus object - this configures the parameter typedef struct. Then we can
% create a parameter object which makes use of the bus object and defines
% default parameter values.
%%
k1=-0.1005;
k2=-2.1508;
k3=-4.6448;
k4=-5.6307;
tau2=0.0210;
tau3=0.0244;

G=tf([k1*k2*k3*k4],[tau2*tau3 tau2+tau3 1 0]);
%%
kappa=1/(0.02*k1*k2*k3*k4)
kappaG=kappa*G;
%%
[Gm,Pm,Wcg,Wcp] = margin(kappaG);
Mf=Pm
Md=50
av=(1+sin((Md-Mf)*pi/180))/(1-sin((Md-Mf)*pi/180))

%precisa dar uma olhada como resolve isso. peguei um valor aprox por
%enquanto.
W = linspace(0, 30, 10000000);
[MAG,PHASE] = bode(kappaG,W);
wg = W(find(abs(squeeze(MAG) - sqrt(av)) <= 1e-7, 1, 'last'));
%wg = 7.8681;


tauv=1/(wg*sqrt(av))
at=1/av
taut=10*av*tauv/at
%%
s = tf('s');
Cv = (av*tauv*s + 1)/(tauv*s +1);
Ct = (at*taut*s + 1)/(taut*s +1);
C = kappa*Cv*Ct

[NUM, DEN] = tfdata(c2d(C, T_sample_control, 'tux'), 'v');
[SNUM, SDEN] = tfdata(G, 'v');