function [x_mat, y_mat] = generate_grid(n_rows, n_cols, width_box, height_box)

%we need to generate all the coordenates
separation_row = height_box/n_rows;
separation_col = width_box/n_cols;
x_mat = zeros(n_rows + 1, n_cols + 1);
y_mat = zeros(n_rows + 1, n_cols + 1);
for row_idx = 1:n_rows + 1
    for col_idx = 1:n_cols + 1
        x_mat(row_idx, col_idx) = 1+separation_row*(col_idx - 1);
        y_mat(row_idx, col_idx) = 1+separation_col*(row_idx - 1);
    end
end
end