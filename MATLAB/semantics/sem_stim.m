%Hi Stephanie!

%  ,_     _
%  |\\_,-~/
%  / _  _ |    ,--.
% (  @  @ )   / ,-'
%  \  _T_/-._( (
%  /         `. \
% |         _  \ |
%  \ \ ,  /      |
%   || |-_\__   /
%  ((_/`(____,-'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%group words by length then find most similar pairs

%stuff to add words
% wordlist = cell(0);
% values = double([]);
% 
% ph = find(values==0);
% values(ph) = NaN;

%load file
[fname, pathname] = uigetfile('*.mat', 'Pick the datafile');

load(strcat(pathname,fname))

%group by word length
wordlengths = cellfun(@length, wordlist);

for i = min(wordlengths):max(wordlengths)
    
    wordlen_idx{i-2} = find(wordlengths==i);
    
end

%quick and dirty word group index
word_groups(1:35) = 1;
word_groups(36:65) = 2;
word_groups(66:99) = 3;
word_groups = word_groups';


%using pdist to get point distances in 5D space (dimensionality determined
%by number of measures)
for i = 1:length(wordlen_idx)
    
    point_distances{i} = triu(squareform(pdist(values(wordlen_idx{i},:))));
    pdvec{i} = pdist(values(wordlen_idx{i},:));
    
end

%from here look for small distances as well-paired words across all
%measures

%hist(pdvec{5},50)
%from histograms, arbitrary threshold of 500 set (include all word pairs
%below threshold) - this is bullshit for 7 letter words

lett_len = input('See word pairs with how many letters? ');

z = lett_len-2;

[I,J] = find(point_distances{z} > 0.1 & point_distances{z} < 500);

%this command to print words of a certain letter length
% wordlist(wordlen_idx{1})

%this displays the list of word pairs with point_distance < 500
for i = 1:length(I)
    
    if word_groups(wordlen_idx{z}(I(i))) ~= word_groups(wordlen_idx{z}(J(i)))
    
        disp(strcat(wordlist{wordlen_idx{z}(I(i))},':',wordlist{wordlen_idx{z}(J(i))}));
        
        good_pds(i) = point_distances{z}(I(i),J(i));
        
        word_pairs{i,1} = wordlist{wordlen_idx{z}(I(i))};
        word_pairs{i,2} = wordlist{wordlen_idx{z}(J(i))};
        
        
    else
        
        good_pds(i) = NaN;
        
        word_pairs{i,1} = [];
        word_pairs{i,2} = [];
        
    end
end

% closest = word_pairs(find(good_pds==min(good_pds)),:);

%indexes actual words pairs out of a bunch of blanks
qindex = find(cellfun(@(x) ~isempty(x), word_pairs(:,1)));

%creates cell with no blanks
good_word_pairs = word_pairs(qindex,:);

%finds unique words in the good pairs
good_words = unique(good_word_pairs);

%finds every possible set of 3 from good_words
good_word_sets = nchoosek(good_words,3);

%already filtered so word pairs don't match word groups, but finding unique
%words in good_word_pairs then finding every possible combo in
%good_word_sets reintroduces this problem
%have to filter sets here so that each set of 3 contains only one word from
%each word group
for i = 1:length(good_word_sets)
    
    %if the word groups of 2 of any of the 3 words in set match
    if word_groups(strmatch(good_word_sets(i,1),wordlist))==word_groups(strmatch(good_word_sets(i,2),wordlist)) | ...
            word_groups(strmatch(good_word_sets(i,1),wordlist))==word_groups(strmatch(good_word_sets(i,3),wordlist)) | ...
            word_groups(strmatch(good_word_sets(i,2),wordlist))==word_groups(strmatch(good_word_sets(i,3),wordlist))
        
        bad_set_idx(i,1) = i;
        
    else
        
        bad_set_idx(i,1) = NaN;
        
    end
end

%find where bad_set_idx is nan; this makes index of good sets within
%good_word_sets
good_set_idx = find(isnan(bad_set_idx)); 

%make a list of words of the chosen length to strmatch the good sets with
wordsoflen = wordlist(wordlen_idx{1,z});

%sums the pdist values of the 3 pairs of words within a set
for i = 1:length(good_set_idx)
    
    %get an index of where the words are
    for ii = 1:size(good_word_sets,2)
        
        word_idx(ii) = strmatch(good_word_sets(good_set_idx(i),ii),wordsoflen);
        
    end
   
    %sort into sensible [I,J] index list to reference point_distances
    pdist_idx = sort(nchoosek(word_idx,2),2);
    
    pdist_sums(i) = sum([point_distances{1,z}(pdist_idx(1,1),pdist_idx(1,2)) ...
        point_distances{1,z}(pdist_idx(2,1),pdist_idx(2,2)) ...
        point_distances{1,z}(pdist_idx(3,1),pdist_idx(3,2))]);
    
    clear word_idx pdist_idx
    
end
    

pdist_sums = pdist_sums';

%sort pdist_sums from smallest (closest set) to largest (furthest set)
[sorted_pdsums, spds_idx] = sort(pdist_sums);

for i = 1:10
    
    disp(good_word_sets(spds_idx(i),:))
    disp(sorted_pdsums(i))
    
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%make searchable structure words -> word groups -> indiv. words -> values

twords = wordlist(1:35);
awords = wordlist(36:65);
pwords = wordlist(66:99);

tvals = values(1:35,:);
avals = values(36:65,:);
pvals = values(66:99,:);

words.tools = struct([]);
words.animals = struct([]);
words.places = struct([]);

words.tools = struct(twords{1},tvals(1,:));
words.animals = struct(awords{1},avals(1,:));
words.places = struct(pwords{1},pvals(1,:));

for i = 2:length(twords)
    
    words.tools.(twords{i}) = tvals(i,:);
    
end

for i = 2:length(awords)
    
    words.animals.(awords{i}) = avals(i,:);
    
end

for i = 2:length(pwords)
    
    words.places.(pwords{i}) = pvals(i,:);
    
end









































