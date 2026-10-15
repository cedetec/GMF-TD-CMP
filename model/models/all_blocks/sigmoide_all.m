%function H=sigmoide(p,x)
function H=sigmoide_all(p,x,nTau)
%% Heaviside suavizada
% H=0.5*( 1-sin(pi*t/ep)-t/ep ).*( (t>=-ep) & (t<=ep) )...
%     +a.*(t > ep);
%% Otra variante con tangente hiperbólica
%H=0.5*a*(1-tanh(2*(t-ep)));
%H=1-(1-a)./( 1+exp( -k*(t-aC) ) );

%% NUEVO
a=p(1);
k=p(2);
aC=p(3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H=1-(1-a)./( 1+exp( -k*(x-aC) ) );
%H=1-(1-p(3+nTau+1))./( 1+exp( -p(3+nTau+2)*(x-p(3+nTau+3)) ) );


%end