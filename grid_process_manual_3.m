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
new_cen_add = new_cen(:,1) + new_cen(:,2);
row_num = 88;
col_num = 12;

%Make the grid
edge_threshold_x = 22;
%find elements inline with this leftmost element
for col_idx=1:col_num
    edge_x = min(dynamic_cen(:,1));
    index_leftmost = find(dynamic_cen(:,1) < edge_threshold_x + edge_x);
    %find respective indexes in the original array
    temp_dyn = dynamic_cen(index_leftmost,:);
    temp_dyn_add = temp_dyn(:,1)+temp_dyn(:,2);
    [void,abs_index] = ismember(temp_dyn_add,new_cen_add);
    plot(dynamic_cen(index_leftmost,1),dynamic_cen(index_leftmost,2))
    column_matrix{col_idx}.index = abs_index;
    dynamic_cen(index_leftmost,:)=[];
end

dynamic_cen = new_cen;
edge_threshold_y = 10;
edge_y_old = 0;
for row_idx=1:row_num
    edge_y = min(dynamic_cen(:,2));
    if abs(edge_y_old - edge_y) > 30 %In case ther eis a white line
        row_matrix{row_idx}.index = [];
        edge_y_old = edge_y;
        continue
    end
    index_topmost = find(dynamic_cen(:,2) < edge_threshold_y + edge_y);
    %find respective indexes in the original array
    temp_dyn = dynamic_cen(index_topmost,:);
    temp_dyn_add = temp_dyn(:,1)+temp_dyn(:,2);
    [void,abs_index] = ismember(temp_dyn_add,new_cen_add);
    plot(dynamic_cen(index_topmost,1),dynamic_cen(index_topmost,2))
    row_matrix{row_idx}.index = abs_index;
    dynamic_cen(index_topmost,:)=[];
    edge_y_old = edge_y;
end
%%
%Construct Matrix
bcd_matrix = zeros(row_num, col_num);
for row_idx = 1:row_num
    for col_idx = 1:col_num
        if ~isempty(intersect(row_matrix{row_idx}.index, column_matrix{col_idx}.index))
            bcd_matrix(row_idx, col_idx) = 1;
        end
    end
end
figure
imshow(~bcd_matrix)
