function plot_2D_data(name, iday, ihour, hy_lon, hy_lat, hy_var, ...
    cells_14, lon_14, lat_14, var_14, range)

fig1 = figure;
set(fig1, 'Visible', 'off')
colormap jet;
contourf(hy_lon',hy_lat, hy_var, 10,'LineStyle','none',...
    'EdgeColor','none');
if exist('range', 'var')
    caxis(range);
end
xlim([-95.4 -94.2]);
ylim([28.6 30.0]);
colorbar;
png_file = strcat('hycom_', name, '_', iday,'_',ihour);
print (fig1,png_file,'-dpng');

fig2 = figure;
set(fig2, 'Visible', 'off')
colormap jet;
trisurf(cells_14,lon_14,lat_14, var_14,'LineStyle','none');
if exist('range', 'var')
    caxis(range);
end
view([0,0,1]);
colorbar;
png_file = strcat('adcirc_', name, '_', iday,'_',ihour);
print (fig2,png_file,'-dpng');
close all

end