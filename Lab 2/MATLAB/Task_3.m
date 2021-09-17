my_name = 'Swagat Panda';

auto_prob = 1;

if (auto_prob == 1)
    % Automatically calculate the probability distribution
    % Get ASCII version of each character
    %	Each ASCII value represents the probability of finding the character
    prob_dist = double(my_name);
else
    % Manually define the probability distribution
    prob_dist = [10 19 30 40 50 35 25 46 33];
    prob_dist = prob_dist/sum(prob_dist);
end

init_prob = prob_dist/total;

disp('Character Probability:');
for i = 1:length(prob_dist)
	display(strcat(my_name(i),' -->  ',num2str(prob_dist(i))));
end
total = sum(prob_dist)

for i = 1:length(my_name)
	sorted_str{i} = my_name(i);
end

[dict, avglen] = huffmandict(sorted_str, init_prob);
disp(dict)
comp = huffmanenco(my_name,dict)
dcomp = huffmandeco(comp,dict)