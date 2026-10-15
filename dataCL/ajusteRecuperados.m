function [salidas] = ajusteRecuperados(tasas,infec,recup,finAjuste,tramoTasaRecuperados,diaPrimerRecs)
%% Simulación/ajuste curvas recuperados - solo considerar primer periodo
%% mediana de recuperación a mitad de la pandemia (mar 2020 - mar 2021)
% medianaRecuperacion=median(tasasRecuperados(1:end/2));
%tramoTasaRecuperados
%% Como la data es más robusta a partir del cuarto mes considerar de alli en adelante ej: 120
mediaCR=mean(tasas(tramoTasaRecuperados))
% medianaRecuperacion=0.96 %experimental
%diaPrimerFallecido = 19; %experimental
diaPrimerDatoRecuperado = 119; %experimental {'21-06-2020'}
diasPromedioSintomas = diaPrimerRecs; %experimental ->  tiempo de recuperacion 2 semanas segun china
estimacionRecuperados = ceil(infec.*mediaCR);
%estimacionRecuperadosAjuste = ceil(infec.*mediaCR);
diasShift=2;
tmp = circshift(estimacionRecuperados,diasShift);
size(tmp);
size(recup);
tmp(1,1:diasPromedioSintomas)=0;
estimacionRecuperados = [tmp(1,1:diaPrimerDatoRecuperado-1),recup(1,diaPrimerDatoRecuperado+finAjuste:end)];
salidas=estimacionRecuperados;
% error on humans
[y0] = diferenciasDiarias(recup);
[y1] = diferenciasDiarias(estimacionRecuperados);
error_aRC=abs(sum(y0)-sum(y1));
% error on model
end