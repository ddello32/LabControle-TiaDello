%% Carrega os dados do pre lab
load lab4.mat;
tpre = t;
%% Carrega Dados
a = load('OUT_2.lvm');
t = a(:,1)*0.001;
y = a(:,2);
r = a(:,4);
u = a(:,6);

%% Isola uma unica onda
t= t(4001:8000) - 4;
y = y(4001:8000);
u = u(4001:8000)/1.1;
r = r(4001:8000);
%% Filters signal
filtro = createFilter();
yf = filter(filtro, y);
%% Plots
%% Sem filtro
ysemfiltro = figure;
plot(t, y, t, r);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída','Entrada')
title('Controlador PID analógico')
saveas(ysemfiltro,'ysemfiltro.eps','epsc')
%% Esforço de controle
upid = figure;
plot(t, u, t, r);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço de Controle','Entrada')
title('Esforço de controle Controlador PID analógico')
saveas(upid,'upid.eps','epsc')
%% Comparação com o simulado
%% Saida
yrsim = figure;
plot(t, yf, tpre(1:4000), ysimpidlocostep(1:4000));
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída filtrada','Saída simulada')
title('Comparação entre respostas do controlador PID analógico e sua simulação')
saveas(yrsim,'yrsim.eps','epsc')
%% Esforço de controle
ursim = figure;
plot(t, u, tpre(1:4000), usimpidlocostep(1:4000));
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço de Controle','Esforço de Controle Simulado')
title('Esforço de controle do controlador PID analógico e sua simulação')
saveas(ursim,'ursim.eps','epsc')
%% Mostra dados da resposta
pida = stepinfo(yf(1:2000), t(1:2000), 1)
pids = stepinfo(ysimpidlocostep(1:2000), tpre(1:2000), 1)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controlador PID SISO Design Tool II
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load 'OUTsiso2.lvm';
saidas2=OUTsiso2(8001:12000,2);
saidafs2=filter(filtro,saidas2);
entradas2=OUTsiso2(8001:12000,4);
controles2=OUTsiso2(8001:12000,6);
%% plot de entrada e saída
yad=figure;
plot(t,yf,t,saidafs2)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída filtrada p/ controlaodor analógico','Saída filtrada p/ controlaodor digital')
title('Comparação entre respostas do controlador PID analógico e sua simulação')
saveas(yad,'yad.eps','epsc')
%% Fixes eps enconding in linux!
%!sed -i -e 's/\\302\(\\2[4-7][0-7]\)/\1/g' -e 's/\\303\\2\([0-7][0-7]\)/\\3\1/g' file.eps
!epsfixer.sh
