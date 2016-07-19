function [bcd_matrix, bar_code] = get_bcd_matrix_extended(new_im, new_cen, edge_threshold_x, row_num, col_num, bar_centers)
%Add the code tor ad if there is a bar code or not
imshow(new_im)
hold on
dynamic_cen = new_cen;
new_cen_add = new_cen(:,1) + new_cen(:,2);%this is an identifier unique_index

edge_threshold_x = 22;
%Make the grid
%find elements inline with this leftmost element
for col_idx=1:col_num
    edge_x = min(dynamic_cen(:,1));
    index_leftmost = find(dynamic_cen(:,1) < edge_threshold_x + edge_x);
    %find respective indexes in the original array
    temp_dyn = dynamic_cen(index_leftmost,:);
    temp_dyn_add = temp_dyn(:,1)+temp_dyn(:,2);
    [void,abs_index] = ismember(temp_dyn_add,new_cen_add);
    plot(dynamic_cen(index_leftmost,1),dynamic_cen(index_leftmost,2), 'r')
    column_matrix{col_idx}.index = abs_index;
    dynamic_cen(index_leftmost,:)=[];
end

dynamic_cen = new_cen;
dyn_bar_cen = bar_centers;
edge_threshold_y = 10;
edge_y_old = 0;
bar_edge_threshold_y = 15;
bar_code = zeros(row_num,1);
for row_idx=1:row_num
    bar_flag = 0;
    edge_y = min(dynamic_cen(:,2));
    if abs(edge_y_old - edge_y) > 30 %In case there is a white line
        row_matrix{row_idx}.index = [];
        edge_y_old = edge_y_old+25;
        bar_ind_top = find(dyn_bar_cen(:,2) < bar_edge_threshold_y + edge_y_old, 1);
        
        %bar_code(row_idx) = 0;
        bar_flag = 1;
        
        if isempty(bar_ind_top)
            bar_code(row_idx) = 0;
        else
            bar_code(row_idx) = 1;
            
        end
        dyn_bar_cen(bar_ind_top, :) = [];
        continue
    end
    index_topmost = find(dynamic_cen(:,2) < edge_threshold_y + edge_y);
    %row_idx
    bar_ind_top = find(dyn_bar_cen(:,2) < edge_threshold_y + edge_y, 1);
    %check if there is a bar
    if ~isempty(edge_y) && (bar_flag~=1)
        if isempty(bar_ind_top)
            bar_code(row_idx) = 0;
        else
            bar_code(row_idx) = 1;
            
        end
    end
        %find respective indexes in the original array
    temp_dyn = dynamic_cen(index_topmost,:);
    temp_dyn_add = temp_dyn(:,1)+temp_dyn(:,2);
    [void,abs_index] = ismember(temp_dyn_add,new_cen_add);
    %plot(dynamic_cen(index_topmost,1),dynamic_cen(index_topmost,2),'b')
    row_matrix{row_idx}.index = abs_index;
    dynamic_cen(index_topmost,:)=[];
    dyn_bar_cen(bar_ind_top, :) = [];
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