messages{1} = 'Whaddup cuz?';
messages{2} = 'What''s really good?';
messages{3} = 'Sup playa?';
messages{4} = 'Get ready to get money...';
messages{5} = 'I pity the fool!';
messages{6} = 'T-R-I-L-L, that''s with capital letters, mayne!';
messages{7} = 'Train tracks underneath the faceless moon...';
messages{8} = 'Your courage will fail...';
messages{9} = 'Bing Bang Boom';
messages{10} = 'Free MP3s ''til the MPs say freeze!';
messages{11} = 'UBP 4 lyfe';
messages{12} = 'This is Thesaurus Rex at his awesome best!';
messages{13} = 'The world is ugly and cold, tryna make me the same...';
messages{14} = 'So imma keep it 100, when it come to the game!';
messages{15} = 'Every time I see the moon I''m looking at the bright side!';
messages{16} = 'I''m waiting for a city bus to flatten me, and transport me to the ever-after-happily';
messages{17} = 'Criss Cross the Big Boss keeps it real!!!';
messages{18} = 'Join the Rebel Alliance today!';
messages{19} = 'YES YES HOMEBOY GO HARD FOR YASELF';
messages{20} = 'I have you now!';

time = clock;

num = ceil(time(6)/3);

disp(messages{num})

clear
% Call Psychtoolbox-3 specific startup function:
if exist('PsychStartup'), PsychStartup; end;

