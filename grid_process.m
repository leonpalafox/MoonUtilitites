%create grid analysis
clear
imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\V_07_0010_c.jpg';
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
imagesc(BW)
adjust = 0;
for row_idx = 1:88
    [bit_chain, adjust] = decode_bits_profile(BW, row_idx, space_between_rows, space_size, bit_size, adjust);
    bit_chain = bit_chain';
    if row_idx>1
        arr_dif = size(bit_chain,1)- size(bit_array(:,row_idx-1),1);
        if arr_dif>0
            bit_array = padarray(bit_array, [arr_dif, 0], 'post');
        elseif arr_dif<0
            bit_chain = padarray(bit_chain ,[abs(arr_dif), 0], 'post');
        end
    end
    bit_array(:, row_idx) = bit_chain;
end
%[x_grid, y_grid] = build_grid(grid_rows, grid_cols, grid_area, 810 , 240);

