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
B = spones(A&A');  % bidirectional  %������ת����ϡ����ʽ�����ҷ���Ԫ�ػ�Ϊ1
U = A - B; % unidirectional
G = A | A';  %�����㣬������һ�������򷵻�1�����򷵻��㡣
