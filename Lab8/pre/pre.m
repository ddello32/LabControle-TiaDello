%% parametros
Rs = 1;
R = 11.257828281912960;
J = 0.003301240719075;
b = 1.111740754736986e-04;
L = 1.451645333650799;
K = 0.049948852047480;

s = tf('s');
Gs = (K/J/L)/(s^2 + ((R+Rs)/L + b/J)*s + ((R+Rs)*b+K^2)/J/L);
Gs = minreal(Gs)
%% P 1
%% Calculo de controlador com menor tempo de estabilização
k = 2.75;
projeto1 = feedback(k*Gs, 1); 
esforco = projeto1/Gs;
options = stepDataOptions('StepAmplitude', 100);
out = stepplot(projeto1, esforco, options)
stepinfo(feedback(k*Gs, 1))
damp(projeto1)
%% P 2
k = 0.1;
projeto2 = feedback(k*Gs, 1); 
esforco = projeto2/Gs;
options = stepDataOptions('StepAmplitude', 100);
out = stepplot(projeto2, esforco, options)
stepinfo(projeto2)
damp(projeto2)

%% I 1
k = 0.003
projeto3 = feedback(k/s*Gs, 1); 
esforco = projeto3/Gs;
options = stepDataOptions('StepAmplitude', 100);
out = stepplot(projeto3, esforco, options)
stepinfo(projeto3)
damp(projeto3)

%% PI 1
ki = 1;
kp = 7.7;
k = 0.012301;
projeto4 = feedback(k*(kp*s+ki)/s*Gs, 1); 
esforco = projeto4/Gs;
options = stepDataOptions('StepAmplitude', 100);
out = stepplot(projeto4, esforco, options)
stepinfo(projeto4)
damp(projeto4)