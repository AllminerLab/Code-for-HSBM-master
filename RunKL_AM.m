function[BestState_A,MaxScore] = RunKL_AM(Adj_A,Adj_M,GT_A,clt_num,Degree_A,Degree01_A,NeighborList_A,Degree_M,Degree01_M,NeighborList_M,option_init)
% usage: [BestState_A,MaxScore] = hsbm_RunKL_0621(Adj_A,Adj_M,GT_A,clt_num,....
%                                  Degree_A,Degree01_A,NeighborList_A,Degree_M,Degree01_M,NeighborList_M,option_init)
    
    
    % variable
    NA = length(Adj_A);
    prevMaxScore = -realmax('double');
    tolerance = 0.00000001;  % 防止由于数值错误造成的循环
    
    [BestState_A] = Initialize(Adj_A,GT_A,option_init);

    NMIValue_A = NMI(GT_A,BestState_A);
    fprintf('The cluster of initialize method! NMIValue_A = %d \n',NMIValue_A)
    
    % compute matrix
    [BestCommVertices_A,BestCommStubs_A,BestEdgeMatrix_A] = ...
        ComputeMatrix(Adj_A,clt_num, BestState_A,Degree_A,Degree01_A,NeighborList_A);
    [BestCommVertices_M,BestCommStubs_M,BestEdgeMatrix_M] = ...
        ComputeMatrix(Adj_M,clt_num, BestState_A,Degree_M,Degree01_M,NeighborList_M);
    % Compute initial score
    MaxScore = ComputeInitialScore(BestCommStubs_A,BestEdgeMatrix_A)+ ComputeInitialScore(BestCommStubs_M,BestEdgeMatrix_M);
    Iter1 = 0;
    while MaxScore >= prevMaxScore + tolerance
        Iter1 = Iter1+1;
        fprintf('Iter1: %d \n',Iter1)
        fprintf('Max score is: %d \n',MaxScore)
        
        % -----代换开始---------
 		CurrentScore = MaxScore;
        prevMaxScore = MaxScore;
        MaxIndex = -1;   
        
        CurrentState_A = BestState_A;
        ChangeSet_A = 1:NA;   % need update
        UpdateIndex_A = -1 *ones(1,NA);    % need update
        
        CurrentCommVertices_A = BestCommVertices_A;
        CurrentCommStubs_A = BestCommStubs_A;
        CurrentEdgeMatrix_A = BestEdgeMatrix_A;
        CurrentCommVertices_M = BestCommVertices_M;
        CurrentCommStubs_M = BestCommStubs_M;
        CurrentEdgeMatrix_M = BestEdgeMatrix_M;
        % -----代换结束---------
        
        UpA = 1; % the number of nodes have been updated
        
        % -----Loop. 每次移动一个节点，同时更新ChangeSet
        for i = 1 : NA
            iter1 = i;
            MaxVertex = 0; % the index of maxratio
            MaxRatio = -realmax('double');
            MaxPriority = 0; 
            
            % ----Loop：selecte the optimal node to move 
            for jA = 1 : NA - UpA + 1
                iter2_A = jA;
                Priority = 0;
                ProposalRatio = -realmax('double');
                % compute neighborset         
                [NeighborSet_noself_A,SelfEdge_A] = ...
                    ComputeNeighborSet(ChangeSet_A(jA),Adj_A,clt_num,NeighborList_A,CurrentState_A);   
                [NeighborSet_noself_M,SelfEdge_M] = ...
                    ComputeNeighborSet(ChangeSet_A(jA),Adj_M,clt_num,NeighborList_M,CurrentState_A);  
 
                % Loop: choose the max increment
                for k =1:clt_num
                    iter_k_A = k;
                    if k ~= CurrentState_A(ChangeSet_A(jA))
                        % compute value
                        value1 = ComputeProposal(ChangeSet_A(jA),CurrentState_A(ChangeSet_A(jA)),k,...
                            Degree_A,NeighborSet_noself_A,CurrentEdgeMatrix_A,CurrentCommStubs_A,SelfEdge_A);
                        value2 = ComputeProposal(ChangeSet_A(jA),CurrentState_A(ChangeSet_A(jA)),k,...
                            Degree_M,NeighborSet_noself_M,CurrentEdgeMatrix_M,CurrentCommStubs_M,SelfEdge_M);
                        value_A = value1 + value2; % 
                        if value_A > ProposalRatio
                            Priority = k;
                            ProposalRatio = value_A; 
                        end
                    end
                end
                
                % max ratio
                if ProposalRatio > MaxRatio
                    MaxVertex = jA;
                    MaxRatio = ProposalRatio;
                    MaxPriority = Priority;
                end 
            end

            % ---- Loop end
            
            % move this node
            % compute neighborset 
            [NeighborSet_noself_A,SelfEdge_A] = ...
                ComputeNeighborSet(ChangeSet_A(MaxVertex),Adj_A,clt_num,NeighborList_A,CurrentState_A);              
            [NeighborSet_noself_M,SelfEdge_M] = ...
                ComputeNeighborSet(ChangeSet_A(MaxVertex),Adj_M,clt_num,NeighborList_M,CurrentState_A);              
 
            % Update matrix
            [CurrentCommVertices_A,CurrentCommStubs_A,CurrentEdgeMatrix_A] = ...
                UpdateMatrices(ChangeSet_A(MaxVertex),CurrentState_A(ChangeSet_A(MaxVertex)),MaxPriority,...
                Degree_A,NeighborSet_noself_A,SelfEdge_A,CurrentCommVertices_A,CurrentCommStubs_A,CurrentEdgeMatrix_A);
            [CurrentCommVertices_M,CurrentCommStubs_M,CurrentEdgeMatrix_M] = ...
                UpdateMatrices(ChangeSet_A(MaxVertex),CurrentState_A(ChangeSet_A(MaxVertex)),MaxPriority,...
                Degree_M,NeighborSet_noself_M,SelfEdge_M,CurrentCommVertices_M,CurrentCommStubs_M,CurrentEdgeMatrix_M);


            % move node to new group
            CurrentState_A(ChangeSet_A(MaxVertex)) = MaxPriority;
            
            % compute current score
            CurrentScore = 2*CurrentScore + MaxRatio;  
            UpdateIndex_A(ChangeSet_A(MaxVertex)) = UpA; 
            
            tempvertex = ChangeSet_A(MaxVertex);
            ChangeSet_A(MaxVertex) = ChangeSet_A(NA-UpA+1);  
            ChangeSet_A(NA-UpA+1) = tempvertex;
            
            UpA = UpA + 1;

            
            if CurrentScore > MaxScore
                MaxScore = CurrentScore;  
                MaxIndex_A = UpA-1;  
                MaxIndex = i;  
            end   
        end
        
        % check
            if UpA-1 == NA
                fprintf('All nodes have been moved.\n');
            else
                fprintf('SOMETHING WRONG HAS OCCURRED STOP! ')
                fprintf('Author moved, UpAuthor-1 = %d \n',UpA-1)
            end   
        
        if MaxIndex ~= -1
            for iA = 1:NA
                if UpdateIndex_A(iA) <= MaxIndex_A                   
                    [NeighborSet_noself_A,SelfEdge_A] = ComputeNeighborSet...
                        (iA,Adj_A,clt_num,NeighborList_A,BestState_A);   
                    [NeighborSet_noself_M,SelfEdge_M] = ComputeNeighborSet...
                        (iA,Adj_M,clt_num,NeighborList_M,BestState_A);  
               
                    % Update matrices
                    [BestCommVertices_A,BestCommStubs_A,BestEdgeMatrix_A] = ...
                        UpdateMatrices(iA,BestState_A(iA),CurrentState_A(iA),...
                        Degree_A,NeighborSet_noself_A,SelfEdge_A,BestCommVertices_A,BestCommStubs_A,BestEdgeMatrix_A);   
                    [BestCommVertices_M,BestCommStubs_M,BestEdgeMatrix_M] = ...
                        UpdateMatrices(iA,BestState_A(iA),CurrentState_A(iA),...
                        Degree_M,NeighborSet_noself_M,SelfEdge_M,BestCommVertices_M,BestCommStubs_M,BestEdgeMatrix_M);   

                    % update BestState
                    BestState_A(iA) = CurrentState_A(iA);
                end
            end
        
        end   
        return;
    end
end