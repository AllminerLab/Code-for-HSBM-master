function [NeighborSet_noself,SelfEdge] = ComputeNeighborSet(vertex,Adj,clt_num,NeighborList,State)
% usage: 
% --- [NeighborSet_noself_A,SelfEdge_A] = ComputeNeighborSet(ChangeSet_A(jA),Adj_A,clt_num,NeighborList_A,CurrentState_A);              
    
    % 计算 vertex 邻居的 index
    % NeighborIndex = find(Adj(vertex,:)~=0);
    NeighborIndex = NeighborList(vertex,:);
    NeighborIndex(NeighborIndex==0) = [];
    
    NeighborSet_noself = zeros(1,clt_num);
    for i = 1:length(NeighborIndex)
        if NeighborIndex(i)~= vertex
        NeighborSet_noself(State(NeighborIndex(i))) = NeighborSet_noself(State(NeighborIndex(i))) + Adj(vertex,NeighborIndex(i));
        end
    end
    
    SelfEdge = Adj(vertex,vertex);
   
end