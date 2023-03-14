function [LRatio, Pmove, Prest] = likeihoodratio(binop,t0,Wshift)
t0 = t0/Wshift;

Pmove = sum(binop(t0:end))/length(binop(t0:end));
Prest = sum(binop(1:t0-1))/length(binop(1:t0-1));

LRatio = (Pmove-Prest)/(1+Prest);

% if isnan(LRatio)
%    LRatio = 0; 
% end

end