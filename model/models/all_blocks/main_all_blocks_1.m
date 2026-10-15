global nTau contF %% mJacobianFull mJacobianDisperse mResidual mLambda
%% In case you need to restart parpool
% delete(gcp('nocreate'))
% parpool("Processes",20)

%% ** Script for Least Squares Optimization **
%% Options for the optimization solver
%% next option for daily curve -> 'TolFun',1e-16
%% next option for cum curve -> 'TolFun',1e-12 ()
oldoptions = optimoptions(@lsqnonlin,'UseParallel',true,'Algorithm','trust-region-reflective','Display','iter','MaxIter',maxiters,'TolFun',1e-12,'TolX',1e-10,'MaxFunEvals',40000,'Diagnostics','on')
options = optimoptions(oldoptions)

%% Upper and lower limits of optimization
Lb=ones(size(p0))*1e-5;
Ub=1*ones(size(p0));

%% ** According to China-WHO joint report, tau1 ranges from 1-14 days, with an average of 5-6 days
%% while tau2 varies between 7 and 56 days, with an average of 14 days
%% New variant that considers the transition from UCI to R
nTau = 6;
pos_a = 1;
pos_k = 2;
pos_aC = 3;
Lb(pos_a)=1e-5; Ub(pos_a)=1; %a
Lb(pos_k)=1e-5; Ub(pos_k)=1; %k
Lb(pos_aC)=1e-5; 
Ub(pos_aC)=max_data_ini;

%% Observacion los tiempos de tau grandes afectan el calculo de derivadas y la estabilidad
%% además en algunos casos se realiza extrapolacion con pcchip y se sale de los rangos,
%% especificamente donde las derivadas tienden a 0 se produce NAN 1/(close at zero) por tanto se debe controlar el 
%% salto en x; ideas futuras: intervenir la funcion sir_ret_fun_vac y cuando se detecte un NAN usar un numero grande que
%% no sobrepase el limite de la computadora y si se detecta hacia el 0 uno pequeño cercano a 0 pero no 0, solo para efectos de seguimiento - No el ajuste final

%% Note that large tau times affect the calculation of derivatives and stability
%% In addition, in some cases extrapolation is carried out with pcchip and it goes out of the ranges,
%% specifically where the derivatives tend to 0 NAN 1/(close at zero) is produced, therefore the
%% jump in x; future ideas: intervene the function sir_ret_fun_vac and when a NAN is detected use a large number that
%% do not exceed the limit of the computer and if a small one close to 0 is detected towards 0 but not 0, only for monitoring purposes - Not the final adjustment

Lb(4)=3; Ub(4)=7; %tau1 -> incubation
Lb(5)=7; Ub(5)=21; %tau2 -> Recovery
Lb(6)=7; Ub(6)=21; %tau3 -> susceptible to recovered (immunity) obs: there is recurrence but slight - fewer ICU cases.
Lb(7)=14; Ub(7)=360; %tau4 -> duration of immunity
Lb(8)=7; Ub(8)=56; %tau5 -> time in ICU admission
Lb(9)=7; Ub(9)=42; %tau6 -> ICU recovery time

% ORIGINALES PAPER 2023
% Lb(4)=3; Ub(4)=7; %tau1 -> incubation
% Lb(5)=7; Ub(5)=21; %tau2 -> Recovery
% Lb(6)=7; Ub(6)=21; %tau3 -> susceptible to recovered (immunity) obs: there is recurrence but slight - fewer ICU cases.
% Lb(7)=14; Ub(7)=240; %tau4 -> duration of immunity
% Lb(8)=7; Ub(8)=56; %tau5 -> time in ICU admission
% Lb(9)=7; Ub(9)=42; %tau6 -> ICU recovery time

%% 05/08/2026
if opcionModel==2
%% For GSIRMTD (opcionModel=2), we fixed tau3-tau6 (they do not modify the model)      
    Lb(6)=7; Ub(6)=7;
    Lb(7)=240; Ub(7)=240;
    Lb(8)=35; Ub(8)=35;
    Lb(9)=32; Ub(9)=32;
end
%% For GSIRM (opcionModel=3), we fixed tau1-tau6 (they do not modify the model)      
if opcionModel>2
    Lb(4)=5; Ub(4)=5; %tau1 -> Incubation
    Lb(5)=14; Ub(5)=14; %tau2 -> Recovery for mild cases
    Lb(6)=7; Ub(6)=7; %tau3 -> susceptible to recovered (immunity) obs: there is recurrence but slight - fewer ICU cases.
    Lb(7)=240; Ub(7)=240; %tau4 -> duration of immunity
    Lb(8)=35; Ub(8)=35; %tau5 -> time in ICU admission
    Lb(9)=32; Ub(9)=32; %tau6 -> ICU recovery time
end

p=p0;
%load("analytics\p_global.mat")

