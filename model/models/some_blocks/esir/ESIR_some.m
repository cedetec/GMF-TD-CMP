%% cï¿½lculo de la funciï¿½n error para el modelo SIR con retardo
function E = ESIR_some(p,tc,xd,x0,N)
global nTau 
%global traza
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
%pref=zeros(size(p));
%pref(2)=5;
%pref(3)=14;
%% función de error para modelo SIR con retardo
% % Para beta constante por tramos hasta el 27 de abril o 02 de sept.
% tau1=p(5);
% tau2=p(6);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Para beta constante por tramos hasta el 16 de junio
% tau1=p(7);
% tau2=p(8);
%% Para datos de la RM hasta el 07 de sept.
% tau1=p(8);
% tau2=p(9);
% tau1=p(5);
% tau2=p(6);
%sol = dde23('sir_ret_fun',[tau1,tau2],'sir_ret_hist',[tc(1),tc(end)],[],p,N,x0);
%% version 05-11-2021
%sol = dde23('sir_ret_fun',taus,'sir_ret_hist',[tc(1),tc(end)],[],p,N,x0);
%del=taus(1:4);
%% Variante vacunacion 16-01-2022
sol = dde23('sir_ret_fun_vac_some',taus,'sir_ret_hist',[tc(1),tc(end)],[],p,N,x0);
y = deval(sol,tc);
alfa=sigmoide(p,y(2,:),nTau);
E=[ alfa.*y(2,:)-xd(:,1)'  y(4,:)-xd(:,3)'  ];
%E= [ ( alfa.*y(2,:)-xd(:,1)' )./xd(:,1)'  ( y(4,:)-xd(:,3)' )./xd(:,3)'  ];
%E= [ ( alfa.*y(2,:)-xd(:,1)' )./( alfa.*y(2,:) )  ( y(4,:)-xd(:,3)' )./y(4,:) ];
%% ESTO ES RELEVANTE DE DILUSIDAR FUNCIONES UCI
%E= [( alfa.*y(2,:)-xd' )/N   , UciPrediccion(2,:)-UciData' )/N ]; %Opcion
%E= ( alfa.*y(2,:)-xd' )/N ; %Opcion
% 0.1 + 0.01
% 
% 
% [0 1] = (valor - min)/(max-min)
% 
% 0,2 + 0,3 ----> 
%% Variante donde el gammaUCI va directamente en la fc. obj.
%gammasU= p(12:12+nGammas-1)'; %posición donde se encuentran los gammasUCI
%tUCI = linspace(tc(1),tc(end),numel(gammasU)) ;
%gammasUCI = piecewise_interpolator(t,all_gammasU,tr2);
%tau5=taus(5);
%gammasUCI = interp1(tUCI,gammasU,tc);
%%
%E= [ delta2*UciPrediccion(2,:)-UciData' )/N ]; %Opcion 2  %% vectorDelta*[tramo_tiempo]
%traza = [traza,E;]
%i=find(tc==floor((tc(end)-3)/5));
%pref(end)=mean(xd(1:i,1)); %%% Observar su uso
%E= [( alfa.*y(2,:)-xd(:,1)' )/N sqrt(1e-6)*(p-pref)'   ];
%% Aqui estan laks funciones a ajustar...  UCI 
%E= [( alfa.*y(2,:)-xd(:,1)' )/N ];
%E= mse( alfa.*y(2,:)-xd(:,1)' )
%%
%% Para modelo con vac. original
%E= [( alfa.*y(2,:)-xd(:,1)' )/N   ( y(4,:)-xd(:,3)' )/N ];
% %% Variante para gammaUCI dentro de la fc. obj.
% tg=tc+round(tau5);
% Data=xd(tc,1:2);
% E= [( alfa.*y(2,:)-Data(:,1)' )/N   ( gammasUCI.*alfa.*y(2,:)-xd(tg,3)' )/N ];
%%
%E= [ (y(4,:)-xd(:,3)')/N ];
%E= 1*mse( alfa.*y(2,:)-xd(:,1)' ) + 1*mse( y(4,:)-xd(:,3)' );
%E= [( alfa.*y(2,:)-xd(:,1)' )/N sqrt(1e-6)*(p-pref)'] .... falllec. tasas];
 %   E= [ (( alfa.*y(2,:)-xd(:,1)' )./alfa.*y(2,:))/N  + ((y(4,:)-xd(:,3)')./y(4,:))/N ];
  %  E= [ (( alfa.*y(2,:)-xd(:,1)' )./alfa.*y(2,:))/N  ((y(4,:)-xd(:,3)')./y(4,:))/N ];
  %y
      
%       pMatrix =[pMatrix, [cont;p]];
%   [rr2,pp]=corr(y(4,:)',xd(:,3));
%   y_tmp=(alfa.*y(2,:))';
%   [rr1,pp]=corr(y_tmp,xd(:,1));
%   rs = [rr1,rr2];
% 
%     [rr0,pp]=corr(xd(:,3),xd(:,1));

  

%   %c=c(1,2)
%     E= [ ( alfa.*y(2,:)-xd(:,1)' )/N  (y(4,:)-xd(:,3)')/N  ];
%     E= [ (1-rr1) (1-rr2) abs((max(alfa.*y(2,:))-max(xd(:,1)))) abs((min(alfa.*y(2,:))-min(xd(:,1)))) ];
%     E= [ (1-rr1) abs((max(alfa.*y(2,:))-max(xd(:,1)))) abs((min(alfa.*y(2,:))-min(xd(:,1)))) ];
%     E= [ (1-rr1) + abs((max(alfa.*y(2,:))-max(xd(:,1)))) + abs((min(alfa.*y(2,:))-min(xd(:,1)))) ];
%     E= [ (1-rr1) (1-rr2)  ( alfa.*y(2,:)-xd(:,1)' )/N  (y(4,:)-xd(:,3)')/N ];
%     E= [ (1-rr2) (y(4,:)-xd(:,3)')/N ];
%     E= [ (1-rr2) (alfa.*y(2,:)-xd(:,1)' )/N ];
 %   E= [ (1-rr2) (1-rr1) + abs((max(alfa.*y(2,:))-max(xd(:,1)))) + abs((min(alfa.*y(2,:))-min(xd(:,1))))];
 %E= [ (1-rr2) (1-rr1) sum((y(4,:)-xd(:,3)')/N) ];
 %E= [  (y(4,:)-xd(:,3)')./y(4,:) ];
 %E= [ sum( alfa.*y(2,:)-xd(:,1)')/N sum( y(4,:)-xd(:,3)' )/N (1-rr2) ];

 %E =  [sum( alfa.*y(2,:)-xd(:,1)')/N];
 %E= [  (alfa.*y(2,:)-xd(:,1)')/N  (y(4,:)-xd(:,3)' )/N ];
%E= [  (1-rr1)  (y(4,:)-xd(:,3)' )/N ];
 %if mod(cont,100)==0

  %c=c(1,2)
  %  E= [ ( alfa.*y(2,:)-xd(:,1)' )/N  (y(4,:)-xd(:,3)')/N  ];
%     E= [ (1-rr1) (1-rr2) abs((max(alfa.*y(2,:))-max(xd(:,1)))) abs((min(alfa.*y(2,:))-min(xd(:,1)))) ];
%     E= [ (1-rr1) abs((max(alfa.*y(2,:))-max(xd(:,1)))) abs((min(alfa.*y(2,:))-min(xd(:,1)))) ];
%     E= [ (1-rr1) + abs((max(alfa.*y(2,:))-max(xd(:,1)))) + abs((min(alfa.*y(2,:))-min(xd(:,1)))) ];
%     E= [ (1-rr1) (1-rr2)  ( alfa.*y(2,:)-xd(:,1)' )/N  (y(4,:)-xd(:,3)')/N ];
%     E= [ (1-rr2) (y(4,:)-xd(:,3)')/N ];
%     E= [ (1-rr1)  (alfa.*y(2,:)-xd(:,1)' )/N ];
%     %e0 = sum(E)
%     %E= [ (1-rr2) (1-rr1) + abs((max(alfa.*y(2,:))-max(xd(:,1)))) + abs((min(alfa.*y(2,:))-min(xd(:,1))))];
%  if mod(cont,20)==0
%      
%      %%disp('p=[gamma;alfaS;deltaS;all_taus;a;k;aC;all_gammasU;all_betas;all_gammas_R]:');
% 
%     rs
%     rr0
%     cont
%     %E
% 
% 
%     
%    % 
%     
%     save('./test2.mat','pMatrix') 
%     
% 
% end
% %AG ->  
% %%Modela 50 % ---> resto predicción y evalua.... 
% 
% 
% cont=cont+1;
