%% Calculation of the error function for the GSIRTD model with time delays
function E = ESIR_rel_sin_vac(p,tc,xd,x0,N,vectorIni,opcion_a1)
global  contF 
nTau = 6;
taus = p(4:4+nTau-1)';
vectorInicial = vectorIni;
options = ddeset('RelTol',1e-2,'AbsTol',1e-4, 'InitialY',vectorInicial,'InitialStep',100);
sol = dde23(@sir_ret_fun_sin_vac,taus,@sir_ret_hist_sin_vac,[tc(1),tc(end)],options,p,N,x0);
y = deval(sol,tc);
a=p(1);
k=p(2);
aC=p(3);
alfa=1-(1-a)./( 1+exp( -k*(y(2,:)-aC) ) );
if opcion_a1 == 1
    alfa = 1;
end

v_t = alfa.*y(2,:);

E= ( v_t-xd(:,1)' )./(v_t) ; 

contF=contF+1;