clear, clc
%% Pré lab
%% Variaveis para o simulink
Sample_time = 0.001;
Noise_step = 1e-5;
Noise_ramp = 0;

%% modéle
k1=-0.0995;
k2=-2.1626;
k3=-4.5739;
k4=-9.1333;
tau2=0.0130;
tau3=0.0232;

A = [0, 1, 0; 0, 0, 1; 0, -1/(tau2*tau3), -(tau2+tau3)/(tau2*tau3)]
B = [0; 0; k1*k2*k3*k4/(tau2*tau3)]
C = [1, 0, 0]
D = 0

%% contrôleur avec x et d connus
rank([B A*B A*(A*B)]) % test commandabilité
%% Calcular autovalores
te = 0.5;
ksi = sqrt(2)/2;
wn = -log(0.02)/(ksi*te);
wd = wn*sqrt(1-ksi^2);
vpc = [-30 -ksi*wn+wd*i -ksi*wn-wd*i]; % vp désirées pour A-B*K
K = place(A,B,vpc)
%% Calculo de M
%0.0720*m2 - 0.1945*m1 + 0.0023*m3 + 1/t == 0
%m1 - 0.3702*m2 - 0.0117*m3 == 1
syms s m1 m2 m3 tau;
Sa = C*inv(s*eye(3) - (A - B*K))*B;
Ma = (s/tau + 1)/(s/30 + 1)*[m1; m2; m3];
[m1r, m2r, m3r, taur] = solve(subs(Sa*K*Ma, s, 0) == 1, subs(diff(Sa*K*Ma, s), s, 0) == 0, m1 == 1, m2 == 0.5, m1, m2, m3, tau);
M = (tf('s')/eval(taur) + 1)/(tf('s')/30 + 1)*[eval(m1r); eval(m2r); eval(m3r)]

%% observateur
rank([C; C*A; (C*A)*A]) % test observabilité
%% TODO Calcular autovalores do observador
vpo = [-150, -150, -150]; % vp désirées pour Aa-La*Ca
L = transpose(acker(A',C',vpo))
eig(A-L*C)

%% Voltar para o domínio da frequencia
hs = minreal(K*M)
syms s;
Cus = eval((K*(inv(s*eye(3) - (A - L*C))))*B);
[symNum,symDen] = numden(Cus); %Get num and den of Symbolic TF
TFnum = sym2poly(symNum);    %Convert Symbolic num to polynomial
TFden = sym2poly(symDen);    %Convert Symbolic den to polynomial
Cus = minreal(tf(TFnum,TFden))
Cys = eval((K*(inv(s*eye(3) - (A - L*C))))*L);
[symNum,symDen] = numden(Cys); %Get num and den of Symbolic TF
TFnum = sym2poly(symNum);    %Convert Symbolic num to polynomial
TFden = sym2poly(symDen);    %Convert Symbolic den to polynomial
Cys = minreal(tf(TFnum,TFden))
Gs = tf([k1*k2*k3*k4],[tau2*tau3 tau2+tau3 1 0])

%% Roda simulink
model = 'grace';
load_system(model);
sim(model);

%% Renomea dados
t = logsout.get('y').Values.Time;
y = logsout.get('y').Values.Data;
yr = logsout.get('yr').Values.Data;
u = logsout.get('u').Values.Data;

yN = logsout.get('yN').Values.Data;
yrN = logsout.get('yrN').Values.Data;
ymN = logsout.get('ymN').Values.Data;
uN = logsout.get('uN').Values.Data;

yR = logsout.get('yR').Values.Data;
yrR = logsout.get('yrR').Values.Data;
ymR = logsout.get('ymR').Values.Data;
uR = logsout.get('uR').Values.Data;

