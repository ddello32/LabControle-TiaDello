clear all;close all;clc
%%
t=0:0.001:4-0.001;
filtro=1/(2*100+1)*ones(1,2*100+1);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controlador proporcional por amortecimento cr�tico
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load 'OUTcritico.lvm';
saidac=OUTcritico(4001:8000,2);
saidafc=filter(filtro,1,OUTcritico(4001:8000,2));
entradac=OUTcritico(4001:8000,4);
controlec=OUTcritico(4001:8000,6);

stepc=stepinfo(saidafc(1:2000),t(1:2000))
%% plot de entrada e sa�da
yc=figure;
plot(t,saidafc,t,entradac)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Sa�da Filtrada','Entrada')
title('Controlador proporcional por amortecimento cr�tico')
saveas(yc,'ypidc.eps','epsc')
%% plot de esfor�o de controle
uc=figure;
plot(t,controlec)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esfor�o de controle')
title('Esfor�o de controle do controlador proporcional por amortecimento cr�tico')
saveas(uc,'upidc.eps','epsc')
%% plot de entrada, sa�da e esfor�o de controle
yuc=figure;
plot(t,saidafc,t,entradac,t,controlec)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Sa�da Filtrada','Entrada','Esfor�o Contr.')
title('Controlador proporcional por amortecimento cr�tico')
saveas(yuc,'yupidc.eps','epsc')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controlador proporcional por overshoot de 2%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load 'OUTov2.lvm';
saidav=OUTov2(4001:8000,2);
saidafv=filter(filtro,1,OUTov2(4001:8000,2));
entradav=OUTov2(4001:8000,4);
controlev=OUTov2(4001:8000,6);

stepv=stepinfo(saidafv(1:2000),t(1:2000))
%% plot de entrada e sa�da
yv=figure;
plot(t,saidafv,t,entradav)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Sa�da Filtrada','Entrada')
title('Controlador proporcional por overshoot de 2%')
saveas(yv,'ypidv.eps','epsc')
%% plot de esfor�o de controle
uv=figure;
plot(t,controlev)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esfor�o de controle')
title('Esfor�o de controle do controlador proporcional por overshoot de 2%')
saveas(uv,'upidv.eps','epsc')
%% plot de entrada, sa�da e esfor�o de controle
yuv=figure;
plot(t,saidafv,t,entradav,t,controlev)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Sa�da Filtrada','Entrada','Esfor�o Contr.')
title('Controlador proporcional por overshoot de 2%')
saveas(yuv,'yupidv.eps','epsc')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controlador PID Ziegler-Nichols
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load 'OUTziegler.lvm';
saidaz=OUTziegler(4001:8000,2);
saidafz=filter(filtro,1,OUTziegler(4001:8000,2));
entradaz=OUTziegler(4001:8000,4);
controlez=OUTziegler(4001:8000,6);

stepz=stepinfo(saidafz(1:2000),t(1:2000))
%% plot de entrada e sa�da
yz=figure;
plot(t,saidafz,t,entradaz)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Sa�da Filtrada','Entrada')
title('Controlador PID por Ziegler-Nichols')

saveas(yz,'ypidz.eps','epsc')
%% plot de esfor�o de controle
uz=figure;
plot(t,controlez)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esfor�o de controle')
title('Esfor�o de controle do controlador PID por Ziegler-Nichols')

saveas(uz,'upidz.eps','epsc')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controlador PID SISO Design Tool I
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load 'OUTsiso.lvm';
saidas=OUTsiso(8001:12000,2);
saidafs=filter(filtro,1,OUTsiso(4001:8000,2));
entradas=OUTsiso(8001:12000,4);
controles=OUTsiso(8001:12000,6);

steps=stepinfo(saidafs(1:2000),t(1:2000))
%% plot de entrada e sa�da
ys=figure;
plot(t,saidafs,t,entradas)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Sa�da Filtrada','Entrada')
title('Controlador PID por SISO Design Tool')

saveas(ys,'ypids.eps','epsc')
%% plot de esfor�o de controle
us=figure;
plot(t,controles)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esfor�o de controle')
title('Esfor�o de controle do controlador PID por SISO Design Tool')
saveas(us,'upids.eps','epsc')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controlador PID SISO Design Tool II
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load 'OUTsiso2.lvm';
saidas2=OUTsiso2(8001:12000,2);
saidafs2=filter(filtro,1,OUTsiso2(4001:8000,2));
entradas2=OUTsiso2(8001:12000,4);
controles2=OUTsiso2(8001:12000,6);

steps2=stepinfo(saidafs2(1:2000),t(1:2000))
%% plot de entrada e sa�da
ys2=figure;
plot(t,saidafs2,t,entradas2)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Sa�da Filtrada','Entrada')
title('Controlador PID por SISO Design Tool')

saveas(ys2,'ypids2.eps','epsc')
%% plot de esfor�o de controle
us2=figure;
plot(t,controles2)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esfor�o de controle')
title('Esfor�o de controle do controlador PID por SISO Design Tool')
saveas(us2,'upids2.eps','epsc')