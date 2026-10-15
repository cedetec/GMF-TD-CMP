I=I';
R=R';
F=F';
%[aF_day_movil] = mediamovil(F,ventana);
U=U';

%global grafica_data 
 
%if interpolacion == 1
    vn = size(I,1);
    %percentPrunning = 0.01;
    dimFloat = percentPrunning*vn;
    dimceil = ceil(dimFloat);
    dimFloor = floor(dimFloat);
    %salto = size(I,1)/dimFloat
    salto = 1/(percentPrunning);
        
    original = dimFloat/percentPrunning;

    size(I,1);
    xV = ceil([1:salto:vn]); 
    x = [1:1:vn];
   
    y = I;
    px = spline(x,y,xV);
    I = px';
    y = U;
    px = spline(x,y,xV);
    U = px';    
    y = F;
    px = spline(x,y,xV);
    F = px';    
    y = R;
    px = spline(x,y,xV);
    R = px';
% grafica_data
    if grafica_data == 1
    figure;
    plot(x,R,'--',xV,R,'o')
    hold on
    plot(x,I,'--',xV,I,'o')
    plot(x,F,'--',xV,F,'x')
    plot(x,U,'--',xV,U,'o')
   
    
    
    if globalPais == 1 
        figure;
        plot(x,F,'--',xV,F,'x','DisplayName','Fallecidos Pais')
        hold on
        plot(x,U,'--',xV,U,'o','DisplayName','UCI País')
    else
        figure;
        plot(x,F,'--',xV,F,'x','DisplayName','Fallecidos Región')
        hold on
        plot(x,U,'--',xV,U,'o','DisplayName','UCI País')  
    end
    legend() 
    end