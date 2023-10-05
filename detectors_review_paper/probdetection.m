function [pd] = probdetection(BinaryOp)

pd = length(find(BinaryOp(2001:end) == 1)) / length(BinaryOp(2001:end));

end