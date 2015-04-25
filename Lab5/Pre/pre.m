clear all;close all;clc
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
bode(kappaG)

%%
[Gm,Pm,Wcg,Wcp] = margin(kappaG);
Mf=Pm
Md=55

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
zpk(C)
%stepplot(feedback(C*G,1), 10)


%%
load simulacoes.mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulação controlador at-av: 45md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, saída e esforço de controle
yr45=figure;
plot(t45(1:4001),y45(1:4001),t45(1:4001),r45(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída','Entrada')
title('Simulação de controlador Atraso-Avanço digital: Md=45°')
saveas(yr45,'yr45.eps','epsc')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulação controlador at-av: 45md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, saída e esforço de controle
ur45=figure;
plot(t45(1:4001),u45(1:4001),t45(1:4001),r45(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço Contr.','Entrada')
title('Simulação de controlador Atraso-Avanço digital: Md=45°')
saveas(ur45,'ur45.eps','epsc')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulação controlador at-av: 50md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, saída e esforço de controle
yr50=figure;
plot(t50(1:4001),y50(1:4001),t50(1:4001),r50(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída','Entrada')
title('Simulação de controlador Atraso-Avanço digital: Md=50°')
saveas(yr50,'yr50.eps','epsc')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulação controlador at-av: 50md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, saída e esforço de controle
ur50=figure;
plot(t50(1:4001),u50(1:4001),t50(1:4001),r50(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço Contr.','Entrada')
title('Simulação de controlador Atraso-Avanço digital: Md=50°')
saveas(ur50,'ur50.eps','epsc')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulação controlador at-av: 55md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, saída e esforço de controle
yr55=figure;
plot(t55(1:4001),y55(1:4001),t55(1:4001),r55(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída','Entrada')
title('Simulação de controlador Atraso-Avanço digital: Md=55°')
saveas(yr55,'yr55.eps','epsc')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulação controlador at-av: 55md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, saída e esforço de controle
ur55=figure;
plot(t55(1:4001),u55(1:4001),t55(1:4001),r55(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço Contr.','Entrada')
title('Simulação de controlador Atraso-Avanço digital: Md=55°')
saveas(ur55,'ur55.eps','epsc')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rampas

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulação controlador at-av: 45md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, saída e esforço de controle
yur45r=figure;
plot(t45(1:4001),y45r(1:4001), t45(1:4001),u45r(1:4001), t45(1:4001),r45r(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída', 'Esforço Contr.','Entrada')
title('Simulação de controlador Atraso-Avanço digital: Md=45°')
saveas(yur45r,'yur45r.eps','epsc')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulação controlador at-av: 45md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, saída e esforço de controle
ur45r=figure;
plot(t45(1:4001),u45r(1:4001),t45(1:4001),r45r(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço Contr.','Entrada')
title('Simulação de controlador Atraso-Avanço digital: Md=45°')
saveas(ur45r,'ur45r.eps','epsc')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulação controlador at-av: 50md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, saída e esforço de controle
yur50r=figure;
plot(t50(1:4001),y50r(1:4001), t50(1:4001),u50r(1:4001),t50(1:4001),r50r(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída', 'Esforço Contr.','Entrada')
title('Simulação de controlador Atraso-Avanço digital: Md=50°')
saveas(yur50r,'yur50r.eps','epsc')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulação controlador at-av: 50md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, saída e esforço de controle
ur50r=figure;
plot(t50(1:4001),u50r(1:4001),t50(1:4001),r50r(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço Contr.','Entrada')
title('Simulação de controlador Atraso-Avanço digital: Md=50°')
saveas(ur50r,'ur50r.eps','epsc')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulação controlador at-av: 55md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, saída e esforço de controle
yur55r=figure;
plot(t55(1:4001),y55r(1:4001), t55(1:4001),u55r(1:4001),t55(1:4001),r55r(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída', 'Esforço Contr.','Entrada')
title('Simulação de controlador Atraso-Avanço digital: Md=55°')
saveas(yur55r,'yur55r.eps','epsc')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulação controlador at-av: 55md
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, saída e esforço de controle
ur55r=figure;
plot(t55(1:4001),u55r(1:4001),t55(1:4001),r55r(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço Contr.','Entrada')
title('Simulação de controlador Atraso-Avanço digital: Md=55°')
saveas(ur55r,'ur55r.eps','epsc')
%% Step infos
yr45si = stepinfo(y45(1:2000), t45(1:2000), 1)
yr50si = stepinfo(y50(1:2000), t50(1:2000), 1)
yr55si = stepinfo(y55(1:2000), t55(1:2000), 1)
%% Eps encoding fix in linux
!epsfixer.sh
