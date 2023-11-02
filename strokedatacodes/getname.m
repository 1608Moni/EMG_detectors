function names = getname(result)

    for i = 1:size(result.subjects,2)
        names(i) = result.subjects{i}.name;
    end


end