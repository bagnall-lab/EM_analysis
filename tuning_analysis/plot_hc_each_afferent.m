hc_tuning=load('hc_tuning_dir.mat');
strio_info=load('cilia_striola_category.mat');
aff_table=readtable('pre_aff_table.csv');
aff_names=load('skid_names');
aff_tuning=load('aff_info.mat');
total_aff_innervated_hc=0;
total_aff_innervated_strio=0;
myel_aff_innervated_hc=0;
myel_aff_innervated_strio=0;

q_h=struct();
figure('units','inches','position',[2 3 10 10])
hold on;

% color_rgb=[223,194,125;166,97,26;1,133,113;128,205,193]./255;
color_rgb=[166,206,227;31,120,180;178,223,138;51,160,44]./255;

for i=1:length(hc_tuning.AM_HC_index)
    q_x=hc_tuning.kino_loci(i,1)-hc_tuning.tuning_dir(i,1);
    q_y=hc_tuning.kino_loci(i,3)-hc_tuning.tuning_dir(i,3);
    q_u=hc_tuning.tuning_dir(i,1);
    q_v=hc_tuning.tuning_dir(i,3);
    q_l=norm([q_u,q_v]);
    q_u=q_u./q_l;
    q_v=q_v./q_l;
    strio_index=strio_info.clust(strio_info.AM_haircell_index==hc_tuning.AM_HC_index(i));
    c=color_rgb(strio_index,:);
    q_h.handle(i)=quiver(q_x,q_y,q_u*2500,q_v*2500,'color',c,'MaxHeadSize',20,'LineWidth',0.5,'AutoScale','off');
end
xlabel('X (L-C, nm)')
ylabel('Z (R-C, nm)')
AxisFormat;

for i=6:110
    skid_aff=aff_table.(['Var' num2str(i)])(1);
    skid_name=aff_names.skid_aff_names{aff_names.skid_aff==skid_aff};
    hc_skid_tmp=aff_table.Var3(aff_table.(['Var' num2str(i)])~=0);
    hc_syn_num_tmp=aff_table.(['Var' num2str(i)])(aff_table.(['Var' num2str(i)])~=0);
    hc_skid=hc_skid_tmp(2:end);
    total_aff_innervated_hc=total_aff_innervated_hc+length(hc_skid);
    if aff_tuning.myel(aff_tuning.skid_aff==skid_aff)==1
        myel_aff_innervated_hc=myel_aff_innervated_hc+length(hc_skid);
    end
    hc_syn_num=hc_syn_num_tmp(2:end);
    T_h=struct();
    for j=1:length(hc_skid)
        check_is_hc_skid=find(aff_names.skid_hc==str2double(hc_skid{j}));
        if ~isempty(check_is_hc_skid)
        skid_AM_index=aff_names.skid_hc_index(aff_names.skid_hc==str2double(hc_skid{j}));
        if strio_info.clust(strio_info.AM_haircell_index==skid_AM_index)==4
            total_aff_innervated_strio=total_aff_innervated_strio+1;
                if aff_tuning.myel(aff_tuning.skid_aff==skid_aff)==1
                    myel_aff_innervated_strio=myel_aff_innervated_strio+1;
                end
        end
        q_h_index=find(hc_tuning.AM_HC_index==skid_AM_index);
        
        T_h.handle(j)=text(q_h.handle(q_h_index).XData,...
            q_h.handle(q_h_index).YData-900,...
            num2str(hc_syn_num(j)),'FontSize',14);
        set(q_h.handle(q_h_index),'LineWidth',2.5)
        else
            warning([hc_skid{j} ' not a hair cell'])
        end
    end
    cd('HC_cn_topo')
    export_svg_jpg(skid_name)
    cd ..
    for j=1:length(hc_skid)
        skid_AM_index=aff_names.skid_hc_index(aff_names.skid_hc==str2double(hc_skid{j}));
        q_h_index=find(hc_tuning.AM_HC_index==skid_AM_index);
        set(q_h.handle(q_h_index),'LineWidth',0.5)
        delete(T_h.handle(j))
    end
end