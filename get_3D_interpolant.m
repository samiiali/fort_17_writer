function [var_interpolant] = ...
    get_3D_interpolant(hy_lon, hy_lat, hy_dep, out_var)

%
% This function fills the missed data in HYCOM files,
% based on the available data.
%

[num_lat, num_lon, num_dep] = size(out_var);

lon_mat_3D = repmat(hy_lon', num_lat, 1, num_dep);
lat_mat_3D = repmat(hy_lat , 1, num_lon, num_dep);
dep_mat_3D = repmat(hy_dep,  1, num_lon, num_lat);
dep_mat_3D = permute(dep_mat_3D, [3 2 1]);

var_no_nan = double(out_var(~isnan(out_var)));
lon_no_nan = double(lon_mat_3D(~isnan(out_var)));
lat_no_nan = double(lat_mat_3D(~isnan(out_var)));
dep_no_nan = double(dep_mat_3D(~isnan(out_var)));

var_interpolant = scatteredInterpolant(...
    lon_no_nan, lat_no_nan, dep_no_nan, ...
    var_no_nan, 'linear', 'nearest');

end

