function [Degree, Degree_noself, NeighborNum, NeighborNum_noself] = ComputeDegree(adj)
% compute degree of network

    adj1 = adj;
    adj1(adj~=0) = 1;
    
    adj_d = diag(adj);
    adj1_d = diag(adj1);
    
    Degree = sum(adj,2);
    Degree_noself = sum(adj,2) - adj_d;
    
    NeighborNum = sum(adj1,2);
    NeighborNum_noself = sum(adj1,2)-adj1_d;

end    

 