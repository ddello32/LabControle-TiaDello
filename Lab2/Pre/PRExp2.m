clear all;close all;clc;

%% Valores numericos dos componentes
r1 = 100*10^3;
r2 =  10*10^3;
r3 = 100*10^3;
r4 = 220*10^3;
r5 = 100*10^3;
r6 = 470*10^3;
r7 =   1*10^6;
c1 = 0.1*10^-6;
c2 = 0.1*10^-6;
c3 = 0.1*10^-6;

%% Definicao das funcoes de transferencia
G1=tf([-r2],[r1])
G2=tf([-r4]/r3,[r4*c1 1])
G3=tf([-r6/r5],[r6*c2 1])
G4=tf([-1],[r7*c3 0])
G=G1*G2*G3*G4

%% Diagrama de Bode
margin(G);

%% Respostas a onda quadrada
    % Simulacoes feitas considerando a entrada de onda quadrada no primeiro
    % estagio, e a saida deste estagio como entrada do proximo, e assim por
    % diante.
t=0:0.01:2.5;
sq=0.5+0.5*square(2*pi*t);

Y1=lsim(G1,sq,t);
Y2=lsim(G2,Y1,t);
Y3=lsim(G3,Y2,t);
Y4=lsim(G4,Y3,t);

figure
subplot(2,1,1)
plot(t,Y1,t,Y2,t,Y3,t,Y4);
legend('Vo1','Vo2','Vo3','Vo4');
title('Resposta a onda quadrada aplicada em r');
ylabel('Tensao de saida (V)');
xlabel('Tempo (s)');
subplot(2,1,2)
plot(t,sq);
title('Onda quadrada aplicada em r');
ylabel('Tensao de saida (V)');
xlabel('Tempo (s)');
ylim([-0.5, 1.5])



