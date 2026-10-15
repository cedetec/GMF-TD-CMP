

% tabla_errores = table(Region)
% Region{i,1} = region;
% erroresTags = cell(4,1);
format shortE
%% 05/08/2026
if opcionModel==1
    erroresTags = {'Susceptible*';'Infected';'Recovered';'ICU Internships'};
    errores = [Ess;Eii;Err;Euu];
else
    erroresTags = {'Susceptible*';'Infected';'Retired'};
    errores = [Ess;Eii;Err];
end
tabla_errores = table(erroresTags,errores)
% taus_results % TAUS
tausTags = {'Tau1';'Tau2';'Tau3';'Tau4';'Tau5';'Tau6'};
tabla_taus = table(tausTags,params_taus_ini,taus_results)
% params_exp % a,k,aC
params_Tags = {'a';'k';'aC'};
tabla_params_exp= table(params_Tags,params_exp_ini,params_exp)
% params_results % beta, gamma, alfa, delta, gammaU, gammaR

params_Tags = {'beta'; 'gamma'; 'alfa'; 'delta';'gammaU'; 'gammaR'};
tabla_params_sum_tasas = table(params_Tags,params_tasas_ini,params_results)

estimaciones_ro = {'ro_basico';'ro_basico_st'}
tabla_ro = table(estimaciones_ro,[ro_basico;ro_basico_st])

vector_p = {'p0';'pn';'varP'}
variacion_p =(p_inicial./p);
tabla_p_final = table(vector_p,[p_inicial';p';variacion_p'])

logtext = {'Errores relativos'};
hiperparametros_tags = {'globalPais';'globalUCImovil';'diaInicio';'diaFinEstudio';'ventana';'acumulada';'maxGlobal';'meanGlobal';'T';'Factor Incial';'Tipo error'};
hiperparametros_values = table(hiperparametros_tags,[globalPais,globalUCImovil,diaInicio,diaFinEstudio,ventana,acumulada,maxGlobal,meanGlobal,numThetas,factor_inicial,logtext]')


Ub(7)
disp('2 Errores relativos f(x) y ajustado en cum')
%e
formatSpec = '%.4e';
sLogpng = strcat('&',num2str(factor_inicial,formatSpec),'&cum/two weeks&$',num2str(errores(1,1),formatSpec),'$&$',num2str(errores(2,1),formatSpec),'$&$',num2str(errores(3,1),formatSpec),'$&',num2str(numThetas),'&[',num2str(diaInicio),',',num2str(diaFinEstudio),']')
%E2.1	&	0.001 & cum/two weeks   &$errores(1,1)$&$errores(2,1)$&$errores(3,1)$& numThetas & $[diaInicio,diaFinEstudio]$&  240 \\