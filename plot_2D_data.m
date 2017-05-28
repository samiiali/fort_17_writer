function plot_2D_data(name, iday, ihour, hy_lon, hy_lat, hy_var, ...
    cells_14, lon_14, lat_14, var_14)

fig1 = figure;
set(fig1, 'Visible', 'on')
colormap jet;
contourf(hy_lon',hy_lat, hy_var,'LineStyle','none',...
    'EdgeColor','none');
%caxis([-1200, 900]);
colorbar;
png_file = strcat('hycom_', name, '_', iday,'_',ihour);
print (fig1,png_file,'-dpng');
close

fig2 = figure;
set(fig2, 'Visible', 'on')
colormap jet;
trisurf(cells_14,lon_14,lat_14, var_14,'LineStyle','none');
view([0,0,1]);
%caxis([-1200, 900]);
colorbar;
png_file = strcat('adcirc_', name, '_', iday,'_',ihour);
print (fig2,png_file,'-dpng');
close

end