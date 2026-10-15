close all
%% Time_0 of the data proccessing
time_config_data_tic=tic

%% Paths of directories
addpath (genpath('calls/')) % on case of add new code
addpath (genpath('model/')) % baseline models and new models (some experiments)
addpath (genpath('dataCL/')) % input and proccessing covid-19
addpath (genpath('exps/')) % for save logs experiments
addpath (genpath('analytics/')) % main call analytics research paper
addpath (genpath('config/')) % examples for multiple config 
addpath (genpath('img_trace/')) %directory save images fit at iterations times
addpath (genpath('fig_review/')) % images for this paper research

%% Experiments 2024
addpath (genpath('synthetics/')) % epidemiological surf and applied autoencoders

%global  grafica_data nCiclos ventana_general %maxiters option_model grafica_ajustes primero
%global  globalPais globalUCImovil  cont  grafica_data nCiclos
%global h Mv 
global funEvals contF traza nGammas numThetas interpolacion 
nGammas=numThetas;
contF=1
funEvals = 40000; % max evals on the optimizer
%global_time_op=tic;
%option_model = 2
%grafica_data = 0; % 1 = graphics of data_config, 0 =  default
grafica_ajustes = 0; % 1 = graphics of smooth, 0 =  default

% smooth curve - phase 1 
interpolacion = 1; % for interpolation origin curve (0 original data with many abrupt changes), deafult = 1
% interpolacion = 1 <- It is interpolated and then the SIER test model is applied to a small subset of points, this is in the experimental phase. 
% for short experiment percentPrunning < 1
percentPrunning = 1 %  this is in the experimental phase, next version ->  1  > values > 0 is percentage of data 

% Optimizer trace 0 is default
traza = 0;
primero = 0; % first experiment = 0

% example 2 - maxiters on cicle lsqnonline
maxiters = 5;

% maxiters = 1 on cicle lsqnonline for map p, residual, resnorm, jabobian, mLabda of lsqnonline
%maxiters = 5;

% realizar primera aproximación factible, luego al usal el optimizadro no lineal aumentar su valor para conseguir mejor precisión
%nCiclos =1% veces que se reduce beta a la mitad
primera_ola=0
% %data_config

I00=diaInicio;
I10=diaFinEstudio;
nF=0;
diaFin=diaFinEstudio-nF;
%ventana_general=14;

%% data_times_processing: analitics and processing of the data covid oficial and not covid oficial repositories
format shortg
variante_sier = 1; % para uso de funciones combinadas (diaria infectado % acum(R,U+F) )
grafica_data=0
matrix_optimus=[];
matrix_optimus_poblacion=[];
matrix_optimus_scores=[];

%% llenado de datos sinteticos segun posición entre 1 (baja poblacion) y 972 (alta poblacion)
%% referente de datos - toda la data nacional e intepolación por spline en 973 curvas epidemiologicas
if use_synt == 1
    %%TEST DE INTERVENIR PROGRAMACIÓN PARA CARGA DE DATO SINTETICO
    load('superficie_datos_covid.mat')
    [f,c] = size(xds_surf);
    c0 = c/4;

    i_synt = xds_surf(:,data_selection);
    r_synt = xds_surf(:,data_selection+c0*1);
    f_synt = xds_surf(:,data_selection+c0*2);
    u_synt = xds_surf(:,data_selection+c0*3);

    ventana = ventana_general;
    [i_synt] = mediamovil(i_synt,ventana);
    [r_synt] = mediamovil(r_synt,ventana);
    [f_synt] = mediamovil(f_synt,ventana);
    [u_synt] = mediamovil(u_synt,ventana);

    s_synt = N - i_synt - r_synt -(u_synt+f_synt);
    datos_exp = [i_synt r_synt u_synt+f_synt s_synt (i_synt+r_synt+f_synt) (i_synt+r_synt+f_synt+u_synt)];
    xd = datos_exp;

