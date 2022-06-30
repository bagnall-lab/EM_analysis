aff_tuning=load('aff_info.mat');
w_tuning=zeros(length(aff_tuning.aff_names),2);
w_strio_index=zeros(length(aff_tuning.aff_names),1);
total_syn_num=zeros(length(aff_tuning.aff_names),1);
tuning_dir=cell(length(aff_tuning.aff_names),1);

figure('units','inches','position',[2 3 4 4])
hold on;
for i=1:length(aff_tuning.aff_names)
    total_syn_num(i)=sum(aff_tuning.syn_num{i});
    w_tuning(i,1)=sum(aff_tuning.all_aff_tuning{i,1}.*aff_tuning.syn_num{i})/sum(aff_tuning.syn_num{i});
    w_tuning(i,2)=sum(aff_tuning.all_aff_tuning{i,2}.*aff_tuning.syn_num{i})/sum(aff_tuning.syn_num{i});
%     w_strio_index(i)=sum(aff_tuning.striola_index{i}.*syn_num{i})/sum(syn_num{i});
    q_x=aff_tuning.soma_loci(i,1);
    q_y=aff_tuning.soma_loci(i,3);
    q_u=w_tuning(i,1);
    q_v=w_tuning(i,2);
    q_l=norm([q_u q_v]);
    q_u=q_u/q_l;
    q_v=q_v/q_l;
    if q_u>sqrt(2)/2
        tuning_dir{i}='L';
        color_rgb='k';
    end
    if q_u<-sqrt(2)/2
        tuning_dir{i}='M';
        color_rgb='r';
    end
    if q_v>sqrt(2)/2
        tuning_dir{i}='R';
        color_rgb='g';
    end
    if q_v<-sqrt(2)/2
        tuning_dir{i}='C';
        color_rgb='b';
    end
%     color_rgb=(40-total_syn_num(i)).*[0.025 0.025 0.025];
    if q_x~=0
    quiver(q_x,q_y,q_u*3000,q_v*3000,'color',color_rgb,'MaxHeadSize',10,'LineWidth',1);
    end
end
scatter(aff_tuning.soma_loci(aff_tuning.myel==1,1),aff_tuning.soma_loci(aff_tuning.myel==1,3),14,'k','filled')
AxisFormat;
export_svg_jpg('aff_tuning_syn_num')
save('aff_info.mat','tuning_dir','-append');