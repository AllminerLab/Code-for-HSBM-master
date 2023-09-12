function result = Evaluation4(A, gt,comm)
    % EdMot:  result = Evaluation4(LCC0,ty_lcc,com)   
    % result = Evaluation4(A,gt,label_final)
    NMIValue = NMI(gt,comm);
    Modularity= getModularity(A,comm);
    F1 = F1Over(gt, comm);
    JC = JCOver(gt, comm);
    Pty = Purity(gt, comm);
    ACC = GetACC(gt, comm);

    result = [NMIValue,ACC,F1,Modularity,JC,Pty];

end