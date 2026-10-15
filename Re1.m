%% R effective computation for GEM (model 2023, opcionModel=1)
function [R,Rf,Rd] = Re1(p,N,x0,rng,nTau,nGammas,xd,Data,acumulada,ventana)
%% Optimized parameters values
tau1=p(4);
tau2=p(5);
tau3=p(6);
tau4=p(7);
tau5=p(8);
tau6=p(9);
all_taus = [tau1,tau2,tau3,tau4,tau5,tau6]';
%% Vectors of Optimized params values
posIni = 4;
all_gammas  = p(posIni+nTau:posIni+nTau+nGammas-1);
all_gammasU  = p(posIni+nTau+nGammas*3:posIni+nTau+nGammas*4-1);
%% Evaluation of time delay for passing of infected to icu
tg=rng;
if tau5<round(tau5)
    I5=find(tg>tau5+1);
else
    I5=find(tg>tau5);
end
tg=[tg(I5(1))-1; tg(I5); tg(I5(end))+1];
diaInicio=tg(1);%% Restar xd al "N"
v_ini = [N-(xd(diaInicio,1)+xd(diaInicio,2)+xd(diaInicio,3));
    Data(diaInicio,1);Data(diaInicio,2);Data(diaInicio,3)];
vectorInicial = v_ini;
options = ddeset('RelTol',1e-4,'AbsTol',1e-8,...
                 'InitialY',vectorInicial,'InitialStep',10);
sol = dde23(@sir_ret_fun_vac_all,all_taus,@sir_ret_hist,[tg(1),tg(end)],options,p,N,x0);
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
%% Segundo orden centrada
Index=2:length(Iday)-1; % (es la mejor aprox.)
Ipf= ( Idayf(Index+1) - Idayf(Index-1) )/2;
%Ipf= alfa(Index).*( Iday(Index+1) - Iday(Index-1) )/2;

Ip = ( Iday(Index+1) - Iday(Index-1) )/2;

tg=rng(I5);
tr = linspace(min(tg),max(tg),numel(all_gammas));
gamma  = interp1(tr,all_gammas,tg,'pchip');

tr2 = linspace(min(tg),max(tg),numel(all_gammasU));
gammasUCI = interp1(tr2,all_gammasU,tg,'pchip');

tu=tg-round(tau5);
diaInicio=tu(1);
v_ini = [N-(xd(diaInicio,1)+xd(diaInicio,2)+xd(diaInicio,3));
    Data(diaInicio,1);Data(diaInicio,2);Data(diaInicio,3)];
vectorInicial = v_ini;
options = ddeset('RelTol',1e-4,'AbsTol',1e-8,...
                 'InitialY',vectorInicial,'InitialStep',10);
sol = dde23(@sir_ret_fun_vac_all,all_taus,@sir_ret_hist,[tu(1),tu(end)],options,p,N,x0);
yu=deval(sol,tu);
a=p(1);
k=p(2);
aC=p(3);
alfa=1-(1-a)./( 1+exp( -k*(yu(2,:)-aC) ) );
if acumulada==1
    Iuf=diferenciasDiarias(alfa.*yu(2,:)); %Iu fitted (segmented black line)
    Iu=diferenciasDiarias(yu(2,:)); %Iu "actual" (filled red line)
else
    Iuf=alfa.*yu(2,:);
    Iu=yu(2,:);
end

tr=tg-round(tau2);
diaInicio=tr(1);
v_ini = [N-(xd(diaInicio,1)+xd(diaInicio,2)+xd(diaInicio,3));
    Data(diaInicio,1);Data(diaInicio,2);Data(diaInicio,3)];
vectorInicial = v_ini;
options = ddeset('RelTol',1e-4,'AbsTol',1e-8,...
                 'InitialY',vectorInicial,'InitialStep',10);
sol = dde23(@sir_ret_fun_vac_all,all_taus,@sir_ret_hist,[tr(1),tr(end)],options,p,N,x0);
yr=deval(sol,tr);
a=p(1);
k=p(2);
aC=p(3);
alfa=1-(1-a)./( 1+exp( -k*(yr(2,:)-aC) ) );
if acumulada==1
    Irf=diferenciasDiarias(alfa.*yr(2,:));
    Ir=diferenciasDiarias(yr(2,:));
else
    Irf=alfa.*yr(2,:);
    Ir=yr(2,:);
end
R  = Ip'./( gamma.*Ir' + gammasUCI.*Iu' )+1;
Rf= Ipf'./( gamma.*Irf' + gammasUCI.*Iuf' )+1;
R=movmean(R,ventana);
Rf=movmean(Rf,ventana);
%% Calculo de "Red" (R efectivo en base a los datos)
tg=rng;
if tau5<round(tau5)
    I5=find(tg>tau5+1);
else
    I5=find(tg>tau5);
end
tg=[tg(I5(1))-1; tg(I5); tg(I5(end))+1];
I=xd(tg,1);
Index=(2:length(I)-1)';
Ip = ( I(Index+1) - I(Index-1) )/2;
tg=rng(I5);
tr=tg-round(tau2);
Ir=xd(tr,1);
tu=tg-round(tau5);
Iu=xd(tu,1);
Rd = 1 + Ip./( Ir/round(tau2) + Iu/round(tau5) );
Rd=movmean(Rd,ventana);