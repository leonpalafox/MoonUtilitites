clear
read_path = '/Volumes/Surveyor/Processed Folders/Surveyor VIIGA';
%read_path = '/Volumes/Surveyor/Surveyor VIIG';
main_path = pwd;
path_file = fullfile(main_path, 'Surveyor VIIG');
old_Area = 0.1;
error_list = [];
err_idx = 1;
for folder_surv_idx = 1165:1165
    folder_name = ['VIIG_', num2str(folder_surv_idx, '%02i')];
    surv_path = fullfile(read_path, folder_name,'Basic Crop');

    width_m = 1928;
    height_m = 1895;

    if ~exist(fullfile(path_file, folder_name, 'crop'), 'file')
        mkdir(fullfile(path_file, folder_name, 'crop'))
    end
    if ~exist(fullfile(path_file, folder_name, 'matlab_aligned'), 'file')
        mkdir(fullfile(path_file, folder_name,'matlab_aligned'))
    end
    save_path = fullfile(path_file, folder_name, 'crop');
    save_path_2 = fullfile(path_file, folder_name, 'matlab_aligned');
        for file_idx = 2:1000
            imname = [folder_name,'_',num2str(file_idx, '%04i'), '_c.tif'];
            imfile = fullfile(surv_path,imname);
            if exist(imfile, 'file')
                I = imread(imfile);
                [n_rows, n_cols] = size(I);
                J = wiener2(I,[10 10]);
                contrastAdjusted = imadjust(gather(J));
                marker = imerode(contrastAdjusted, strel('line',10,0));
                Iclean = imreconstruct(marker, contrastAdjusted);
                level = graythresh(Iclean);
                [centers, radii, metric] = imfindcircles(I,[25 40]);
                %find the leftmost center (smallest X)
                [left_center, index_left] = min(centers(:,1));
                %hard coded values
                %center to edge: 314
                cent_edge = 314;
                width = 1850;
                height = 1830;
                %base to center of circle
                base_center = 990;
                point_in_edge_x = centers(index_left,1) + cent_edge;
                point_in_edge_y = centers(index_left,2);
                upper_x_corner = point_in_edge_x;
                upper_y_corner = point_in_edge_y - height + base_center;
                A=imcrop(I, [coord(1), coord(2), width, height]);
                file_name = ['crop_', imfile];
                imwrite(A, fullfile(save_path,imname))
            end
        end
end
