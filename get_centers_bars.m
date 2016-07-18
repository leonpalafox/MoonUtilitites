function [new_cen, bar_cen] = get_centers_bars(new_im)
thresh = 400;
min_thresh = 60;
min_bar_thresh = 1200;

bar_thresh = 5000;
[B,L] = bwboundaries(~new_im);
props = regionprops(L, 'Area','Centroid');
centers=cat(1, props.Centroid);
sel_idx = find([props.Area] < thresh & [props.Area] > min_thresh);
bar_idx = find([props.Area] < bar_thresh & [props.Area] > min_bar_thresh);
%imshow(new_im)
for n = 1:length(sel_idx)
    %plot(B{sel_idx(n)}(:,2), B{sel_idx(n)}(:,1), 'r')
    %plot(centers(sel_idx(n), 1),centers(sel_idx(n), 2), 'b+')
    new_cen(n,1) = centers(sel_idx(n), 1); %this holds the x
    new_cen(n,2) = centers(sel_idx(n), 2); %this holds the y
end
for n = 1:length(bar_idx)
    %plot(B{sel_idx(n)}(:,2), B{sel_idx(n)}(:,1), 'r')
    %plot(centers(sel_idx(n), 1),centers(sel_idx(n), 2), 'b+')
    bar_cen(n,1) = centers(bar_idx(n), 1); %this holds the x
    bar_cen(n,2) = centers(bar_idx(n), 2); %this holds the y
end
% index_cols = find([new_cen(:,1)]<25);
% index_rows = find([new_cen(:,2)]<25);
% plot(new_cen(index_cols,1), new_cen(index_cols,2), '+')
% plot(new_cen(index_rows,1), new_cen(index_rows,2), '*')
