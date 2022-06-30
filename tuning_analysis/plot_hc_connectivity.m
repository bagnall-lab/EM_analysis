skid_names=load('skid_names.mat');
hc_tuning=load('hc_tuning_dir.mat');
skid_names.skid_hc_index=zeros(length(skid_names.skid_hc_names),1);
hc_max_count=zeros(length(skid_names.skid_hc_names),1);
hc_total_syn=zeros(length(skid_names.skid_hc_names),1);
for i=1:length(skid_names.skid_hc_names)
skid_names.skid_hc_index(i)=str2double(skid_names.skid_hc_names{i}(end-1:end));
end
save('skid_names.mat','-struct','skid_names')
cn_table=readtable('pre_aff_table.csv');

% for i=1:length(skid_names.skid_aff)
%     
% end
table_hc_skid=cn_table.Var3(2:end);
for i=6:128
    cn_skid=cn_table.(['Var' num2str(i)])(1);
    if ismember(cn_skid,skid_names.skid_aff)
        cn_num=cn_table.(['Var' num2str(i)])(2:end);
        [~,max_index]=max(cn_num);
        cn_hc_skid=str2double(table_hc_skid(cn_num~=0));
        cn_hc_index=zeros(length(cn_hc_skid),1);
        max_hc_skid=str2double(table_hc_skid(max_index));
        max_hc_index=skid_names.skid_hc_index(skid_names.skid_hc==max_hc_skid);
        hc_max_count(max_hc_index)=hc_max_count(max_hc_index)+1;
        for j=1:length(cn_hc_skid)
            cn_hc_index(j)=skid_names.skid_hc_index(skid_names.skid_hc==cn_hc_skid(j));
        end
    end
end

for i=1:90
    hc_total_syn(skid_names.skid_hc_index(skid_names.skid_hc==str2double(cn_table.Var3(i+1))))=str2double(cn_table.Var129(i+1));
end
figure('units','inches','position',[2 3 10 10])
hold on;
scatter(hc_tuning.kino_loci(:,1),hc_tuning.kino_loci(:,3),(hc_max_count+0.1)*500,'r.')
title('Max projetion to # of hair cells')
AxisFormat;
export_svg_jpg('Max_projetion2hair_cells')
figure('units','inches','position',[2 3 10 10])
hold on;
scatter(hc_tuning.kino_loci(:,1),hc_tuning.kino_loci(:,3),(hc_total_syn+0.1)*100,'r.')
AxisFormat;
title(' # of total synapses to hair cells')
export_svg_jpg('total_synapses2hair_cells')