function [] =  analiticaF(data)
m1 = importdata(data)
m1 = double(m1)'
maximos = m1./max(m1)
figure;boxplot(maximos);
figure;surf(maximos);

end