function [word_struct, new_row, out_mat, bcd_mat] = extract_bcd_words(new_im, bcd_matrix, barker_code, length_word, num_words, ordinal_barker, image_name)
flat_bcd = bcd_matrix(:); %This flattens the array
start_idx = findPattern(flat_bcd', barker_code);
new_row = {'Filename', 'WarningAbscenceofBarker','Warning_only_1_Barker', 'Warning_not_consistent_Barker'; image_name, 0,0,0 };
if length(start_idx)<2
    warning('Something might be wrong, there is only 1 Barker Code');
    new_row{2,3}=1;
    
elseif isempty(start_idx)
    warning('I couldn not find any Barker Code');
    word_struct = [];
    new_row{2,2}=1;
    return
end
colored_bcd = bcd_matrix;
for color_idx = 1:length(start_idx)
    [x_ind, y_ind] = ind2sub(size(bcd_matrix),start_idx(color_idx));
    colored_bcd(x_ind, y_ind) = 5;
end
% figure
% subplot(1,2,1)
% imshow(new_im)
% subplot(1,2,2)
% imagesc(colored_bcd)

%first word is the barker code
start_idx = start_idx(ordinal_barker);
out_mat=[];
bcd_mat = [];
for word_idx = 1:num_words
    bin_word = flat_bcd(start_idx:start_idx+length_word-1)';
    word_struct(word_idx).word = bin_word;
    out_mat = [out_mat,word_idx*1000+808,bin_word]; 
    bcd_mat = [bcd_mat, bi2de(bin_word(1:end-1), 'left-msb')];
    start_idx = start_idx+length_word;
end
    
    
