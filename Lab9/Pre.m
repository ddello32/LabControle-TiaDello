clear all;close all;clc;
filtro = createFilter();

%% Ensaio Parado!
%% Carrega Dados
a = load('MotorTravadoCorrente.lvm');
t = a(:,1)*0.01;
i = a(:,2);
iF = filter(filtro, i);
Iinf = mean(i(700:2950))

ensaiop = figure;
hplot = plot(t, i);
xlabel('Tempo(s)')
ylabel('Corrente(A)')
makedatatip(hplot, [29.50, Iinf], {'i_\infty'}, {'Tempo (s): ', 'Corrente (A): '})
title('Corrente de ensaio com motor parado')
saveas(ensaiop,'ensaiop.eps','epsc')
%% Parametros
Rs = 0;
V = 12;
L = 0;
R = (V - Rs*Iinf)/Iinf
L = 0;

%% Ensaio rodando
%% Carrega Dados
a = load('CorrenteGirandoLivre.lvm');
tr = a(1:9488,1)*0.01;
ir = a(1:9488,2);
irF = filter(filtro, ir);
irF = medfilt1(irF, 30);

ensaiori = figure;
plot(tr, ir);
xlabel('Tempo(s)')
ylabel('Corrente(A)')
title('Corrente de ensaio com motor em movimento')
saveas(ensaiori,'ensaiori.eps','epsc')

a = load('VelocidadeGirandoLivre.lvm');
tr = a(1:9488,1)*0.01;
vr = -1*a(1:9488,2);
vrF = filter(filtro, vr);
vrF = medfilt1(vrF, 30);

ensaiorv = figure;
plot(tr, vr);
xlabel('Tempo(s)')
ylabel('Velocidade Angular(rad/s)')
title('Velocidade angular para ensaio com motor em movimento')
saveas(ensaiorv,'ensaiorv.eps','epsc')

%% Calculo dos parametros mecanicos
vrInf = mean(vrF(5000:8428))
irInf = mean(irF(5000:8428))


ensaioriF = figure;
hplot = plot(tr(1:8428), irF(1:8428));
xlabel('Tempo(s)')
ylabel('Corrente(A)')
title('Corrente filtrada com motor em movimento')
makedatatip(hplot, [84.27, irInf], {'i_\infty'}, {'Tempo (s): ', 'Corrente (A): '})
saveas(ensaioriF,'ensaioriF.eps','epsc')

K = (V - (R +Rs)*irInf)/vrInf
b12 = (K/R)*(V - K*vrInf)/vrInf

ensaiorvF = figure;
hplot = plot(tr, vrF);
xlabel('Tempo(s)')
ylabel('Velocidade(rad/s)')
title('Velocidade filtrada com motor em movimento')
makedatatip(hplot, [84.27, vrInf], {'v_\infty'}, {'Tempo (s): ', 'Velocidade (rad/s): '})
saveas(ensaiorvF,'ensaiorvF.eps','epsc')

%% Disco 1 livre
a = load('DiscoEncTravadoVelocidade.lvm');
tr1 = a(83:end,1)*0.01 - 0.82;
vr1 = a(83:end,2);
theta1 = cumsum(vr1)*0.01; % Integrate velocity
theta1 = theta1 - theta1(end) % Offset to zero
disco2travado = figure;
hplot = plot(tr1(1:250), theta1(1:250))
% Pontos de maximo e mínimo
tm1 = [0, 0.16, 0.32, 0.48, 0.63, 0.79, 0.93, 1.09, 1.24, 1.4, 1.56, 1.71, 1.85, 2.01];
thm1 = [-0.3493, 0.3192, -0.2815, 0.2564, -0.2187, 0.2036, -0.1583, 0.1558, -0.1081, 0.1081, -0.06535, 0.05781, -0.02765, 0.02262];
makedatatip(hplot, [tm1', thm1'],  {'\theta(t_1)','\theta(t_2)','\theta(t_3)','\theta(t_4)','\theta(t_5)','\theta(t_6)','\theta(t_7)','\theta(t_8)','\theta(t_9)','\theta(t_{10})','\theta(t_{11})','\theta(t_{12})','\theta(t_{13})','\theta(t_{14})'}, {'t(s): ', '\theta(rad): '})
xlabel('Tempo(s)')
ylabel('Deslocamento (rad)')
title('Deslocamento angular para ensaio com disco 2 travado')
%saveas(disco2travado,'disco2travado.eps','epsc')
%% Calculo
m = length(tm1);
wd1 = (m-1)*pi/sum(diff(tm1))
tgphi1 = (m-1)*pi/sum(log(abs(thm1(1:m-1)./thm1(2:m))))
ksi1 = sqrt(1/(tgphi1^2 + 1))
wn1 = wd1/(ksi1*tgphi1)
%% Disco 2 livre
a = load('DiscoMotorTravadoVelocidade.lvm');
tr2 = a(311:700,1)*0.01 - 3.1;
vr2 = a(311:700,2);
theta2 = cumsum(vr2)*0.01; % Integrate velocity
theta2 = theta2 - theta2(end) % Offset to zero
disco1travado = figure;
hplot = plot(tr2(1:340), theta2(1:340))
% Pontos de maximo e mínimo
tm2 = [0, 0.15, 0.3, 0.44, 0.58, 0.74, 0.88, 1.03, 1.18, 1.33, 1.47, 1.62, 1.76, 1.92, 2.06, 2.21, 2.36, 2.5, 2.64];
thm2 = [-0.1483, 0.1508, -0.1357, 0.1257, -0.1206, 0.1131, -0.1005, 0.1005, -0.08042, 0.08545, -0.06283, 0.07037, -0.04775, 0.05781, -0.02765, 0.04524, -0.01508, 0.02765, -0.005027];  
makedatatip(hplot, [tm2', thm2'],  {'\theta(t_1)','\theta(t_2)','\theta(t_3)','\theta(t_4)','\theta(t_5)','\theta(t_6)','\theta(t_7)','\theta(t_8)','\theta(t_9)','\theta(t_{10})','\theta(t_{11})','\theta(t_{12})','\theta(t_{13})','\theta(t_{14})','\theta(t_{15})','\theta(t_{16})','\theta(t_{17})','\theta(t_{18})','\theta(t_{19})','\theta(t_{20})'}, {'t(s): ', '\theta(rad): '})
xlabel('Tempo(s)')
ylabel('Deslocamento (rad)')
title('Deslocamento angular para ensaio com disco 1 travado')
%saveas(disco2travado,'disco2travado.eps','epsc')
%% Calculo
m = length(tm2);
wd2 = (m-1)*pi/sum(diff(tm2))
tgphi2 = (m-1)*pi/sum(log(abs(thm2(1:m-1)./thm2(2:m))))
ksi2 = sqrt(1/(tgphi2^2 + 1))
wn2 = wd2/(ksi2*tgphi2)
%% Parametros
J1 = (b12 + K^2/R)/(2*ksi1*wn1 + 2*ksi2*wn1^2/wn2)
J2 = wn1^2*J1/wn2^2
kappa = wn1^2*J1
b2 = 2*ksi2*wn2*J2
b1 = b12 - b2

%% Fix eps
!epsfixer.sh

