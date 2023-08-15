function [leadingEdge, trailingEdge] = edge(groundtruth)

temp_ = diff(groundtruth);
leadingEdge = find(temp_ == 1) + 1;    
trailingEdge = find(temp_ == -1) + 1;

end