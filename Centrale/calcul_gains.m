%%% Explication des réglages de script1.m par la démarche du cours

clear, clc

%% modèle de commande
A = [1 2 0; 3 1 -2; 4 -2 1];
B = [1; -1; 1];
Bd = [0; 1; 0];
C = [7 8 1];
D = 0;
Dd = 0;


%% observateur
Aa = [A Bd; 0 0 0 0]; % système augmenté par modèle des perturbations
Ba = [B; 0];
Ca = [C 0];

To = 1/3; % on peut faire mieux: par ex To=1/100 et k0=100 donnent 33dB et 88°
k0 = 5; 
g = grampar(Aa',Ca',k0*To);
Qo = inv(g)*k0/To;
Qo = (Qo+Qo')/2; % pour que Qo soit symétrique malgré les arrondis
Ro = eye(1);
[La,P,Eo] = lqr(Aa',Ca',Qo,Ro);
La = La'
Eo
% rem: polynôme désiré de script1 obtenu par round(poly(Eo))


%% contrôleur avec x et d connus
Tc = To/10; % To/100 LTR parfait, To/10 LTR acceptable
Rc = eye(1);
Sc = inv(C*Tc*grampar(A,B,Tc)*C');
[K,S,Ec] = lqr(A,B,C'*Sc*C,Rc);
K,Ec
% rem: polynôme désiré de script1 obtenu par round(poly(Ec)) avec Tc=To/10
% pour choix 1 et Tc=To/100 pour choix 2

