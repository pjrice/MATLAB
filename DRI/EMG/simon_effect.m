%simon effect
%RTs are faster for spatially congruent compared to noncongruent trials

%find which trials are congruent and which are incongruent

%essentially ask, was the answer even, or odd? if it was even, where was
%even assigned to?

%load all necessary variables in, assign to different variables and cat new
%files' variables into them, save as new filename












%clean a little shit up

condMatrix = logical(condMatrix);

even_temp = cell2mat(evenoddchooser);
evenpresent = even_temp(:,1)==1;

finger_temp = cell2mat(fingerchooser);
fingerpresent = finger_temp(:,1)==1;

symbol_temp = cell2mat(symbolchooser);
symbolpresent = symbol_temp(:,1)==1;

ab_temp = cell2mat(abchooser);
a_present = ab_temp(:,1)==1; %on the stimulus screen, was A on the left?


%was the answer odd?
oddanswers = mod(stim,2);
oddanswers = logical(oddanswers);

finger_trials_temp = cat(2,condMatrix,evenpresent,fingerpresent,oddanswers,a_present);
symbol_trials_temp = cat(2,condMatrix,evenpresent,symbolpresent,oddanswers,a_present);

%was it the finger condition; was even assigned to the index finger?    
even_index = find(condMatrix==1&evenpresent==1&fingerpresent==1);  %even-index presented
odd_index = find(condMatrix==1&evenpresent==0&fingerpresent==1);  %odd-index presented
even_middle = find(condMatrix==1&evenpresent==1&fingerpresent==0);  %even-middle presented
odd_middle = find(condMatrix==1&evenpresent==0&fingerpresent==0);  %odd-middle presented

finger_cond_trials = cat(1,even_index,odd_index,even_middle,odd_middle);
finger_trials = finger_trials_temp(finger_cond_trials,:);

%was it the symbol condition; was even assigned to A?
even_A = find(condMatrix==0&evenpresent==1&symbolpresent==1);  %even-A presented
odd_A = find(condMatrix==0&evenpresent==0&symbolpresent==1);  %odd-A presented
even_B = find(condMatrix==0&evenpresent==1&symbolpresent==0);  %even-B presented
odd_B = find(condMatrix==0&evenpresent==0&symbolpresent==0);  %odd-B presented

symbol_cond_trials = cat(1,even_A,odd_A,even_B,odd_B);
symbol_trials = symbol_trials_temp(symbol_cond_trials,:);



finger_trials(:,6) = zeros(15,1);
for z = 1:length(finger_trials)
    
    if finger_trials(z,2)==1&&finger_trials(z,3)==1 && finger_trials(z,4)==0
        
        finger_trials(z,6)=1;
        
    elseif finger_trials(z,2)==0&&finger_trials(z,3)==1 && finger_trials(z,4)==1
        
        finger_trials(z,6)=1;
        
    elseif finger_trials(z,2)==1&&finger_trials(z,3)==0 && finger_trials(z,4)==1
        
        finger_trials(z,6)=1;
        
    elseif finger_trials(z,2)==0&&finger_trials(z,3)==0 && finger_trials(z,4)==0
        
        finger_trials(z,6)=1;
        
    end
    
end

symbol_trials(:,6) = zeros(15,1);
for z = 1:length(symbol_trials)
    
    if symbol_trials(z,2)==1&&symbol_trials(z,3)==1&&symbol_trials(z,5)==1 && symbol_trials(z,4)==1
        
        symbol_trials(z,6)=1;
        
    elseif symbol_trials(z,2)==1&&symbol_trials(z,3)==1&&symbol_trials(z,5)==0 && symbol_trials(z,4)==0
        
        symbol_trials(z,6)=1;
        
    elseif symbol_trials(z,2)==0&&symbol_trials(z,3)==1&&symbol_trials(z,5)==1 && symbol_trials(z,4)==0
        
        symbol_trials(z,6)=1;
        
    elseif symbol_trials(z,2)==0&&symbol_trials(z,3)==1&&symbol_trials(z,5)==0 && symbol_trials(z,4)==1
        
        symbol_trials(z,6)=1;
        
    elseif symbol_trials(z,2)==1&&symbol_trials(z,3)==0&&symbol_trials(z,5)==1 && symbol_trials(z,4)==0
        
        symbol_trials(z,6)=1;
        
    elseif symbol_trials(z,2)==1&&symbol_trials(z,3)==0&&symbol_trials(z,5)==0 && symbol_trials(z,4)==1
        
        symbol_trials(z,6)=1;
        
    elseif symbol_trials(z,2)==0&&symbol_trials(z,3)==0&&symbol_trials(z,5)==1 && symbol_trials(z,4)==1
        
        symbol_trials(z,6)=1;
        
    elseif symbol_trials(z,2)==0&&symbol_trials(z,3)==0&&symbol_trials(z,5)==0 && symbol_trials(z,4)==0
        
        symbol_trials(z,6)=1;
        
    end
end


%all_trials(:,1) answers the question, should the subject have responded with
%their index finger? with yes or no
all_trials = nan(30,1);
all_trials(symbol_cond_trials) = symbol_trials(:,6);
all_trials(finger_cond_trials) = finger_trials(:,6);
        
%go back and confirm manually that all_trials(:,1) is the truth

%add what finger they DID respond with
actual_finger = cell2mat(cat(2,respMat(7,:)))';

all_trials(:,2) = zeros(30,1);
all_trials(find(actual_finger=='S'),2) = 1;

%did they get it right?
all_trials(:,3) = zeros(30,1);
all_trials(find(all_trials(:,1)==all_trials(:,2)),3) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%end DRI_preprocess here and make new function to run stats with

