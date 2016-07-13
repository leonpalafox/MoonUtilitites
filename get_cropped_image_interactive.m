function cropped_im = get_cropped_image_extended(imfile, row_num, col_num, radii, centers)
%This function read a bit into the bar code to detect if there is some sort
%of information
I = imread(imfile);
%I = rgb2gray(I);
[n_rows, n_cols] = size(I);
J = wiener2(I,[10 10]);
contrastAdjusted = imadjust(gather(J));
marker = imerode(contrastAdjusted, strel('line',10,0));
Iclean = imreconstruct(marker, contrastAdjusted);
level = graythresh(Iclean);
BW = im2bw(Iclean,0.6);
%prime_base_center = 796;
prime_base_center = 840; %roll 4
%right_cent_edge = 759;
right_cent_edge = 770; %roll 4
left_cent_edge = 3213;
%%

if length(radii) < 2
    %there is only one circle
    %check if it is the right circle or the left circle
    dist_to_right_edge = size(BW,2) - centers(1,1);
    dist_to_left_edge = centers(1,1);
    if dist_to_right_edge < dist_to_left_edge
        disp 'You only have the right dot'
        %so we use the same as when we have two
        cent_edge = right_cent_edge; %distance from cicrle to left edge of cropping area
        width = 400;
        height = 1920;
        %base to center of circle
        base_center = prime_base_center;%distance from cicrle to top edge (same for both circles)
        point_in_edge_x = centers(1,1) - cent_edge;
        point_in_edge_y = centers(1,2);
        upper_x_corner = point_in_edge_x;
        upper_y_corner = point_in_edge_y - base_center;
    else
        disp 'You only have the left dot'
        %so we use the same as when we have two
        cent_edge = left_cent_edge; %distance from cicrle to left edge of cropping area
        width = 400;
        height = 1920;
        %base to center of circle
        base_center = prime_base_center;%distance from cicrle to top edge (same for both circles)
        point_in_edge_x = centers(1,1) + cent_edge;
        point_in_edge_y = centers(1,2);
        upper_x_corner = point_in_edge_x;
        upper_y_corner = point_in_edge_y - base_center;
    end
elseif length(radii)==2
    %you have two circles so lets use the rightmost one
    [right_center, index_right] = max(centers(:,1));
    cent_edge = right_cent_edge;
    width = 400;
    height = 1920;
    %base to center of circle
    base_center = prime_base_center;
    point_in_edge_x = centers(index_right,1) - cent_edge;
    point_in_edge_y = centers(index_right,2);
    upper_x_corner = point_in_edge_x;
    upper_y_corner = point_in_edge_y - base_center;
else
    msg = 'Error occurred with the number of circles, please check';
    error(msg)
end

if (frame_counter == 40)
    imshow(imfile)
    hold on;
    rectangle('position', [upper_x_corner, upper_y_corner, width, height])
    answer =  questdlg('Do the bcd frame looks right?','Moon Matlab', 'Yes', 'No', 'No');
    if strcmp(answer, 'No')
        msgbox('Please readjust it')
        new_params = getrect;
        new_im = imcrop(contrastAdjusted, new_params);
        x_ts = new_params(1)
        y_tx = new_params(2)
        height_box = new_params(3)
        width_box = new_params(4)
        error('Check the log and update the numbers accordingly')
    end
        
end
% imshow(BW)
% hold on
% viscircles(centers, radii,'EdgeColor','r');

%cent_edge = 785;

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
cropped_im = im2bw(cropped_im, 0.45); %this is for roll 4
%cropped_im = im2bw(cropped_im, 0.55);
