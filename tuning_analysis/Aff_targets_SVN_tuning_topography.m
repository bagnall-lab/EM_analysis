aff_info=load('aff_info.mat');
cn_table=readtable('pre_SVN_table.csv');

SVN_N=dir('SuperiorVN_R_*.csv');
tuning.soma_loci=zeros(length(SVN_N),3);
skid_names=cell(length(SVN_N),1);
skid=zeros(length(SVN_N),1);
skid_cn_all=str2double(cn_table.Var3(2:end));

total_aff_innervation=0;
myel_aff_innervation=0;
soma_='soma';
for i=1:length(SVN_N)
    if ~strcmp(SVN_N(i).name,'VS_R_02.csv')
        T=readtable(SVN_N(i).name);
    else
        T=readtable('VS_R_02.xlsx');
    end
    skid_names{i}=SVN_N(i).name(1:end-4);
    if iscell(T.tags)
        soma_index=find(contains(T.tags,soma_));
        skid(i)=T.skeleton_id(1);
        tuning_index=find(aff_info.skid_aff==skid(i));
        if length(soma_index)~=1
            warning([SVN_N(i).name ' has more than one soma loci'])
        end
        tuning.soma_loci(i,:)=[T.x(soma_index),T.y(soma_index),T.z(soma_index)];
    else
        warning([SVN_N(i).name ' has no soma loci'])
    end
end

save('skid_SVN.mat','skid','skid_names','tuning');

SVN=load('skid_SVN.mat');
figure('units','inches','position',[2 3 4 4])
hold on;
all_tuning=struct();
for i=6:16
    selected_skid=cn_table.(['Var' num2str(i)])(1);
    cn_vector=cn_table.(['Var' num2str(i)])(2:end);
    cn_skid=skid_cn_all(cn_vector~=0);
    total_aff_innervation=total_aff_innervation+length(cn_skid);
    q_x=SVN.tuning.soma_loci(SVN.skid==selected_skid,3);
    q_y=-SVN.tuning.soma_loci(SVN.skid==selected_skid,2);
    
    q_u=zeros(length(cn_skid),1);
    q_v=zeros(length(cn_skid),1);
    strio_index=zeros(length(cn_skid),1);
    total_syn_num=zeros(length(cn_skid),1);
    for j=1:length(cn_skid)
        if ~isempty(aff_info.w_tuning(aff_info.skid_aff==cn_skid(j),1))
            q_u(j)=aff_info.w_tuning(aff_info.skid_aff==cn_skid(j),1);
            q_v(j)=aff_info.w_tuning(aff_info.skid_aff==cn_skid(j),2);
            strio_index(j)=aff_info.w_strio_index(aff_info.skid_aff==cn_skid(j));
            total_syn_num(j)=aff_info.total_syn_num(j);
%             color_rgb=(40-total_syn_num(j)).*[0.025 0.025 0.025];
            color_rgb=[0.7,0.7,0.7];
            
            quiver(q_x,q_y,q_u(j)*4000,q_v(j)*4000,'color',color_rgb,'MaxHeadSize',10);
            if aff_info.myel(aff_info.skid_aff==cn_skid(j))==1
            scatter(q_x+q_u(j)*4000,q_y+q_v(j)*4000,'k.')
            myel_aff_innervation=myel_aff_innervation+1;
            end
        else
            q_u(j)=nan;
            q_v(j)=nan;
            strio_index(j)=nan;
            total_syn_num(j)=nan;
        end

    end
    all_tuning(i-5).central_skid=selected_skid;
    all_tuning(i-5).cn_skid=cn_skid;
    all_tuning(i-5).q_u=q_u;
    all_tuning(i-5).q_v=q_v;
    all_tuning(i-5).strio_index=strio_index;
    all_tuning(i-5).total_syn_num=total_syn_num;
%     color_rgb=(40-nanmean(total_syn_num)).*[0.025 0.025 0.025];
%     if q_x~=0
%         quiver(q_x,q_y,nanmean(q_u)*3000,nanmean(q_v)*3000,'color',color_rgb,'MaxHeadSize',10);
%     end
if ~isempty(SVN.skid_names(SVN.skid==selected_skid))
    name_text=SVN.skid_names{SVN.skid==selected_skid};
    text(q_x-1000,q_y-1000,...
        name_text(end-1:end),'interpreter','none','FontSize',8)
end
%     text(q_x,q_y-2000,num2str(nanmean(total_syn_num)),'interpreter','none')
end
xlabel('Z (R-C)')
ylabel('Y (D-V)')
xlim([5.3e5 5.7e5])
ylim([-1.6e5 -1.35e5])
AxisFormat;
title('Superior VN')
export_svg_jpg('aff2SVN_tuning')
save('skid_SVN.mat','all_tuning','-append');

figure('units','inches','position',[2 3 6 6])
hold on;
for i=1:length(aff_info.skid_aff)
     q_u=aff_info.w_tuning(i,1);
     q_v=aff_info.w_tuning(i,2);
     q_l=norm([q_u q_v]);
%      if ismember(aff_tuning.skid_aff(i),skid_cn_all)
%          color='r';
%      else
         color='k';
%      end
     quiver(0,0,q_u./q_l,q_v./q_l,'color',color);
end
xlabel('X (L-C)')
ylabel('Z (R-C)')
AxisFormat;
export_svg_jpg('aff_tuning_selected')