percent_correct = sum(all_trials(:,3))/length(all_trials);

%get timestamps
for t = 1:numtrials
    
    %correct so that first timestamp is at time zero (trial start)
    events(t,:) = VBLTimestamp(t,:)-streamstart_time;
    events(t,:) = events(t,:)-events(t,1);
    
end

respTime = events(:,5) - events(:,4);

index_trials = find(all_trials(:,1));
middle_trials = find(~all_trials(:,1));

respTime_index = respTime;
respTime_middle = respTime;

respTime_index(middle_trials) = nan;
respTime_middle(index_trials) = nan;


wrong = find(~all_trials(:,3));

figure
hold on
plot(respTime_index,'b')
plot(respTime_index,'b.')
plot(respTime_middle,'r')
plot(respTime_middle,'r.')

for z = 1:length(wrong)
    
    plot([wrong(z),wrong(z)],ylim,'k')
    
end

%get trials that have consecutively used the same finger; toss the first
%trial in these sets because you actually used a different finger

index_conseq = nan(length(index_trials),1);
index_conseq(2:end) = diff(index_trials);
index_conseq(:,2) = index_trials;
index_conseq(:,3) = condMatrix(index_trials);

middle_conseq = nan(length(middle_trials),1);
middle_conseq(2:end) = diff(middle_trials);
middle_conseq(:,2) = middle_trials;
middle_conseq(:,3) = condMatrix(middle_trials);



%separate consecutive trials into conditions
sym_index_conseq = index_conseq(find(index_conseq(:,1)==1&index_conseq(:,3)==0),2);
fin_index_conseq = index_conseq(find(index_conseq(:,1)==1&index_conseq(:,3)==1),2);

sym_middle_conseq = middle_conseq(find(middle_conseq(:,1)==1&middle_conseq(:,3)==0),2);
fin_middle_conseq = middle_conseq(find(middle_conseq(:,1)==1&middle_conseq(:,3)==1),2);

m_sic = mean(respTime(sym_index_conseq));
m_fic = mean(respTime(fin_index_conseq));

m_smc = mean(respTime(sym_middle_conseq));
m_fmc = mean(respTime(fin_middle_conseq));

sem_sic = std(respTime(sym_index_conseq))/sqrt(length(sym_index_conseq));
sem_fic = std(respTime(fin_index_conseq))/sqrt(length(sym_index_conseq));

sem_smc = std(respTime(sym_middle_conseq))/sqrt(length(sym_index_conseq));
sem_fmc = std(respTime(fin_middle_conseq))/sqrt(length(sym_index_conseq));

figure
hold on
bar([m_sic m_fic m_smc m_fmc])
h = errorbar([m_sic m_fic m_smc m_fmc],[sem_sic,sem_fic,sem_smc,sem_fmc],'c');
set(h,'linestyle','none')

%only plot trials that occurred consecutively, AND the same finger was used
%under the same condition
%n is too small for one person - combine all three datasets (want to do
%anyway) and then try. Cat all of the separate "cond_fing_conseq" (example:
%sym_index_conseq) together (so, cat patrick, darby, and margarita's
%sym_index_conseq), as well as all the other necessary vectors (will be
%somewhat tricky because sym_index_conseq indexes trials within a set of
%30)

%better idea: cat all the base arrays together, then index everything out
%from there. The code already written should be basically the same; the
%vector lengths will just be longer
















%in my data set, there are sig faster RTs for trials performed with index
%consecutively compare to trials performed with middle consecutively
%(regardless of condition)

index_con_m = mean(respTime(index_conseq(find(index_conseq(:,1)==1),2)));
middle_con_m = mean(respTime(middle_conseq(find(middle_conseq(:,1)==1),2)));

index_con_sem = std(respTime(index_conseq(find(index_conseq(:,1)==1),2)))...
    /sqrt(length(respTime(index_conseq(find(index_conseq(:,1)==1),2))));

middle_con_sem = std(respTime(middle_conseq(find(middle_conseq(:,1)==1),2)))...
    /sqrt(length(respTime(middle_conseq(find(middle_conseq(:,1)==1),2)))); %#ok<*FNDSB>

[H,P,CI,STATS] = ttest2(respTime(index_conseq(find(index_conseq(:,1)==1),2)),respTime(middle_conseq(find(middle_conseq(:,1)==1),2)));

figure
hold on
bar([index_con_m,middle_con_m])
h = errorbar([index_con_m,middle_con_m],[index_con_sem,middle_con_sem],'c');
set(h,'linestyle','none')

%are consecutive trials faster than nonconsecutive, regardless of finger?
%for darby and I, consec. trials actually trend (ns) towards being SLOWER

consec_respTime = cat(1,respTime(index_conseq(find(index_conseq(:,1)==1),2)),respTime(middle_conseq(find(middle_conseq(:,1)==1),2)));

nconsec_respTime = cat(1,respTime(index_conseq(find(index_conseq(:,1)~=1),2)),respTime(middle_conseq(find(middle_conseq(:,1)~=1),2)));

con_sem = std(consec_respTime)/sqrt(length(consec_respTime));
ncon_sem = std(nconsec_respTime)/sqrt(length(nconsec_respTime));

figure
hold on
bar([mean(consec_respTime),mean(nconsec_respTime)])
h = errorbar([mean(consec_respTime),mean(nconsec_respTime)],[con_sem,ncon_sem],'c');
set(h,'linestyle','none')

[H,P,CI,STATS] = ttest2(consec_respTime,nconsec_respTime);


























    
