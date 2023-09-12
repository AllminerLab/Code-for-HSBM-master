function [CommVertices,CommStubs,EdgeMatrix] = UpdateMatrices(vertex,from,destination,Degree,NeighborSet_noself,SelfEdge,CommVertices,CommStubs,EdgeMatrix)
% usage:  
%      --- [CurrentCommVertices_A,CurrentCommStubs_A,CurrentEdgeMatrix_A] = ...
%                      UpdateMatrices(ChangeSet_A(MaxVertex),CurrentState_A(ChangeSet_A(MaxVertex)),MaxPriority,...
%                      Degree_A,NeighborSet_noself_A,SelfEdge_A,CurrentCommVertices_A,CurrentCommStubs_A,CurrentEdgeMatrix_A);
                

    clt_num = length(CommVertices);
    
    %% 更新 CommVertices 和 CommStubs
    CommVertices(from) = CommVertices(from) - 1;
    CommVertices(destination) = CommVertices(destination) +1;
    
    CommStubs(from) = CommStubs(from) - Degree(vertex);  
    CommStubs(destination) = CommStubs(destination) + Degree(vertex); 
    
    %% 更新 EdgeMatrix
    for t = 1:clt_num
        if t ~= from && t~= destination
            EdgeMatrix(from,t) = EdgeMatrix(from,t) - NeighborSet_noself(t);  
            EdgeMatrix(t,from) = EdgeMatrix(t,from) - NeighborSet_noself(t);
            EdgeMatrix(destination,t) = EdgeMatrix(destination,t) + NeighborSet_noself(t);
            EdgeMatrix(t,destination) = EdgeMatrix(t,destination) + NeighborSet_noself(t);
        end
    end
    
    EdgeMatrix(from,from) = EdgeMatrix(from,from) - NeighborSet_noself(from) - SelfEdge;
    EdgeMatrix(destination,destination) = EdgeMatrix(destination,destination) + NeighborSet_noself(destination) + SelfEdge;
    
    EdgeMatrix(from,destination) = EdgeMatrix(from,destination) - NeighborSet_noself(destination) + NeighborSet_noself(from);
    EdgeMatrix(destination,from) = EdgeMatrix(destination,from) - NeighborSet_noself(destination) + NeighborSet_noself(from);
    

end