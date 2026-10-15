function [salida] = mediamovil(x,ventana)
salida = ceil(movmean(x,ventana));
end