%% Plots
%Sem ruído
yur=figure;
plot(t(1:4001),y(1:4001),t(1:4001),yr(1:4001), t(1:4001),u(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída','Entrada', 'Esforço de Controle')
title('Simulação do controlador com entrada degrau')
saveas(yur,'yur.eps','epsc')
info = stepinfo(y(1:2000), t(1:2000), 1)
%Com ruído
yurN=figure;
plot(t(1:4001),ymN(1:4001),t(1:4001),yrN(1:4001), t(1:4001),uN(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída','Entrada', 'Esforço de Controle')
title('Simulação do controlador com ruído branco')
saveas(yurN,'yurN.eps','epsc')
infoN = stepinfo(ymN(1:2000), t(1:2000), 1)
%Rampa
yurR=figure;
plot(t(1:4001),ymR(1:4001),t(1:4001),yrR(1:4001), t(1:4001),uR(1:4001))
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída','Entrada', 'Esforço de Controle')
title('Simulação do controlador para entrada rampa')
saveas(yurR,'yurR.eps','epsc')
infoR = stepinfo(ymR(1:2000), t(1:2000), 1)

%% Observador
model = 'estados';
load_system(model);
sim(model);

t = stateslog.get('x').Values.Time;
x1 = stateslog.get('x').Values.Data(:,1);
x2 = stateslog.get('x').Values.Data(:,2);
x3 = stateslog.get('x').Values.Data(:,3);
x1e = stateslog.get('xest').Values.Data(:,1);
x2e = stateslog.get('xest').Values.Data(:,2);
x3e = stateslog.get('xest').Values.Data(:,3);

obsx1 = figure,
plot(t(1:4001), x1(1:4001), 'b-', t(1:4001), x1e(1:4001), 'r-');
xlabel('Tempo(s)')
ylabel('Estado')
legend('x_1', 'x_{1obs}')
saveas(obsx1,'obsx1.eps','epsc')

obsx2 = figure,
plot(t(1:4001), x2(1:4001), 'b-', t(1:4001), x2e(1:4001), 'r-');
xlabel('Tempo(s)')
ylabel('Estado')
legend('x_2','x_{2obs}')
saveas(obsx2,'obsx2.eps','epsc')

obsx3 = figure,
plot(t(1:4001), x3(1:4001), 'b-', t(1:4001), x3e(1:4001), 'r-');
xlabel('Tempo(s)')
ylabel('Estado')
legend('x_3', 'x_{3obs}')
saveas(obsx3,'obsx3.eps','epsc')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Lab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Carrega Dados
a = load('Planta_gui.lvm');
t = a(:,1)*0.001;
y = a(:,3) + 0.055;
r = a(:,2);
u = a(:,4) - 0.02;
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
yrSIS = figure;
plot(t, y, t, r);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída','Entrada')
title('Saída do controlador-observador')
saveas(yrSIS,'yrSIS.eps','epsc')
%% Esforço de controle
urSIS = figure;
plot(t, u, t, r);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esforço de Controle','Entrada')
title('Esforço de controle do controlador-observador')
saveas(urSIS,'urSIS.eps','epsc')
%% Resposta a rampa
yrSISR = figure;
plot(t, cumtrapz(t,y)+0.111, t, cumtrapz(t,r));
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Saída','Entrada')
title('Saída do controlador-observador para entrada rampa')
saveas(yrSISR,'yrSISR.eps','epsc')
%% Mostra dados da resposta
info = stepinfo(yf(1:2000), t(1:2000), 1)
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
tav = a(:,1)*0.001;
yav = a(:,2);
rav = a(:,4);
uav = a(:,6);
tav = tav(4001:8000) - 4;
yav = yav(4001:8000);
uav = uav(4001:8000);
rav = rav(4001:8000);
yfav = filter(filtro, yav); 

yfrcomp = figure;
plot(t, r, t, yfv, t, yfz, t, yfa, t, yfav, t, yf);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Entrada','Controlador proporcional por overshoot de 2%', 'Controlador PID por Ziegler-Nichols', 'Controlador PID analógico', 'Controlador Atraso-Avanço com Md = 45^o', 'Controlador-Observador digital')
title('Comparação entre respostas filtradas dos controladores projetados')
saveas(yfrcomp,'yfrcomp.eps','epsc')
yrcomp = figure;
plot(t, r, t, yv, t, yz, t, ya, t, yav, t, yf);
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Entrada', 'Controlador proporcional por overshoot de 2%', 'Controlador PID por Ziegler-Nichols', 'Controlador PID analógico', 'Controlador Atraso-Avanço com Md = 45^o', 'Controlador-Observador digital')
title('Comparação entre respostas dos controladores projetados')
saveas(yrcomp,'yrcomp.eps','epsc')

%% Eps encoding fix in linux
!epsfixer.sh
