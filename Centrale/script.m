clear, clc

%% mod�le (simulation et commande, car lin�aire)
A = [1 2 0; 3 1 -2; 4 -2 1];
B = [1; -1; 1];
Bd = [0; 1; 0];
C = [7 8 1];
D = 0;
Dd = 0;

%% point d'�quilibre initial  pour Simulink
dbar = 0;
ybar = -2;
xubar = inv([A B; C D])*[-Bd*dbar; ybar-Dd*dbar];
xbar = xubar(1:3)
ubar = xubar(4)

A*xbar + B*ubar + Bd*dbar % doit valoir 0!
C*xbar + D*ubar + Dd*dbar % doit valoir ybar!

eig(A) % 2 vp � pr>0 -> instable!, ce que confirme les simulations

%% contr�leur avec x et d connus
rank([B A*B A*(A*B)]) % test commandabilit�
vpc = [-2 -2+2i -2-2i]; % vp d�sir�es pour A-B*K
K = place(A,B,vpc)

k = -1/(C*inv(A-B*K)*B)
kd = C*inv(A-B*K)*Bd/(C*inv(A-B*K)*B)

%% observateur
xaestbar = [0; 0; 0; 0]; % conditions initiales observateur pour planches Simulink
Aa = [A Bd; 0 0 0 0]; % syst�me augment� par mod�le des perturbations
Ba = [B; 0];
Ca = [C 0];

rank([Ca; Ca*Aa; (Ca*Aa)*Aa; ((Ca*Aa)*Aa)*Aa]) % test observabilit�
vpo = [vpc/3 -1/3]; % vp d�sir�es pour Aa-La*Ca
La = transpose(place(Aa',Ca',vpo));
eig(Aa-La*Ca)


%% observateur-contr�leur complet
Ka = [K kd];
Aobscon = Aa-La*Ca-Ba*Ka;
Bobscon = [Ba*k La];
Cobscon = -Ka;
Dobscon = [k 0];
obscon = ss(Aobscon,Bobscon,Cobscon,Dobscon,'InputName',{'yr','y'},'OutputName','u');

loopoc = -obscon(1,2); % transfert de boucle de l'observateur-contr�leur (y->u)
zpk(loopoc) % on voit que c'est un compensateur � effet int�gral!

%% syst�me boucl�
sys = ss(A,[B Bd],[C; C],0); % syst�me en boucle ouverte (la sortie est dupliqu�e pour utiliser lft)
set(sys,'InputName',{'u','d'},'OutputName',{'ym','y'});
sysbf = lft(obscon,sys,1,1); % syst�me en boucle ferm�e
figure(1), step(sysbf,50) % r�ponse temporelle du syst�me boucl�

zpk(sysbf) % le transfert en poursuite ne d�pend que du contr�leur.
minreal(zpk(sysbf)) % pour simplifier num�rateur/d�nominateur


%% analyse robustesse
loop = ss(Aa,La,Ca,0); % transfert de boucle de l'observateur seul
H = sys(1,1)*loopoc; % transfert de boucle du syst�me compens� (pour lire les marges)
figure(2), bode(loop,H,{1e-2,1e1}) % lecture des marges, robustesse d�sastreuse...

