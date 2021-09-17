txtfileID = fopen('Text File.txt', 'r');
format_spec = '%s';
txtfile_name = fscanf(txtfileID,format_spec);
txtfile_binary = dec2bin(txtfile_name);

txtfile_size = size(txtfile_name);
disp = reshape(txtfile_binary',1,[])