function [B, U, G] = DirectionalBreakup(A)
% DIRECTIONALBREAKUP returns the bidirectional, unidirectional, and
% undirected versions of the adjacency matrix A.
%
% [B, U, G] = DirectionalBreakup(A) returns
%   B: the bidirectional subgraph
%   U: the unidirectional subgraph
%   G: the undirected graph
%
%  Note that G = B + U

A(find(A)) = 1;
B = spones(A&A');  % bidirectional  %将矩阵转化成稀疏形式，并且非零元素化为1
U = A - B; % unidirectional
G = A | A';  %或运算，至少有一个非零则返回1，否则返回零。
