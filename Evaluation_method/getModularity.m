function [modularity] = getModularity(adj_mat,partition)
%
% Author - Zhiqiang Xu, 05/2012
%
% Email  - zxu1@e.ntu.edu.sg
% 
% Description - evaluates the structure of the 
%               resulting clustering;
%               modularity is to measure structure quality 
%
% Input  - adj_mat    : adjacency matrix
%        - partition  : the final posterior distribution of the cluster labels
%
% Output - modularity : scalar
%        
% -------------------------------------------------------------------------  
% --------------------------º∆À„Modularity-----------------------------------------------
    cltId = unique(partition);
    N = length(partition);
    K = length(cltId);   

	% -----------------------modularity------------------------
    M = sum(adj_mat(:));    
    
    rho = zeros(K);    
    clt = true(N,K);
    cltSize = zeros(K,1);
    for k = 1:K
        clt(:,k) = logical(partition==cltId(k));
        cltSize(k) = sum(clt(:,k));
        rho(k,k)   = sum(sum(adj_mat(clt(:,k),clt(:,k))))/M;
    end    
    for i = 1:(K-1)        
        for j = (i+1):K            
            rho(i,j) = sum(sum(adj_mat(clt(:,i),clt(:,j))))/M;
            rho(j,i) = rho(i,j);
        end
    end
    
    alpha = sum(rho,2);
    modularity = sum(diag(rho)-alpha.^2);