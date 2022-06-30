hc_tuning=load('hc_tuning_dir.mat');
figure('units','inches','position',[2 3 10 10])
hold on

for i=1:length(hc_tuning.AM_HC_index)
    q_x=hc_tuning.kino_loci(i,1);
    q_y=hc_tuning.kino_loci(i,3);
    t_x=hc_tuning.tuning_dir(i,1);
    t_z=hc_tuning.tuning_dir(i,3);
    uv_norm=norm([t_x,t_z]);
    q_u=t_x./uv_norm*2000;
    q_v=t_z./uv_norm*2000;
    if q_u>0
        x_color='r';
    else
        x_color='k';
    end
    Q=quiver(q_x,q_y,q_u,q_v,'color',x_color);
    Q.MaxHeadSize=100;
    text(q_x,q_y-300,num2str(hc_tuning.AM_HC_index(i)),'interpreter','none')
end
xlabel('X position')
xlim([9.5e4 10.9e4]*4)
ylabel('Z position')
ylim([8800 9800]*60)
AxisFormat;
export_svg_jpg('HC_tuning_vector_topography')