elseif  use_synt == 2
    %% call main of data proccessing
    data_times_processing
    xds=xd;
    tc=I00:I10;
    for ip=0:100
        aux=[xd(1,:); abs(diff(xd))];
        %flag
        % aux=aux(tc,:);
        M=cov(aux);
        [MM,flag]=chol(M);
        if flag==0
            MM=MM/pow2(ip);
            aux=aux+randn(size(aux))*MM;
            ineg=find(aux<0);
            aux(ineg)=-aux(ineg);
            ND=cumsum(aux);
            %xds(tc,:)=round(ND);
            xds=round(ND);
        else
            R = qr(M)/pow2(ip);
            aux=aux+randn(size(aux))*R;
            ineg=find(aux<0);
            aux(ineg)=-aux(ineg);
            ND=cumsum(aux);
            %xds(tc,:)=round(ND);
            xds=round(ND);
            %% Poisson dist.
            % xds( 2:length(xd), [1;2;4] )  = round( poissrnd( xd( 2:length(xd), [1;2;4])-xd( 1:length(xd)-1, [1;2;4] ) )/pow2(ip) );
            %  xds( 2:length(xd), [1;2;4] ) = cumsum( xds( 2:length(xd), [1;2;4] ) );
            %
            % xds( 2:length(xd), : )  = poissrnd( abs( xd( 2:length(xd), : )-xd( 1:length(xd)-1, : )  ) / pow2(ip)  ) ;
            % xds = cumsum( xds );
            % xds( tc(2):tc(end), : )  = poissrnd( abs( xd(  tc(2):tc(end), : )-xd(  tc(1):tc(end)-1, : )  ) / pow2(ip)  ) ;
            % xds(tc,:) = cumsum( xds(tc,:) );
            %% Negative binomial dist.
            %xds( 2:length(xd), : ) = round( nbinrnd( round( xd( 2:length(xd),: )/7 ), 1/8 )/pow2(ip) );
            % rd=xd( 2:length(xd),: ); pp=0.5;
            % xds( 2:length(xd), : ) = round( nbinrnd( rd, pp )/pow2(ip) );
        end

        Ids = xds(:,1);
        Rds = xds(:,2);
        Uds = xds(:,3);
        Fds = Uds - Us;

        %% 22/09/26: Smoothing averaging
        % [Ids] = mediamovil(Ids,ventana);
        % [Rds] = mediamovil(Rds,ventana);
        % [Uds] = mediamovil(Uds,ventana);
        % Fds = Uds - Us;

        if opcionModel==1
            Sds = N - Ids - Rds - Uds;
            xds = [Ids Rds Uds Sds (Ids+Rds+Fds) (Ids+Rds+Uds)];
        else
            Sds = N - Ids - Rds - Fds;
            %xds = [Ids Rds+Fds Sds (Ids+Rds+Fds)];
             xds = [Ids (Rds+Fds) Uds Sds (Ids+Rds+Fds) (Ids+Rds+Uds)];    
        end
        %% data_xd_GEM_test3 lo obtuve con "7 > norm( ( xd-xds)./xd , inf )"
        %% data_xd_GEM lo obtuve con "6 > norm( ( xd-xds)./xd , inf )"
        if  4 >= norm( ( xd-xds)./xd , inf )
            disp(['Error relativo maximo en datos sinteticos... ',num2str( norm( ( xd-xds)./xd , inf ) ) ])
            break
        end
    end
    xdor = xd;
    xd = xds;
    %% Save synthetic data for using in "predict" script
    ds = xds(:);
end
%% Time_1 of the data proccessing
if use_synt == 3
    data_times_processing
    load('Orig_data.mat');
end
time_config_data_toc=toc(time_config_data_tic);

