function [leadingEdge, trailingEdge] = edge(groundtruth)

temp_ = diff(groundtruth);
leadingEdge = find(temp_ == 2);
trailingEdge = find(temp_ == -2);

end