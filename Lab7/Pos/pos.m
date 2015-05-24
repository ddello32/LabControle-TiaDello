clear all;close all;clc;
filtro = createFilter();

%% Ensaio Parado!
%% Carrega Dados
a = load('Corrente travado.lvm');
t = a(:,1)*0.01;
i = a(:,2);
iF = filter(filtro, i);

ensaiop = figure;
plot(t, i);
xlabel('Tempo(s)')
ylabel('Corrente(A)')
title('Corrente de ensaio com motor parado')
saveas(ensaiop,'ensaiop.eps','epsc')
%% Parametros
Rs = 1;
V = 12;

%% Determina R
Iinf = mean(iF(1200:1367))
R = (V - Rs*Iinf)/Iinf

%% Calculo de L
Ides = (1-exp(-1))*Iinf
Irise = iF(453:1300);
eps = 0.1;
idx= find(abs(Irise - Ides) <= eps);
te = (Ides - Irise(idx(2)))/diff(Irise(idx)) + idx(2);
te = 0.01*te
riseI = figure;
hplot = plot(t(453:1300) - 4.53, Irise);
xlabel('Tempo(s)')
ylabel('Corrente(A)')
title('Análise com pontos de relevância para corrente com motor parado')
makedatatip(hplot, [te, Ides; 13-4.53, Iinf], {'0.63 i_\infty'; 'i_\infty'}, {'Tempo (s): ', 'Corrente (A): '})
saveas(riseI,'riseI.eps','epsc')

L = te*(R + Rs)

%% Ensaio rodando
%% Carrega Dados
a = load('Corrente.lvm');
tr = a(1722:end,1)*0.01 - 17.21;
ir = a(1722:end,2);
irF = filter(filtro, ir);
irF = medfilt1(irF, 30);

ensaiori = figure;
plot(tr, ir);
xlabel('Tempo(s)')
ylabel('Corrente(A)')
title('Corrente de ensaio com motor em movimento')
saveas(ensaiori,'ensaiori.eps','epsc')

a = load('Velocidade.lvm');
tr = a(1722:end,1)*0.01 - 17.21;
vr = a(1722:end,2);
vrF = filter(filtro, vr);
vrF = medfilt1(vrF, 30);

ensaiorv = figure;
plot(tr, vr);
xlabel('Tempo(s)')
ylabel('Velocidade Angular(rad/s)')
title('Velocidade angular para ensaio com motor em movimento')
saveas(ensaiorv,'ensaiorv.eps','epsc')

%% Calculo dos parametros mecanicos
vrInf = mean(vrF(7300:7725))
irInf = mean(irF(7300:7725))

ensaioriF = figure;
hplot = plot(tr(1:7725), irF(1:7725));
xlabel('Tempo(s)')
ylabel('Corrente(A)')
title('Corrente filtrada com motor em movimento')
makedatatip(hplot, [77.25, irInf], {'i_\infty'}, {'Tempo (s): ', 'Corrente (A): '})
saveas(ensaioriF,'ensaioriF.eps','epsc')

K = (V - (R +Rs)*irInf)/vrInf
b = K*irInf/vrInf

Vdes = (exp(-1))*vrInf
Vqueda = vrF(7725:end);
eps = 0.01;
idx= find(abs(Vqueda - Vdes) <= eps);
if(size(idx, 1) == 1)
    if(Vqueda(idx(1)) >= Vdes)
        idx(2) = idx(1) + 1;
    else
        idx(2) = idx(1) - 1;
    end
end
tm = (Vdes - Vqueda(idx(2)))/diff(Vqueda(idx)) + idx(2);
tm = tm*0.01
J = tm*b

ensaiorvF = figure;
hplot = plot(tr, vrF);
xlabel('Tempo(s)')
ylabel('Velocidade(rad/s)')
title('Velocidade filtrada com motor em movimento')
makedatatip(hplot, [77.25, vrInf; tm + 77.25, Vdes], {'v_\infty', '0.3679 v_\infty'}, {'Tempo (s): ', 'Velocidade (rad/s): '})
saveas(ensaiorvF,'ensaiorvF.eps','epsc')

%% Modelo no espaço de estados

A = [ -(R+Rs)/L -K/L 0;
      K/J -b/J 0;
      0 1 0;]
B = [1/L; 0; 0]
C = [1 0 0; 0 1 0]
D = [0; 0]
in = cat(2, cat(2, zeros(1,183), 12*ones(1,7607)), zeros(1,6152));
sistema = ss(A, B, C, D,'InputName','V','OutputName',{'i', 'v'});
options = stepDataOptions('InputOffset',0, 'StepAmplitude', V);
T = lsim(sistema, in, tr);
simi = figure,
plot(tr, irF, tr, T(:,1))
xlabel('Tempo(s)')
ylabel('Corrente(A)')
legend('Corrente medida filtrada', 'Corrente simulada')
title('Comparação entre sistema simulado e sistema medido')
saveas(simi,'simi.eps','epsc')
simv = figure,
plot(tr,vrF, tr, T(:,2))
xlabel('Tempo(s)')
ylabel('Velocidade Angular(rad/s)')
legend('Velocidade medida filtrada', 'Velocidade simulada')
title('Comparação entre sistema simulado e sistema medido')
saveas(simv,'simv.eps','epsc')

%% Tm = 41
tm2 = 41;
J2 = tm2*b
A = [ -(R+Rs)/L -K/L 0;
      K/J2 -b/J2 0;
      0 1 0;]
B = [1/L; 0; 0]
C = [1 0 0; 0 1 0]
D = [0; 0]
in = cat(2, cat(2, zeros(1,183), 12*ones(1,7607)), zeros(1,6152));
sistema = ss(A, B, C, D,'InputName','V','OutputName',{'i', 'v'});
options = stepDataOptions('InputOffset',0, 'StepAmplitude', V);
T = lsim(sistema, in, tr);
figure,
plot(tr, irF, tr, T(:,1))
figure,
plot(tr,vrF, tr, T(:,2))

%% Fix eps
!epsfixer.sh

