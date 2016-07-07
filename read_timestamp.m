function [timestamp_data, centers, radii] = read_timestamp(imfile)
%now we crop the part with the text
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
%[centers, radii, metric] = imfindcircles(Iclean,[20 50],'ObjectPolarity','dark', 'Sensitivity', 0.6);
[centers, radii, metric] = imfindcircles(BW,[30 70],'ObjectPolarity','dark', 'Sensitivity', 0.7);
if length(radii) < 2
    %there is only one circle
    %check if it is the right circle or the left circle
    dist_to_right_edge = size(BW,2) - centers(1,1);
    dist_to_left_edge = centers(1,1);
    if dist_to_right_edge < dist_to_left_edge
        disp 'You only have the right dot'
        %so we use the same as when we have two
        cent_edge = 1439; %distance from cicrle to left edge of cropping area
        %base to center of circle
        base_center = 881;%distance from cicrle to top edge (same for both circles)
        x_ts = centers(1,1) - cent_edge;
        y_tx = centers(1,2) - base_center;
        
    else
        disp 'You only have the left dot'
        %so we use the same as when we have two
        cent_edge = 3972-1439; %distance from cicrle to left edge of cropping area
        %base to center of circle
        base_center = 881;%distance from cicrle to top edge (same for both circles)
        x_ts = centers(1,1) + cent_edge;
        y_tx = centers(1,2)-base_center;

    end
elseif length(radii)==2
    %you have two circles so lets use the rightmost one
    [right_center, index_right] = max(centers(:,1));
    cent_edge = 1439;
    %base to center of circle
    base_center = 881;
    x_ts = centers(index_right,1) - cent_edge;
    y_tx = centers(index_right,2) - base_center;
    
else
    msg = 'Error occurred with the number of circles, please check';
    error(msg)
end



height_box = 1000;
width_box = 64;
new_im = imcrop(contrastAdjusted, [x_ts, y_tx, height_box, width_box]);
%%




H = fspecial('disk',1);
blurred = imfilter(new_im,H,'replicate');
level = graythresh(blurred);
BW = im2bw(blurred,level);
%imshow(BW);
results = ocr(BW, 'TextLayout', 'Line', 'CharacterSet', '0123456789');
timestamp_data = sscanf(results.Text, '%s');