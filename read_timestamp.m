function timestamp_data = read_timestamp(image_file)
contrastAdjusted = imadjust(gather(imread(image_file)));
%now we crop the part with the text
x_ts = 2939;
y_tx = 288;
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