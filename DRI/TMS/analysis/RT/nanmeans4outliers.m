%nanmeans to properly throw out outliers
%PMd stimulation, rule responses
mean1 = nanmean([ruleRT(s_trials_ns{1},1);ruleRT(s_trials_ns{3},3)]);
mean2 = nanmean([ruleRT(f_trials_ns{1},1);ruleRT(f_trials_ns{3},3)]);

mean3 = nanmean([ruleRT(s_trials_es{1},1);ruleRT(s_trials_es{3},3)]);
mean4 = nanmean([ruleRT(f_trials_es{1},1);ruleRT(f_trials_es{3},3)]);

mean5 = nanmean([ruleRT(s_trials_ls{1},1);ruleRT(s_trials_ls{3},3)]);
mean6 = nanmean([ruleRT(f_trials_ls{1},1);ruleRT(f_trials_ls{3},3)]);
%PMd stimulation, stimulus responses
mean7 = nanmean([stimRT(s_trials_ns{1},1);stimRT(s_trials_ns{3},3)]);
mean8 = nanmean([stimRT(f_trials_ns{1},1);stimRT(f_trials_ns{3},3)]);

mean9 = nanmean([stimRT(s_trials_es{1},1);stimRT(s_trials_es{3},3)]);
mean10 = nanmean([stimRT(f_trials_es{1},1);stimRT(f_trials_es{3},3)]);

mean11 = nanmean([stimRT(s_trials_ls{1},1);stimRT(s_trials_ls{3},3)]);
mean12 = nanmean([stimRT(f_trials_ls{1},1);stimRT(f_trials_ls{3},3)]);
%Vertex stimulation, rule responses
mean13 = nanmean([ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)]);
mean14 = nanmean([ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)]);

mean15 = nanmean([ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)]);
mean16 = nanmean([ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)]);

mean17 = nanmean([ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)]);
mean18 = nanmean([ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)]);
%Vertex stimulation, stimulus responses
mean19 = nanmean([stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)]);
mean20 = nanmean([stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)]);

mean21 = nanmean([stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)]);
mean22 = nanmean([stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)]);

mean23 = nanmean([stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)]);
mean24 = nanmean([stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)]);



%sems
%PMd stimulation, rule responses
sem1 = nanstd([ruleRT(s_trials_ns{1},1);ruleRT(s_trials_ns{3},3)])/...
    sqrt(length([ruleRT(s_trials_ns{1},1);ruleRT(s_trials_ns{3},3)]));
sem2 = nanstd([ruleRT(f_trials_ns{1},1);ruleRT(f_trials_ns{3},3)])/...
    sqrt(length([ruleRT(f_trials_ns{1},1);ruleRT(f_trials_ns{3},3)]));

sem3 = nanstd([ruleRT(s_trials_es{1},1);ruleRT(s_trials_es{3},3)])/...
    sqrt(length([ruleRT(s_trials_es{1},1);ruleRT(s_trials_es{3},3)]));
sem4 = nanstd([ruleRT(f_trials_es{1},1);ruleRT(f_trials_es{3},3)])/...
    sqrt(length([ruleRT(f_trials_es{1},1);ruleRT(f_trials_es{3},3)]));

sem5 = nanstd([ruleRT(s_trials_ls{1},1);ruleRT(s_trials_ls{3},3)])/...
    sqrt(length([ruleRT(s_trials_ls{1},1);ruleRT(s_trials_ls{3},3)]));
sem6 = nanstd([ruleRT(f_trials_ls{1},1);ruleRT(f_trials_ls{3},3)])/...
    sqrt(length([ruleRT(f_trials_ls{1},1);ruleRT(f_trials_ls{3},3)]));
%PMd stimulation, stimulus responses
sem7 = nanstd([stimRT(s_trials_ns{1},1);stimRT(s_trials_ns{3},3)])/...
    sqrt(length([stimRT(s_trials_ns{1},1);stimRT(s_trials_ns{3},3)]));
sem8 = nanstd([stimRT(f_trials_ns{1},1);stimRT(f_trials_ns{3},3)])/...
    sqrt(length([stimRT(f_trials_ns{1},1);stimRT(f_trials_ns{3},3)]));

sem9 = nanstd([stimRT(s_trials_es{1},1);stimRT(s_trials_es{3},3)])/...
    sqrt(length([stimRT(s_trials_es{1},1);stimRT(s_trials_es{3},3)]));
sem10 = nanstd([stimRT(f_trials_es{1},1);stimRT(f_trials_es{3},3)])/...
    sqrt(length([stimRT(f_trials_es{1},1);stimRT(f_trials_es{3},3)]));

sem11 = nanstd([stimRT(s_trials_ls{1},1);stimRT(s_trials_ls{3},3)])/...
    sqrt(length([stimRT(s_trials_ls{1},1);stimRT(s_trials_ls{3},3)]));
sem12 = nanstd([stimRT(f_trials_ls{1},1);stimRT(f_trials_ls{3},3)])/...
    sqrt(length([stimRT(f_trials_ls{1},1);stimRT(f_trials_ls{3},3)]));
%Vertex stimulation, rule responses
sem13 = nanstd([ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)])/...
    sqrt(length([ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)]));
sem14 = nanstd([ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)])/...
    sqrt(length([ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)]));

sem15 = nanstd([ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)])/...
    sqrt(length([ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)]));
sem16 = nanstd([ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)])/...
    sqrt(length([ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)]));

sem17 = nanstd([ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)])/...
    sqrt(length([ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)]));
sem18 = nanstd([ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)])/...
    sqrt(length([ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)]));
%Vertex stimulation, stimulus responses
sem19 = nanstd([stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)])/...
    sqrt(length([stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)]));
sem20 = nanstd([stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)])/...
    sqrt(length([stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)]));

