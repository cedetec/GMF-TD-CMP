%% cï¿½lculo de la funciï¿½n error para el modelo SIR con retardo
function E = ESIR_rel(p,tc,xd,x0,N)
global nTau 
%% funciï¿½n de error para modelo SIR con retardo
% % Para beta lineal por tramos
%V = otras;
%tau1=p(2);
%tau2=p(3);
%p0=[a;k;aC;all_taus;all_gammas;all_alfaS;all_deltaS;all_gammasU;all_betas;all_gammasR]
%rangoTaus = 
taus = p(4:4+nTau-1)'; %de posicion donde se encuentran los taus
%% Desnormalización para evaluar los taus reales
% taus(1)=13*taus(1)+1;
% taus(2)=20*taus(2)+1;
% %taus(3)=119*taus(3)+1;
% taus(3)=19*taus(3)+1;
% taus(4)=239*taus(4)+1;
% taus(5)=42*taus(5)+14;
% taus(6)=21*taus(6)+21;
%% Variante vacunacion 16-01-2022
%options = ddeset('Jumps',5);
%%menor tol mayor tiempo - para experimentos inciciales usar error alto
%tic
vectorInicial = [N-xd(1,1);xd(1,1);xd(1,2);xd(1,3)];
%options = ddeset('RelTol',1e-2,'AbsTol',1e-4,...
%                 'InitialY',[N;1;1;1]);
options = ddeset('RelTol',1e-2,'AbsTol',1e-4,...
                 'InitialY',vectorInicial);
sol = dde23('sir_ret_fun_vac_all',taus,'sir_ret_hist',[tc(1),tc(end)],options,p,N,x0);
y = deval(sol,tc);
%y(isnan(y))=1e+6
alfa=sigmoide(p,y(2,:),nTau);
%toc
%alfa

%% Se contara valores menores que cero para guiar la optimización hacia valores positivos
numNegY = find(y(2,:)<0);
numNegA = find(alfa<0);
numRel = 0;
vectorBajoCero = zeros(1,size(y,2));
if ~isempty(numNegY) || ~isempty(numNegA) 
    size(numNegY,1);
    size(numNegA,1);
    numNegY;
    numNegA;
   % plot(y(2,:));
    x = 1:1:size(y,2);
    vectorBajoCero(1,numNegY) = y(2,numNegY);
    
    numRel = vectorBajoCero; %;*sum(y(2,numNegY))
  %  pause
else
    numRel = zeros(1,size(y,2));
end
%percentageRelativo = numNeg/size(xd,1)
%alfa
%% Error relativo al modelo considera
%E= [  ( alfa.*y(2,:)-xd(:,1)' )./( alfa.*y(2,:)) +numRel',  ( y(4,:)-xd(:,3)' )./y(4,:) ];
%E= [  ( alfa.*y(2,:)-xd(:,1)' )./( alfa.*y(2,:))   ( y(4,:)-xd(:,3)' )./y(4,:) ];
E= [  ( alfa.*y(2,:)-xd(:,1)' )./( alfa.*y(2,:))   ( y(4,:)-xd(:,3)' )./y(4,:) ];
%salidaTest = mean(E)

%E= [ sum( ( alfa.*y(2,:)-xd(:,1)' )./( alfa.*y(2,:)))/size(xd,1) sum(( y(4,:)-xd(:,3)' )./y(4,:))/size(xd,1)];
%% %%   5.6863e+05 20 thetas 830 60 0.1 no acumulada - movil

%% Error relativo a los datos
%E= [ ( ( alfa.*y(2,:)-xd(:,1)' )./(xd(:,1)) + abs(numRel)') ( y(4,:)-xd(:,3)' )./xd(:,3) ];
%% Valor mínimo del error:
%%   5.7246e+04 5 tethas
%%   3.8215e+05 10 thetas 830 60 0.1 no acumulada - movil
%%   6.0514e+06 10 thetas 830 60 0.1 no acumulada - original
%E=mean(E);
% if isnan(E)
%     salida = 'aparece NAN'
% end

%E= [ ( alfa.*y(2,:)-xd(:,1)' )/N ( y(4,:)-xd(:,3)' )/N ];
%E= [ ( alfa.*y(2,:)-xd(:,1)' )  ( y(4,:)-xd(:,3)' )];
%E= [ ( alfa.*y(2,:)-xd(:,1)' )./( alfa.*y(2,:))];
%E= [  ( y(4,:)-xd(:,3)' )./y(4,:)];
%E= [  ( y(4,:)-xd(:,3)' )./xd(:,3)];
%y(1,:)