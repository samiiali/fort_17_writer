%
% This script reads the qtot from hycom file and
% writes fort.17 for Adcirc.
%

close all

%
% Opening input and output files
%
iyear = 2017;
iday = 113;
ihour = 0;
n_layer = 31;
enable_plots = 0;
sigma = linspace(1, -1, n_layer)';
if exist('sigma.txt','file') == 2
    sigma = dlmread('sigma.txt');
end
nodes_14 = dlmread('IO_Files/nodes_of_fort.14');
cells_14 = dlmread('IO_Files/elems_of_fort.14','',0,2);
fid1 = fopen('IO_Files/fort.17','w');
%
iyear_00 = sprintf('%d',iyear);
ihour_00 = sprintf('%02d',ihour);
iday_00 = sprintf('%03d',iday);
name_00 = strcat('IO_Files/archv.',iyear_00, ...
    '_',iday_00,'_',ihour_00,'_3z.nc');

%
% Getting ADCIRC parameters from fort.14 inputs.
%
n_layer = size(sigma,1);
n_nodes = size(nodes_14, 1);
n_cells = size(cells_14, 1);
node_nums = nodes_14(:,1);
lon_14 = nodes_14(:, 2);
lat_14 = nodes_14(:, 3);
%nodes_14(:, 4) = max(nodes_14(:, 4), 1.0);
dep_14 = zeros(n_nodes, n_layer);
for i_layer = 1: n_layer
    dep_14(:, i_layer) = -(sigma(i_layer) - 1)/2 * nodes_14(:, 4);
end
%
clear nodes_14;

