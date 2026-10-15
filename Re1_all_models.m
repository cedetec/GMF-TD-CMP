%% R effective plot for SIRM and CSIRM (opcionModel=3 or 4)
function [R,Rf,Rd] = Re1_all_models(p,N,x0,rng,xd,Data,acumulada,ventana)
%% Optimized parameters values
nGammas = (size(p,1)-9)/6;
posIni = 4;
nTau = 6;
all_gammas  = p(posIni+nTau:posIni+nTau+nGammas-1);
tau2=p(5);
%% Evaluation of model solution
tg=rng;
if tg(1) > 1
    tg=[tg(1)-1; tg; tg(end)+1];
else
     tg=[tg; tg(end)+1];
end
diaInicio=tg(1);
%% Restar xd al "N"
v_ini = [N-(xd(diaInicio,1)+xd(diaInicio,2));
    Data(diaInicio,1);Data(diaInicio,2)];

vectorInicial = v_ini;
options = odeset('RelTol',1e-4,'AbsTol',1e-8,'InitialStep',10);
sol = ode15s(@(t,y)odefun(t,y,p,N,x0),[tg(1),tg(end)],vectorInicial,options);
y=deval(sol,tg);

a=p(1);
k=p(2);
aC=p(3);
alfa=1-(1-a)./( 1+exp( -k*(y(2,:)-aC) ) );
if acumulada==1
    Idayf = diferenciasDiarias(alfa.*y(2,:)); %Iday fitted
    Iday =  diferenciasDiarias(y(2,:));
else
    Idayf=alfa.*y(2,:);
    Iday=y(2,:);
end
tg=rng;
if tg(1) > 1
    %% Segundo orden centrada
    Index=2:length(Iday)-1;
    Ipf = ( Idayf(Index+1) - Idayf(Index-1) )/2;
    Ip  = ( Iday(Index+1) - Iday(Index-1) )/2;
else
    % Index=1:length(Iday)-1;
    % Ipf = Idayf(Index+1) - Idayf(Index);
    % Ip = Iday(Index+1) - Iday(Index);
    Index=2:length(Iday)-1;
    Ipf = ( Idayf(Index+1) - Idayf(Index-1) )/2;
    Ip  = ( Iday(Index+1) - Iday(Index)-1 )/2;
    Ipf =  [Idayf(2) - Idayf(1), Ipf];
    Ip =  [Iday(2) - Iday(1), Ip];
end
%Ipf=alfa(Index).*Ip;
tr = linspace(min(rng),max(rng),numel(all_gammas));
gamma  = interp1(tr,all_gammas,rng,'pchip');

if tg(1) > 1
    Iday=Iday(2:end-1);
    Idayf=Idayf(2:end-1);
else
    Iday=Iday(1:end-1);
    Idayf=Idayf(1:end-1);
end

R  = 1 + Ip'./( gamma.*Iday' );
Rf = 1 + Ipf'./( gamma.*Idayf' );

R=movmean(R,ventana);

Rf=movmean(Rf,ventana);
%% Calculo de "Red" (R efectivo en base a los datos)
%I=Data(:,1);
if tg(1) > 1
    tg=[tg(1)-1; tg; tg(end)+1];
    I=Data(tg,1);
    Index=(2:length(I)-1)';
    Ip = ( I(Index+1) - I(Index-1) )/2;
    I=I(2:end-1);
else
     tg=[tg; tg(end)+1];
     I=xd(tg,1);
    % Index=1:length(I)-1;
    % Ip = I(Index+1) - I(Index);
    % I=I(1:end-1);
    % tg=[tg, tg(end)+1];
    % I=xd(tg,1);
    Index=(2:length(I)-1)';
    Ip = ( I(Index+1) - I(Index-1) )/2;
    Ip = [ I(2)-I(1); Ip];
    I=I(1:end-1);
end
Rd = 1 + Ip./( I/round(tau2) );
Rd=movmean(Rd,ventana);