%plot of all symbol trial rule RTs
figure(2)
hold on
plot(ruleRT(s_trials(:,1),1))
plot(ruleRT(s_trials(:,2),2))
plot(ruleRT(s_trials(:,3),3))
plot(ruleRT(s_trials(:,4),4))

%plot of all symbol trial stimulus RTs
figure(3)
hold on
plot(stimRT(s_trials(:,1),1))
plot(stimRT(s_trials(:,2),2))
plot(stimRT(s_trials(:,3),3))
plot(stimRT(s_trials(:,4),4))

%plot of all finger trial rule RTs
figure(4)
hold on
plot(ruleRT(f_trials(:,1),1))
plot(ruleRT(f_trials(:,2),2))
plot(ruleRT(f_trials(:,3),3))
plot(ruleRT(f_trials(:,4),4))

%plot of all finger trial stimulus RTs
figure(5)
hold on
plot(stimRT(f_trials(:,1),1))
plot(stimRT(f_trials(:,2),2))
plot(stimRT(f_trials(:,3),3))
plot(stimRT(f_trials(:,4),4))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot of all early stimulation trial rule RTs
figure(6)
hold on
plot(ruleRT(earlystim(:,1),1),'b')
plot(ruleRT(earlystim(:,2),2),'r')
plot(ruleRT(earlystim(:,3),3),'b')
plot(ruleRT(earlystim(:,4),4),'r')
title('Early stimulation, rule presentation')
ylim([0 3])

%plot of all early stimulation trial stimulus RTs
figure(7)
hold on
plot(stimRT(earlystim(:,1),1),'b')
plot(stimRT(earlystim(:,2),2),'r')
plot(stimRT(earlystim(:,3),3),'b')
plot(stimRT(earlystim(:,4),4),'r')
title('Early stimulation, stimulus presentation')
ylim([0 3])

%plot of all late stimulation trial rule RTs
figure(8)
hold on
plot(ruleRT(latestim(:,1),1),'b')
plot(ruleRT(latestim(:,2),2),'r')
plot(ruleRT(latestim(:,3),3),'b')
plot(ruleRT(latestim(:,4),4),'r')
title('Late stimulation, rule presentation')
ylim([0 3])

%plot of all late stimulation trial stimulus RTs
figure(9)
hold on
plot(stimRT(latestim(:,1),1),'b')
plot(stimRT(latestim(:,2),2),'r')
plot(stimRT(latestim(:,3),3),'b')
plot(stimRT(latestim(:,4),4),'r')
title('Late stimulation, stimulus presentation')
ylim([0 3])

%plot of all no stimulation trial rule RTs
figure(10)
hold on
plot(ruleRT(nostim(:,1),1),'b')
plot(ruleRT(nostim(:,2),2),'r')
plot(ruleRT(nostim(:,3),3),'b')
plot(ruleRT(nostim(:,4),4),'r')
title('No stimulation, rule presentation')
ylim([0 3])

%plot of all no stimulation trial stimulus RTs
figure(11)
hold on
plot(stimRT(nostim(:,1),1),'b')
plot(stimRT(nostim(:,2),2),'r')
plot(stimRT(nostim(:,3),3),'b')
plot(stimRT(nostim(:,4),4),'r')
title('No stimulation, stimulus presentation')
ylim([0 3])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot of symbol X early stimulation trials, rule RTs
figure(12)
hold on
plot(ruleRT(s_trials_es{1},1),'b')
plot(ruleRT(s_trials_es{2},2),'r')
plot(ruleRT(s_trials_es{3},3),'b')
plot(ruleRT(s_trials_es{4},4),'r')
title('Symbol trials, early stimulation, rule RTs')
ylim([0 3])

%plot of symbol X late stimulation trials, rule RTs
figure(13)
hold on
plot(ruleRT(s_trials_ls{1},1),'b')
plot(ruleRT(s_trials_ls{2},2),'r')
plot(ruleRT(s_trials_ls{3},3),'b')
plot(ruleRT(s_trials_ls{4},4),'r')
title('Symbol trials, late stimulation, rule RTs')
ylim([0 3])

