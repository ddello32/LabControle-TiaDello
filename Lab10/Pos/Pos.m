clear all;close all;clc;
filtro = createFilter();

%% Planta calculada no pr�-relat�rio:
G=importdata('planta.mat');

%% Controlador 1
% Simula��o
s = tf('s');
K=7718.97616400369*(s+-2.35491869113702)/s/(s+79539.8332719318);                 %TODO: Pegar do sisotool

% Laborat�rio
c = load('PI0501Controle.lvm');
v = load('PI0501Velocidade.lvm');
t = c(:,1)*0.01;
y = v(:,2);
u = c(:,2);
% u(1190:11:1430) = -u(1190:11:1430)/1.5;
% u(1210:3:1395) = -u(1210:3:1395)/1.2;
% u(1210:1390) = -u(1210:1390);
% 
% u(1190:11:1430) = -u(1190:11:1430)/1.5;
% u(1210:3:1395) = -u(1210:3:1395)/1.2;
% u(1210:1390) = -u(1210:1390);
% 
% u(3840:11:4080) = -u(3840:11:4080)/1.5;
% u(3843:3:4050) = -u(3843:3:4050)/1.2;
% u(3843:4050) = u(3843:4050)/1.9;
% 
% % u(1300:1316) = -u(1300:1316);
% u(2966:end) = -u(2966:end);
% u(840) = -u(840);
% u(842) = -u(842);
% 
% u(984) = -u(984);
% u(982) = -u(982);
% u(980) = -u(980);
% u(978) = -u(978);
% u(976) = -u(976);
% u(974) = -u(974);
% u(972) = -u(972);
% u(970) = -u(970);
% 
% u(4123:4301) = -u(4123:4301);
% 
% u(4128) = -u(4128);
% u(4126) = -u(4126);
% u(4124) = -u(4124);
% u(4126) = -u(4126);
% u(4128) = -u(4128);
% u(4130) = -u(4130);
% 
% u(4304) = -u(4304);
% u(4302) = -u(4302);
% u(4300) = -u(4300);
% u(4298) = -u(4298);
% u(4296) = -u(4296);
% u(4294) = -u(4294);
% 
e = zeros(1, length(t));
e(246:7091) = 100;
e(7092:end) = -100;
%%
for i = 246:17:length(u)
    if(abs(u(i)) < 5)
        u(i) = -u(i);
    end
end
%% Plots
epsa = figure;
plot(t,r,t,v)
xlabel('Tempo(s)')
ylabel('Velcidade(rad/s)')
title('Saída do sistema com controlador PI aprimorado')
legend('Referencia', 'Velocidade medida')
saveas(epsa,'bla0505medido.eps','epsc')
%% 
epsb = figure;
plot(t,u/10)
yaxis([-12, 12])
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
title('Esforço de controle do sistema com controlador PI aprimorado')
saveas(epsb,'blaesforco.eps','epsc')
%% Filters signal
yf = filter(filtro, v);
uf = filter(filtro, u);
%% Plots
%% Sem filtro
ysemfiltro = figure;
plot(t, y);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Sa�da')
title('Sa�da sem filtro do controlador 1')
saveas(ysemfiltro,'ylab1.eps','epsc')
%% Esfor�o de controle
upid = figure;
plot(t, u);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço de Controle')
title('Esforço de controle Controlador 1')
saveas(upid,'ulab1.eps','epsc')
%% Comparação com o simulado
%% Saida
yrsim = figure;
plot(t, yf, tpre(1:4000), y45(1:4000));
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída filtrada','Saída simulada')
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
