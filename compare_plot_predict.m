load('Orig_data.mat');
%% Para no ejecutar el main antes (no funciona porque se cambia el valor de diaInicio)
acumulada=2;
% percentPrunning = 1;
% variante_sier = 1;
% grafica_data=0; 
% flagpause=0; % for pause on visualization
% ventana_general=60;
% ventana=ventana_general;
% region = 'Metropolitana';
% data_times_processing
% tc=diaInicio:diaFinEstudio;
opcionModel =3; 
cantidad=100;
diaInicio=1; diaFinEstudio=250;
tc=diaInicio:diaFinEstudio;
%close all
load('data_xd_GEM_test4.mat')
load("data_p_GSIR_test4.mat");
load("data_InfR_GSIR_test4.mat");
load("data_resnorm_GSIR_test4.mat");
pred=1;
er = data_resnorm;
nF=100;
%% CI computed with normality assumption (reasonable for the size)
Pm=mean(data_p,2);
Pstd=std(data_p,0,2);
Plb=Pm-tinv(0.975,cantidad-1)*Pstd/sqrt(cantidad);
Pub=Pm+tinv(0.975,cantidad-1)*Pstd/sqrt(cantidad);
 all_blocks_params_model_analytics_hibridas
if opcionModel==1
    vectorInicial = [N-xdor(diaInicio,1)-xdor(diaInicio,2)-xdor(diaInicio,3);Dataor(1,1);Dataor(1,2);Dataor(1,3)];
else
    vectorInicial = [N-xdor(diaInicio,1)-xdor(diaInicio,2);Dataor(1,1);Dataor(1,2)];
end
% LB curve
[tp,Iflb,Ulb] = computepred(tc,Plb,x0or,nF,acumulada,nTau,N,opcionModel,vectorInicial);
% Mean curve
[~,Ifm,Um] = computepred(tc,Pm,x0or,nF,acumulada,nTau,N,opcionModel,vectorInicial);
% UB curve
[~,Ifub,Uub] = computepred(tc,Pub,x0or,nF,acumulada,nTau,N,opcionModel,vectorInicial);
%% Statistics calculation forecasting
%Data
IDa = xdor(tp,1)';
IDa = diferenciasDiarias(IDa)';
%% Beginning of calculation for ploting
%% Shaded prediction interval
ipred=(length(tc):length(tp))';
Iflb_ip=Iflb(ipred);
Ifm_ip  = Ifm(ipred);
Ifub_ip = Ifub(ipred);
Iflb_ip = Iflb_ip(:);
Ifm_ip  = Ifm_ip(:);
Ifub_ip = Ifub_ip(:);
ipred   = ipred(:);
X = [ipred; flipud(ipred)];
Y1 = [Iflb_ip; flipud(Ifm_ip)];   % inferior -> media
Y2 = [Ifm_ip;  flipud(Ifub_ip)];  % media -> superior
%% Definitions for good exportation into pdf files
% 1. Definir un tamaño físico controlado para la ventana de la figura
% Esto evita que al exportar a EPS el texto se desproporcione.
fig = figure('Position', [50, 50, 675, 413]); 
%fig=figure;
hold on;

% 2. Crear tu gráfico usando 'tiledlayout' (herramienta nativa moderna)
% Aquí es donde se aplica el "TileSpacing" de forma correcta.
%t = tiledlayout(1, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
%ax = nexttile;

%% I Plot 
h1=fill(X, Y1, [0.502,0.749,1], 'EdgeColor','none', 'FaceAlpha',0.35);
fill(X, Y2, [0.502,0.749,1], 'EdgeColor','none', 'FaceAlpha',0.35);

h2=plot(tp, Ifm, 'b', 'LineWidth', 2);
h3=plot(tp, Iflb, '--g', 'LineWidth', 1.5);
h4=plot(tp, Ifub, '-.k', 'LineWidth', 1.5);

%set(gca,'Layer','top') 
% Original data
ii=find( mod(tp,4)==0 );
ii=[1; ii; length(tp)];
texp = tp(ii);
h5=plot(texp,IDa(ii),'ro','LineWidth',1.5,'MarkerSize',2);
%
tini=200;
ical=(tini:length(tp))';
maxInf=max(Ifub(ical));
maxInf=max( maxInf, max(Iflb(ical)) );
minInf=min(Iflb(ical));
minInf=min(minInf,min(Ifub(ical)));
mindata=min(diferenciasDiarias(xdor(ical,1)'));
maxdata=max(diferenciasDiarias(xdor(ical,1)'));
%yl=ylim;
h6=line([tc(end), tc(end)], [yl(1) yl(2)],'LineStyle',':','LineWidth',1,'Color','black');
%h6=line([tc(end), tc(end)], [0.01*min(minInf,mindata) 1.01*max(maxdata,maxInf)],'LineStyle',':','LineWidth',1,'Color','black');
xlabel('Time (days)','FontSize',14)
ylabel('Cases incidence','FontSize',14)
%ylim('auto')
axis([tini tp(end)+2 yl(1) yl(2)]);
%axis([tini tp(end)+2 0.01*min(minInf,mindata) 1.01*max(maxdata,maxInf)]);

% yl=[0.01*min(minInf,mindata) 1.01*max(maxdata,maxInf)];
% ylim([min(yl) max(yl)]);
box on
ax=gca;
ax.FontSize=16;
%ax.YLimMode = 'auto';
%h = [h1 h2 h3 h4 h5 h6 h7];      % incluir sólo los handles que quieres en leyenda
%h = h(isgraphics(h));            % filtrar inválidos
%lgd = legend(ax, 'Location','northwest');
%set(lgd,'Location','northwest','FontSize',12);
lgd = legend([h1 h2 h3 h4 h5 h6], {'Pred. band','Mean curve','LB curve','UB curve','Data','End of calibration'},'Location','north');
%lgd.AutoUpdate = 'off';
% lgd.AutoUpdate = 'off';

% 3. Configurar la fuente GLOBAL de los ejes (Labels y números crecerán juntos)
set(ax, 'FontSize', 16);

% 4. Insertar la leyenda de forma externa pero vinculada al Layout
%lgd = legend(ax, 'Seno de X', 'Location', 'eastoutside');
%set(lgd,'Location','northwest','Interpreter','latex','FontSize',12)
%lgd.String = strcat(lgd.String, '    '); 
%lgd.String = strcat(lgd.String, '\;\;\;'); 
%drawnow;

% 5. Truco para estirar la caja vectorialmente si el texto sigue al límite
% (Multiplica el ancho actual por un 10% adicional de seguridad)
pos = lgd.Position;
pos(3) = pos(3) * 1.10; 
lgd.Position = pos;

% 6. Forzar el renderizado vectorial limpio (Painters)
fig.Renderer = 'opengl';
findobj(gcf,'Type','line')    % lista handles de líneas
% 6. Exportar a formato EPS de forma ajustada y recortada
%yl=ylim;
%ylim=([10*yl(1) yl(2)/10]);
exportgraphics(fig, 'Fig3c.pdf', 'ContentType', 'vector','BackgroundColor','none');
hold off
shg