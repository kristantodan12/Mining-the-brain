load('sub_all.mat')
structures = importdata('struct.mat');
behaviors = importdata('behav.mat');
folder = 'G:\My Drive\PhD\Speed vs accuracy\Script\crossval\30realizations';
for r = 1:30
    fprintf('\n Realization # %6.3f',r);
    g1 = find(sub_all(:,r)==1);
    g2 = find(sub_all(:,r)==2);
    behav1 = behaviors(g1,:);
    behav2 = behaviors(g2,:);
    for i = 1:4
        fprintf('\n Structure # %6.3f',i);
        structure1 = structures(g1,:,i);
        structure2 = structures(g2,:,i);
        for j = 1:15
            behavior1 = behaviors(g1,j);
            behavior2 = behaviors(g2,j);
            [r1, p1] = corr(behavior1,structure1,'rows','complete');
            [r2, p2] = corr(behavior2,structure2,'rows','complete');
            feat_1 = zeros(360,1);
            feat_2 = zeros(360,1);
            idx_1 = find(p1 < 0.05);
            idx_2 = find(p2 < 0.05);
            feat_1(idx_1) = 1;
            feat_2(idx_2) = 1;
            feat_all1(:,i,j) = feat_1;
            feat_all2(:,i,j) = feat_2;
        end
    end
    feat1 = squeeze(sum(feat_all1,2));
    feat2 = squeeze(sum(feat_all2,2));
    feat1(feat1>0) = 1;
    feat2(feat2>0) = 1;
    for i = 1:15
    a_1 = find(feat1(:,i)>0);
        for j = 1:15
            b_1 = find(feat1(:,j)>0);
            c_1 = intersect(a_1,b_1);
            d_1 = length(c_1)/(length(a_1)+length(b_1)-length(c_1));
            IOU_1(i,j) = d_1;
        end
    end
    for i = 1:15
    a_2 = find(feat2(:,i)>0);
        for j = 1:15
            b_2 = find(feat2(:,j)>0);
            c_2 = intersect(a_2,b_2);
            d_2 = length(c_2)/(length(a_2)+length(b_2)-length(c_2));
            IOU_2(i,j) = d_2;
        end
    end
    baseFileName_1 = sprintf('IOU_G1_R%d.txt', r);
    fullMatFileName_1 = fullfile(folder, baseFileName_1);
    dlmwrite(fullMatFileName_1,IOU_1); 
    baseFileName_2 = sprintf('IOU_G2_R%d.txt', r);
    fullMatFileName_2 = fullfile(folder, baseFileName_2);
    dlmwrite(fullMatFileName_2,IOU_2); 
    behav_1 = sprintf('behav_G1_R%d.txt', r);
    behavMatFileName_1 = fullfile(folder, behav_1);
    dlmwrite(behavMatFileName_1,behav1); 
    behav_2 = sprintf('behav_G2_R%d.txt', r);
    behavMatFileName_2 = fullfile(folder, behav_2);
    dlmwrite(behavMatFileName_2,behav2); 
end