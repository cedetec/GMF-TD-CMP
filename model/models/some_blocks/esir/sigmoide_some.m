%function H=sigmoide(p,x)
function H=sigmoide_some(p,x,nTau)
%% Heaviside suavizada
% H=0.5*( 1-sin(pi*t/ep)-t/ep ).*( (t>=-ep) & (t<=ep) )...
%     +a.*(t > ep);
%% Otra variante con tangente hiperbólica
%H=0.5*a*(1-tanh(2*(t-ep)));
%H=1-(1-a)./( 1+exp( -k*(t-aC) ) );
%% Logística general
%K=1-a;
%H=1-K*I0./( I0^b+(K^b-I0^b)*exp( -r*(t-t(1)) ) ).^(1/b);
%% Heaviside con transición polinomial cúbico
% t1=t(i); t2=2*t(i);
% %t1=Ic; t2=2*Ic;
% p=1+(a-1)*(t-t1).^2/(t2-t1)^2+2*(1-a)*(t-t1).^2.*(t-t2)/(t2-t1)^3;
% H=1.0.*(t<t1)+p.*( (t>=t1) & (t<=t2) )+a.*(t > t2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Alfa calculado (sugerido por Cabrera-Vives) para RM y RÑ
%disp('p=[gamma;all_taus;a;k;aC;all_betas]:');
% a=p(7);
% k=p(8);
% aC=p(9);
% a=p(4);
% k=p(5);
% aC=p(6);
a=p(3+nTau+1);
k=p(3+nTau+2);
aC=p(3+nTau+3);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ** Modificación considerando 2 cuarentenas en la RA **
% a=p(8);
% k=p(9);
% aC=p(end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H=1-(1-a)./( 1+exp( -k*(x-aC) ) );
%H=1-(1-p(3+nTau+1))./( 1+exp( -p(3+nTau+2)*(x-p(3+nTau+3)) ) );


%end