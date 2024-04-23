%testing for normality
swtest(AllMatrix(:, 1))
swtest(AllMatrix(:, 2))
swtest(AllMatrix(:, 3))
% 
% 
% 
% swtest(CSL(:, 2))
% swtest(MAM(:, 1))
% swtest(MAM(:, 2))
%   The Shapiro-Wilk and Shapiro-Francia null hypothesis is:
%   "X is normal with unspecified mean and variance."
%     H = 0 => Do not reject the null hypothesis at significance level ALPHA.
%     H = 1 => Reject the null hypothesis at significance level ALPHA.
[h] = vartest2(AllMatrix(:, 1),AllMatrix(:, 2))
[h] = vartest2(AllMatrix(:, 1),AllMatrix(:, 3))
[h] = vartest2(AllMatrix(:, 2),AllMatrix(:, 3))
% [h] = vartest2(MAM(:, 1),MAM(:, 2))
%The returned result h = 1 indicates that vartest2 rejects the null hypothesis
%Test the null hypothesis that the data in x and y comes from distributions with the same variance.
[h,p,ci,stats] = ttest2(AllMatrix(:, 1), AllMatrix(:, 2))

[h,p,ci,stats] = ttest2(AllMatrix(:, 1), AllMatrix(:, 3))

[h,p,ci,stats] = ttest2(AllMatrix(:, 2), AllMatrix(:, 3))


[p,h,stats] = ranksum(AllMatrix(:, 1), AllMatrix(:, 2))