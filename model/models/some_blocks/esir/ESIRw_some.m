%% cï¿½lculo de la funciï¿½n error para el modelo SIR con retardo
function E = ESIRw_some(p,tc,xd,x0,N,pint)
global nTau cont
%global traza
global nGammas
global pMatrix
%% funciï¿½n de error para modelo SIR con retardo
% % Para beta lineal por tramos
%V = otras;
%tau1=p(2);
%tau2=p(3);
taus = p(4:4+nTau-1)'; %de posicion donde se encuentran los taus
%% Desnormalización para evaluar los taus reales
taus(1)=13*taus(1)+1;
taus(2)=20*taus(2)+1;
%taus(3)=119*taus(3)+1;
taus(3)=19*taus(3)+1;
taus(4)=239*taus(4)+1;
taus(5)=42*taus(5)+14;
taus(6)=21*taus(6)+21;
%% Variante vacunacion 16-01-2022
sol = dde23('sir_ret_fun_vac_some',taus,'sir_ret_hist',[tc(1),tc(end)],[],p,N,x0);
y = deval(sol,tc);
alfa=sigmoide(p,y(2,:),nTau);
taus = pint(4:4+nTau-1)'; %de posicion donde se encuentran los taus
%% Desnormalización para evaluar los taus reales
taus(1)=13*taus(1)+1;
taus(2)=20*taus(2)+1;
%taus(3)=119*taus(3)+1;
taus(3)=19*taus(3)+1;
taus(4)=239*taus(4)+1;
taus(5)=42*taus(5)+14;
taus(6)=21*taus(6)+21;
sol = dde23('sir_ret_fun_vac_some',taus,'sir_ret_hist',[tc(1),tc(end)],[],pint,N,x0);
yint = deval(sol,tc);
alfaint=sigmoide(pint,yint(2,:),nTau);
E= [ ( alfa.*y(2,:)-xd(:,1)' )./( alfaint.*yint(2,:) )   ( y(4,:)-xd(:,3)' )./yint(4,:) ];