%
% Getting HYCOM coordinates
%
hy_lon = ncread(name_00,'Longitude');
hy_lat = ncread(name_00,'Latitude');
hy_dep = ncread(name_00,'Depth');
num_lon = size(hy_lon, 1);
num_lat = size(hy_lat, 1);
num_dep = size(hy_dep, 1);
%
lon_mat_3D = repmat(hy_lon', num_lat, 1, num_dep);
lat_mat_3D = repmat(hy_lat , 1, num_lon, num_dep);
dep_mat_3D = repmat(hy_dep,  1, num_lon, num_lat);
dep_mat_3D = permute(dep_mat_3D, [3 2 1]);
lon_mat_2D = repmat(hy_lon', num_lat, 1);
lat_mat_2D = repmat(hy_lat,  1, num_lon);

%
% Interpolating qtot from hycom grid to fort.14
%
qtot = ncread(name_00,'qtot')';
qtot_filled = fill_2D_nan_vals(hy_lon, hy_lat, qtot);
qtot_14 = interp2(lon_mat_2D, lat_mat_2D,...
    qtot_filled, lon_14, lat_14);
assert(isempty(find(isnan(qtot_14),1)),...
    'Missed data issue is serious');
if (enable_plots)
    plot_2D_data('qtot', iday_00, ihour_00, hy_lon, hy_lat, ...
        -qtot, cells_14, lon_14, lat_14, -qtot_14);
end
%
%clear qtot qtot_filled qtot_14

%
% Interpolating ssh from hycom grid to fort.14
%
ssh = ncread(name_00,'ssh')';
ssh_filled = fill_2D_nan_vals(hy_lon, hy_lat, ssh);
ssh_14 = interp2(lon_mat_2D, lat_mat_2D,...
    ssh_filled, lon_14, lat_14);
assert(isempty(find(isnan(ssh_14),1)),...
    'Missed data issue is serious');
if (enable_plots)
    plot_2D_data('ssh', iday_00, ihour_00, hy_lon, hy_lat, ...
        ssh, cells_14, lon_14, lat_14, ssh_14);
end
%
%clear ssh ssh_filled ssh_14

%
% Interpolating x velocity from hycom grid to fort.14
%
u_x = ncread(name_00, 'u');
u_x = permute(u_x, [2 1 3]);
u_x_filled = fill_3D_nan_vals(hy_lon, hy_lat, hy_dep, u_x);
%
u_x_14 = zeros(n_nodes, n_layer);
for i_dep = 1:n_layer
    u_x_14(:,i_dep) = interp3(lon_mat_3D, lat_mat_3D, dep_mat_3D, ...
        u_x_filled, lon_14, lat_14, dep_14(:,i_dep));
end
%
if (enable_plots)
    plot_2D_data('u', iday_00, ihour_00, hy_lon, hy_lat, ...
        u_x_filled(:,:,2), cells_14, lon_14, lat_14, u_x_14(:,3));
end
%
%clear u_x u_x_filled u_x_14

%
% Interpolating x velocity from hycom grid to fort.14
%
u_y = ncread(name_00, 'v');
u_y = permute(u_y, [2 1 3]);
u_y_filled = fill_3D_nan_vals(hy_lon, hy_lat, hy_dep, u_y);
%
u_y_14 = zeros(n_nodes, n_layer);
for i_dep = 1:n_layer
    u_y_14(:,i_dep) = interp3(lon_mat_3D, lat_mat_3D, dep_mat_3D, ...
        u_y_filled, lon_14, lat_14, dep_14(:,i_dep));
end
%
if (enable_plots)
    plot_2D_data('v', iday_00, ihour_00, hy_lon, hy_lat, ...
        u_y_filled(:,:,2), cells_14, lon_14, lat_14, u_y_14(:,3));
end
%
%clear u_y u_y_filled u_y_14

%
% Interpolating salinity from hycom grid to fort.14
%
salin = ncread(name_00, 'salinity');
salin = permute(salin, [2 1 3]);
salin_filled = fill_3D_nan_vals(hy_lon, hy_lat, hy_dep, salin);
%
salin_14 = zeros(n_nodes, n_layer);
for i_dep = 1:n_layer
    salin_14(:,i_dep) = interp3(lon_mat_3D, lat_mat_3D, dep_mat_3D, ...
        salin_filled, lon_14, lat_14, dep_14(:,i_dep));
end
%
if (enable_plots)
    plot_2D_data('salinity', iday_00, ihour_00, hy_lon, hy_lat, ...
        salin_filled(:,:,2), cells_14, lon_14, lat_14, salin_14(:,3));
end
%clear salin salin_filled salin_14

%
% Interpolating temperature from hycom grid to fort.14
%
temp = ncread(name_00, 'temperature');
temp = permute(temp, [2 1 3]);
temp_filled = fill_3D_nan_vals(hy_lon, hy_lat, hy_dep, temp);
%
temp_14 = zeros(n_nodes, n_layer);
for i_dep = 1:n_layer
    temp_14(:,i_dep) = interp3(lon_mat_3D, lat_mat_3D, dep_mat_3D, ...
        temp_filled, lon_14, lat_14, dep_14(:,i_dep));
end
%
if (enable_plots)
    plot_2D_data('temp', iday_00, ihour_00, hy_lon, hy_lat, ...
        temp_filled(:,:,2), cells_14, lon_14, lat_14, temp_14(:,3));
end
%clear temp temp_filled temp_14

%
% Finally, we write the output to file
%
fprintf(fid1, 'This file is written based on HYCOM output.\n');
fprintf(fid1, '%12d\n%12E\n%12d\n%12d\n%12d\n%12d\n%12d\n', ...
    21, 0., 0, n_nodes, n_cells, n_nodes, n_cells);
fprintf(fid1, '%22.14E\n', zeros(3*n_nodes,1)); %ETA1 ETA2 ETA3
disp('ETA1 ETA2 ETA3 Written.');
fprintf(fid1, '%22.14E\n', zeros(n_nodes,1)); % DUU2
fprintf(fid1, '%22.14E\n', zeros(n_nodes,1)); % DVV2
disp('DUU2 DVV2 Written.');
fprintf(fid1, '%22.14E\n', dep_14(:,n_layer)>0); % *** NODECODE
fprintf(fid1, '%22.14E\n', ones(n_cells,1)); %NOFF
fprintf(fid1, '%10d\n', zeros(18,1));
fprintf(fid1, '%10d\n', 4);
fprintf(fid1, '%10d\n', zeros(12,1));
fprintf(fid1, '%22.14E\n', zeros(3*n_nodes,1)); % DUU DUV DVV
disp('DUU DUV DVV Written.');
fprintf(fid1, '%22.14E\n', zeros(n_nodes,1)); % DUU2
fprintf(fid1, '%22.14E\n', zeros(n_nodes,1)); % DVV2
disp('DUU2 DVV2 Written.');
fprintf(fid1, '%22.14E\n', zeros(n_nodes,1)); % BSX
fprintf(fid1, '%22.14E\n', zeros(n_nodes,1)); % BSY
disp('BSX BSY Written.');
fprintf(fid1, '%22.14E\n', zeros(n_nodes*n_layer,1)); % U
fprintf(fid1, '%22.14E\n', zeros(n_nodes*n_layer,1)); % V
fprintf(fid1, '%22.14E\n', zeros(n_nodes*n_layer,1)); % WZ
disp('U V WZ Written.');
fprintf(fid1, '%22.14E\n', 1.e-6*ones(n_nodes*n_layer,1)); % Q2
fprintf(fid1, '%22.14E\n', ones(n_nodes*n_layer,1)); % L
disp('Q2 L Written.');
fprintf(fid1, '%22.14E\n', flipud(salin_14)'); % Sal
fprintf(fid1, '%22.14E\n', flipud(temp_14)'); % Tem
disp('Salinity Temperature Written.');
fclose(fid1);

fclose('all');
