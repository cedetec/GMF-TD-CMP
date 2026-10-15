%% old callTestVacuna
%% Definic�n de datos y par�metros iniciales para el ajuste
%% format short e
%% Los resultados no cambian considerando diferentes "datos mejorados"
% Carpeta Documents/MATLAB
% % % %% Para datos de la regi�n metropolitana
% % % load('datos-metrop-28-09-20.mat');
global nBetas 
global nGammas
global nTau
global time_range 
global all_taus;
global all_betas;
global all_gammasU;
global all_gammasR;
global numThetas;
%global pMatrix;
nBetas=numThetas; % igual numero de thetas y betas


t=1:size(I,1);
%t=2:203; %Para replicar experimentos de 2020

%% Optimizaci�n se realiza con datos desde el 04 de marzo (hab�a 1 casos acumulado) hasta el 07 de sept

tc=diaInicio:diaFin;
%tc=t(1):t(end);
time_range = tc;

%% En caso de trabajar con data de origen
% I=A(:,1); no ajustados
% F=A(:,2); no ajustados
% R=A(:,3); no ajustados

%% En caso de trabajar con datos ajustados
xd=[I R U+F];
%x0=[(1:length(xd))' xd];
%% En caso de trabajar con datos usados en 2020
%xd=[IDM' (RDM+FDM)'];
%xd=I;
% % % %% Funci�n de historia para la resoluci�n del sistema con retardos
%x0=xd(1:56+tc(1),:);
% % % %%x0=xd(1:tc(1),:);
% x0=[tc' xd(tc,:)];
% % % %x0=[N-xd(t(1),1)-xd(t(1),2); xd(t(1),1); xd(t(1),2)];
%x0=xd(tc,:);
% % % %x0=[tc' xd(tc,:)];
%% Los datos son s�lo los infectados activos diarios
Data=xd(tc,:);
%Data=xd(tc,1:2);
x0=[tc' Data];
%figure;
% 
% dataDiaria = [I,R,F];
%plot(xd)
%pause

% % % %==========================================================================
% % % % ----Valores iniciales propuesto para los parametros beta y gamma---
%% Beta de base (funcionan bien para modelo con vac. original)
%% Estos valores funcionan excelente, tomar m�nimo 70 iteraciones (gR)
beta=0.194;
%beta=beta/2;
%beta=beta/3;
beta=0.5*(0.5+1/3)*beta;
%beta=beta/4;



%beta=0.124
%% Beta para variante donde los UCI van directamente en el target
%beta=0.01*beta;
% % % % %%%%%%%%%%%%%%%
gamma=1/28;
% tau1=5;
% tau2=14;
tau1=5;
tau2=14;
tau3=7;
%tau3=10;
tau4=120;
tau5=35;
%% Nueva variante con paso de UCI a R
tau6=32;
maxtau1=0;

maxTaus = [];
%% Normalización
tau1n=(tau1-1)/13;
tau2n=(tau2-1)/20;
tau3n=(tau3-1)/19;
tau4n=(tau4-1)/239;
tau5n=(tau5-14)/42;
tau6n=(tau6-21)/21;
all_taus = [tau1n,tau2n,tau3n,tau4n,tau5n,tau6n]';
beta_qty = numThetas ; %RM % Ojo aqui con el n�mero de betas
%beta_qty = 15 ; 
%nTau = 2;
%nBetas = beta_qty;
all_betas = ones(beta_qty,1)*beta ;
GammasUCI_qty = nGammas;
% all_gammasU = beta*0.001;
%% Estos valores funcionan excelente, tomar m�nimo 70 iteraciones (gR)
all_gammasU = ones(GammasUCI_qty,1)*beta*0.001*10*5 ; %Mismo n�mero de betas en gammas Uci (experimental)
%% Nueva variante con gamma de UCI a R
all_gammasR = 5*0.1*all_gammasU;
%% Gamma para variante donde los UCI van directamente en el target
%all_gammasU = ones(GammasUCI_qty,1)*beta*0.1/2 ;

%all_gammasU = ones(beta_qty,1)*beta ; %Mismo n�mero de betas en gammas Uci (experimental) 
a=0.5;
%all_gammasU = beta*0.001 ; %Mismo n�mero de betas en gammas Uci (experimental) 

%% Este valor es determinante en los resultados del experimento - considerar su estudio en 
%% en el modelo de optimizaci�n y estabilidad
%i=find(tc==(tc(end)-3)/5);
i=find(tc==tc(end));
aC=mean(Data(1:i));
%aC=mean(xd(1:i,1));
k=1e-3;
alfaS=0.00194; % 0.194 funcionan
deltaS=0.011; % 0.194
p0=[gamma;alfaS;deltaS;all_taus;a;k;aC;all_gammasU;all_betas;all_gammasR];
%save('test1.mat','p0')  

%pMatrix = [];
%% Método no iterativo acoplado (original)
%main_new_vacunacion;
%% Método iterativo desacoplado
%main_new_vacunacion_iter

disp('CARGADO... some_blocks_params_model')