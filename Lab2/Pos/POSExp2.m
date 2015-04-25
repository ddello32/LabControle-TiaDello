close all,
clear all,
clc

%% Cria passa baixa doido
filtro = createFilter();

%% Determinação de G1
aux = load('OUT1.lvm');
r1 = aux(:,4); %Entrada
y1 = aux(:,2); %Saída em 1
t1 = aux(:,1).*1e-3;
figure,
plot(t1, y1, t1, r1);
%To avoid dividing by zero
y1p = y1(r1 ~= 0);
r1p = r1(r1 ~= 0);
err = y1p./r1p;
k1 = mean(err);
g1 = tf(k1, 1)

%% Determinação de G2
aux = load('OUT2.lvm');
r2 = aux(:,4); %Entrada
y2 = aux(:,2); %Saída em 1
t2 = aux(:,1).*1e-3;
y2f = filter(filtro, y2);
figure,
plot(t2 ,y2)
figure,
plot(t2, y2f)
% Select only one period
r2p = r2(1001:1500);
y2p = y2f(1001:1500);
tp = t2(1001:1500)-1;
k21 = max(y2p)/r2p(500);
k2 = k21/k1;
ta1 = find(((0.98)*max(y2p)-1e-4 <= y2p).*(y2p <= (0.98)*max(y2p) + 1e-4));
ta1 = ta1(1);
tao2 = tp(ta1)/4;
figure,
hax = axes;
plot(tp, y2p, 'k', tp(ta1), y2p(ta1), 'rs');
line(get(hax, 'XLim'), [max(y2p), max(y2p)], 'LineStyle', '--') 
line(get(hax, 'XLim'), [y2p(ta1), y2p(ta1)], 'LineStyle', '--') 
line([tp(ta1), tp(ta1)], get(hax, 'YLim'), 'LineStyle', '--') 
xlabel('Tempo(s)');
ylabel('Saida(V)');
g2 = tf(k2, [tao2, 1])
%% Determinação de G3
aux = load('OUT3.lvm');
r3 = aux(:,4); %Entrada
y3 = aux(:,2); %Saída em 1
t3 = aux(:,1).*1e-3;
y3f = filter(filtro, y3);
figure,
plot(t3, y3, t3, y3f);
% Select only one high
r3p = r3(1001:1500);
y3p = y3f(1001:1500);
tp = t3(1001:1500) - 1;
k321 = y3p(500)/r3(500);
k3 = k321/k2/k1;
ta1 = find((tao2-1e-10 <= tp).*(tao2+1e-10 >= tp));
ta1 = ta1(1);
ta2 = find((2*tao2-1e-10 <= tp).*(2*tao2+1e-10 >= tp));
ta2 = ta2(1);
figure,
plot(tp, y3p, tp(ta1), y3p(ta1), 'b*', tp(ta2), y3p(ta2), 'b*');
a = y3p(ta1)/k321;
b = y3p(ta2)/k321;
x = (1 + exp(1)*(b-1) - a)/(1 + exp(1)*(a-1)); %Resolvendo a equação do slide
tao3 = -tao2/log(x);
g3 = tf(k3, [tao3, 1])
%% Determinação de G4
aux = load('OUT4.lvm');
r4 = aux(:,4); %Entrada
y4 = aux(:,2); %Saída em 1
t4 = aux(:,1);
y4(t4 < 5000) = [];
r4(t4 < 5000) = [];
t4(t4 < 5000) = [];
t4 = t4*1e-3 - 5;
y4f = filter(filtro, y4);
figure,
plot(t4, y4, t4, y4f);
% Select only one high
r4p = r4(1001:1500);
y4p = y4f(1001:1500);
tp = t4(1001:1500) - 1;
ta1 = find((tao3 + 0.3 -1e-2 <= tp).*(tao3 + 0.3 + 1e-2 >= tp));
ta1 = ta1(1);
figure,
plot(tp, y4p, tp(ta1), y4p(ta1), 'b*', tp(480), y4p(480), 'b*')
% Calculo acochambrado da derivada
k4321 = (y4p(480)-y4p(ta1))/(tp(480) - tp(ta1));
k4 = k4321/k3/k2/k1;
g4 = tf(k4, [1, 0])

gs = g1*g2*g3*g4

sim1 = lsim(g1, r1, t1);
figure,
plot(t1, sim1, t1, y1)

sim2 = lsim(g2*g1, r2, t2);
figure,
plot(t2, sim2, t2, y2)

sim3 = lsim(g3*g2*g1, r3, t3);
figure,
plot(t3, sim3, t3, y3)

sim4 = lsim(g1*g2*g3*g4, r4, t4);
figure,
plot(t4, sim4, t4, y4)