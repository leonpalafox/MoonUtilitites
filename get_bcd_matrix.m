function bcd_matrix = get_bcd_matrix(new_im, new_cen, edge_threshold_x, row_num, col_num)
imshow(new_im)
hold on
dynamic_cen = new_cen;
new_cen_add = new_cen(:,1) + new_cen(:,2);


%Make the grid
%find elements inline with this leftmost element
for col_idx=1:col_num
    edge_x = min(dynamic_cen(:,1));
    index_leftmost = find(dynamic_cen(:,1) < edge_threshold_x + edge_x);
    %find respective indexes in the original array
    temp_dyn = dynamic_cen(index_leftmost,:);
    temp_dyn_add = temp_dyn(:,1)+temp_dyn(:,2);
    [void,abs_index] = ismember(temp_dyn_add,new_cen_add);
    plot(dynamic_cen(index_leftmost,1),dynamic_cen(index_leftmost,2))
    column_matrix{col_idx}.index = abs_index;
    dynamic_cen(index_leftmost,:)=[];
end

dynamic_cen = new_cen;
edge_threshold_y = 10;
edge_y_old = 0;
for row_idx=1:row_num
    edge_y = min(dynamic_cen(:,2));
    if abs(edge_y_old - edge_y) > 30 %In case there is a white line
        row_matrix{row_idx}.index = [];
        edge_y_old = edge_y;
        continue
    end
    index_topmost = find(dynamic_cen(:,2) < edge_threshold_y + edge_y);
    %find respective indexes in the original array
    temp_dyn = dynamic_cen(index_topmost,:);
    temp_dyn_add = temp_dyn(:,1)+temp_dyn(:,2);
    [void,abs_index] = ismember(temp_dyn_add,new_cen_add);
    plot(dynamic_cen(index_topmost,1),dynamic_cen(index_topmost,2))
    row_matrix{row_idx}.index = abs_index;
    dynamic_cen(index_topmost,:)=[];
    edge_y_old = edge_y;
end
%%
%Construct Matrix
bcd_matrix = zeros(row_num, col_num);
for row_idx = 1:row_num
    for col_idx = 1:col_num
        if ~isempty(intersect(row_matrix{row_idx}.index, column_matrix{col_idx}.index))
            bcd_matrix(row_idx, col_idx) = 1;
        end
    end
end