intervalo = I00:I10;
xd_studio = xd(intervalo,:);
xd_studio_diff = [diferenciasDiarias(xd_studio(:,1)')',...
    diferenciasDiarias(xd_studio(:,2)')',...
    diferenciasDiarias(xd_studio(:,3)')'];

coef_var_I = std2(xd_studio_diff(:,1))/mean(xd_studio_diff(:,1));
coef_var_R = std2(xd_studio_diff(:,2))/mean(xd_studio_diff(:,2));
coef_var_U = std2(xd_studio_diff(:,3))/mean(xd_studio_diff(:,3));
coef_var = [coef_var_I,coef_var_R,coef_var_U];
mean_coef_var = mean(coef_var);

maxThetas = 20;
minThetas = 5;

%% For trace
% figure
% plot(data_pais)
% figure
% plot(data_region)
% figure
% plot(xd)

diaInicio = I00
diaFinEstudio = I10;
nF=0;
% nF=84; %For case prediction use nf = time predicction before end day study
diaFin=diaFinEstudio-nF;


params_ini = [];
cota_error = 10000;
option_model = opcionModel 
traza =0;
format shortg

%% Observacion para tesistas: el tiempo de infección promedio si se establece en por ejemplo 0.07, dara aprox 14 dias como masivamente se cree
% pero en el contexto matemática tenemos a 1/gamma y por otro lado a los
% taus que buscan el periodo de tiempo, se producen multiples minimos
% locales debido a que ambas variables buscan de manera implicita el tiempo
% (a traves de la tasa gamma) y de manera explicita misma caracteristica (a traves de tau)

%% Observation for thesis students: the average infection time, if set to, for example, 0.07, will give approximately 14 days, as is widely believed
%, but in the mathematical context, we have 1/gamma, and on the other hand the
% taus looking for the time period, multiple minima occur
% local because both variables implicitly lookup time
% (via gamma rate) and explicitly the same feature (via tau)

%% 04/08/2026: We change line 102 by 103 and add line 104
option_model = opcionModel
option_error = opcionError

a_t = 10e-5;
b_t = 0.9;
 
beta_lb_up_op = [a_t,0.9]; % Average transmission rate
gamma_lb_up_op = [a_t,b_t]; % mean rate of the remotion 
alfaS_lb_up_op = [a_t,b_t];% the smaller, the less variation in the maximum distances of curves.
deltaS_lb_up_op = [a_t,b_t];
all_test_gammasR_lb_up_op = [a_t,b_t];
all_test_gammasU_lb_up_op = [a_t,b_t];
a_test_lb_up_op = [0.01,b_t];

d_t = diaFin - diaInicio;

%% Important 1: here define factor of initial values (critical values on models); 
%% this is experimental for each covid 19 data set
%% Important 2: if after 20 iters and no convergence, modification of one grade of the magnitude of the +- factor_inicial and repeat the experiment

%factor_inicial =0.00025; % Magallanes for cum curve
% factor_inicial =0.001; % Metropolitan for cum curve
%factor_inicial =0.0018; % acceptable Metropolitan for daily curve
%factor_inicial =0.018; % bad results for Metropolitan for daily curve
%factor_inicial =0.018; % bad results for Metropolitan for cum curve
factor_inicial =0.0018; % good results for Metropolitan for daily curve

%beta = max(beta_lb_up_op)*0.1;
if (N > 8e6 && acumulada == 2)
    ini_ites = 5;
else
    ini_ites = 1;
end
if auto_ajuste == 1

for iTest=ini_ites:100
    factor_inicial =1.0000/(pow2(iTest)); % Metropolitan
    beta = max(beta_lb_up_op)*factor_inicial; %rate of the contact/transmition
    gamma = max(gamma_lb_up_op)*factor_inicial;% (1/gamma) mean time infection - mean rate of the remotion
    alfaS=max(alfaS_lb_up_op)*factor_inicial;
    deltaS=max(deltaS_lb_up_op)*factor_inicial;
    all_test_gammasR=max(all_test_gammasR_lb_up_op)*factor_inicial;
    all_test_gammasU=max(all_test_gammasU_lb_up_op)*factor_inicial;
    a_test = max(a_test_lb_up_op);%;
    %% This routine builds the vector of initial values (p0) of the model
    all_blocks_params_model_analytics_hibridas
    p=p0;
    %% Errores usando valores iniciales
    %% 05/08/2026
    if opcionModel==1
        compute_curves
    else
        compute_curves_all_models
    end
    %sum_target = sum(test_data_covid(:,1));
    %sum_model = sum(fr'.*test_data_covid_estimate(:,2))
    conteos_menores_cero
    if sum_target > sum_model && (conteos_menores_cero == 0) %% valores mayores que 0 en vector model...
        break;
    end
    % E
    % Eii
    %iTest
end

else
    beta = max(beta_lb_up_op)*factor_inicial; %rate of the contact/transmition
    gamma = max(gamma_lb_up_op)*factor_inicial;% (1/gamma) mean time infection - mean rate of the remotion
    alfaS=max(alfaS_lb_up_op)*factor_inicial;
    deltaS=max(deltaS_lb_up_op)*factor_inicial;
    all_test_gammasR=max(all_test_gammasR_lb_up_op)*factor_inicial;
    all_test_gammasU=max(all_test_gammasU_lb_up_op)*factor_inicial;
    a_test = max(a_test_lb_up_op);%;
    %% This routine builds the vector of initial values (p0) of the model
    all_blocks_params_model_analytics_hibridas
    p=p0;
end

%% 21/08/2026: To compute metrics relative to initial parameter estimates
tc_t=1:size(x0,1);
if opcionModel==1
    residual0=ESIR_rel_all(p0,tc_t,Data,x0,N,v_ini,opcion_a1,opcionError);
    errores0 = [Ess;Eii;Err;Euu];
    [Re0,Ref0,Red0] = Re1(p0,N,x0,tg,nTau,nGammas,xd,Data,acumulada,ventana_general);
else
    residual0=ESIR_rel_all_models(p0,tc_t,Data,x0,N,v_ini,opcion_a1,opcionModel);
    errores0 = [Ess;Eii;Err];
    if opcionModel==2
        [Re0,Ref0,Red0] = Re1_sin_vac(p0,N,x0,tg,nTau,nGammas,xd,Data,acumulada,ventana_general);
    else
        [Re0,Ref0,Red0] = Re1_all_models(p0,N,x0,tg,xd,Data,acumulada,ventana_general);
    end
end
resnorm0=norm(residual0)^2;
RE_re0=norm( ( Ref0-Red0 )./Ref0, inf);
%% 


%pause
tic
main_all_blocks_1
toc



%% Errores usando valores optimizados

%% 05/08/2026
if opcionModel==1  
    compute_curves
else
    compute_curves_all_models
end

format shortg

%% Optimized parameters values

a_salida = p0(1);
k_salida = p0(2);
aC_salida = p0(3);
tau1_salida = p0(4);
tau2_salida = p0(5);
tau3_salida = p0(6);
tau4_salida = p0(7);
tau5_salida = p0(8);
tau6_salida = p0(9);

taus_results = [tau1_salida;tau2_salida;...
    tau3_salida;tau4_salida;tau5_salida;...
    tau6_salida;];
params_exp = [a_salida;k_salida;aC_salida;];

posIni = 4; 

%% Vectors of Optimized params values
all_gammas_salida  = p(posIni+nTau:posIni+nTau+nGammas-1);
all_alfaS_salida    = p(posIni+nTau+nGammas:posIni+nTau+nGammas*2-1);
all_deltaS_salida   = p(posIni+nTau+nGammas*2:posIni+nTau+nGammas*3-1);
all_gammasU_salida  = p(posIni+nTau+nGammas*3:posIni+nTau+nGammas*4-1);
all_betas_salida    = p(posIni+nTau+nGammas*4:posIni+nTau+nGammas*5-1);
all_gammasR_salida  = p(posIni+nTau+nGammas*5:posIni+nTau+nGammas*6-1);


%% Estimation non-formal of the epidemiological params - the sum of the rates
suma_beta = sum(all_betas_salida);
suma_gamma = sum(all_gammas_salida);
suma_alfaS = sum(all_alfaS_salida);
suma_deltaS = sum(all_deltaS_salida);
suma_gammasU = sum(all_gammasU_salida);
suma_gammasR = sum(all_gammasR_salida);

params_results = [suma_beta;suma_gamma;...
    suma_alfaS;suma_deltaS;suma_gammasU;...
    suma_gammasR;]

%% Basic estimation of Ro (non-formal) (for reference and research)

ro_basico = suma_beta/suma_gamma;
ro_distribucion_bloque = all_betas_salida./all_gammas_salida;
ro_basico_st = (suma_beta/suma_gamma)/nGammas;
results_ro = [ro_basico;ro_basico_st];

%% Study interval
distancia_t = diaFinEstudio - diaInicio; % interval size
meses = distancia_t/30; % months of the study
dim_tramo = meses/nGammas; % block dimension
