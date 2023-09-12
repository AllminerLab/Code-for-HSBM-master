function [BestCommVertices,BestCommStubs,BestEdgeMatrix] = ComputeMatrix(adj,clt_num,BestState,Degree,Degree01,NeighborList)
    % usage:
    %         -- [BestCommVertices,BestCommStubs,BestEdgeMatrix] = ...
    %            ComputeMatrix(adj,clt_num, BestState,Degree,Degree01,NeighborList)
    
    
    K = clt_num;
    N = size(adj,1);
    
    BestCommVertices = zeros(1,K);
    BestCommStubs = zeros(1,K);
    BestEdgeMatrix = zeros(K,K);    
    


    for i = 1:N
        BestCommVertices(BestState(i)) = BestCommVertices(BestState(i)) + 1;
        BestCommStubs(BestState(i)) = BestCommStubs(BestState(i)) + Degree(i); 
    end
     


    for i= 1:N
        for j = 1 : Degree01(i) 
            neighbor = NeighborList(i,j);
            BestEdgeMatrix(BestState(i),BestState(neighbor)) = BestEdgeMatrix(BestState(i),BestState(neighbor)) + adj(i,neighbor);
            if BestState(neighbor) ~= BestState(i) 
                BestEdgeMatrix(BestState(i),BestState(neighbor)) = BestEdgeMatrix(BestState(i),BestState(neighbor)) + adj(i,neighbor);
            end
            if neighbor == i
                BestEdgeMatrix(BestState(i),BestState(neighbor)) = BestEdgeMatrix(BestState(i),BestState(neighbor)) + adj(i,neighbor);
            end
        end
    end
    BestEdgeMatrix = BestEdgeMatrix/2;
    
    tmp = diag(BestEdgeMatrix);
    sum_all = sum(sum(BestEdgeMatrix));
    sum_all = sum_all+ sum(tmp);    

    
end