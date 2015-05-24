clear all, clc

%% Nominal plant parameters
R = 0.56;
L = 4e-3;
Ifr = 0.4;
K = 1.19e-2;
J = 3.45e-5;
b = 2.4e-7;

%% Compute equilibrium point (initial condition for plant.mdl)
d1bar = 0;
d2bar = 0;
wbar = 300;

Ibar = sign(wbar)*Ifr + b*abs(wbar)*wbar/K + d1bar;
Ubar = R*Ibar+K*wbar-d2bar;

[wbar, Ibar ,Ubar, d1bar, d2bar]

%% Linearization around 3 "representative" equilibrium points
% create array of Control Toolbox LTI systems 
wtab = [100 300 500];
for i = 1:3;
    A = [-2*abs(wtab(i))*b/J K/J; -K/L -R/L];
    B = [0; 1/L];
    Bd = [-K/J 0; 0 1/L];
    C = [1 0];
    D = 0;
    Dd = zeros(1,2);
    sys(:,:,i) = augstate(ss(A,[B Bd],C,[D Dd]));
end
set(sys,'InputName',{'U','d1','d2'},'OutputName',{'wm','w','I'})
eig(sys) % 1 slow, 1 fast eigenvalue => use singular perturbations

%% Linearized slow model
% create array of Control Toolbox LTI systems 
% rem: linearized slow system = slow linearized system
for i = 1:3;
    As = -(K^2/R+abs(wtab(i))*2*b)/J;
    Bs = K/J/R;
    Bds = [-K/J K/J/R];
    Cs = 1;
    Ds = 0;
    Dds = zeros(1,2);
    Fs = [1; -K/R];
    Gs = [0; 1/R];
    Gds = [0 0; 0 1/R];
    syss(:,:,i) = ss(As,[Bs Bds],[Cs; Fs],[Ds Dds; Gs Gds]);
end
set(syss,'InputName',{'U','d1','d2'},'OutputName',{'wm','w','I'})

figure(1),step(sys,syss) % compare full and slow systems

%% Design model = linearized slow model for "middle" point defined by w=300
[As,Bs,Cs,Ds] = ssdata(syss(1,1,2)) % re-extract data (wm = output 1, U = output 1, i = 2)


%% Tune PI controller
Tr = .1; % desired settling time
p0 = 2*pi/Tr;
kI = p0^2/Bs
k = (2/sqrt(2)*p0+As)/Bs
M = 0;
N = [-kI kI];
P = -1;
Q = [0 -k];
cont = ss(M,N,P,Q);
set(cont,'InputName',{'wr','wm'},'OutputName',{'U'})
etabar = -k*wbar-Ubar; % initial condition for no initial transient in Simulink

sysscl = lft(cont,syss,1,1); % closed-loop system, slow model
syscl = lft(cont,sys,1,1); % closed-loop system, full linear model
figure(2),step(sysscl,syscl) % compare closed-loop systems

% Finally, export controller in plant_cl.mdl to test it against the simulation model

%% Discrete controller
Ts = Tr/20; % sampling time
syssd = c2d(syss,Ts); % exact zoh discretization for simulation in CTB
contd = c2d(cont,Ts,'foh'); % foh is better for controller discretization
sysscld = lft(contd,syssd,1,1); % closed-loop system
figure(3),step(sysscl,sysscld)

[Md,Nd,Pd,Qd] = ssdata(contd);
% Finally, export controller in plant_cld.mdl to test it against the simulation model



