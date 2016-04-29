function cropped_im = get_cropped_image(imfile, row_num, col_num)
I = imread(imfile);
%I = rgb2gray(I);
[n_rows, n_cols] = size(I);
J = wiener2(I,[10 10]);
contrastAdjusted = imadjust(gather(J));
marker = imerode(contrastAdjusted, strel('line',10,0));
Iclean = imreconstruct(marker, contrastAdjusted);
level = graythresh(Iclean);
BW = im2bw(Iclean,0.6);
%%
[centers, radii, metric] = imfindcircles(Iclean,[20 50],'ObjectPolarity','dark', 'Sensitivity', 0.8);
%viscircles(centers, radii,'EdgeColor','r');
[right_center, index_right] = max(centers(:,1));
%cent_edge = 785;
cent_edge = 759;
width = 276;
height = 1920;
%base to center of circle
base_center = 796;
point_in_edge_x = centers(index_right,1) - cent_edge;
point_in_edge_y = centers(index_right,2);
upper_x_corner = point_in_edge_x;
upper_y_corner = point_in_edge_y - base_center;
% imshow(Iclean)
% rectangle('Position', [upper_x_corner, upper_y_corner, width, height], 'EdgeColor', 'r')
% viscircles(centers, radii,'EdgeColor','b');
%%
% [origin_x, origin_y] = ginput(1);
% [end_x, end_y] = ginput(1);
% height_box = end_y-origin_y;
% height_box = row_num * 25;
% width_box = col_num * 25;
% width_box = end_x - origin_x;
% cropped_im = imcrop(BW, [origin_x, origin_y, width_box, height_box]);
cropped_im = imcrop(Iclean, [upper_x_corner, upper_y_corner, width, height]);
cropped_im = im2bw(cropped_im, 0.55);
