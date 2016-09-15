%get the path order
values = [1 1 1 5 5 5 10 10 10 25 25 25 50 50 50 100 100 100];  

path_order = datasample(values,length(values),'Replace',false);


actual_path = [1 5 1 10 5 50 25 10 100 50 5 25 10 1 25 100 50 100];

    
