aff_tuning=load('aff_info.mat');
aff_N=dir('*_R_*.csv');
aff_tuning.soma_loci=zeros(length(aff_N),3);
soma_='soma';
for i=1:length(aff_N)
    T=readtable(aff_N(i).name);
    if iscell(T.tags)
        soma_index=find(contains(T.tags,soma_));
        aff_skid=T.skeleton_id(1);
        tuning_index=find(aff_tuning.skid_aff==aff_skid);
        if length(soma_index)~=1
            warning([aff_N(i).name ' has more than one soma loci'])
        end
        aff_tuning.soma_loci(tuning_index,:)=[T.x(soma_index),T.y(soma_index),T.z(soma_index)];
    else
        warning([aff_N(i).name ' has no soma loci'])
    end
end

% color_rgb=[255,255,204;194,230,153;120,198,121;35,132,67]./255;
% color_rgb=[166,206,227;31,120,180;178,223,138;51,160,44]./255;
color_rgb=[166,206,227;31,120,180;178,223,138;51,160,44]./255;

figure('units','inches','position',[2 3 10 10])
hold on;
for i=1:length(aff_tuning.aff_names)
    if aff_tuning.soma_loci(i,1)~=0
        q_x=aff_tuning.soma_loci(i,1);
        q_y=aff_tuning.soma_loci(i,3);
        for j=1:length(aff_tuning.all_aff_tuning{i,1})
        q_u=aff_tuning.all_aff_tuning{i,1}(j);
        q_v=aff_tuning.all_aff_tuning{i,2}(j);
       	color=color_rgb(aff_tuning.striola_index{i}(j),:);
        quiver(q_x,q_y,q_u*2000,q_v*2000,'color',color,'MaxHeadSize',10,'LineWidth',2)
        end
    else
        nullindex=i;
    end
end
aff_tuning.myel=zeros(length(aff_tuning.aff_names),1);
index_num=1:length(aff_tuning.aff_names);
index_num=index_num';
for i=1:length(aff_tuning.aff_names)
    if strcmp(aff_tuning.aff_names{i}(end-2),'_')
        aff_tuning.myel(i)=1;
    end
end
scatter(aff_tuning.soma_loci(aff_tuning.myel==1,1),...
    aff_tuning.soma_loci(aff_tuning.myel==1,3),'k','filled');
unmyel_color=[0.6 0.6 0.6];
scatter(aff_tuning.soma_loci(aff_tuning.myel~=1&index_num~=nullindex,1),...
    aff_tuning.soma_loci(aff_tuning.myel~=1&index_num~=nullindex,3),'MarkerFaceColor',unmyel_color,...
    'MarkerEdgeColor',unmyel_color);
xlabel('Soma/Tuning: X (L-C)')
ylabel('Soma/Tuning: Z (R-C)')
AxisFormat;
export_svg_jpg('aff_soma_XZ')
save('aff_info.mat','-struct','aff_tuning')
figure('units','inches','position',[2 3 10 10])
hold on;
scatter(aff_tuning.soma_loci(aff_tuning.myel==1,1),...
    aff_tuning.soma_loci(aff_tuning.myel==1,3),'k','filled');
unmyel_color=[0.6 0.6 0.6];
scatter(aff_tuning.soma_loci(aff_tuning.myel~=1&index_num~=nullindex,1),...
    aff_tuning.soma_loci(aff_tuning.myel~=1&index_num~=nullindex,3),'MarkerFaceColor',unmyel_color,...
    'MarkerEdgeColor',unmyel_color);
xlabel('Soma/Tuning: X (L-C)')
ylabel('Soma/Tuning: Z (R-C)')
AxisFormat;
export_svg_jpg('aff_soma_XZ_solid')
% figure('units','inches','position',[2 3 10 10])
% hold on;
% for i=1:length(aff_tuning.aff_names)
%     if aff_tuning.soma_loci(i,1)~=0
%         q_x=aff_tuning.soma_loci(i,1);
%         q_y=aff_tuning.soma_loci(i,3);
%         
%         q_u=aff_tuning.mean_aff_tuning(i,1);
%         q_v=aff_tuning.mean_aff_tuning(i,3);
%         quiver(q_x,q_y,q_u*2000,q_v*2000,'color','k','MaxHeadSize',10)
%        
%     end
% end
% xlabel('Soma/Tuning: X (L-C)')
% ylabel('Soma/Tuning: Z (R-C)')
% AxisFormat;
% export_svg_jpg('aff_soma_XZ')
% figure('units','inches','position',[2 3 10 10])
% hold on;
% for i=1:length(aff_tuning.aff_names)
%     if aff_tuning.soma_loci(i,1)~=0
%         q_x=aff_tuning.soma_loci(i,1);
%         q_y=aff_tuning.soma_loci(i,2);
%         q_u=aff_tuning.aff_tuning(i,1);
%         q_v=aff_tuning.aff_tuning(i,3);
%         quiver(q_x,q_y,q_u*2000,q_v*2000,'color','k','MaxHeadSize',10)
%     end
% end
% xlabel('Soma/Tuning: X (L-C)')
% ylabel('Soma: Y (D-V)/Tuning: Z (R-C)')
% AxisFormat;
% export_svg_jpg('aff_soma_XY')
% 
% figure('units','inches','position',[2 3 10 10])
% hold on;
% for i=1:length(aff_tuning.aff_names)
%     if aff_tuning.soma_loci(i,1)~=0
%         q_x=aff_tuning.soma_loci(i,2);
%         q_y=aff_tuning.soma_loci(i,3);
%         q_u=aff_tuning.aff_tuning(i,1);
%         q_v=aff_tuning.aff_tuning(i,3);
%         quiver(q_x,q_y,q_u*2000,q_v*2000,'color','k','MaxHeadSize',10)
%     end
% end
% xlabel('Soma: Y (D-V)/Tuning: X (L-C)')
% ylabel('Soma/Tuning: Z (R-C)')
% AxisFormat;
% export_svg_jpg('aff_soma_YZ')