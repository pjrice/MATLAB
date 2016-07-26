%function to get standard error of the mean
function x = sem(data)

x = std(data,'omitnan')/sqrt(length(data));

end