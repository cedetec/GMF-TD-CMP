function [D38string,D38table,D38double] = D38(path)
%addpath ./data
D38string = importfileD38string(path, [1, Inf]);
%D38table = importfileD38table("./data/Datos-COVID19-master-09-11-2021/output/producto38/CasosFallecidosPorComuna.csv", [1, Inf],nTimeInf);
D38table = importfileD38table(path,[1, Inf]);
D38double = importfileD38double(path, [1, Inf]);

end
%

%i=1:100