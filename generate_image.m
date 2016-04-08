function out_im = generate_image(x_ar, y_ar, state_ar, image_test)
%first create canvas
%find smaller x and y
%find larger x and y
dot_size_x = 12;
dot_size_y = 20;
[im_rows, im_cols] = size(image_test);
out_im = ones(im_rows, im_cols);
for sq_idx = 1:size(x_ar,1)
    if state_ar(sq_idx,1)==1
        out_im(y_ar(sq_idx,1):y_ar(sq_idx,1)+dot_size_y, x_ar(sq_idx,1):x_ar(sq_idx,1)+dot_size_x) = 0;
    end
end
