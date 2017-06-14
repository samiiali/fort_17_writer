function [out_var] = fill_3D_nan_vals(hy_lon, hy_lat, hy_dep, out_var)

%
% This function fills the missed data in HYCOM files,
% based on the available data.
%

[num_lat, num_lon, ~] = size(out_var);

lon_mat_2D = repmat(hy_lon', num_lat, 1);
lat_mat_2D = repmat(hy_lat,  1, num_lon);

var_no_nan = double(out_var(~isnan(out_var(:, :, 1))));
lon_no_nan = double(lon_mat_2D(~isnan(out_var(:, :, 1))));
lat_no_nan = double(lat_mat_2D(~isnan(out_var(:, :, 1))));

var_interpolant = scatteredInterpolant(...
    lon_no_nan, lat_no_nan, ...
    var_no_nan, 'linear', 'nearest');
    
out_var(:,:,1) = var_interpolant(double(lon_mat_2D), ...
    double(lat_mat_2D));

for i_lat = 1:num_lat
    for i_lon = 1:num_lon
        var_is_nan_dep = find(isnan(out_var(i_lat, i_lon, :)));
        var_no_nan_dep = find(~isnan(out_var(i_lat, i_lon, :)));
        if (size(var_no_nan_dep, 3) >= 2)
            out_var(i_lat, i_lon, var_is_nan_dep) = ...
                interp1(hy_dep(var_no_nan_dep), ...
                out_var(i_lat, i_lon, var_no_nan_dep), ...
                hy_dep(var_is_nan_dep),'nearest','extrap');
        elseif (size(var_no_nan_dep, 3) == 1)
            out_var(i_lat, i_lon, var_is_nan_dep) = ...
                out_var(i_lat, i_lon, var_no_nan_dep(1));
        end
    end
end

end

