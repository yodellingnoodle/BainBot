close all
clc
clear

%%add axis lines on biplot, allow for hybrid letter number MRNs,
%%categorical data e.g. gender
%%scraper for mrgfus data
%%add citations and description for each part

%% Prep selected file %%
[icondata,iconcmap] = imread("peterbain.tif"); 
uiwait(msgbox(["Welcome to BainBot, your multivariate analysis helper!";"MATLAB ver. R2023b";"LH ICSM"],"Hello Doctor","custom",icondata,iconcmap));
target_file = uigetfile('*.xlsx',"Please select an Excel file to analyze");
Core_Data = readmatrix(target_file);
Core_Data(:,1) = [];
Core_Data(:,end) = []; % remove if all to be analyzed
MRNs = num2str(readvars(target_file));
Categories = readcell(target_file);
Categories(:,1) = [];
Categories(:,end) = []; % as above
Categories = Categories(1,:);
Categories = char(Categories.');
uiwait(msgbox("Dr Bain is sharpening his pencil...","Please wait"));

%% Principle Component Analysis (PCA) %%

%Only if variables are on the same scale%
%figure()
%boxplot(Core_Data,'Orientation','horizontal','Labels',Categories)

Pairwise_Matrix = corr(Core_Data,Core_Data);
Inverse_Variance_Weights = 1./var(Core_Data);
[wcoeff,score,latent,tsquared,explained] = pca(Core_Data,'VariableWeights',Inverse_Variance_Weights);
coefforth = diag(std(Core_Data))\wcoeff;

figure % Percentage contributions to variance of generated principle components % GRAPH
hold on
[charts,ax] = pareto(explained);
xlabel('Principal Component Number')
ylabel('Variance Contribution (%)')
(set(gca, 'YGrid', 'on', 'XGrid', 'off'));
charts(1).FaceColor = [0 0 0];
charts(1).BarWidth = 0.6;
charts(2).Color = [0 0 0];
title('Percentage contributions of principle components')
hold off

[st2,index] = sort(tsquared,'descend');
extreme = index(1);
MRNs(extreme,:)

figure % Biplot with first two principle components % GRAPH
hold on
biplot(coefforth(:,1:2),'Scores',score(:,1:2),'Varlabels',Categories,'ObsLabels',MRNs);
xlabel('Component 1')
ylabel('Component 2')
title('Variables as vectors against first two principle components')
grid on
hold off

figure % Biplot with first three principle components % GRAPH
hold on
biplot(coefforth(:,1:3),'Scores',score(:,1:3),'Varlabels',Categories,'ObsLabels',MRNs);
xlabel('Component 1')
ylabel('Component 2')
zlabel('Component 3')
title('Variables as vectors against first three principle components')
grid on
view([30 40])
hold off

%% Maximum Relevance — Minimum Redundancy (MRMR) Feature Ranker %%

MRMR_data = readtable(target_file);
MRMR_data(:,1) = [];
MRMR_target_response = readcell(target_file);
MRMR_target_response = char(MRMR_target_response(1,end));
[idx,scores] = fsrmrmr(MRMR_data,MRMR_target_response);
%[idx,scores] = fsrmrmr(MRMR_data,"Post_opBFS"); % Need to fix

figure % Ranked bar plot variable importance as predictors for the outcome % GRAPH
bar(scores(idx),'k')
(set(gca, 'YGrid', 'on', 'XGrid', 'off'));
xlabel("Variables")
ylabel("Importance score")
predictorNames = MRMR_data.Properties.VariableNames(1:end-1);
xticklabels(strrep(predictorNames(idx),"_","\_"))
xtickangle(45)
title('Ranking and weighting of variables as predictors of outcome')

%% Scatter Plot Matrix (w/ univariate histogram) %%

figure %%%%% CORRECT AXES LABELS and PLOT color to black
hold on
gplotmatrix(Core_Data,[],[],[],[],[],false);
text([.08 .24 .43 .66 .83], repmat(-.1,1,5), Categories, 'FontSize',8);
text(repmat(-.12,1,5), [.86 .62 .41 .25 .02], Categories, 'FontSize',8, 'Rotation',90);
title('Scatter plot matrix of all variable combinations')
hold off

%% K Means Cluster


