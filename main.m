clc
clear
run E:\eidors-v3.11-ng\eidors-v3.11-ng\eidors\startup.m;
[filename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
image = imread([pathname,filename]);
b = imresize(image,[1 1]);
imshow(image);
scalp = [];
skull = [];
CSF = [];
brain = [];

while true
    point  = ginput(1);
    if isempty(point)
        plot([scalp(1,1),scalp(end,1)],[scalp(1,2),scalp(end,2)],'red','LineWidth',1);
        break;
    end
    hold on;
    if isempty(scalp)
        plot(point(1),point(2),'o','MarkerEdgeColor','red','LineWidth',1);
    else 
        plot(point(1),point(2),'o','MarkerEdgeColor','red','LineWidth',1);
        plot([point(1),scalp(end,1)],[point(2),scalp(end,2)],'red','LineWidth',1);
    end
    scalp = [scalp;point];
end

while true
    point  = ginput(1);
    if isempty(point)
        plot([skull(1,1),skull(end,1)],[skull(1,2),skull(end,2)],'g','LineWidth',1);
        break;
    end
    hold on;
    if isempty(skull)
        plot(point(1),point(2),'o','MarkerEdgeColor','g','LineWidth',1);
    else 
        plot(point(1),point(2),'o','MarkerEdgeColor','g','LineWidth',1);
        plot([point(1),skull(end,1)],[point(2),skull(end,2)],'g','LineWidth',1);
    end
    skull = [skull;point];
end
% %%
% while true
%     point  = ginput(1);
%     if isempty(point)
%         plot([CSF(1,1),CSF(end,1)],[CSF(1,2),CSF(end,2)],'b','LineWidth',1);
%         break;
%     end
%     hold on;
%     if isempty(CSF)
%         plot(point(1),point(2),'*','MarkerEdgeColor','b','LineWidth',1);
%     else 
%         plot(point(1),point(2),'*','MarkerEdgeColor','b','LineWidth',1);
%         plot([point(1),CSF(end,1)],[point(2),CSF(end,2)],'b','LineWidth',1);
%     end
%     CSF = [CSF;point];
% end

while true
    point  = ginput(1);
    if isempty(point)
        plot([brain(1,1),brain(end,1)],[brain(1,2),brain(end,2)],'y','LineWidth',1);
        break;
    end
    hold on;
    if isempty(brain)
        plot(point(1),point(2),'o','MarkerEdgeColor','y','LineWidth',1);
    else 
        plot(point(1),point(2),'o','MarkerEdgeColor','y','LineWidth',1);
        plot([point(1),brain(end,1)],[point(2),brain(end,2)],'y','LineWidth',1);
    end
    brain = [brain;point];
end

%%
min_val = min(scalp(:,2));
max_val = max(scalp(:,2));
scalp = 2*(scalp-min_val)/(max_val-min_val)-1;
skull = 2*(skull-min_val)/(max_val-min_val)-1;
brain = 2*(brain-min_val)/(max_val-min_val)-1;
scalp = flip(scalp);
skull = flip(skull);
brain = flip(brain);
shape = { 0,                      % height
          {scalp, skull,brain}, % contours
          [4,50],                 % perform smoothing with 50 points
          0.04};                  % small maxh (fine mesh)

elec_pos = [ 16,                  % number of elecs per plane
             1,                   % equidistant spacing
             0.5]';               % a single z-plane
         
elec_shape = [0.04,               % radius
              0,                  % circular electrode
              0.01 ]';             % maxh (electrode refinement) 

fmdl = ng_mk_extruded_model(shape, elec_pos, elec_shape);
fmdl.nodes(:,2) = -fmdl.nodes(:,2);
figure;
show_fem(fmdl);
img = mk_image(fmdl,1);
img.elem_data(fmdl.mat_idx{1}) = 1;
img.elem_data(fmdl.mat_idx{2}) = 2;
img.elem_data(fmdl.mat_idx{3}) = 3;
show_fem(img);
