%%% Comme script.m, mais avec meilleur réglage de l'observateur-contrôleur

clear, clc

%% modèle (simulation et commande, car linéaire)
A = [1 2 0; 3 1 -2; 4 -2 1];
B = [1; -1; 1];
Bd = [0; 1; 0];
C = [7 8 1];
D = 0;
Dd = 0;

%% point d'équilibre initial  pour Simulink
dbar = 0;
ybar = -2;
xubar = inv([A B; C D])*[-Bd*dbar; ybar-Dd*dbar];
xbar = xubar(1:3)
ubar = xubar(4)

A*xbar + B*ubar + Bd*dbar % doit valoir 0!
C*xbar + D*ubar + Dd*dbar % doit valoir ybar!

eig(A) % 2 vp à pr>0 -> instable!, ce que confirme les simulations

%% contrôleur avec x et d connus
rank([B A*B A*(A*B)]) % test commandabilité
vpc = roots([1          98        4798      117360]) % valeurs propres désirées pour le contrôleur (choix 1)
vpc = roots([1         988      487693   120411908]) % valeurs propres désirées pour le contrôleur (choix 2)
K = place(A,B,vpc)

k = -1/(C*inv(A-B*K)*B)
kd = C*inv(A-B*K)*Bd/(C*inv(A-B*K)*B)

%% observateur
xaestbar = [0; 0; 0; 0]; % conditions initiales observateur pour planches Simulink
Aa = [A Bd; 0 0 0 0]; % système augmenté par modèle des perturbations
Ba = [B; 0];
Ca = [C 0];

rank([Ca; Ca*Aa; (Ca*Aa)*Aa; ((Ca*Aa)*Aa)*Aa]) % test observabilité
vpo = roots([1    20   123   317   309]) % valeurs propres désirées pour l'observateur
La = transpose(place(Aa',Ca',vpo));
eig(Aa-La*Ca)


%% observateur-contrôleur complet
Ka = [K kd];
Aobscon = Aa-La*Ca-Ba*Ka;
Bobscon = [Ba*k La];
Cobscon = -Ka;
Dobscon = [k 0];
obscon = ss(Aobscon,Bobscon,Cobscon,Dobscon,'InputName',{'yr','y'},'OutputName','u');

loopoc = -obscon(1,2); % transfert de boucle de l'observateur-contrôleur (y->u)
zpk(loopoc) % on voit que c'est un compensateur à effet intégral!

%% système bouclé
sys = ss(A,[B Bd],[C; C],0); % système en boucle ouverte (la sortie est dupliquée pour utiliser lft)
set(sys,'InputName',{'u','d'},'OutputName',{'ym','y'});
sysbf = lft(obscon,sys,1,1); % système en boucle fermée
figure(1), step(sysbf,50) % réponse temporelle du système bouclé

zpk(sysbf) % le transfert en poursuite ne dépend que du contrôleur, celui en rejet que de l'observateur
minreal(zpk(sysbf),1e0) % pour simplifier approximativement numérateur/dénominateur

%% analyse robustesse
loop = ss(Aa,La,Ca,0); % transfert de boucle de l'observateur seul
H = sys(1,1)*loopoc; % transfert de boucle du système compensé (pour lire les marges)
figure(2), bode(loop,H,{1e-1,1e2}) % lecture des marges
% bonne robustesse pour l'observateur seul, d'où robustesse du
% transfert compensé par effet LTR (LTR correct pour choix 1 de vpc,
% excellent pour choix 2)


%% Filtre sur yr pour diminuer la sollicitation des actionneurs
wn = 2*pi/1
sysf = wn^3*tf(1,[1 wn])*tf(1,[1 1.5*wn wn^2]);

zpk(sysf)
figure(3),step(sysf)

