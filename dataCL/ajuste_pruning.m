%global interpolacion;
global diaInicio diaFin


%%TEST
if interpolacion == 1
interpPruning;
searchpointIni = diaInicio/size(aI_day_movil,2);
searchpointFin = diaFin/size(aI_day_movil,2);
diaInicio=ceil(searchpointIni*size(I,1));
diaFin=ceil(searchpointFin*size(I,1));

end

%%TEST
if interpolacion == 2
interpPruning_analysis;
searchpointIni = diaInicio/size(I,2);
searchpointFin = diaFin/size(I,2);
diaInicio=ceil(searchpointIni*size(I,1));
diaFin=ceil(searchpointFin*size(I,1));

end