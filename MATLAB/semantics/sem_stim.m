%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%group words by length then find most similar pairs

%stuff to add words
% wordlist = cell(0);
% values = double([]);
% 
% ph = find(values==0);
% values(ph) = NaN;

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
    
end

%from here look for small distances as well-paired words across all
%measures

hist(point_distances{5},50)
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
        
        good_words{i,1} = wordlist{wordlen_idx{z}(I(i))};
        good_words{i,2} = wordlist{wordlen_idx{z}(J(i))};
        
        
    else
        
        good_pds(i) = NaN;
        
        good_words{i,1} = [];
        good_words{i,2} = [];
        
    end
end

closest = good_words(find(good_pds==min(good_pds)),:)

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









































