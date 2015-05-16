function [GRAMPAR] = grampar(A,B,T)

n = length(A);
M_INTER = [-A  B*B'; zeros(n) A'];
frob_m = norm(M_INTER*T,'fro');
J_OPT = max( 1 + ceil(log(frob_m)/log(2)) , 0 ); % correction bug PhM
t_opt = T/(2^J_OPT);

F0 = expm(t_opt*A');
m_out = expm(M_INTER*t_opt);
Q0 = F0'*m_out(1:n,n+1:2*n);

Fk = F0;
Qk = Q0;
for k = 0:J_OPT-1
    Qk = Qk+Fk'*Qk*Fk;
    Fk = Fk^2;
end

GRAMPAR = Qk;



