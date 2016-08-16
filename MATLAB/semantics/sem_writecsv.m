
%writes word set data to csv
%run sem_stim before this

tempcell = good_word_sets(spds_idx,:);

for i = 1:length(tempcell)
    
    tempcell{i,4} = sorted_pdsums(i);
    
end

%change filename here
fid = fopen('P:\UW\projects\semantics\fours.csv', 'w');

fprintf(fid,'%s, %s, %s, %u\n',tempcell{1,:})
for i = 2:length(tempcell)
    fprintf(fid,'%s, %s, %s, %u\n',tempcell{i,:})
end
fclose(fid)


