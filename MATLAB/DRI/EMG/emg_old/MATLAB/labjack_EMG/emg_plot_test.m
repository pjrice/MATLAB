% 
% for i = 1:numScansRequested
%     
%     s = 2*i - 1;
%     g = 2*i;
%     
%     ch1(i) = adblData(s);
%     ch2(i) = adblData(g);
%     
% end


for i = 1:numScansRequested
    
    
    %rewrite this in a more intelligent way you shithead
    index1 = 16*i - 15;
    index2 = 16*i - 14;
    index3 = 16*i - 13;
    index4 = 16*i - 12;
    index5 = 16*i - 11;
    index6 = 16*i - 10;
    index7 = 16*i - 9;
    index8 = 16*i - 8;
    index9 = 16*i - 7;
    index10 = 16*i - 6;
    index11 = 16*i - 5;
    index12 = 16*i - 4;
    index13 = 16*i - 3;
    index14 = 16*i - 2;
    index15 = 16*i - 1;
    index16 = 16*i;
    
    ch1(i) = adblData(index1);
    ch2(i) = adblData(index2);
    ch3(i) = adblData(index3);
    ch4(i) = adblData(index4);
    ch5(i) = adblData(index5);
    ch6(i) = adblData(index6);
    ch7(i) = adblData(index7);
    ch8(i) = adblData(index8);
    ch9(i) = adblData(index9);
    ch10(i) = adblData(index10);
    ch11(i) = adblData(index11);
    ch12(i) = adblData(index12);
    ch13(i) = adblData(index13);
    ch14(i) = adblData(index14);
    ch15(i) = adblData(index15);
    ch16(i) = adblData(index16);
end

for i = 1:numScansRequested
    
    
    %rewrite this in a more intelligent way you shithead
    index1 = 16*i - 15;
    index2 = 16*i - 14;
    index3 = 16*i - 13;
    index4 = 16*i - 12;
    index5 = 16*i - 11;
    index6 = 16*i - 10;
    index7 = 16*i - 9;
    index8 = 16*i - 8;
    index9 = 16*i - 7;
    index10 = 16*i - 6;
    index11 = 16*i - 5;
    index12 = 16*i - 4;
    index13 = 16*i - 3;
    index14 = 16*i - 2;
    index15 = 16*i - 1;
    index16 = 16*i;
    
    ch1(i) = adblData_mat(index1);
    ch2(i) = adblData_mat(index2);
    ch3(i) = adblData_mat(index3);
    ch4(i) = adblData_mat(index4);
    ch5(i) = adblData_mat(index5);
    ch6(i) = adblData_mat(index6);
    ch7(i) = adblData_mat(index7);
    ch8(i) = adblData_mat(index8);
    ch9(i) = adblData_mat(index9);
    ch10(i) = adblData_mat(index10);
    ch11(i) = adblData_mat(index11);
    ch12(i) = adblData_mat(index12);
    ch13(i) = adblData_mat(index13);
    ch14(i) = adblData_mat(index14);
    ch15(i) = adblData_mat(index15);
    ch16(i) = adblData_mat(index16);
end

for i = 1:numScansRequested
    
    
    %rewrite this in a more intelligent way you shithead
    index1 = 4*i - 3;
    index2 = 4*i - 2;
    index3 = 4*i - 1;
    index4 = 4*i;

    
    ch1(i) = adblData(index1);
    ch2(i) = adblData(index2);
    ch3(i) = adblData(index3);
    ch4(i) = adblData(index4);
    
end

figure
hold on

plot(ch1)
plot(ch2)
plot(ch3)
plot(ch4)
plot(ch5)
plot(ch6)
plot(ch7)
plot(ch8)
plot(ch9)
plot(ch10)
plot(ch11)
plot(ch12)
plot(ch13)
plot(ch14)
plot(ch15)
plot(ch16)