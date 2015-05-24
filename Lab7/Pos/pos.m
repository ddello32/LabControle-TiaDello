clear all;close all;clc;
filtro = createFilter();

%% Ensaio Parado!
%% Carrega Dados
a = load('Corrente travado.lvm');
t = a(:,1)*0.01;
i = a(:,2);
iF = filter(filtro, i);

%% Parametros
Rs = 1;
V = 12;

%% Determina R
Iinf = mean(iF(1200:1367))
R = (V - Rs*Iinf)/Iinf

%% Calculo de L
Ides = (1-exp(-1))*Iinf
Irise = iF(453:1000);
eps = 0.1;
idx= find(abs(Irise - Ides) <= eps);
te = (Ides - Irise(idx(2)))/diff(Irise(idx)) + idx(2);
te = 0.01*te
L = te*(R + Rs)

%% Ensaio rodando
%% Carrega Dados
a = load('Corrente.lvm');
tr = a(1722:end,1)*0.01 - - 17.22;
ir = a(1722:end,2);
irF = filter(filtro, ir);
irF = medfilt1(irF, 30);

a = load('Velocidade.lvm');
tr = a(1722:end,1)*0.01 - 17.22;
vr = a(1722:end,2);
vrF = filter(filtro, vr);
vrF = medfilt1(vrF, 30);

%% Calculo dos parametros mecanicos
vrInf = mean(vrF(7300:7725))
irInf = mean(irF(7300:7725))

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

%% Modelo no espaço de estados

A = [ -(R+Rs)/L -K/L 0;
      K/J -b/J 0;
      0 1 0;]
B = [1/L; 0; 0]
C = [1 0 0; 0 1 0]
D = [0; 0]
%in = cat(2, cat(2, zeros(1,183), 12*ones(1,7607)), zeros(1,6152));
sistema = ss(A, B, C, D,'InputName','V','OutputName',{'i', 'v'});
options = stepDataOptions('InputOffset',0, 'StepAmplitude', V);
T = step(sistema, tr, options)
figure,
plot(tr(1:7750)-1.86,irF(1:7750), tr(1:7750), T(1:7750,1))
figure,
plot(tr(1:7750)-1.86,vrF(1:7750), tr(1:7750), T(1:7750,2))

