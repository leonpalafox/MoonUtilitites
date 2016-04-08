function [gridx, gridy] = build_grid(grid_rows, grid_cols, grid_area, originx, originy)
xsize = grid_cols + 1;
ysize = grid_rows + 1;
[gridx,gridy] = meshgrid(originx:grid_area: originx + xsize*grid_area-2, originy:grid_area:originy + ysize*grid_area-2);



