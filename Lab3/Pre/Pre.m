%% Carrega Função de transferencia do sistema
a = 6.556;
b = 0.0004103;
c = 0.04056;
d = 1;
e = 0;
GS = tf(a, [b, c, d, e]);
t=0:0.01:5;
sq=0.5+0.5*square(2*pi*t);
%% Calculo de controlador com menor tempo de estabilização
kp = 1.114
kp = 1.609
mf = feedback(kp*GS, 1);
% y(t)
stepplot(mf)
sim1 = lsim(mf, sq, t);
figure,
haxes = axes;
plot(t, sim1, 'k', t, sq, 'g', 2.418, 0.98, 'rsq');
ylim([-0.5, 1.5])
xlim([1.5, 4.5]);
line(get(haxes, 'XLim'), [1 1], 'LineStyle', '--');
line(get(haxes, 'XLim'), [0.98 0.98], 'LineStyle', '--');
line(get(haxes, 'XLim'), [1.02 1.02], 'LineStyle', '--');
line([2.418, 2.418], get(haxes, 'YLim'), 'LineStyle', '--');
estabilizacao = 0.418;
overshoot = 0;

damp(mf)
wn = 16.4;
ksi = 1;
te = -log(0.02)/ksi/wn;
syms xi

solve(exp(-xi*pi/sqrt(1-xi^2)) -ov)
erroStep = 0 % step
erroRamp = Inf % rampa
% Resposta a rampa deu ruim pq vai estourar mesmo. Erro infinito!
% Ver print screens do sisotool.
%% Zieger-Nichelson
% Critério de routh
% 1 + k*a/(b*s^3 + c*s^2 + d*s + e)
% (b*s^3 + c*s^2 + d*s + e + ka)/(b*s^3 + c*s^2 + d*s + e)
% s3 b                     d           0
% s2 c                     e+ka        0
% s1 (c*d - b*(e+ka))/c    0           0  
% s0 (e+ka)

% b  > 0 -> Verdade
% c  > 0 -> Verdade
% (c*d - b*(e+ka))/c > 0 -> (c*d - b*e)/(b*a) > k
% e+ka > 0 -> k > 0
kosc = (c*d - b*e)/(b*a);
ziegmf = feedback(kosc*GS, 1);
damp(ziegmf)
wnosc = 49.4;
Tosc = 2*pi/wnosc;
%Usando a tabela
s = tf('s');
kp = 0.6*kosc;
Ti = Tosc/2;
Td = Tosc/8;
pidzg = kp*(1 + 1/(Ti*s) +Td*s)
% Kp = 9.05, Ki = 142, Kd = 0.144
%%
s = tf('s')
pidsiso = 3.3874*(1+0.04*s)*(1+2.2*s)/(s*(1+0.00017*s))
% Kp = 7.59, Ki = 3.39, Kd = 0.297, Tf = 0.00017
pidsiso2 = 6.6842*(1+0.04*s)*(1+2.2*s)/(s*(1+0.00017*s))
%  Kp = 5.3, Ki = 2.37, Kd = 0.207, Tf = 0.00017