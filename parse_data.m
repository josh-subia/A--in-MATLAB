function parsed_data = parse_data(num_obs,object_field,name_of_field)
    for i = 1:num_obs
        parsed_data(i) = getfield(object_field(i),name_of_field);
    end
end