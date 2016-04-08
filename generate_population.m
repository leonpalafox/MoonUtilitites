function pop_array = generate_population(image_val, n_rows, n_cols, population_size)
[im_rows, im_cols] = size(image_val);
pop_array = zeros(im_rows, im_cols, population_size);
x_ar = floor((im_cols-12-1).*rand(n_rows*n_cols,population_size)+1);
y_ar = floor((im_rows-20-1).*rand(n_rows*n_cols,population_size)+1);
state = binornd(1,0.5,[n_rows*n_cols,population_size]);
for pop_idx = 1:population_size
    test_im = generate_image(x_ar(:, pop_idx), y_ar(:, pop_idx), state(:, pop_idx), image_val);
    pop_array(:,:, pop_idx) = test_im;
end