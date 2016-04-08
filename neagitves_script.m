%This is a script to check if I can process the negatives
imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\VIIG_1159_0096_c.tif'
I = imread(imfile);
[n_rows, n_cols] = size(I);
J = wiener2(I,[10 10]);
contrastAdjusted = imadjust(gather(J));
marker = imerode(contrastAdjusted, strel('line',10,0));
Iclean = imreconstruct(marker, contrastAdjusted);
level = graythresh(Iclean);
[centers, radii, metric] = imfindcircles(I,[25 40]);
%find the leftmost center (smallest X)
[left_center, index_left] = min(centers(:,1));
%hard coded values
%center to edge: 314
cent_edge = 314;
width = 1850;
height = 1830;
%base to center of circle
base_center = 990;
point_in_edge_x = centers(index_left,1) + cent_edge;
point_in_edge_y = centers(index_left,2);
upper_x_corner = point_in_edge_x;
upper_y_corner = point_in_edge_y - height + base_center;
%%
imshow(BW)
rectangle('Position', [upper_x_corner, upper_y_corner, width, height], 'EdgeColor', 'r')
viscircles(centers, radii,'EdgeColor','b');
A=imcrop(I, [upper_x_corner, upper_y_corner, width, height]);
file_name = ['crop_test.tif'];
imwrite(A, file_name)
break
%Ibw = im2bw(Ifil,graythresh(Ifil));