sem21 = nanstd([stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)])/...
    sqrt(length([stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)]));
sem22 = nanstd([stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)])/...
    sqrt(length([stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)]));

sem23 = nanstd([stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)])/...
    sqrt(length([stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)]));
sem24 = nanstd([stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)])/...
    sqrt(length([stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)]));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%nanmeans for 2406 to throw out block 1

mean1 = nanmean([ruleRT(s_trials_ns{3},3)]);
mean2 = nanmean([ruleRT(f_trials_ns{3},3)]);

mean3 = nanmean([ruleRT(s_trials_es{3},3)]);
mean4 = nanmean([ruleRT(f_trials_es{3},3)]);

mean5 = nanmean([ruleRT(s_trials_ls{3},3)]);
mean6 = nanmean([ruleRT(f_trials_ls{3},3)]);
%PMd stimulation, stimulus responses, block 3
mean7 = nanmean([stimRT(s_trials_ns{3},3)]);
mean8 = nanmean([stimRT(f_trials_ns{3},3)]);

mean9 = nanmean([stimRT(s_trials_es{3},3)]);
mean10 = nanmean([stimRT(f_trials_es{3},3)]);

mean11 = nanmean([stimRT(s_trials_ls{3},3)]);
mean12 = nanmean([stimRT(f_trials_ls{3},3)]);

%Vertex stimulation, rule responses
mean13 = nanmean([ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)]);
mean14 = nanmean([ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)]);

mean15 = nanmean([ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)]);
mean16 = nanmean([ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)]);

mean17 = nanmean([ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)]);
mean18 = nanmean([ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)]);
%Vertex stimulation, stimulus responses
mean19 = nanmean([stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)]);
mean20 = nanmean([stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)]);

mean21 = nanmean([stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)]);
mean22 = nanmean([stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)]);

mean23 = nanmean([stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)]);
mean24 = nanmean([stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)]);

%PMd stimulation, rule responses, block 3
sem1 = nanstd([ruleRT(s_trials_ns{3},3)])/...
    sqrt(length([ruleRT(s_trials_ns{3},3)]));
sem2 = nanstd([ruleRT(f_trials_ns{3},3)])/...
    sqrt(length([ruleRT(f_trials_ns{3},3)]));

sem3 = nanstd([ruleRT(s_trials_es{3},3)])/...
    sqrt(length([ruleRT(s_trials_es{3},3)]));
sem4 = nanstd([ruleRT(f_trials_es{3},3)])/...
    sqrt(length([ruleRT(f_trials_es{3},3)]));

sem5 = nanstd([ruleRT(s_trials_ls{3},3)])/...
    sqrt(length([ruleRT(s_trials_ls{3},3)]));
sem6 = nanstd([ruleRT(f_trials_ls{3},3)])/...
    sqrt(length([ruleRT(f_trials_ls{3},3)]));
%PMd stimulation, stimulus responses, block 3
sem7 = nanstd([stimRT(s_trials_ns{3},3)])/...
    sqrt(length([stimRT(s_trials_ns{3},3)]));
sem8 = nanstd([stimRT(f_trials_ns{3},3)])/...
    sqrt(length([stimRT(f_trials_ns{3},3)]));

sem9 = nanstd([stimRT(s_trials_es{3},3)])/...
    sqrt(length([stimRT(s_trials_es{3},3)]));
sem10 = nanstd([stimRT(f_trials_es{3},3)])/...
    sqrt(length([stimRT(f_trials_es{3},3)]));

sem11 = nanstd([stimRT(s_trials_ls{3},3)])/...
    sqrt(length([stimRT(s_trials_ls{3},3)]));
sem12 = nanstd([stimRT(f_trials_ls{3},3)])/...
    sqrt(length([stimRT(f_trials_ls{3},3)]));

%Vertex stimulation, rule responses
sem13 = nanstd([ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)])/...
    sqrt(length([ruleRT(s_trials_ns{2},2);ruleRT(s_trials_ns{4},4)]));
sem14 = nanstd([ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)])/...
    sqrt(length([ruleRT(f_trials_ns{2},2);ruleRT(f_trials_ns{4},4)]));

sem15 = nanstd([ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)])/...
    sqrt(length([ruleRT(s_trials_es{2},2);ruleRT(s_trials_es{4},4)]));
sem16 = nanstd([ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)])/...
    sqrt(length([ruleRT(f_trials_es{2},2);ruleRT(f_trials_es{4},4)]));

sem17 = nanstd([ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)])/...
    sqrt(length([ruleRT(s_trials_ls{2},2);ruleRT(s_trials_ls{4},4)]));
sem18 = nanstd([ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)])/...
    sqrt(length([ruleRT(f_trials_ls{2},2);ruleRT(f_trials_ls{4},4)]));
%Vertex stimulation, stimulus responses
sem19 = nanstd([stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)])/...
    sqrt(length([stimRT(s_trials_ns{2},2);stimRT(s_trials_ns{4},4)]));
sem20 = nanstd([stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)])/...
    sqrt(length([stimRT(f_trials_ns{2},2);stimRT(f_trials_ns{4},4)]));

sem21 = nanstd([stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)])/...
    sqrt(length([stimRT(s_trials_es{2},2);stimRT(s_trials_es{4},4)]));
sem22 = nanstd([stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)])/...
    sqrt(length([stimRT(f_trials_es{2},2);stimRT(f_trials_es{4},4)]));

sem23 = nanstd([stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)])/...
    sqrt(length([stimRT(s_trials_ls{2},2);stimRT(s_trials_ls{4},4)]));
sem24 = nanstd([stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)])/...
    sqrt(length([stimRT(f_trials_ls{2},2);stimRT(f_trials_ls{4},4)]));