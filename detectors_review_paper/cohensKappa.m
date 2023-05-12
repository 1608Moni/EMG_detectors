function [kappa C] = cohensKappa(y, yhat)
    C = confusionmat(y, yhat); % compute confusion matrix
    n = sum(C(:)); % get total N
    C = C./n; % Convert confusion matrix counts to proportion of n
    r = sum(C,2); % row sum
    s = sum(C); % column sum
    expected = r*s; % expected proportion for random agree
    po = sum(diag(C)); % Observed proportion correct
    pe = sum(diag(expected)); % Proportion correct expected
%     diff1 = yhat-y;
%     if isempty(find(diff1 ~=0)) == 1
%         kappa = 1;
%     else
        kappa = (po-pe)/(1-pe); % Cohen's kappa
%     end
%       C
%      figure
%      subplot(2,1,1)
%      stairs(y,'Linewidth',1.5)
%      title('Groundtruth')
%      subplot(2,1,2)
%      stairs(yhat,'Linewidth',1.5)
%      title('Binary output')
%      txt = {strcat('cohen coeff = ',num2str(round(kappa,5)))};
%      text(1.5,0.8,txt,'FontSize',12)
end