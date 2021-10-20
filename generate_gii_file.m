addpath('G:\My Drive\PhD\Speed vs accuracy\Script\gifti-1.8')
atlas_L = gifti('L.annotation.label.gii');
atlas_R = gifti('R.annotation.label.gii');
surf_L=gifti('Q1-Q6_RelatedParcellation210.L.midthickness_MSMAll_2_d41_WRN_DeDrift.32k_fs_LR.surf.gii');
surf_R=gifti('Q1-Q6_RelatedParcellation210.R.midthickness_MSMAll_2_d41_WRN_DeDrift.32k_fs_LR.surf.gii');
folder = 'G:\My Drive\PhD\Speed vs accuracy\Manuscript\New\Figure\Ability Areas\';
%cdata
load('ability.mat') %% load atlas
feat = ability;
for j = 1:3
    mode=(feat(:,j));
    show_L=atlas_L;
    show_L.cdata=show_L.cdata*0;
    show_R=atlas_R;
    show_R.cdata=show_R.cdata*0;
    for i=1:180
        temp=[];
        pos=find(atlas_L.cdata==i);
        show_L.cdata(pos)=mode(180+i);
        temp=[];
        pos=find(atlas_R.cdata==i);
        show_R.cdata(pos)=mode(i);
    end
    baseFileName_L = sprintf('Ability_L_%d.func.gii', j);
    fullMatFileName_L = fullfile(folder, baseFileName_L);
    baseFileName_R = sprintf('Ability_R_%d.func.gii', j);
    fullMatFileName_R = fullfile(folder, baseFileName_R);
    save(show_L,fullMatFileName_L,'ExternalFileBinary'); 
    save(show_R,fullMatFileName_R,'ExternalFileBinary'); 
end