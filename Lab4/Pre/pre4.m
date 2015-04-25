Load('')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simula��o controlador PID: r-seno saturado, 1000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, sa�da e esfor�o de controle
yru1000sin=figure;
plot(t,ysimpidloco,t,rsimpidloco,t,usimpidloco)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Sa�da','Entrada','Esfor�o Contr.')
title('Simula��o de controlador PID anal�gico')
saveas(yru1000sin,'yru1000sin.eps','epsc')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simula��o controlador PID: r-seno saturado, 100
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, sa�da e esfor�o de controle
yru100sin=figure;
plot(t100,ysimpidloco100,t100,rsimpidloco100,t100,usimpidloco100)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Sa�da','Entrada','Esfor�o Contr.')
title('Simula��o de controlador PID anal�gico')
saveas(yru100sin,'yru100sin.eps','epsc')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simula��o controlador PID: r-step, 1000
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot de entrada, sa�da
yr1000step=figure;
plot(t,ysimpidlocostep,t,rsimpidlocostep)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Sa�da','Entrada')
title('Simula��o de controlador PID anal�gico')
saveas(yr1000step,'yr1000step.eps','epsc')
% plot de entrada, esfor�o de controle
ru1000step=figure;
plot(tstep,usimpidlocostep,tstep,rsimpidlocostep)
xlabel('Tempo(s)')
ylabel('Amplitude(V)')
legend('Esfor�o Contr.','Entrada')
title('Simula��o do esfor�o de controle do controlador PID anal�gico')
saveas(ru1000step,'ru1000step.eps','epsc')

