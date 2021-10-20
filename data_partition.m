load('family_ID_string.mat') %% Load family ID
fam_ID = family_ID_string;
u = unique(family_ID_string);
sub = zeros(838,1);
for i = 1:length(u)
    ID = u(i);
    ind = find(fam_ID==ID);
    if length(ind)==1
        sub(ind)=1;
    elseif length(ind)==2
            sub(ind(1))=2;
            sub(ind(2))=1;
    else
        sub(ind(1))=1;
         sub(ind(2:end))=2;
    end
    clear ind
end

%% extract the families
load('family_ID_string.mat')
fam_ID = family_ID_string;
u = unique(family_ID_string);
for i = 1:length(u)
    ID = u(i);
    fam_m = find(fam_ID==ID);
    fam{i} = fam_m;
end

%% partitioning to 2 groups and doing realizations
load('fam.mat')
for i = 1:15
    a = randperm(401);
    sub = zeros(838,1);
    for j = 1:401
        f_c = (fam(a(j)));
        f = cell2mat(f_c);
        if length(f)==1
            sub(f)=1;
        elseif length(f)==2
            sub(f(1))=1;
            sub(f(2))=2;
        elseif length(f)>2
            sub(f(1))=1;
            sub(f(2:end))=2;
        end     
    end
    sub_all(:,i) = sub;
    a_all(:,i) = a;
end

load('fam.mat')
for i = 1:30
    a = randi([1 2],1,401);
    sub = zeros(838,1);
    for j = 1:401
        f_c = (fam((j)));
        f = cell2mat(f_c);
        idx = a(j);
        if idx==1
            if length(f)==1
                sub(f)=1;
            elseif length(f)==2
                sub(f(1))=1;
                sub(f(2))=2;
            elseif length(f)>2
                sub(f(1))=1;
                sub(f(2:end))=2;
            end   
        elseif idx==2
            if length(f)==1
                sub(f)=2;
            elseif length(f)==2
                sub(f(1))=2;
                sub(f(2))=1;
            elseif length(f)>2
                sub(f(1))=2;
                sub(f(2:end))=1;
            end       
        end
    end
    sub_all(:,i) = sub;
end


