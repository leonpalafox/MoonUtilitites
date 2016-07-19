function [timestamp_data, centers, radii, frame_counter] = read_timestamp_interactive(imfile, frame_counter)
%now we crop the part with the text
I = imread(imfile);
%I = rgb2gray(I);
[n_rows, n_cols] = size(I);
J = wiener2(I,[10 10]);
contrastAdjusted = imadjust(gather(J));
marker = imerode(contrastAdjusted, strel('line',10,0));
Iclean = imreconstruct(marker, contrastAdjusted);
level = graythresh(Iclean);
BW = im2bw(Iclean,0.45);
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
        base_center = 911; %roll 4
        base_center = 885;
        base_center = 909; %roll 5
        base_center = 952;
        x_ts = centers(1,1) - cent_edge;
        y_tx = centers(1,2) - base_center;
        
    else
        disp 'You only have the left dot'
        %so we use the same as when we have two
        cent_edge = 3972-1439; %distance from cicrle to left edge of cropping area
        %base to center of circle
        base_center = 881;%distance from cicrle to top edge (same for both circles)
        base_center = 911; %roll 4
        base_center = 885; %roll 5
        base_center = 909; %roll 5
        base_center = 952;
        
        x_ts = centers(1,1) + cent_edge;
        y_tx = centers(1,2)-base_center;

    end
elseif length(radii)==2
    %you have two circles so lets use the rightmost one
    [right_center, index_right] = max(centers(:,1));
    cent_edge = 1439;
    %base to center of circle
    base_center = 881;
    base_center = 911; %roll 4
    base_center = 885;
    base_center = 909;
    base_center = 952;
    
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
%This is the interactive part

if (frame_counter == 40 || frame_counter == 0)
    figure('rend','painters','pos',[10 10 1600 1000])
    hold on
    imshow(imfile)
    rectangle('position', [x_ts, y_tx, height_box, width_box])
    answer =  questdlg('Do the frame looks right?','Moon Matlab', 'Yes', 'No', 'No');
    if strcmp(answer, 'No')
        waitfor(msgbox('Please readjust it'));
        new_params = getrect;
        new_im = imcrop(contrastAdjusted, new_params);
        x_ts = new_params(1)
        y_tx = new_params(2)
        height_box = new_params(3)
        width_box = new_params(4)
        close all
        error('Check the log and update the numbers accordingly')
    end
    close all
    frame_counter = 1;
        
end
%%



H = fspecial('disk',1);
blurred = imfilter(new_im,H,'replicate');
level = graythresh(blurred);
BW = im2bw(blurred,level);

%imshow(BW);
results = ocr(BW, 'TextLayout', 'Line', 'CharacterSet', '0123456789');
timestamp_data = sscanf(results.Text, '%s');