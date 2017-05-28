function [out_var] = fill_2D_nan_vals(hy_lon, hy_lat, out_var)

%
% This function fills the missed data in HYCOM files,
% based on the available data.
%

[num_lat, num_lon] = size(out_var);

fuse1 = 0;

for i_lat = 1:num_lat
    var_is_nan_row = find(isnan(out_var(i_lat, :)));
    var_no_nan_row = find(~isnan(out_var(i_lat, :)));
    if (size(var_no_nan_row,2) >= 1)
        out_var(i_lat, var_is_nan_row) = ...
            interp1(hy_lon(var_no_nan_row), ...
            out_var(i_lat,var_no_nan_row), ...
            hy_lon(var_is_nan_row),'nearest','extrap');
    else
        fuse1 = 1;
    end
end

if (fuse1)
    for i_lon = 1:num_lon
        var_is_nan_col = find(isnan(out_var(:, i_lon)));
        var_no_nan_col = find(~isnan(out_var(:, i_lon)));
        if (size(var_no_nan_col,1) >= 1)
            out_var(var_is_nan_col,i_lon) = ...
                interp1(hy_lat(var_no_nan_col), ...
                out_var(var_no_nan_col,i_lon), ...
                hy_lat(var_is_nan_col),'nearest','extrap');
        else
            disp(['There is missed data issue,',...
                'but ... still if you are lucky, ',...
                'it will not affect you']);
        end
    end
end


end

