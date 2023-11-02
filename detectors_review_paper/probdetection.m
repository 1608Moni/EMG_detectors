function [pd] = probdetection(BinaryOp)

pd = sum(BinaryOp,2) / length(BinaryOp(1,2001:end));

end