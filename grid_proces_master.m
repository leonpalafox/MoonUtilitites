%create grid analysis
clear
path = 'C:\Users\leon\Documents\Data\MoonData';
%filename = uigetfile(fullfile(path, '*.tif'));
images = dir([path,'\*.tif']);
%imfile = fullfile(path,filename);
%imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\V_07_0010_c.jpg';
%imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\I_04_0027_c.jpg';
%imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\I_04_0013_c.jpg';
%nuts and bolts
%%
edge_threshold_x = 22;
row_num = 80;
col_num = 12;
barker_code = [0 0 0 1 1 1 0 1 1 0 1];
length_of_word = 11;
num_words = 17;
register_table = cell2table(cell(1,4), 'VariableNames',{'Filename', 'WarningAbscenceofBarker','Warning_only_1_Barker', 'Warning_not_consistent_Barker'});
%main program
for im_idx = 1:6
    close all
    imfile = fullfile(path,images(im_idx).name);
    new_im = get_cropped_image(imfile,row_num, col_num);
    %imshow(new_im)

    %%
    centers = get_centers(new_im);
    for cen_idx = 1:size(centers,1)
        text(centers(cen_idx,1), centers(cen_idx,2), num2str(cen_idx))
    end
    %%
    bcd_matrix = get_bcd_matrix(new_im, centers, edge_threshold_x, row_num, col_num);


    %%
    out_mast = [];
    dec_mast = [];
    for ordinal_idx = 1:2
        [bcd_words, new_row, out_mat, dec_mat] = extract_bcd_words(new_im, bcd_matrix, barker_code, length_of_word, num_words, ordinal_idx, images(im_idx).name);
        if ordinal_idx == 1 %only add for the first time (theya re all the same)
            register_table = [register_table; new_row(2,:)];
        end
        out_mast = [out_mast;out_mat];
        dec_mast = [dec_mast; dec_mat];
        
    end
    if sum(diff(dec_mast,size(dec_mast,1)-1))~=0
        register_table.Warning_not_consistent_Barker{end} = 1;
    end
    bcd_struct(im_idx).bcd_matrix = bcd_matrix;
    %decode_dec_mast()%This decodes the image using the tables
end