%plot of symbol X no stimulation trials, rule RTs
figure(14)
hold on
plot(ruleRT(s_trials_ns{1},1),'b')
plot(ruleRT(s_trials_ns{2},2),'r')
plot(ruleRT(s_trials_ns{3},3),'b')
plot(ruleRT(s_trials_ns{4},4),'r')
title('Symbol trials, no stimulation, rule RTs')
ylim([0 3])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot of symbol X early stimulation trials, stimulus RTs
figure(15)
hold on
plot(stimRT(s_trials_es{1},1),'b')
plot(stimRT(s_trials_es{2},2),'r')
plot(stimRT(s_trials_es{3},3),'b')
plot(stimRT(s_trials_es{4},4),'r')
title('Symbol trials, early stimulation, stimulus RTs')
ylim([0 3])

%plot of symbol X late stimulation trials, stimulus RTs
figure(16)
hold on
plot(stimRT(s_trials_ls{1},1),'b')
plot(stimRT(s_trials_ls{2},2),'r')
plot(stimRT(s_trials_ls{3},3),'b')
plot(stimRT(s_trials_ls{4},4),'r')
title('Symbol trials, late stimulation, stimulus RTs')
ylim([0 3])

%plot of symbol X no stimulation trials, stimulus RTs
figure(17)
hold on
plot(stimRT(s_trials_ns{1},1),'b')
plot(stimRT(s_trials_ns{2},2),'r')
plot(stimRT(s_trials_ns{3},3),'b')
plot(stimRT(s_trials_ns{4},4),'r')
title('Symbol trials, no stimulation, stimulus RTs')
ylim([0 3])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot of finger X early stimulation trials, rule RTs
figure(18)
hold on
plot(ruleRT(f_trials_es{1},1),'b')
plot(ruleRT(f_trials_es{2},2),'r')
plot(ruleRT(f_trials_es{3},3),'b')
plot(ruleRT(f_trials_es{4},4),'r')
title('Finger trials, early stimulation, rule RTs')
ylim([0 3])

%plot of finger X late stimulation trials, rule RTs
figure(19)
hold on
plot(ruleRT(f_trials_ls{1},1),'b')
plot(ruleRT(f_trials_ls{2},2),'r')
plot(ruleRT(f_trials_ls{3},3),'b')
plot(ruleRT(f_trials_ls{4},4),'r')
title('Finger trials, late stimulation, rule RTs')
ylim([0 3])

%plot of finger X no stimulation trials, rule RTs
figure(20)
hold on
plot(ruleRT(f_trials_ns{1},1),'b')
plot(ruleRT(f_trials_ns{2},2),'r')
plot(ruleRT(f_trials_ns{3},3),'b')
plot(ruleRT(f_trials_ns{4},4),'r')
title('Finger trials, no stimulation, rule RTs')
ylim([0 3])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot of finger X early stimulation trials, stimulus RTs
figure(21)
hold on
plot(stimRT(f_trials_es{1},1),'b')
plot(stimRT(f_trials_es{2},2),'r')
plot(stimRT(f_trials_es{3},3),'b')
plot(stimRT(f_trials_es{4},4),'r')
title('Finger trials, early stimulation, stimulus RTs')
ylim([0 3])

%plot of finger X late stimulation trials, stimulus RTs
figure(22)
hold on
plot(stimRT(f_trials_ls{1},1),'b')
plot(stimRT(f_trials_ls{2},2),'r')
plot(stimRT(f_trials_ls{3},3),'b')
plot(stimRT(f_trials_ls{4},4),'r')
title('Finger trials, late stimulation, stimulus RTs')
ylim([0 3])

%plot of finger X no stimulation trials, stimulus RTs
figure(23)
hold on
plot(stimRT(f_trials_ns{1},1),'b')
plot(stimRT(f_trials_ns{2},2),'r')
plot(stimRT(f_trials_ns{3},3),'b')
plot(stimRT(f_trials_ns{4},4),'r')
title('Finger trials, no stimulation, stimulus RTs')
ylim([0 3])