function [ratiovalue] = ComputeProposal(vertex,from,destination,Degree,NeighborSet,CurrentEdgeMatrix,CurrentCommStubs,SelfEdge)  
    % usage:  
    %     --- [ratiovalue_A] = ComputeProposal(vertex,from,destination,Degree_A,NeighborSet_noself_A,CurrentEdgeMatrix_A,CurrentCommStubs_A,SelfEdge_A)  
    
    clt_num = length(CurrentCommStubs);
    
    if from == destination
        ratiovalue = 0;
        return;        
    end
        
    if Degree(vertex) == 0
        ratiovalue = 0;
        return;
    end       
    
    ratiovalue = 0;
    
    %% 计算交叉项，即包含t的项
    for t = 1:clt_num
        if t ~= from && t ~= destination
            help1 = CurrentEdgeMatrix(from,t);                    
            help2 = CurrentEdgeMatrix(destination,t);    
            help3 = NeighborSet(t);                      
            
            ratiovalue = ratiovalue + LogFunction(help1-help3) - LogFunction(help1);  
            ratiovalue = ratiovalue + LogFunction(help2+help3) - LogFunction(help2); 
        end
    end
    
     %% 计算from-destination项，即包含r,s的项  
     help1 = CurrentEdgeMatrix(from,destination);           
     help2 = NeighborSet(from)- NeighborSet(destination);  
     
     ratiovalue = ratiovalue + LogFunction(help1 + help2) - LogFunction(help1);   
     
     %% 计算from/from项
     help1 = 2 * CurrentEdgeMatrix(from,from);   
     help2 = 2 * SelfEdge + 2 * NeighborSet(from);  %
     
     ratiovalue = ratiovalue + 0.5 * LogFunction(help1-help2) - 0.5 * LogFunction(help1);   
     
     %% 计算dest/dest项
     help1 = 2 * CurrentEdgeMatrix(destination,destination);   
     help2 = 2 * SelfEdge + 2 * NeighborSet(destination);     
     
     ratiovalue = ratiovalue + 0.5 * LogFunction(help1+help2) - 0.5 * LogFunction(help1); 
     
     
     %% 计算其他项
     help1 = CurrentCommStubs(from);   
     help2 = CurrentCommStubs(destination);  
     help3 = Degree(vertex);    
     
     ratiovalue = ratiovalue - LogFunction(help1-help3) + LogFunction(help1);  
     ratiovalue = ratiovalue - LogFunction(help2+help3) + LogFunction(help2);
     
end