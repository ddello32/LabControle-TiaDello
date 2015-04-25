%% Carrega Pre lab
load 'simulacoes.mat'
tpre = t45;
%% 45
%% Carrega Dados
a = load('Controlador1.lvm');
t = a(:,1)*0.001;
y = a(:,2);
r = a(:,4);
u = a(:,6);

%% Isola uma unica onda
t= t(4001:8000) - 4;
y = y(4001:8000);
u = u(4001:8000);
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
title('Saída sem filtro do controlador Atraso-Avanço digital')
saveas(ysemfiltro,'ysemfiltro45.eps','epsc')
%% Esforço de controle
upid = figure;
plot(t, u, t, r);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço de Controle','Entrada')
title('Esforço de controle Controlador Atraso-Avanço digital')
saveas(upid,'upid45.eps','epsc')
%% Comparação com o simulado
%% Saida
yrsim = figure;
plot(t, yf, tpre(1:4000), y45(1:4000), t, r);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída filtrada','Saída simulada', 'Entrada')
title('Comparação entre respostas do controlador Atraso-Avanço digital e sua simulação')
saveas(yrsim,'yrsim45.eps','epsc')
%% Esforço de controle
ursim = figure;
plot(t, u, tpre(1:4000), u45(1:4000));
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço de Controle','Esforço de Controle Simulado')
title('Esforço de controle do controlador Atraso-Avanço digital e sua simulação')
saveas(ursim,'ursim45.eps','epsc')
%% Mostra dados da resposta
pid45 = stepinfo(yf(1:2000), t(1:2000), 1)
pid45s = stepinfo(y45(1:2000), tpre(1:2000), 1)
%%50
%% Carrega Dados
a = load('Controlador2.lvm');
t = a(:,1)*0.001;
y = a(:,2);
r = a(:,4);
u = a(:,6);

%% Isola uma unica onda
t= t(4001:8000) - 4;
y = y(4001:8000);
u = u(4001:8000);
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
title('Saída sem filtro do controlador Atraso-Avanço digital')
saveas(ysemfiltro,'ysemfiltro50.eps','epsc')
%% Esforço de controle
upid = figure;
plot(t, u, t, r);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço de Controle','Entrada')
title('Esforço de controle Controlador Atraso-Avanço digital')
saveas(upid,'upid50.eps','epsc')
%% Comparação com o simulado
%% Saida
yrsim = figure;
plot(t, yf, tpre(1:4000), y50(1:4000), t, r);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída filtrada','Saída simulada', 'Entrada')
title('Comparação entre respostas do controlador Atraso-Avanço digital e sua simulação')
saveas(yrsim,'yrsim50.eps','epsc')
%% Esforço de controle
ursim = figure;
plot(t, u, tpre(1:4000), u50(1:4000));
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço de Controle','Esforço de Controle Simulado')
title('Esforço de controle do controlador Atraso-Avanço digital e sua simulação')
saveas(ursim,'ursim50.eps','epsc')
%% Mostra dados da resposta
pid50 = stepinfo(yf(1:2000), t(1:2000), 1)
pid50s = stepinfo(y50(1:2000), tpre(1:2000), 1)
%% 55
%% Carrega Dados
a = load('Controlador3.lvm');
t = a(:,1)*0.001;
y = a(:,2);
r = a(:,4);
u = a(:,6);

%% Isola uma unica onda
t= t(4001:8000) - 4;
y = y(4001:8000);
u = u(4001:8000);
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
title('Saída sem filtro do controlador Atraso-Avanço digital')
saveas(ysemfiltro,'ysemfiltro55.eps','epsc')
%% Esforço de controle
upid = figure;
plot(t, u, t, r);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço de Controle','Entrada')
title('Esforço de controle Controlador Atraso-Avanço digital')
saveas(upid,'upid55.eps','epsc')
%% Comparação com o simulado
%% Saida
yrsim = figure;
plot(t, yf, tpre(1:4000), y55(1:4000), t, r);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída filtrada','Saída simulada', 'Entrada')
title('Comparação entre respostas do controlador Atraso-Avanço digital e sua simulação')
saveas(yrsim,'yrsim55.eps','epsc')
%% Esforço de controle
ursim = figure;
plot(t, u, tpre(1:4000), u55(1:4000));
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço de Controle','Esforço de Controle Simulado')
title('Esforço de controle do controlador Atraso-Avanço digital e sua simulação')
saveas(ursim,'ursim55.eps','epsc')
%% Mostra dados da resposta
pid55 = stepinfo(yf(1:2000), t(1:2000), 1)
pid55s = stepinfo(y55(1:2000), tpre(1:2000), 1)
%% Compara tudo!!
%'Controlador proporcional por overshoot de 2%'
load 'OUTov2.lvm';
yv=OUTov2(4001:8000,2);
yfv=filter(filtro,OUTov2(4001:8000,2));
rv=OUTov2(4001:8000,4);
uv=OUTov2(4001:8000,6);
%'Controlador PID por Ziegler-Nichols'
load 'OUTziegler.lvm';
yz=OUTziegler(4001:8000,2);
yfz=filter(filtro, OUTziegler(4001:8000,2));
rz=OUTziegler(4001:8000,4);
uz=OUTziegler(4001:8000,6);
%'Controlador PID analógico'
a = load('PIDA.lvm');
ya = a(4001:8000,2);
yfa = filter(filtro,ya);
ra = a(4001:8000,4);
ua = a(4001:8000,6);
% 'Controlador Atraso-Avanço com Md = $45^o$'
a = load('Controlador1.lvm');
t = a(:,1)*0.001;
y = a(:,2);
r = a(:,4);
u = a(:,6);
t= t(4001:8000) - 4;
y = y(4001:8000);
u = u(4001:8000);
r = r(4001:8000);
filtro = createFilter();
yf = filter(filtro, y);

yfrcomp = figure;
plot(t, r, t, yfv, t, yfz, t, yfa, t, yf);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Entrada','Controlador proporcional por overshoot de 2%', 'Controlador PID por Ziegler-Nichols', 'Controlador PID analógico', 'Controlador Atraso-Avanço com Md = 45^o')
title('Comparação entre respostas filtradas dos controladores projetados')
saveas(yfrcomp,'yfrcomp.eps','epsc')
yrcomp = figure;
plot(t, r, t, yv, t, yz, t, ya, t, y);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Entrada', 'Controlador proporcional por overshoot de 2%', 'Controlador PID por Ziegler-Nichols', 'Controlador PID analógico', 'Controlador Atraso-Avanço com Md = 45^o')
title('Comparação entre respostas dos controladores projetados')
saveas(yrcomp,'yrcomp.eps','epsc')
%% Fix eps
!epsfixer.sh
