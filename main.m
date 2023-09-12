

clear all

% 'karate','polbooks','PolBlogs','football_v2','dolphins'
load('data/karate.mat')  

KLPerNetwork = 20;
option_init = 'kmeans'; % partitioning method, which can be 'random','kmeans','AP','Ncut','SC','NMF', etc.

Adj_A = Adj;
GT_A = GroundTruth;
NA = length(Adj_A);
clt_num = length(unique(GroundTruth));

Adj_W = MotifAdjacency(Adj_A, 'm4');
Adj_M = MotifAdjacencyWeight(Adj_A,Adj_W);

[Degree_A, ~, Degree01_A, ~] = ComputeDegree(Adj_A);
[NeighborList_A] = Adj2Neigh(Adj_A);
[Degree_M, ~, Degree01_M, ~] = ComputeDegree(Adj_M);
[NeighborList_M] = Adj2Neigh(Adj_M);

Value = zeros(KLPerNetwork,2);
State_A = zeros(KLPerNetwork,NA);

% 计时
tic

HighestScore =  -realmax('double');
for j = 1:KLPerNetwork
    [BestState_A,MaxScore] = RunKL_AM(Adj_A,Adj_M,GT_A,clt_num,...
                            Degree_A,Degree01_A,NeighborList_A,...
                            Degree_M,Degree01_M,NeighborList_M,option_init);
    
    Value(j,1) = NMI(GT_A,BestState_A);
    Value(j,2) = MaxScore;
    
    State_A(j,:) = BestState_A;
    fprintf('KLPerNetwork Value_A: %d \n',Value(j,1))
    
    if MaxScore >= HighestScore
        HighestScore = MaxScore;
        SavedState_A = BestState_A;
    end
    


end

% NMIValue_A = NMI(GT_A,SavedState_A)
result_A = Evaluation4(Adj_A,GT_A,SavedState_A)



