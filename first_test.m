%%
%Test OCR in large file
test_image = imread('MP4629_0001.tiff');
%remove salt and pepper noise
J = wiener2(test_image,[10 10]);
contrastAdjusted = imadjust(gather(J));
marker = imerode(contrastAdjusted, strel('line',10,0));
Iclean = imreconstruct(marker, contrastAdjusted);
level = graythresh(Iclean);
BW = im2bw(J,level);
imshow(BW)

%%
results = ocr(BW, 'TextLayout', 'Block');


regularExpr = '\d';

% Get bounding boxes around text that matches the regular expression
bboxes = locateText(results, regularExpr, 'UseRegexp', true);

digits = regexp(results.Text, regularExpr, 'match');

% draw boxes around the digits
Idigits = insertObjectAnnotation(test_image, 'rectangle', bboxes, digits);

figure;
imshow(Idigits);