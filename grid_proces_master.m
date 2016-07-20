%create grid analysis
clear
%path = '/Volumes/Surveyor/Matlab Processed/Mission VII/VII_05/matlab_aligned';
path ='C:\Users\leon\Documents\Data\MoonData';
%save_path = '/Volumes/Surveyor/Matlab Processed/Mission VII/VII_05/bcd_data';
save_path = 'C:\Users\leon\Documents\Data\MoonData\bcd_data';
%filename = uigetfile(fullfile(path, '*.tif'));
images = dir(fullfile(path,'*.tif'));
%imfile = fullfile(path,filename);
%imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\V_07_0010_c.jpg';
%imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\I_04_0027_c.jpg';
%imfile = 'C:\Users\leon\Dropbox\Code\Octave\MoonUtilitites\I_04_0013_c.jpg';
%nuts and bolts
%%
edge_threshold_x = 24;
row_num = 88;
col_num = 11;
barker_code = [0 0 0 1 1 1 0 1 1 0 1];
length_of_word = 11;
num_words = 17;
register_table = cell2table(cell(1,4), 'VariableNames',{'Filename', 'WarningAbscenceofBarker','Warning_only_1_Barker', 'Warning_not_consistent_Barker'});
%main program

%%
break
frame_counter = 0;


for im_idx = 1:length(images)


    tic
    close all
    imfile = fullfile(path,images(im_idx).name);
    [time_stamp, centers_base, radii, frame_counter] = read_timestamp_interactive(imfile, frame_counter); %this also gives the centers and radii of the black dots
    frame_counter = frame_counter + 1;
    new_im = get_cropped_image_extended(imfile,row_num, col_num, radii, centers_base);

    %imshow(new_im)

    
    [centers, bar_centers] = get_centers_bars(new_im);
%     for cen_idx = 1:size(centers,1)
%         text(centers(cen_idx,1), centers(cen_idx,2), num2str(cen_idx))
%         plot(centers(cen_idx,1), centers(cen_idx,2), '+')
%         hold on
%     end
    
    [bcd_matrix, bar_code] = get_bcd_matrix_extended(new_im, centers, edge_threshold_x, row_num, col_num, bar_centers);
    csv_filename = strsplit(images(im_idx).name,'.');
    csv_filename = csv_filename(1);
    csvwrite(fullfile(save_path,[csv_filename{1},'_bcd_code.csv']), bcd_matrix)
    csvwrite(fullfile(save_path,[csv_filename{1},'_bar_code.csv']), bar_code)
    fid = fopen(fullfile(save_path,[csv_filename{1},'_timestamp.txt']), 'w'); 
    fprintf(fid, '%s', time_stamp); 
    fclose(fid);
    toc

    %%
%     out_mast = [];
%     dec_mast = [];
%     for ordinal_idx = 1:5
%         [bcd_words, new_row, out_mat, dec_mat] = extract_bcd_words(new_im, bcd_matrix, barker_code, length_of_word, num_words, ordinal_idx, images(im_idx).name);
%         if ordinal_idx == 1 %only add for the first time (theya re all the same)
%             register_table = [register_table; new_row(2,:)];
%         end
%         out_mast = [out_mast;out_mat];
%         dec_mast = [dec_mast; dec_mat];
%         
%     end
%     if sum(diff(dec_mast,size(dec_mast,1)-1))~=0
%         register_table.Warning_not_consistent_Barker{end} = 1;
%     end
%     bcd_struct(im_idx).bcd_matrix = bcd_matrix;
    %decode_dec_mast()%This decodes the image using the tables
end
e