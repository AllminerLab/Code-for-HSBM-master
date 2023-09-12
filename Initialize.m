function [BestState] = Initialize(adj,GT,option_init)
% usage: -- [BestState] = Initialize(adj,GT,option_init)
    
    K = length(unique(GT));
    N = size(adj,1);
      
    if strcmp(option_init,'Louvain')
        [COM,~] = cluster_jl(adj);
        BestState = (COM.COM{1,1})'; 
    end
    
    if strcmp(option_init,'GT')
        BestState = ground_truth;
    end
    
    if strcmp(option_init,'Fix_Random')
        rng(K-1);
        BestState = unidrnd(K,1,N);
    end
    
    if strcmp(option_init,'random')
        BestState = round(rand(1,N)*(K-1))+1;
    end  

    if strcmp(option_init,'kmeans')
        BestState(:) = kmeans(full(adj(:,:)),K);
    end   
    
    if strcmp(option_init,'AP')
        [i,j,s] = find(adj);
        S = [i,j,s];
        p = median(s); 
        [BestState,~,~,~]= apcluster(S,p);
    end
    
    if strcmp(option_init,'Ncut')
        [NcutDiscrete,~,~] = ncutW(adj,K);
        [~,BestState] = find(NcutDiscrete);
    end
    
    if strcmp(option_init,'SC')
        [BestState, ~] = KmeansCluster(adj, K);
    end

    if strcmp(option_init,'NMF')
        BestState = NMF_getLabel(adj, K);
    end   

    
end