%% Algunos ejemplos de cargar de checkpoint ad-hoc (ultra-fast proccesing)
%% Some examples of loading from ad-hoc checkpoint (ultra-fast processing)
if cargar_checkpoint==1
%load("analytics\p_global.mat")
   if acumulada == 1 || acumulada == 2      
   if numThetas == 10
   load("analytics\p_global_10thetas_acum20.mat")
   end
   if numThetas == 20
   load("analytics\p_global_20thetas_acum20.mat")
        if primera_ola ==1
        load("analytics\p_global_20thetas_acum20_deola1.mat")
        end
       if toda_la_ola ==1
        load("analytics\p_global_30thetas_acum20_completa.mat")
       if strcmp(region,'Antofagasta') 
           load("analytics\p_antofagasta.mat")
       end
       end
   end
   if numThetas == 30   
    if toda_la_ola ==1
        load("analytics\p_global_30thetas_acum20_completa.mat")
    end
    if opcion_a1==1
        load("analytics\p_global_30thetas_acum20_completa_a_igual1.mat")
    end
   end  
   elseif acumulada == 2
   if numThetas == 10
   load("analytics\p_global_10thetas_daily10.mat")
   end
   if numThetas == 20
   load("analytics\p_global_20thetas_daily20.mat")
   end
   if numThetas == 30
   load("analytics\p_global_20thetas_daily30.mat")
   end
   end
end


%% Iterative cycle optimizer parameters
resnormref=1e-2;
tol=5e-2;
r=0.3;
it=1;
maxit=100;
vectorR = [];
cont=0;
contGlobal=0;

% for trace
% if traza == 1
%     disp(p0)
%     pause
% end

tc=diaInicio:diaFin;
nGammas=numThetas;
time_range = tc;

if acumulada ~= 2
Data=xd(tc,:);
x0=[tc' Data];
end

%% 05/08/2026
if opcionModel==1
    v_ini = [N-xd(diaInicio,1)-xd(diaInicio,2)-xd(diaInicio,3);
        Data(1,1);Data(1,2);Data(1,3)];
else
    v_ini = [N-xd(diaInicio,1)-xd(diaInicio,2);
        Data(1,1);Data(1,2)];
end

vectorInicial = v_ini;
tc_t=1:size(x0,1);

% for map p, residual, resnorm, jabobian, mLabda of lsqnonline
mJacobianDisperse = {};
mJacobianFull_left = {};
mJacobianFull_right = {};
mResidual = [];
mResNorm = [];
mLambda = {};
pM = [];
iteraciones=0;
for it=1:maxit
   if abs(r-resnormref)/r<tol
       disp('abs(r-resnormref)/r<tol');
       break;
   end

   if abs(r)<=0.001
      disp('abs(r)<=0.001');
       break;
   end

   if funEvals<=contF
       disp('funEvals<=contF');
       break;
   end
   
   %% Call optimizer lsqnonlin / structure lambda whose fields contain the Lagrange multipliers at the solution x, and the Jacobian of fun at the solution x. 
   %% [p=x,resnorm=r,residual,exitflag,output,lambda,jacobian]

  %% 05/08/2026
  if opcionModel==1
       [p,resnorm,residual,exitflag,output,lambda,jacobian]=lsqnonlin(@(p) ESIR_rel_all(p,tc_t,Data,x0,N,v_ini,opcion_a1,opcionError),p0,Lb,Ub,options);
  else
       [p,resnorm,residual,exitflag,output,~,~]=lsqnonlin(@(p) ESIR_rel_all_models(p,tc_t,Data,x0,N,v_ini,opcion_a1,opcionModel),p0,Lb,Ub,options);
  end
   iteraciones=iteraciones+output.iterations;
   %[p,resnorm,residual,exitflag,output,lambda,jacobian]=lsqnonlin(@(p) ESIR_rel_all(p,tc_t,Data,x0,N,v_ini,opcion_a1,opcionError),p0,Lb,Ub,options);
    %[fil, col] = size(jacobian);
    p0=p;
    r0=resnorm;
    vectorR = [vectorR,resnorm];

    %% 05/08/2026
    % if opcionModel==1
    %     mJacobianFull_left{1,it} = full(jacobian(1:fil/2,:)); % contains on matrix of the gradient of the optimization
    %     mJacobianFull_right{1,it} = full(jacobian(fil/2+1:end,:));
    % else
    %     mJacobianFull_left{1,it} = full(jacobian);
    % end
    % mJacobianDisperse{1,it} = jacobian; % contains on matrix of the gradient of the optimization
    % mLambda{1,it} = lambda;
    mResNorm = [mResNorm,resnorm];
    mResidual = [mResidual;residual];
    pM = [pM,p];
    %pause
    if cont==5
        coefVar = std(vectorR)/mean(vectorR)
        vectorR = vectorR(1,2:5);
        cont=4;
        if coefVar < 0.01 % if coeficient variation (on various cicles) < tol -> stop optimization (example: 1%)
            salida = "Parando..."
            break; 
        end
        
    end
 
    cont=cont+1;
    contGlobal=contGlobal+1
end
format short e
disp('Valor mínimo del error:');
disp(r)



