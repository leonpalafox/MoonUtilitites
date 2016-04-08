function [bit_chain, adjust_row] = decode_bits_profile_manual(BW, row_idx, space_in_row, space_size_m, bit_size_m, adjust_row, origin_x, orig_y)
%%Input required is the BW image

if mod(row_idx, 20)==0
    adjust_row = 4+adjust_row;
end

origin_y = orig_y + (row_idx-1)*space_in_row+adjust_row;
%get optimum inclination
end_y_center = orig_y + (row_idx-1)*space_in_row+adjust_row; %this is fixed
end_x = origin_x + 245; %this is fixed
search_range = 8;
cnt = 1;
search_vector = [end_y_center - search_range:1:end_y_center + search_range];
for y_index = end_y_center - search_range:1:end_y_center + search_range
    c(:,cnt) = ~improfile(BW,[origin_x, end_x],[origin_y, y_index]); %get the profile for the image
    cnt = cnt+1;
end
treshold_c = 2;
[gold_c, index] = max(sum(c));
 if sum(abs(sum(c)-gold_c)<=5)>=treshold_c
     work_profile = c(:,index);
 else
     disp 'Change search range'
 end
 end_y = search_vector(index); 
 line([origin_x, end_x], [origin_y, end_y])
 %%
%detect average bit length and space
% space_cnt = 0;
% bit_cnt = 0;
% space_ind = 1;
% bit_ind = 1;
% for ind = 1:length(work_profile)
%     if work_profile(ind) == 1
%         bit_cnt = bit_cnt+1;
%     else
%         space_cnt = space_cnt + 1;
%     end
%     if ind>1
%         if work_profile(ind-1)==0 && work_profile(ind)==1 %if there is an upbit
%             space_arr(space_ind) = space_cnt;
%             space_cnt = 0;
%             space_ind = space_ind + 1;
%         elseif work_profile(ind-1)==1 && work_profile(ind)==0 %if there is an down
%             bit_arr(bit_ind) = bit_cnt;
%             bit_cnt = 0;
%             bit_ind = bit_ind + 1;
%         end
%     end
% end
% bit_size = mode(bit_arr);
% space_size = mode(space_arr);
bit_size = bit_size_m;
space_size = space_size_m;
%%
%%With bit size and space size, commence decoding
bits_count = 10; %expected bits to find
word_bit = [];
space_cnt = 0;
word_ct = 1;
offset = 5;
if exist('work_profile')
if (sum(work_profile) ~= 0)
    for ind = 1:length(work_profile)
        if ind>1
            if work_profile(ind-1)==0 && work_profile(ind)==1 %if there is an upbit
                    num_zeros  = space_cnt/(space_size+bit_size);
                    [num_zeros, float_zeros] = deal(fix(num_zeros), num_zeros-fix(num_zeros));
                    if float_zeros>0.9
                        num_zeros = num_zeros + 1;
                    end
                    if num_zeros>0
                        if num_zeros+length(word_bit)+1 <= bits_count %check that the size is reasonable
                            word_bit(word_ct:word_ct+num_zeros) = 0;
                            word_ct = word_ct + num_zeros;
                        else
                            word_bit(word_ct:word_ct+num_zeros-1) = 0;
                            word_ct = word_ct + num_zeros-1;
                        end
                    end
                    word_bit(word_ct) = 1;
                    word_ct = word_ct + 1;
                    space_cnt = 0;


            elseif work_profile(ind-1)==1 && work_profile(ind)==0 %if there is an down start counting
                space_cnt = space_cnt+1;
            elseif work_profile(ind) == 0
                space_cnt = space_cnt+1;
            end


        end

    end
else
    word_bit = zeros(1, bits_count);
end
else 
    word_bit = zeros(1, bits_count);
end
bit_chain = word_bit;


%%



