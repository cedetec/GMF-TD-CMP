%% Lado derecho del modelo SIR con dos retardos tau1 y tau2
function v = sir_ret_fun_vac_some(t,y,Z,p,N,~)
global time_range 
global nBetas
global nGammas
global all_betas
global all_gammasU
global all_gammasR
global nTau
%Z
ylag1 = Z(:,1);
ylag2 = Z(:,2);
ylag3 = Z(:,3);
ylag4 = Z(:,4);
ylag5 = Z(:,5);
%% Version 16-01-2022
%all_betas = p(end-nBetas+1:end);
%all_gammasU = p(end-nGammas-nBetas+1:end-nBetas);
%% Nueva variante con gamma de UCI a R
ylag6 = Z(:,6);
all_betas   = p(end-nGammas-nBetas+1:end-nGammas);
all_gammasU = p(end-2*nGammas-nBetas+1:end-nBetas-nGammas);
all_gammasR = p(end-nGammas+1:end);
%% Para la RM y de Ñuble
% % beta1=p(1);
% % beta2=p(2);
% % beta3=p(3);
gamma=p(1);
alfaS=p(2);
deltaS=p(3);
% %% Nueva variante incluyendo f(t) en la ec. de los UCI
% tau5=p(8);
% a=p(3+nTau+1);
% k=p(3+nTau+2);
% aC=p(3+nTau+3);
% tr = linspace(min(time_range),max(time_range),numel(all_betas)) ;
% beta = piecewise_interpolator(t,all_betas,tr) ;
% gammasUCI = piecewise_interpolator(t,all_gammasU,tr) ;
%gammasUCI =  p(end-nBetas);
%%
tr = linspace(min(time_range),max(time_range),numel(all_betas)) ;
%beta = piecewise_interpolator(t,all_betas,tr) ;
if t<=time_range(end)
    beta = interp1(tr,all_betas,t);
else
    beta = interp1(tr,all_betas,time_range(end));
end
tr2 = linspace(min(time_range),max(time_range),numel(all_gammasU)) ;
%gammasUCI = piecewise_interpolator(t,all_gammasU,tr2);
if t<=time_range(end)
   gammasUCI = interp1(tr2,all_gammasU,t);
else
   gammasUCI = interp1(tr2,all_gammasU,time_range(end));
end
%% Nueva variante con gamma de UCI a R
tr3 = linspace(min(time_range),max(time_range),numel(all_gammasR)) ;
if t<=time_range(end)
   gammasR   = interp1(tr3,all_gammasR,t);
else
   gammasR   = interp1(tr3,all_gammasR,time_range(end));
end
%fr=sigmoide(p,y(2,:),nTau);
%frd=interp1(time_range,fr,t-tau5,'pchip','extrap');
%%
%% Por ahora el cambio de escenario es al ojo
%% Aqui definir una estrategia de carga rapida de datos y parametros de simulación
%beta = beta1.*(t<=44)+beta2.*( (t>44) & (t<=72) )+beta3.*( t>72 );


%v = zeros(3,1);
v = zeros(4,1);
% v(1) = - beta*y(1)*ylag1(2)/N - alfaS*ylag3(1) + deltaS*ylag4(1);
% v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2);
% v(3) = gamma*ylag2(2)+alfaS*ylag3(1)-deltaS*ylag4(1);
% v(4) = gammasUCI*ylag2(2);

%% NUEVO
v(1) = - beta*y(1)*ylag1(2)/N - alfaS*ylag3(1) + deltaS*ylag4(1);
v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2) - gammasUCI*ylag5(2);%*( 1 + (a-1)/( 1+exp( -k*(ylag5(2)-aC) ) ) );
%v(2) = beta*y(1)*ylag1(2)/N - gamma*ylag2(2);
v(3) = gamma*ylag2(2)+alfaS*ylag3(1)-deltaS*ylag4(1)+gammasR*ylag6(4);
v(4) = gammasUCI*ylag5(2)-gammasR*ylag6(4);
% gammasUCI;
% v
% beta
% gamma
% alfaS
% deltaS
