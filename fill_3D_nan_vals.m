function [out_var] = fill_3D_nan_vals(hy_lon, hy_lat, hy_dep, out_var)

%
% This function fills the missed data in HYCOM files,
% based on the available data.
%

[num_lat, num_lon, ~] = size(out_var);

fuse1 = 0;
%
for i_lat = 1:num_lat
    var_is_nan_row = find(isnan(out_var(i_lat, :, 1)));
    var_no_nan_row = find(~isnan(out_var(i_lat, :, 1)));
    if (size(var_no_nan_row,2) >= 1)
        out_var(i_lat, var_is_nan_row, 1) = ...
            interp1(hy_lon(var_no_nan_row), ...
            out_var(i_lat, var_no_nan_row, 1), ...
            hy_lon(var_is_nan_row),'nearest','extrap');
    else
        fuse1 = 1;
    end
end

%
if (fuse1)
    for i_lon = 1:num_lon
        var_is_nan_col = find(isnan(out_var(:, i_lon, 1)));
        var_no_nan_col = find(~isnan(out_var(:, i_lon, 1)));
        if (size(var_no_nan_col,1) >= 1)
            out_var(var_is_nan_col, i_lon, 1) = ...
                interp1(hy_lat(var_no_nan_col), ...
                out_var(var_no_nan_col, i_lon, 1), ...
                hy_lat(var_is_nan_col),'nearest','extrap');
        else
            disp(['There is missed data issue,',...
                'but ... still if you are lucky, ',...
                'it will not affect you']);
        end
    end
end

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

