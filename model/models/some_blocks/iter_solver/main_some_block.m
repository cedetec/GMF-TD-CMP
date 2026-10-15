global nTau
%% ** Script para Optimizaci�n por m�nimos cuadrados **
%% Opciones para el solver de optimizaci�n
%maxiters=5;
options = optimset('Algorithm','trust-region-reflective','Display','iter','MaxIter',maxiters,'TolFun',1e-17,'TolX',1e-14,'MaxFunEvals',20000);
%delete(gcp)
%parpool('local')
%options = optimset('Algorithm','levenberg-marquardt','Display','iter-detailed','MaxIter',maxiters,'TolFun',1e-17,'TolX',1e-24,'MaxFunEvals',20000);
%options = optimset('Display','iter','PlotFcns',@optimplotfval);
%% Para Datos de �uble hasta el 02 de sept. se cambia el TolX (norma del paso)
%options = optimset('Algorithm','trust-region-reflective','Display','iter','MaxIter',1000,'TolFun',1e-17,'TolX',2.16e-08,'MaxFunEvals',20000);
%options = optimset('Algorithm','trust-region-reflective','Display','iter','MaxIter',1000,'TolFun',1e-17,'TolX',7.07913e-08,'MaxFunEvals',20000);
%options = optimset('Algorithm','trust-region-reflective','Display','iter','MaxIter',1000,'TolFun',1e-17,'TolX',9.7e-08,'MaxFunEvals',20000);
%% Inicializaci�n de cotas para los par�metros
Lb=zeros(size(p0));
Ub=inf*ones(size(p0));
%Ub=N*ones(size(p0));
%% ** Seg�n informe conjunto China-OMS, tau1 var�a entre 1 y 14 d�as, con un promedio de 5-6 dias
%% mientras que tau2 var�a entre 7 y 56 d�as, con un promedio de 14 d�as
%% Para beta=constante en todas partes
% Lb(3)=1; Ub(3)=14; %tau1
% Lb(4)=7; Ub(4)=56; %tau2
% Lb(5)=0; Ub(5)=1;
% Lb(7)=0; Ub(7)=max(Data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Considerando beta variable hasta el 27 de abril (id�ntico hasta 02 de sept. en �uble)
% Lb(5)=1; Ub(5)=14; %tau1
% Lb(6)=7; Ub(6)=56; %tau2
% Lb(7)=0; Ub(7)=1;
% Lb(9)=0; Ub(9)=max(Data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Considerando beta variable hasta el 16 de junio (se agregan 2 escenarios m�s)
% Lb(7)=1; Ub(7)=14; %tau1
% Lb(8)=7; Ub(8)=56; %tau2
% Lb(9)=0; Ub(9)=1;
% Lb(11)=0; Ub(11)=max(Data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Considerando beta variable hasta el 07 de sept. para la regi�n metrop.
% Lb(8)=1; Ub(8)=14; %tau1
% Lb(9)=7; Ub(9)=56; %tau2
% Lb(10)=0; Ub(10)=1; %a
% Lb(12)=0; Ub(12)=max(Data); %aC
%% Considerando beta variable hasta el 07 de sept. para la regi�n metrop.
%nTau = 5;
%% Nueva variante que considera paso de UCI a R
nTau = 6;
%nBetas = 7;
%p0=[gamma;alfaS;deltaS;all_taus;a;k;aC;all_gammasU;all_betas];
pos_a= 3 + nTau;
Lb(1)=0.0001; Ub(1)=1; 
Lb(2)=0.0001; Ub(2)=1; 
Lb(3)=0.0001; Ub(3)=1;
% % %% No normalizados
% Lb(4)=1; Ub(4)=14; %tau1
% Lb(5)=1; Ub(5)=21; %tau2
%% Debemos encontrar un buen rango pata tau3 (comienzo de la inmunidad desde la vacunación)
%% Lb(6)=1; Ub(6)=120; %tau3
%% Probare un rango de 1-20 días para tau3
% Lb(6)=1; Ub(6)=20; %tau3
% Lb(7)=1; Ub(7)=240; %tau4
% Lb(8)=14; Ub(8)=56; %tau5
% Lb(9)=21; Ub(9)=42; %tau6
%% Normalización
Ub(4)=1; %tau1
Ub(5)=1; %tau2
Ub(6)=1; %tau3
Ub(7)=1; %tau4
Ub(8)=1; %tau5
Ub(9)=1; %tau6 
%%
Lb(pos_a+1)=0; Ub(pos_a+1)=1; %a
Lb(pos_a+3)=0; Ub(pos_a+3)=max(Data(:,1)); %aC
%p=p0;
resnormref=9.7028e-02;
tol=5e-2;
%tol=0.214;
r=0.3;
it=0;
maxit=5;
while (abs(r-resnormref)/r>tol)&&(it<maxit)
    [p,r,~,~,~,~,jac]=lsqnonlin(@(p) ESIR_rel_some(p,tc,Data,x0,N),p0,Lb,Ub,options);
    p0=p;
    it=it+1;
end
format short e
%disp('p=[gamma;alfaS;deltaS;all_taus;a;k;aC;all_gammasU;all_betas;all_gammas_R]:');
%disp(p')
% disp('Valor mínimo del error:');
% disp(r)

figure
graficaSIRr_vac_some