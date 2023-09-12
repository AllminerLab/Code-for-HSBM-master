function [sum] = ComputeInitialScore(BestCommStubs_A,BestEdgeMatrix_A)
% usage: [score] = ComputeInitialScore(BestCommStubs_A,BestEdgeMatrix_A)

    clt_num = length(BestCommStubs_A);

    sum = 0;
    for r = 1:clt_num
        sum = sum - LogFunction(BestCommStubs_A(r));
        for s = r:clt_num  % 只计算了上三角
            if r ~= s
                sum = sum + LogFunction(BestEdgeMatrix_A(r,s));
            elseif r == s
                sum = sum + 0.5 * LogFunction(2 * BestEdgeMatrix_A(r,s));
            end
        end
    end
end