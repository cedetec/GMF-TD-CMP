%% Plot
% 1. Definir un tamaño físico controlado para la ventana de la figura
% Esto evita que al exportar a EPS el texto se desproporcione.
fig = figure('Position', [100, 100, 600, 450]); 
hold on;
plot(tg,UCI,'-.k','LineWidth',1.0,'DisplayName','Modeled');
I=find( mod(tg,4)==0 );
texp=tg(I);
if texp(1)>tg(1)
    texp=[tg(1); texp];
    I=[1; I];
end
if texp(end)<tg(end)
    texp=[texp; tg(end)];
    I=[I; length(tg)];
end
%texp=texp+I00-1;
plot(texp,UCIDa(I),'sb','MarkerEdgeColor','b',...
        'MarkerFaceColor',[0 0.4470 0.7410],'MarkerSize',3,'DisplayName','Observed');
%grid on
maxdata=max(UCIDa);
mindata=min(UCIDa);
maxUCI=max(UCI);
minUCI=min(UCI);
xlabel('Time (days)','FontSize',16)
ylabel('Cases incidence','FontSize',16)
axis([tg(1) tg(end) 0.01*min(minUCI,mindata) 1.05*max(maxdata,maxUCI)])
% Generar ticks adaptativos
num_ticks = 5; % Número deseado de ticks
ticks = linspace(1,tg(end), num_ticks); % Ticks adaptativos
% 
% % Cambiar los ticks y etiquetas
xticks(ticks);
xticklabels(arrayfun(@(v) sprintf('%.f', v), ticks+I00-1, 'UniformOutput', false));
ax=gca;
% 3. Configurar la fuente GLOBAL de los ejes (Labels y números crecerán juntos)
box on
ax.FontSize= 16;
drawnow
pos = lgd.Position;
pos(3) = pos(3) * 1.10; 
lgd.Position = pos;

% 6. Forzar el renderizado vectorial limpio (Painters)
fig.Renderer = 'opengl';
findobj(ax,'Type','line')    % lista handles de líneas
% 6. Exportar a formato EPS de forma ajustada y recortada
exportgraphics(fig, 'Fig1b.pdf', 'ContentType', 'vector','BackgroundColor','none');
hold off
legend
shg


