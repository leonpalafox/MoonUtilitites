%create grid analysis
clear
imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\V_07_0010_c.jpg';
%imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\I_04_0027_c.jpg';
%imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\I_04_0013_c.jpg';
I = imread(imfile);
I = rgb2gray(I);
[n_rows, n_cols] = size(I);
J = wiener2(I,[10 10]);
contrastAdjusted = imadjust(gather(J));
marker = imerode(contrastAdjusted, strel('line',10,0));
Iclean = imreconstruct(marker, contrastAdjusted);
level = graythresh(Iclean);
BW = im2bw(Iclean,0.45);
space_size = 12;
bit_size = 11; %size of the blackpart
grid_area = 20; %units in px
space_between_rows = 22;
imshow(BW)
adjust = 1;

[origin_x, origin_y] = ginput(1);
[end_x, end_y] = ginput(1);
height_box = end_y-origin_y;
width_box = end_x - origin_x;
new_im = imcrop(BW, [origin_x, origin_y, width_box, height_box]);
%imshow(new_im)
%%
n_rows = 80;
n_cols = 10;
thresh = 400;
[B,L] = bwboundaries(new_im);
props = regionprops(L, 'Area','Centroid');
centers=cat(1, props.Centroid);
sel_idx = find([props.Area] < thresh);
imshow(new_im)
hold all
for n = 1:length(sel_idx)
    plot(B{sel_idx(n)}(:,2), B{sel_idx(n)}(:,1), 'r')
    %plot(centers(sel_idx(n), 1),centers(sel_idx(n), 2), 'b+')
    new_cen(n,1) = centers(sel_idx(n), 1); %this holds the x
    new_cen(n,2) = centers(sel_idx(n), 2); %this holds the y
end
index_cols = find([new_cen(:,1)]<25);
index_rows = find([new_cen(:,2)]<25);
plot(new_cen(index_cols,1), new_cen(index_cols,2), '+')
plot(new_cen(index_rows,1), new_cen(index_rows,2), '*')
dist_thre = 30;
%min_distances = pdist2(new_cen(1,:), new_cen, 'euclidean');

%%
imshow(new_im)
hold on
dynamic_cen = new_cen;
%Find the upper edge y
mat_row = 1;
empty_matrix = zeros(n_rows, n_cols);
edge_y_old = 0;
edge_x_old = 0;
for cen_idx = 1 : 88
    edge_y = min(dynamic_cen(:,2));
    if abs(edge_y_old - edge_y) > 30
        empty_matrix(mat_row,:) = 0;
        mat_row = mat_row + 1;
        edge_y_old = edge_y;
        continue
    end
    edge_y_old = edge_y;
        
    %find the left edge
    edge_x = min(dynamic_cen(:,1));
    if abs(edge_x_old - edge_x) > 20;
        disp 'there is something odd'
        edge_x = edge_x_old;
    end
    edge_x_old = edge_x;
    %find all the elements that are on the upper edge
    edge_threshold_x = 10;
    edge_threshold_y = 10;
    index_upper = find(dynamic_cen(:,2) < edge_threshold_y + edge_y);
    %now find the leftmost element
    [val_da, index_min] = min(dynamic_cen(index_upper, 1));
    up_corner = dynamic_cen(index_upper(index_min), :);
    plot(up_corner(1), up_corner(2), 'o')
    %check if it is in the left edge
    
    mat_count = 1;
    center_thresh = 27;
    for elem_idx = 1:12
        if up_corner(1)<= edge_threshold_x + center_thresh*(elem_idx - 1)
           %disp 'Is corner'
            empty_matrix(mat_row, mat_count) = 1;
            mat_count = mat_count + 1;
            break
        else
            %disp ' corner is white'
            empty_matrix(mat_row,mat_count) = 0;
            mat_count = mat_count + 1;
        end 
    end
    if cen_idx == 100
        break
    end
    
    upper_cen = dynamic_cen(index_upper, :);

    for elem_idx = 1:size(upper_cen, 1)-1
        distances = pdist2(up_corner, upper_cen, 'cityblock'); %we get the distance against every point
        [vals, arg_min] = sort(distances);
        for count_idx = 2:20
            if vals(2)<= center_thresh*(count_idx-1);
                empty_matrix(mat_row,mat_count) = 1;
                mat_count = mat_count + 1;
                up_corner = upper_cen(arg_min(2),:);
                upper_cen(arg_min(1),:) = []; %delete the traversed element
                break
            else
                empty_matrix(mat_row,mat_count) = 0;
                mat_count = mat_count + 1;
            end
        end
    end

    dynamic_cen(index_upper, :) = [];
    mat_row = mat_row + 1;
    if cen_idx == 100
        break
    end
end
figure
imshow(~empty_matrix)
%%

    





