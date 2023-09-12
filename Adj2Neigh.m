function [neighbor] = Adj2Neigh(Adj)       
    NA = size(Adj,1);
    NP = size(Adj,2);
      
    tmp = Adj;
    tmp(tmp~=0) = 1;
    neigh_num = sum(tmp,1);
    neigh_max = max(neigh_num);
    
    neighbor = zeros(NA,neigh_max);
    
    for i =1:NA
        num = 0;
        for r =1:NP
            if Adj(i,r) ~= 0
                num = num +1;
                neighbor(i,num) =r;
            end
        end
    end
end