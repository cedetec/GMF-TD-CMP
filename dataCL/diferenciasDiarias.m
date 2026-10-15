function [y] = diferenciasDiarias(x)
y =   abs(x(1,2:end) - x(1,1:end-1));
y = [y(1,1),y];
end
