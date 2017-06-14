function [out_var] = fill_2D_nan_vals(hy_lon, hy_lat, out_var)

%
% This function fills the missed data in HYCOM files,
% based on the available data.
%

[num_lat, num_lon] = size(out_var);

lon_mat_2D = repmat(hy_lon', num_lat, 1);
lat_mat_2D = repmat(hy_lat,  1, num_lon);

var_no_nan = double(out_var(~isnan(out_var)));
lon_no_nan = double(lon_mat_2D(~isnan(out_var)));
lat_no_nan = double(lat_mat_2D(~isnan(out_var)));

var_interpolant = scatteredInterpolant(...
    lon_no_nan, lat_no_nan, ...
    var_no_nan, 'linear', 'nearest');
    
out_var = var_interpolant(double(lon_mat_2D), double(lat_mat_2D));

end

