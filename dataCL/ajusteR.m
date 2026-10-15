function [aRC,y0,y1,error_aRC] = ajusteR(IC,RC,diaPrimerRecs)
%% Ajustes ad-hoc para primeros meses de pandemia
tramoTasaRecuperados = 120:150; % Datos promedio del segunda mitad de año %% Para probar robustez de datos a futuro experimentar
IC_desp = circshift(IC,1); %calculo con infectados de dia anterior
tasasRecuperados = RC./(IC_desp+0.000001);
tasasIn = tasasRecuperados;
%inicioAjuste=1;
finAjuste=0; 
[aRC] = ajusteRecuperados(tasasIn,IC,RC,finAjuste,tramoTasaRecuperados,diaPrimerRecs);
% error on humans
[y0] = diferenciasDiarias(RC);
[y1] = diferenciasDiarias(aRC);
error_aRC=abs(sum(y0)-sum(y1))
end